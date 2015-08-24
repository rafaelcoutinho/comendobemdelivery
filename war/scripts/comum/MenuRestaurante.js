dojo.require("dojo.fx.easing");

dojo.provide("comum.MenuRestaurante");

//Tempo que será usado nas animações em milisegundos
var tempoAnimacao = 500;
var menuRestaurantes = null;

/**
 * Compara dos restaurantes usando o nome. Esta funcão pode ser usada em
 * Array.sort.
 * 
 * @param r1
 *            O restaurante para comparar.
 * @param r2
 *            Outro restaurante.
 * @return 1 se o nome do primeiro for antes do segundo. 0 se forem iguais. -1
 *         se o segundo for antes do primeiro.
 */
function comparaRestaurantes(r1, r2) {
	if (r1.name > r2.name)
		return 1;
	if (r1.name == r2.name)
		return 0;
	return -1;
}

/**
 * Chamado quando o usuário clicar num tipo de restaurante.
 * 
 * @param evt
 *            Evento gerado.
 */
function clicarTipo(evt) {
	// DIV do tipo que foi clicado
	var elementoTipo = evt.currentTarget;

	// tipo que será mostrado
	var tipoParaCarregar = elementoTipo.innerHTML;

	// Troca o botão que está selecionado
	var tipos = dojo.query('#menuRestaurantes .tipo');
	for ( var i = 0; i < tipos.length; i++) {
		var tipo = tipos[i];

		// Se for este o tipo que tem que ser selecionado
		if (tipo.innerHTML == tipoParaCarregar) {
			// Usuário selecionou o mesmo elemento
			if (dojo.hasClass(tipo, 'selecionado')) {
				return;
			}

			// Se não, coloca a classe
			dojo.addClass(tipo, 'selecionado');
			continue;
		}

		// Se este estava selecionado, remove a classe
		if (dojo.hasClass(tipo, 'selecionado')) {
			dojo.removeClass(tipo, 'selecionado');
		}
	}

	var paraMostrar = dojo.byId('tipo_' + tipoParaCarregar);

	// Mostra o novo elemento
	var mostraNovo = dojo.animateProperty( {
		node : paraMostrar,
		properties : {
			top : {
				end : 0,
				unit : 'px'
			}
		},
		duration : tempoAnimacao,
		easing : dojo.fx.easing['expoOut']
	});

	// Procura por alguém selecionado
	var selecionados = dojo.query('#itens .selecionado');
	if (selecionados && selecionados.length > 0) {
		var elementoSelecionado = selecionados[0];
		dojo.removeClass(elementoSelecionado, 'selecionado');

		// Esconde o elemento selecionado
		dojo.animateProperty( {
			node : elementoSelecionado,
			properties : {
				top : {
					end : 250,
					unit : 'px'
				}
			},
			duration : tempoAnimacao,
			easing : dojo.fx.easing['expoOut'],
			onEnd : function() {
				mostraNovo.play();
			}
		}).play();
	} else {
		mostraNovo.play();
	}

	dojo.addClass(paraMostrar, 'selecionado');
}

/**
 * Coloca os DIVs onde serão colocados os tipos de restaurantes nos lugares
 * corretos.
 */
function rearranjaItemsMenu () {
	var altura = 35;

	// Rearranja os itens da lista de restaurantes
	dojo.query('#menuRestaurantes .esquerda').forEach(function(item, index) {
		dojo.style(item, 'top', ((index + 1) * altura) + "px");
	});

	dojo.query('#menuRestaurantes .direita').forEach(function(item, index) {
		dojo.style(item, 'top', ((index + 1) * altura) + "px");
	});
}

