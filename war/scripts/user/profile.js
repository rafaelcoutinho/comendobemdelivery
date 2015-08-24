/* ------ Requires ------ */
dojo.require('dijit.Dialog');

dojo.require("dojox.widget.Calendar");
dojo.require("dojo.fx");
dojo.require("dojox.fx.easing");

dojo.require("comum.format");
dojo.require("comum.user");

/* ------ Variáveis ------ */
var carregandoEnderecos = false;
var dialogNovoEndereco = null;
var enderecos = null;
var loaderEnderecos = null;

/* ------ Funções ------ */
function alteraEndereco(idEndereco) {
	var endereco = getEndereco(idEndereco);
	
	// Pega o elemento que será atualizado
	var elementoEndereco = dojo.byId(idEndereco + '');
	
	// E substitui o conteúdo pelo do template
	elementoEndereco.innerHTML = dojo.byId('templateAlterar').innerHTML;
	
	// Conecta evento para procurar CEP
	var linkCep = dojo.query("a[href='cep']", elementoEndereco)[0];
	dojo.connect(linkCep, 'click', function (evt) {
		evt.preventDefault();
		encontraEndereco(dojo.query('form', elementoEndereco)[0]);
	});
	
	// Preenche com os dados
	preencheComEndereco(elementoEndereco, endereco);
}

function ativaAba(idBotao, idAba) {
	// Desativa todos os botões
	dojo.forEach( dojo.query('#abas a') , function (item) {
		dojo.addClass(item, 'inactive');
		dojo.removeClass(item, 'active');
	});
	
	// Desaparece com todos os conteúdos
	dojo.forEach( dojo.query('.conteudo') , function (item) {
		dojo.style(item, 'display', 'none');
	});
	
	// Ativa o botão esperado
	var botao = dojo.byId(idBotao);
	dojo.addClass(botao, 'active');
	dojo.removeClass(botao, 'inactive');
	
	// Mostra o conteúdo
	dojo.style(idAba, 'display', 'block');
}

function atualizaEndereco (idEndereco) {
	var elemento = dojo.byId(idEndereco + '');
	dojo.empty(elemento);
	criaInteriorElemento(elemento, getEndereco(idEndereco));
}

function carregaEnderecos(callback, comLoader) {
	if (carregandoEnderecos) return;
	
	carregandoEnderecos = true;
	
	if (comLoader) {
		colocaLoaderEnderecos();
	}
	
	dojo.xhr('GET', {
		url : contexto + '/getAddresses.do',
		load : function (response) {
			enderecos = dojo.fromJson(response);
			if (!checaLogado(enderecos)) {
				alert('Usuário não está logado.');
				return;
			}
			
			callback();
			carregandoEnderecos = false;
		}
	});
}

function colocaLoaderEnderecos() {
	if (!loaderEnderecos)
		loaderEnderecos = colocaLoader(dojo.byId('enderecos'), 'first');
}

function criaDialogNovoEndereco() {
	dialogNovoEndereco = criaDialog({
		title : 'Novo Endereço',
		style : 'width: 345px;'
	});
	
	dialogNovoEndereco.containerNode.innerHTML = dojo.byId('templateAlterar').innerHTML;
	
	// Remove o botão Salvar e o H2 que não vamos usar
	dojo.destroy(dojo.query("h2", dialogNovoEndereco.containerNode)[0]);
	dojo.destroy(dojo.query("img[class='salvar']", dialogNovoEndereco.containerNode)[0]);
	
	var container = dialogNovoEndereco.containerNode;
	
	// Adiciona o botão OK e o Cancelar
	var sOk = '<img src="' + contexto + '/resources/img/botaoOK.png" alt="OK" />';
	var ok = dojo.place(sOk, container);
	dojo.addClass(ok, 'botao');
	
	dojo.connect(ok, 'click', salvaNovoEndereco);
	
	var sCancelar= '<img src="' + contexto + '/resources/img/botaoCancela.png" alt="Cancelar" />';
	var cancelar = dojo.place(sCancelar, container);
	dojo.addClass(cancelar, 'botao');
	
	dojo.connect(cancelar, 'click', function (evt) {
		dialogNovoEndereco.hide();
	});
	
	var formulario = dojo.query('form', container)[0];
	var linkCep = dojo.query("a[href='cep']", formulario)[0];
	dojo.connect(linkCep, 'click', function (evt) {
		evt.preventDefault();
		encontraEndereco(formulario);
	});
}

function criaElementoEndereco(endereco) {
	var elemento = dojo.create('div', {id : endereco.id});
	dojo.addClass(elemento, 'endereco');
	
	criaInteriorElemento(elemento, endereco);
		
	return elemento;
}

