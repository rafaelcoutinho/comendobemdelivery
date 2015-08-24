//----- Requires -----
dojo.require('comum.CampoRedondo');
dojo.require('comum.format');

dojo.provide('main.Pedido');
dojo.declare('main.Pedido', null, (function () {
	//Funções privadas
	var _criaElementoPedido = function (item) {
		if (item == null) return null;
		var elemento = dojo.create('li', {id : item.plate.id});
		var maximo = 16;
		if (item.quantity > 10) maximo = 15;
		
		var titulo = item.plate.title;
		if (titulo.length > maximo) {
			titulo = titulo.substring(0, maximo - 3);
			titulo += '...';
			dojo.attr(elemento, 'title', item.title);
		}
		
		elemento.innerHTML = item.quantity + ' ' + titulo;
		
		dojo.place('<span title="Remover" >X</span>', elemento);
		
		dojo.connect(elemento, 'onmouseenter', function () {
			dojo.addClass(elemento, 'sobre');
		});
		dojo.connect(elemento, 'onmouseleave', function () {
			dojo.removeClass(elemento, 'sobre');
		});
		dojo.connect(elemento, 'onclick', function () {
			_itemSelecionado(item, elemento);
		});
		
		return elemento;
	};
	
	var _itemSelecionado = function (item, elemento) {
		// Clicou em item previamente selecionado
		if (dojo.hasClass(elemento, 'selecionado')) {
			_limpaSelecao();
			_preencheItemSelecionado(null);
		
		// Selecionou um item
		} else {
			_limpaSelecao();			
			dojo.addClass(elemento, 'selecionado');
			_preencheItemSelecionado(item);
		}
	};
	
	var _limpaCampos = function () {
		var elPedido = dojo.byId('pedido');
		
		_preencheItemSelecionado(null);
		
		var elPratos = dojo.query('#totalPratos', elPedido)[0];
		elPratos.innerHTML = '';
		
		var elSubTotal = dojo.query('#subTotal', elPedido)[0];
		elSubTotal.innerHTML = '';
		
		var elTaxaEntrega = dojo.query('#taxaDeEntrega', elPedido)[0];
		elTaxaEntrega.innerHTML = '';
	};
	
	var _limpaSelecao = function () {
		dojo.forEach(dojo.query('#pedido ul > li.selecionado'), function (item) {
			dojo.removeClass(item, 'selecionado');
		});
	};
	
	var _preencheItemSelecionado = function (item) {
		var elItemSelecionado = dojo.byId('itemSelecionado');
		var elValorUnitario = dojo.byId('valorUnitario');
		var elQuantidade = dojo.byId('quantidade');
		var btAcomp = dojo.byId('acompanhamentosEObservacoes');
		
		if (item == null) {
			elItemSelecionado.innerHTML = '[Selecione Acima]';
			
			elValorUnitario.innerHTML = '';
			
			dojo.attr(elQuantidade, 'value', '');
			elQuantidade.value = '';

			dojo.attr(btAcomp, 'disabled', 'disabled');
			dojo.addClass(btAcomp, 'desligado');
		} else {
			var maximo = 20; // largura máxima do campo
			var titulo = item.plate.title;
			if (titulo.length > maximo) {
				titulo = titulo.substring(0, maximo - 3);
				titulo += '...';
			}
			
			elItemSelecionado.innerHTML = titulo;
			
			var precoUnitario = 0;
			precoUnitario += item.plate.cost;
			if (item.plate.sideDishes) {
				for (var i = 0; i < item.plate.sideDishes.length; i++) {
					precoUnitario += item.plate.sideDishes[i].cost * item.plate.sideDishes[i].quantity;
				}
			}
			elValorUnitario.innerHTML = formataMoeda(precoUnitario);
			
			dojo.attr(elQuantidade, 'value', item.quantity);
			elQuantidade.value = item.quantity;

			dojo.removeAttr(btAcomp, 'disabled');
			dojo.removeClass(btAcomp, 'desligado');
		}
	};
	
	var _preenchePedido = function (pedido) {
		var elPedido = dojo.byId('pedido');
		
		var subTotal = 0;
		
		var elLista = dojo.query('ul', elPedido)[0];
		dojo.empty(elLista);
		for (var i = 0; i < pedido.items.length; i++) {
			var item = pedido.items[i];
			
			var elItemPedido = _criaElementoPedido(item);
			dojo.place(elItemPedido, elLista);
			
			subTotal += item.quantity * item.plate.cost;
			if (item.plate.sideDishes) {
				for (var j = 0; j < item.plate.sideDishes.length; j++) {
					var subItem = item.plate.sideDishes[j];
					subTotal += (subItem.cost * subItem.quantity) * item.quantity;
				}
			}
		}

		var elValorUnitario = dojo.query('#valorUnitario', elPedido)[0];
		elValorUnitario.innerHTML = '';

		var elQuantidade = dojo.query('#quantidade', elPedido)[0];
		dojo.attr(elQuantidade, 'value', '');
		elQuantidade.value = '';
		
		var elPratos = dojo.query('#totalPratos', elPedido)[0];
		elPratos.innerHTML = pedido.items.length;
		
		var elSubTotal = dojo.query('#subTotal', elPedido)[0];
		elSubTotal.innerHTML = formataMoeda(subTotal);
		
		var elTaxaEntrega = dojo.query('#taxaDeEntrega', elPedido)[0];
		elTaxaEntrega.innerHTML = formataMoeda(pedido.deliveryCost);
	};
	
	// O objeto Pedido
	var Pedido = {
		pedido : null,
		
		constructor : function () {
			_limpaCampos();
		},
		
		adicionar : function (paraAdicionar) {
			var lista = dojo.query('#pedido ul')[0];
			dojo.empty(lista);
			dojo.place('<li>Adicionando: <br />' + paraAdicionar.quantity + ' x ' 
					+ paraAdicionar.name + '</li>', lista);
			var itemListaLoader = dojo.place('<li />', lista);
			colocaLoader(itemListaLoader);
			
			// Para recarregar o pedido
			this.pedido = null;
			
			var callback = dojo.hitch(this, function (response) {
				if (response.status && response.status == 'SUCCESS') {
					this.preenchePedido();
				}
			});
			
			dojo.xhrPost({
				url : contexto + '/addToOrder.do',
				handleAs : 'json',
				content : paraAdicionar,
				handle : function () {
					dojo.destroy(itemListaLoader);
				},
				load : callback
			});
		},
		
		escondePedido : function () {
			
		},
	
		getPedido : function (callback) {
			var lista = dojo.query('#pedido ul')[0];
			dojo.empty(lista);
			dojo.place('<li>Carregando pedido...</li>', lista);
			var itemListaLoader = dojo.place('<li />', lista);
			colocaLoader(itemListaLoader);
			
			if (this.order == null) {
				dojo.xhr('GET', {
					url : contexto + '/getOrder.do',
					handleAs : 'json',
					load : function (response) {
						this.pedido = response;
						callback();
					},
					error : callback
				});
			} else {
				return this.pedido;
			}
		},
		
		mostraPedido : function () {
			dojo.animateProperty({
				node : dojo.byId('pedidoWrapper'),
				properties : {
					right: { end : 0, unit : 'px'}
				},
				duration: 250,
				easing : dojo.fx.easing['expoOut']
			}).play();
		},
		
		preenchePedido : function () {			
			if (this.pedido == null) {
				this.getPedido(this.preenchePedido);
			} else {
				_preenchePedido(this.pedido);
			}
		}
	};
	
	return Pedido;
})());