dojo.declare("comum.MenuRestaurantes", null, {
	tipos : new Array(), // mantém todos os tipos de restaurantes 
	restaurantes : new Array(), // mantém todos os restaurante
	
	/** 
	 * Função que será chamada quando o usuário clicar sobre
	 * o nome de um restaurante no menu.
	 * 
	 * @param id {String|Number} O ID do restaurante que deve ser
	 * mostrado.
	 */ 
	mostraRestaurante : function (id) {},
	
	constructor : function (args) {
		dojo.mixin(this, args);
		this.carregaRestaurantes();
	},
	
	carregaRestaurantes : function () {
		dojo.xhr("GET", {
			url : contexto + '/listRestaurants.do',
			handleAs : "json",
			load : function(response) {
				try{
					menuRestaurantes.restaurantes = response;
					menuRestaurantes.restaurantes.sort(comparaRestaurantes);

					menuRestaurantes.processaTipos();
					menuRestaurantes.recriaMenuRestaurantes();
				} catch (error) {console.log(error);}
			}
		});
	},
	
	
	/**
	 * Cria o DIV que mostrará todos os restaurantes de uma determinada categoria.
	 * 
	 * @param tipo
	 *            O tipo dos restaurantes mostrados.
	 * @param elementoPai
	 *            O elemento pai do elemento resultante.
	 */
	criaElementoTipoRestaurante : function (tipo, elementoPai) {
		var elementoTipo = dojo.create('div', {
			id : 'tipo_' + tipo
		}, elementoPai);

		var nomeImagem = tiraAcentos(tipo.toLowerCase() + ".jpg");

		dojo.addClass(elementoTipo, 'item');
		dojo.style(elementoTipo, 'background',
				"rgb(210, 208, 208) url('../../resources/img/bgMenu/" + nomeImagem
						+ "')");

		// Coloca um elemento para cada restaurante deste tipo
		var adicionados = 0;
		var linha = 1;
		for ( var i = 0; i < this.restaurantes.length; i++) {
			if (dojo.indexOf(this.restaurantes[i].type, tipo) != -1) {
				var restaurante = this.restaurantes[i];

				var elementoRestaurante = dojo.create('div', {
					id : restaurante.id
				}, elementoTipo);
				
				dojo.addClass(elementoRestaurante, 'restaurante');
				dojo.style(elementoRestaurante, 'top', (linha * 30) + "px");

				var nome = restaurante.name;
				if (nome.length > 14) {
					nome = nome.substring(0, 11) + "...";
					dojo.attr(elementoRestaurante, 'title', restaurante.name);
				}
				elementoRestaurante.innerHTML = nome + " ";
				
				dojo.connect(elementoRestaurante, 'onclick', dojo.hitch (this, function (evt) {
					var elemento = evt.currentTarget;
					this.mostraRestaurante(dojo.attr(elemento, 'id'));
				}));

				var spanStatus = dojo.create('span', null, elementoRestaurante);

				if (restaurante.isOpen) {
					dojo.addClass(spanStatus, 'aberto');
					spanStatus.innerHTML = "Aberto";
				} else {
					dojo.addClass(spanStatus, 'fechado');
					spanStatus.innerHTML = "Fechado";
				}

				if (adicionados < 7) {
					dojo.addClass(elementoRestaurante, 'ladoA');
				} else {
					dojo.addClass(elementoRestaurante, 'ladoB');
				}

				linha++;
				if (linha == 8)
					linha = 1;

				adicionados++;
			}
		}
	},
	
	/**
	 * Lê a lista de tipos que funciona como links para cada um deles.
	 */
	criaLinksTipos : function () {
		var elementosTipo = dojo.query('#menuRestaurantes .tipo');

		// Cria links dos tipos
		for ( var i = 0; i < this.tipos.length && i < elementosTipo.length; i++) {
			var elementoTipo = elementosTipo[i];

			elementoTipo.innerHTML = this.tipos[i];
			dojo.addClass(elementoTipo, 'cheio');

			dojo.connect(elementoTipo, 'onclick', clicarTipo);
		}
	},
	
	/**
	 * Lê a lista de tipos e restaurantes e cria os elementos de restaurantes a
	 * partir destes dados.
	 */
	criaLinksRestaurantes : function () {
		var elementoItens = dojo.byId('itens');

		// Cria um div para cada tipo
		for ( var i = 0; i < this.tipos.length; i++) {
			this.criaElementoTipoRestaurante(this.tipos[i], elementoItens);
		}
	},
	
	/**
	 * Se o usuário selecionou algum tipo de restaurante no menu, ele será
	 * deselecionado e a lista de restaurantes sumirá.
	 */
	deselecionaTipo : function () {
		var selecionados = dojo.query('#itens .selecionado');
		if (selecionados && selecionados.length > 0) {
			var elementoSelecionado = selecionados[0];

			// Esconde o elemento selecionado
			dojo.animateProperty( {
				node : elementoSelecionado,
				properties : {
					top : {
						end : 250,
						unit : 'px'
					}
				},
				duration : this.tempoAnimacao,
				easing : dojo.fx.easing['expoOut']
			}).play();
		}

		dojo.query('#menuRestaurantes .selecionado').forEach(function(item) {
			dojo.removeClass(item, 'selecionado');
		});
	},
	
	/**
	 * Recria a lista de tipos de restaurantes a partir da lista de restaurantes
	 * evitando tipos duplicados.
	 */
	processaTipos : function () {
		this.tipos = new Array();

		for ( var i = 0; i < this.restaurantes.length; i++) {
			var r = this.restaurantes[i];

			// Cada restaurante pode ter mais de um tipo
			for ( var j = 0; j < r.type.length; j++) {
				var tipo = r.type[j];
				if (dojo.indexOf(this.tipos, tipo) == -1) {
					this.tipos.push(tipo);
				}
			}
		}
		
		this.tipos.sort();
	},

	recriaMenuRestaurantes : function () {
		dojo.query('#menuRestaurantes .tipo').forEach(function(item, index) {
			item.innerHTML = " ";
			dojo.removeClass(item, 'cheio');
		});

		dojo.empty('itens');

		this.criaLinksTipos();
		this.criaLinksRestaurantes();
	}
});


// ////////////////////////
// ------ Eventos ------//
// ////////////////////////
dojo.addOnLoad(function() {
	rearranjaItemsMenu();
});