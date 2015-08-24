/* ------ Requires ------ */
dojo.require("comum.format");
dojo.require("comum.user");
dojo.require("comum.Paginacao");

/* ------ Variáveis ------ */
var filtrados = new Array();
var pedidos = new Array();
var emAndamento = new Array();
var historico = new Array();

var filtrarCom = null;

var paginacaoHistorico = null;

/* ------ Funções ------ */
function carregaPedidos(callback) {
	habilitaFiltro(false);
	dojo.xhr('GET', {
		url : contexto + '/getOrders.do',
		handleAs : 'json',
		load : function (response) {
			if (!checaLogado(response)) {
				alert('Usuário não está logado.');
				return;
			}
			
			for (var i = 0; i < response.length; i++) {
				var pedido = response[i];
				if (pedido.status == 'FINISHED' || pedido.status == 'CANCELLED') {
					historico.push(pedido);
				} else {
					emAndamento.push(pedido);
				}
			}
			
			callback();
			habilitaFiltro(true);
		}
	});
}

function contemTexto(pedido) {
	if (!filtrarCom || filtrarCom == '') return true;
	
	var texto = filtrarCom.toLowerCase();
	if (pedido.id.indexOf(texto) != -1) return true;
	if (formataData(pedido.date).indexOf(texto) != -1) return true;
	if (pedido.time.indexOf(texto) != -1) return true;
	if (traduzStatus(pedido.status)[0].toLowerCase().indexOf(texto) != -1) return true;
	if (pedido.restaurant.name.toLowerCase().indexOf(texto) != -1) return true;
	if (tiraAcentos(pedido.restaurant.name).toLowerCase().indexOf(texto) != -1) return true;
	
	return false;
}

function criaElementoPedido(pedido) {
	var destacar = filtrarCom;
	var resultado = dojo.create('tr');
	
	var ordem = '<td><a href="order.jsp?id=' + pedido.id + '">';
	ordem += destacaTexto(pedido.id, destacar) + '</a></td>';
	dojo.place(ordem, resultado);
	
	dojo.place('<td>' + destacaTexto(formataData(pedido.date), destacar) + '</td>', resultado);
	dojo.place('<td>' + destacaTexto(pedido.time, destacar) + '</td>', resultado);
	
	var statusPedido = traduzStatus(pedido.status);
	var status = dojo.place('<td>' + destacaTexto(statusPedido[0], destacar) + '</td>', resultado);
	dojo.addClass(status, statusPedido[1]);
	
	var rest = '<td><a href="' + contexto + 'jsp/main.jsp?restId=';
	rest += pedido.restaurant.id + '">' + destacaTexto(pedido.restaurant.name, destacar)  + '</a></td>';
	dojo.place(rest, resultado);
	
	dojo.connect(resultado, 'onmouseenter', function (evt) {dojo.addClass(resultado, 'sobre');});
	dojo.connect(resultado, 'onmouseleave', function (evt) {dojo.removeClass(resultado, 'sobre');});
	
	return resultado;
}

function destacaTexto (conteudo, texto) {
	if (!texto || texto == '') return conteudo;
	
	if (conteudo.indexOf(texto) != -1) {
		conteudo = conteudo.replace(new RegExp(texto, 'ig'),'<span class="highlight">' +  texto + '</span>');
	}
	
	return conteudo;
}

function filtraLista (texto) {
	// Mostra pelo que estamos filtrando
	filtrarCom = texto;
	paginacaoHistorico.filtra();
	
	var quantidade = paginacaoHistorico.filtrados.length;
	var mensagem = quantidade;
	mensagem += quantidade > 1 ? ' encontrados. ' : ' encontrado. ';
	mensagem += 'Filtrando por: "' + texto + '"';
	dojo.byId('filtrandoPor').innerHTML = mensagem;
}

function habilitaFiltro(habilita) {
	habilitaCampo('filtrarHistorico', habilita);
	habilitaCampo('limparFiltro', habilita);
}

function preencheEmAndamento () {
	var tabelaAbertos = dojo.query('#andamento tbody')[0];
	
	var contador = 0;
	for(var i = 0; i < emAndamento.length; i++) {
		dojo.place(criaElementoPedido(emAndamento[i]), tabelaAbertos);
		contador ++;
	}
	
	dojo.query('#barraWelcome h2')[0].innerHTML = usuario.name + ',';
	
	var mensagem = '';
	if (contador == 0) {
		mensagem = 'Você não tem nenhum pedido em andamento.';
	} else {
		mensagem = 'Você tem <span>';
		mensagem += contador + '</span>';
		mensagem += contador > 1 ? ' pedidos' : ' pedido';
		mensagem += ' em andamento.';
	}
	dojo.byId('mensagem').innerHTML = mensagem;
}

function preencheHistorico () {
	filtrarCom = null;
	paginacaoHistorico.filtra();
	
	var quantidade = paginacaoHistorico.filtrados.length; 
	var mensagem = quantidade;
	mensagem += quantidade > 1 ? ' pedidos finalizados' : ' pedido finalizado';
	dojo.byId('filtrandoPor').innerHTML = mensagem;
	dojo.byId('filtrarHistorico').value = '';
}

function preenchePedidos () {
	preencheEmAndamento();
	
	paginacaoHistorico = new comum.Paginacao({
		lista : dojo.query('#historico tbody')[0],
		botoes : dojo.byId('historicoPaginas'),
		criaNo : criaElementoPedido,
		filtraItem : contemTexto,
		elementos : historico
	});
	
	preencheHistorico();
}

function traduzStatus(status) {
	switch (status) {
		case 'FINISHED':
			return ['Finalizado', 'finalizado'];
		case 'CANCELLED':
			return ['Cancelado', 'cancelado'];
		case 'EVALUATED':
			return ['Analisado', 'analisado'];
		case 'INTRANSIT':
			return ['A caminho', 'caminho'];
		case 'NEW':
			return ['Novo', 'novo'];
		case 'VISUALIZED_BY_RESTAURANT':
			return ['Recebido', 'recebido'];
		case 'PREPARING':
			return ['Preparando', 'preparando'];
		default:
			return [status, status];
	}
}

/* ------ Inicialização ------ */
dojo.addOnLoad(function () {
	carregaPedidos(preenchePedidos);
	
	dojo.connect(dojo.byId('filtrarHistorico'), 'onkeyup', function (evt) {
		var textoBuscado = evt.target.value;
		filtraLista(textoBuscado);
	});
	
	dojo.connect(dojo.byId('limparFiltro'), 'onclick', preencheHistorico);
});