function criaInteriorElemento (elemento, endereco) {
	dojo.place('<h2>' + trimTexto(endereco.street, 35) + '</h2>', elemento);
	
	var paragrafo = dojo.create('p', null, elemento);
	
	var inner = 'CEP: ' + formataCEP(endereco.zip) + '<br />';
	inner += trimTexto(endereco.street, 45) + '<br />';
	
	inner += 'Número/Complemento: ' + endereco.number;
	if (endereco.additionalInfo && endereco.additionalInfo != '') inner += ", " + endereco.additionalInfo;
	inner += '<br />';
	
	inner += 'Bairro: ' + endereco.neighborhood + '<br />';
	inner += 'Cidade: ' + endereco.city + '<br />';
	inner += 'Estado: ' + endereco.state +'<br />';
	inner += 'Telefone: ' + formataTelefone(endereco.phone);
	
	paragrafo.innerHTML = inner;
	
	var sImagem = '<img class="botao" src="../../resources/img/btAlterar.png" alt="alterar endereço"/>';
	var imagem = dojo.place(sImagem, paragrafo);
	dojo.connect(imagem, 'onclick', function () {alteraEndereco(endereco.id);});
}

function criaNovoEndereco(event) {
	event.preventDefault();
	
	if (dialogNovoEndereco == null) {
		criaDialogNovoEndereco();
	}
	
	dialogNovoEndereco.show();
}

function encontraEndereco(formulario) {
	var camposEndereco = dojo.formToObject(formulario);
	
	var cep = camposEndereco.zip;
	if (!cep || cep == '') {
		alert('CEP inválido: "' + cep + '"');
		return;
	}
	
	bloquear(formulario);
	cep = limpaCEP(cep);

	dojo.xhr('GET', {
		url : contexto + "/getAddressByZip.do",
		handleAs : 'json',
		load : function(response) {
			preencheEndereco(response, formulario);
			desbloquear();
		}
	});
}

function getEndereco(idEndereco) {
	for (var i = 0; i < enderecos.length; i++) {
		if (enderecos[i].id == idEndereco) {
			return enderecos[i];
		}
	}
	
	return null;
}

function limpaListaEnderecos () {
	dojo.query('#enderecos div').forEach(dojo.destroy);
}

function mudouEndereco(endereco, dadosFormulario) {
	for (var prop in endereco) {
		if (prop == 'id') continue;
		if (endereco[prop] != dadosFormulario[prop])
			return true;
	}
	
	return false
}

function preencheComEndereco(elementoEndereco, endereco) {
	dojo.query("h2", elementoEndereco)[0].innerHTML = trimTexto(endereco.street, 35);
	dojo.query("input[name='zip']", elementoEndereco)[0].value = formataCEP(endereco.zip);
	dojo.query("input[name='street']", elementoEndereco)[0].value = endereco.street;
	dojo.query("input[name='number']", elementoEndereco)[0].value = endereco.number;
	
	if (endereco.additionalInfo) {
		dojo.query("input[name='additionalInfo']", elementoEndereco)[0].value = endereco.additionalInfo;
	}
	
	dojo.query("input[name='neighborhood']", elementoEndereco)[0].value = endereco.neighborhood; 
	dojo.query("input[name='city']", elementoEndereco)[0].value = endereco.city;
	dojo.query("input[name='state']", elementoEndereco)[0].value = endereco.state;
	
	dojo.query("input[name='regionCode']", elementoEndereco)[0].value = getDDD(endereco.phone); 
	dojo.query("input[name='phone']", elementoEndereco)[0].value = getTelefone(endereco.phone);
	
	var salvar = dojo.query("img[class='salvar']", elementoEndereco)[0];
	dojo.connect(salvar, 'onclick', function () {salvaEndereco(endereco.id);});
}

function preencheComidaPreferida() {
	dojo.xhr('GET', {
		url : contexto + "/getPreferredFood.do",
		load : function (response) {
			var objeto = dojo.fromJson(response);
			if (!checaLogado(objeto)) {
				alert('Usuário não está logado.');
				return;
			}
			
			var preferidas = objeto.items;
			for (var i = 0; i < preferidas.length; i++) {
				dojo.query("input[value='" + preferidas[i] + "']")[0].checked = 'checked';
			}
		}
	});
}

function preencheDadosUsuario () {
	if (!checaLogado(usuario)) {
		alert('Usuário não está logado.');
		throw new Error('O usuário não está logado.');
	}
	
	dojo.byId('email').value = usuario.login;
	dojo.byId('userName').value = usuario.name; 
	
	var telefone = usuario.address.phone;
	dojo.byId('regionCode').value = getDDD(telefone);
	dojo.byId('phone').value = getTelefone(telefone);
	
	if (usuario.birthDate) {
		var bDay = usuario.birthDate;
		var y = bDay.substring(0, 4);
		var m = bDay.substring(5, 7);
		var d = bDay.substring(8, 10);
		dojo.byId('bDay').value = formataData(new Date(y, parseInt(m) - 1, d));
	}
	
	if (usuario.gender && usuario.gender == 'F') {
		var radio = dojo.query("input[value='female']")[0];
		radio.checked = 'checked';
	} else {
		var radio = dojo.query("input[value='male']")[0];
		radio.checked = 'checked';
	}
	
	if (usuario.receiveNewsletter) {
		dojo.byId('receiveNewsletter').checked = 'checked';
	}
}

