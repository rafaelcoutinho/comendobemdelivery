//----- Requires -----
dojo.require('comum.format');
dojo.require('comum.CampoRedondo');
dojo.require('main.Pedido');

dojo.provide('main.Restaurante');
dojo.declare('main.Restaurante', null, {
	restaurante : null,
	loader : null,
	restaurantes : new Array(),
	pedido : null,
	
	constructor : function () {
		this.pedido = new main.Pedido();
		this.pedido.preenchePedido();
	},
	
	carregando : function () {
		this.loader = colocaLoader(dojo.query('#cardapio tbody')[0], 'only');
		dojo.query('#tituloRestaurante h2')[0].innerHTML = 'Carregando';
	},
	
	carregaRestaurante : function (id) {
		if (this.restaurante != null && this.restaurante.id == id) return;
		
		var novoRestaurante = null;
		
		dojo.forEach(this.restaurantes, function (item) {
			if (item.id == id) {
				novoRestaurante = item;
				return false;
			}
		}, this);
		
		// Se encontrou o restaurante já carregado
		if (novoRestaurante != null) {
			this.restaurante = novoRestaurante;
			this.preencheRestaurante();
			return;
		}
		
		var callback = dojo.hitch(this, function (response) {
			if (response.failure) {
				alert('Restaurante não encontrado.');
				this.preencheRestaurante();
				return;
			}
			
			this.restaurante = response;
			this.restaurantes.push(this.restaurante);
			this.preencheRestaurante();
		});
		
		// Se não, carrega
		dojo.xhr('GET', {
			url : contexto + '/getRestaurant.do',
			content : {id : id},
			handleAs : 'json',
			load : callback,
			error: callback
		});
	},
	
	criaItemCardapio : function (item) {
		var resultado = dojo.create('tr', { id : item.id });
		
		var descricao = dojo.create('td', null, resultado);
		dojo.addClass(descricao, 'descricao');
		descricao.innerHTML = '<span>' + item.title + '</span> - ' + item.description;
		
		dojo.place('<td>' + formataMoeda(item.price) + '</td>', resultado);
		
		var quantidade = dojo.place('<td class="quantidade"></td>', resultado);
		dojo.place('<span>- </span>', quantidade);
		var campo = new comum.CampoRedondo({largura:25, altura: 15, name: 'quantidade'});
		var outroNo = dojo.place(campo.domNode, quantidade);
		dojo.place('<span> +</span>', quantidade);
		
		campo.setValor(1);
			
		var acompanhamentos = dojo.place('<td><a href="#">Selecionar</a></td>', resultado);
		
		var pedir = dojo.place('<td></td>', resultado);
		
		var callback = dojo.hitch(this, function (evt) {			
			var tr = evt.currentTarget.parentNode;
			var id = dojo.attr(tr, 'id');
			var campoQtd = dojo.query('input', tr)[0];
			var quantidade = campoQtd.value;
			
			var nome = dojo.query('.descricao span', tr)[0].innerHTML;
			
			this.pedido.adicionar({id : id, quantity : quantidade, name : nome});
		});
		
		dojo.connect(pedir, 'onclick', callback);
		
		var imagemPedir = dojo.place('<img src="../../resources/img/btPedir.png" alt="Pedir" />', pedir);
		
		return resultado;
	},
	
	limpaCampos : function () {
		var titulo = dojo.byId('tituloRestaurante');
		
		var imagem = dojo.query('img', titulo)[0];
		dojo.attr(imagem, 'src', '');
		dojo.attr(imagem, 'alt', '');
		
		var nomeRestaurante = dojo.query('h2', titulo)[0];
		dojo.empty(nomeRestaurante);
		
		var descricao = dojo.query('p', titulo)[0];
		descricao.innerHTML = '';
		
		var listaCategorias = dojo.byId('categorias');
		dojo.empty(listaCategorias);
		
		var tabelaCardapio = dojo.query('#cardapio tbody')[0];
		dojo.empty(tabelaCardapio);
	},
	
	mostraCategoria : function (categoria) {
		if (this.restaurante == null) return;
		
		dojo.query('#categorias li').forEach(function (item) {
			if (item.innerHTML == categoria) {
				dojo.addClass(item, 'selecionado');
				return false;
			}
		});
		
		var tabelaCardapio = dojo.query('#cardapio tbody')[0];
		dojo.empty(tabelaCardapio);
		
		var pratos = this.restaurante.plates;
		for (var i = 0; i < pratos.length; i++) {
			var prato = pratos[i];
			if (prato.category == categoria) {
				dojo.place(this.criaItemCardapio(prato), tabelaCardapio);
			}
		}
	},
	
	preencheCardapio : function (itens) {
		if (!itens) return;
		
		var listaCategorias = dojo.byId('categorias');
		dojo.empty(listaCategorias);
		
		var categorias = new Array();
		for (var i = 0; i < itens.length; i++) {
			if (dojo.indexOf(categorias, itens[i].category) == -1) {
				var categoria = itens[i].category;
				categorias.push(categoria);
				var itemCategoria = dojo.place('<li>' + categoria + '</li>', listaCategorias);
				
				var callback = dojo.hitch(this, function (evt) {
					var categoria = evt.target.innerHTML;
					var selecionado = dojo.query('.selecionado', listaCategorias)[0];
					if (selecionado) {
						// se for o mesmo não faz nada
						if (selecionado.innerHTML == categoria) return;
						
						// Se não for o mesmo, remove a classe
						dojo.removeClass(selecionado, 'selecionado');
					}
					this.mostraCategoria(categoria);
				});
				
				dojo.connect(itemCategoria, 'onclick', callback);
			}
		}
		
		categorias.sort();
		this.mostraCategoria(categorias[0]);
	},
	
	preencheRestaurante : function () {
		if (!this.restaurante) {
			dojo.style('conteudo_main', 'display', 'block');
			dojo.style('conteudo_restaurante', 'display', 'none');
			return;
		}
		
		// Remove o loader se tiver
		if (this.loader) dojo.destroy(this.loader);
		
		var titulo = dojo.byId('tituloRestaurante');
		
		var imagem = dojo.query('img', titulo)[0];
		dojo.attr(imagem, {
			src : contexto + '/' + this.restaurante.imageUrl,
			alt : this.restaurante.imageAlt
		});
		
		var nomeRestaurante = dojo.query('h2', titulo)[0];
		nomeRestaurante.innerHTML = this.restaurante.name;
		
		var descricao = dojo.query('p', titulo)[0];
		descricao.innerHTML = this.restaurante.description;
		
		this.preencheCardapio(this.restaurante.plates);
		this.pedido.mostraPedido();
	},
	
	setRestaurante : function (id) {
		window.location.hash = 'restaurantId=' + id;
		if (this.restaurante == null || id != this.restaurante.id) {
			this.limpaCampos();
			this.carregando();
			this.carregaRestaurante(id);
		}
	}
});