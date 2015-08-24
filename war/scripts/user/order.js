////////////////////////////
// ----- Requires --------//
////////////////////////////
dojo.require('dijit.Dialog');
dojo.require('dojox.fx._base');

dojo.require("comum.format");
dojo.require("comum.user");

// //////////////////////////
// ------ Variáveis -------//
// //////////////////////////
var dialogTroca = null;
var enderecoEntrega = null;
var enderecosDeEntrega = null;

var ordem = null;
var taxaDeEntrega = null;

// //////////////////////////
// ------ Funções --------//
// //////////////////////////
function carregaOrdem() {
	dojo.xhr('GET', {
		url : contexto + '/getOrder.do',
		load : function (response) {
			ordem = dojo.eval(response);
			if (!checaLogado(ordem)) {
				alert('Usuário não está logado.');
				return;
			}
			
			preencheDadosPedido();
		}
	});
}

function criaItemCompra(item) {
	var resultado = dojo.create('tr');
	dojo.addClass(resultado, 'item');

	var texto = '<td class="colunaItem"><span>';
	texto += item.plate.title + '</span>';
	
	// Observação
	if (item.obs) {
		texto += '<br />Observação: ' + item.obs;
	}
	
	// Acompanhamentos
	if (item.plate.sideDishes) {
		texto += '<br />Acompanhamentos: ';
		var acompanhamentos = item.plate.sideDishes; 
		for (var i = 0; i < acompanhamentos.length; i++) {
			// O mesmo acompanhamento pode aparecer várias vezes
			for (j = 0; j < acompanhamentos[i].quantity; j++) {
				texto += acompanhamentos[i].name + " (" + formataMoeda(acompanhamentos[i].cost) + ")";
				if (j != acompanhamentos[i].quantity - 1) texto += ', ';
			}
			if (i != acompanhamentos.length - 1) texto += ', ';
		}
	}

	texto += '<td>' + formataMoeda(getCusto(item.plate)) + '</td>';
	texto += '<td>- <input type="text" size="3" value="' + item.quantity + '" readonly="readonly"/> +</td>';
	texto += '<td>' + formataMoeda(getCusto(item.plate) * item.quantity) + '</td>';

	var produto = dojo.place(texto, resultado);

	return resultado;
}

/**
 * Usado para criar um endereço de entrega que será mostrado na lista de escolha
 * de endereços de entrega.
 * 
 * @return {DOMNode} O nó que representa o endereço de entrega.
 */
function criaItemEndereco(endereco) {
	var item = dojo.create('div', null);
	item.innerHTML = trimTexto(endereco.street, 60) + ", " + endereco.number;

	dojo.addClass(item, 'endereco');

	if (endereco.additionalInfo)
		item.innerHTML += ", " + endereco.additionalInfo;

	item.innerHTML += "<br />";
	item.innerHTML += endereco.city + " - " + endereco.state;
	item.innerHTML += " - " + formataCEP(endereco.zip);

	dojo.connect(item, 'onclick', function() {
		setEndereco(endereco);
		dialogTroca.hide();
		dojox.fx.highlight( {
			node : 'endereco',
			delay : 500,
			duration : 500
		}).play();
	});

	return item;
}

/**
 * Mostra a lista com todos os endereços de entrega alternativos - exclui o
 * endereço atualmente selecionado - do usuário para que ele possa alterar.
 * 
 * @return
 */
function escolheEndereco() {
	if (dialogTroca == null) {
		dialogTroca = criaDialog( {
			title : 'Alterar Endereço de Entrega',
			style : 'width: 500px; height: 300px'
		});
	}
	
	function preencheEnderecos () {
		// Limpa o Dialog
		dialogTroca.containerNode.innerHTML = '';

		dojo.forEach(enderecosDeEntrega, function(endereco) {
			if (endereco.id != enderecoEntrega.id) {
				dojo.place(criaItemEndereco(endereco),
						dialogTroca.containerNode);
			}
		});
	}
	
	colocaLoader(dialogTroca.containerNode);
	dialogTroca.show();
	dojo.style(dialogTroca.containerNode, 'height', '256px');
	
	// Se não tiver carregado os endereços ainda
	if (enderecosDeEntrega == null) {
		dojo.xhr('GET', {
			url : contexto + '/getAddresses.do',
			handleAs : 'json',
			load : function(response) {
				if (!checaLogado(response)) {
					alert('Usuário não está logado.');
					dialogTroca.hide();
					return;
				}
			
				enderecosDeEntrega = response;
				preencheEnderecos();
			}
		});
	} else {
		preencheEnderecos();
	}
}

function getCusto (prato) {
	var total = 0;
	total += prato.cost;
	
	if (prato.sideDishes) {
		var acompanhamentos = prato.sideDishes; 
		for (var i = 0; i < acompanhamentos.length; i++) {
			total += acompanhamentos[i].cost * acompanhamentos[i].quantity;
		}
	}
	
	return total;
}

function preencheDadosUsuario() {
	dojo.byId('nome').innerHTML = usuario.name;
	setEndereco(usuario.address);
}

function preencheDadosPedido() {
	var tbody = dojo.query('#itensPedido tbody')[0];
	dojo.empty(tbody);
	
	var itensCompra = ordem.items;
	
	var subtotal = 0;
	for (var i = 0; i < itensCompra.length; i++) {
		var elementoItem = criaItemCompra(itensCompra[i]);
		dojo.place(elementoItem, tbody);
		
		subtotal += getCusto(itensCompra[i].plate);
	}
	
	var taxa = ordem.deliveryCost;
	
	dojo.byId('subtotal').innerHTML = formataMoeda(subtotal);
	dojo.byId('taxa').innerHTML = formataMoeda(taxa);
	dojo.byId('total').innerHTML = formataMoeda(taxa + subtotal);
}

function setEndereco(endereco) {
	enderecoEntrega = endereco;

	var sEndereco = endereco.street;
	sEndereco += ", " + endereco.number;
	sEndereco += (endereco.additionalInfo && endereco.additionalInfo != '') ? ", "
			+ endereco.additionalInfo
			: '';
	sEndereco += " - " + endereco.city;
	sEndereco += " - " + endereco.state;

	dojo.byId('endereco').innerHTML = sEndereco;
	dojo.byId('telefone').innerHTML = formataTelefone(endereco.phone);
}

// //////////////////////////
// ---- Inicialização ----//
// //////////////////////////
dojo.addOnLoad(function() {
	// Se o usuário não estiver logado, redireciona ele para a página de login
	if (usuario.failure) {
			window.location = "login.jsp";
		} else {
			enderecoEntrega = usuario.address;
			preencheDadosUsuario();
		}

		dojo.connect(dojo.byId('mudarEnderecoBotao'), 'onclick',
				escolheEndereco);
		
		dojo.connect(dojo.byId('alterarPedidoBotao'), 'onclick',
				function (evt) {window.location = contexto + "/" ;});

		carregaOrdem();
	});