function preencheEndereco(endereco, formulario) {
	dojo.query("input[name='street']", formulario)[0].value = endereco.street;
	dojo.query("input[name='state']", formulario)[0].value = endereco.state;
	dojo.query("input[name='city']", formulario)[0].value = endereco.city;
	dojo.query("input[name='neighborhood']", formulario)[0].value = endereco.neighborhood;
}

function preencheListaEnderecos() {
	var listaEnderecos = dojo.byId('enderecos');
	for (var i = 0; i < enderecos.length; i++) {
		dojo.place(criaElementoEndereco(enderecos[i]), listaEnderecos, 'first');
	}
	removeLoaderEnderecos();
}

function removeLoaderEnderecos() {
	if (loaderEnderecos) {
		dojo.destroy(loaderEnderecos);
		loaderEnderecos = null;
	}
}

function salvaEndereco (idEndereco) {
	var elemento = elemento = dojo.byId(idEndereco + '');
	
	var formulario = dojo.query('form', elemento)[0];
	
	if (validaDados(formulario, elemento, 'first')) {
		var dados = dojo.formToObject(formulario);
		
		// Arruma o telefone
		if (dados.regionCode) {
			dados.phone = dados.regionCode + dados.phone;
		}
		
		dados.phone = limpaTelefone(dados.phone);
		dados.zip = limpaCEP(dados.zip);
		
		// Se não mudou, volta ao que estava antes
		if (!mudouEndereco(getEndereco(idEndereco), dados)) {
			atualizaEndereco(idEndereco);
			return;
		}
		
		limpaListaEnderecos();
		colocaLoaderEnderecos();
		
		dojo.xhrPost({
			url : contexto + '/saveAddress.do',
			content: dados,
			handleAs : 'json',
			load : function (response) {
				if (!checaSucesso(response)) {
					alert('Erro ao salvar endereço.');
				}
				
				carregaEnderecos(preencheListaEnderecos());
			}
		});
	}
}

function salvaNovoEndereco() {
	var dialogContainer = dialogNovoEndereco.containerNode;
	var formulario = dojo.query('form', dialogContainer)[0];
	
	if (validaDados(formulario, dialogContainer, 'first')) {
		var dados = dojo.formToObject(formulario);
		
		// Arruma o telefone e o CEP
		if (dados.regionCode) {
			dados.phone = dados.regionCode + dados.phone;
		}
		
		dados.phone = limpaTelefone(dados.phone);
		dados.zip = limpaCEP(dados.zip);
		
		// Esconde a Dialog
		dialogNovoEndereco.hide();
		
		// Limpa a lista de endereços e coloca o loader
		limpaListaEnderecos();
		
		colocaLoaderEnderecos();
		
		dojo.xhrPost({
			url : contexto + '/saveAddress.do',
			content: dados,
			handleAs : 'json',
			load : function (response) {
				if (!checaSucesso(response)) {
					alert('Erro ao salvar endereço.');
				}
				
				enderecos = response;
				
				carregaEnderecos(preencheListaEnderecos);
			}
		});
	}
}

/* ------ Eventos ------ */


/* ------ Inicialização ------ */
function configuraAbas() {
	var dadosLink = dojo.byId('dadosLink');
	dojo.connect(dadosLink, 'onclick', function (evt) {
		evt.preventDefault();
		ativaAba('dadosLink', 'dadosCadastrais');
	});
	
	var enderecosLink = dojo.byId('enderecosLink');
	dojo.connect(enderecosLink, 'onclick', function (evt) {
		evt.preventDefault();
		if (enderecos == null) carregaEnderecos(preencheListaEnderecos, true);
		ativaAba('enderecosLink', 'enderecos');
	});
}

dojo.addOnLoad (function () {
	ativaAba('dadosLink', 'dadosCadastrais');
	configuraAbas();
	
	// Se o usuário não estiver logado, isso deverá jogar uma exceção
	preencheDadosUsuario();
	preencheComidaPreferida();
	
	// Para criar novos endereços
	dojo.connect(dojo.query("#enderecos a[href='novoEndereco']")[0], 'click', criaNovoEndereco);
	
	dojo.connect(dojo.byId('enviarDados'), 'onclick', function (evt) {
		if (validaDados('dadosForm', dojo.byId('abas'), 'after')) {
			dojo.byId('dadosForm').submit();
		}
	});
	
	dojo.connect(dojo.byId('bDay'), 'onfocus', function (evt) {
		var calendar = new  dojox.widget.Calendar({}, dojo.byId('bDayCalendar'));
		var d = evt.target.value;
		if (d && d != '') {
			calendar.attr('value', getData(d));
		}
		
		dojo.connect(calendar, 'onValueSelected', function (date) {
			dojo.byId('bDay').value = formataData(date);
			calendar.destroy();
			dojo.place('<div id="bDayCalendar"></div>', 'bDayWrap', 'after');
		});
		dojo.connect(calendar.domNode, 'onmouseleave', function () {
			calendar.destroy();
			dojo.place('<div id="bDayCalendar"></div>', 'bDayWrap', 'after');
		});
	});
});