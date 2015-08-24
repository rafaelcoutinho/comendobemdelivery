dojo.provide("comum.Paginacao");

dojo.declare("comum.Paginacao", null, {
	
	/**
	 * Marca a página atual. Não deve ser manipulado diretamente.
	 */
	paginaAtual : 1,

	/**
	 * Os elementos que serão controlados por esta classe
	 * 
	 * @type {Array}
	 */
	elementos : new Array(),

	/**
	 * Os elementos filtrados serão armazenados aqui. Não devem ser manipulados
	 * diretamente pelo usuário.
	 * 
	 * @type {Array}
	 */
	filtrados : new Array(),

	/**
	 * Este é o elemento onde os itens serão desenhados.
	 * 
	 * @type {DOMNode}
	 */
	lista : null,

	/**
	 * Número máximo de itens numa página.
	 * 
	 * @type {Number}
	 */
	porPagina : 15,

	/**
	 * Este é o elemento onde serão desenhados os botões de controle de página.
	 * 
	 * @type {DOMNode}
	 */
	botoes : null,

	/**
	 * Uma função que será usada para criar os nós que serão adicionados na
	 * lista ou tabela passada.
	 * 
	 * @param item
	 *            {Object} O objeto que representa o dado que será desenhado.
	 * @return {DOMNode} O nó criado para ser colocado dentro da lista ou
	 *         tabela.
	 */
	criaNo : null,

	/**
	 * Esta função é usada para filtrar o array de elementos quando necessário.
	 * 
	 * @param item
	 *            {Object} O objeto que será filtrado.
	 * @return {Boolean} True se o objeto deve ser adicionado na lista.
	 */
	filtraItem : null,

	constructor : function(args) {
		// Setup the object
		dojo.mixin(this, args);
	
		// Check for required arguments
		if (this.criaNo == null || this.lista == null || this.botoes == null)
			throw new Error("criaNo, lista e botoes devem ser declarados.");
	},
	
	/**
	 * Filtra a lista de elementos e armazena-os o array de itens filtrados. No
	 * final, desenha a lista.
	 */
	filtra : function() {
		// Se não existe função de filtragem
		if (this.filtraItem == null) {
			this.filtrados = this.elementos;
			this.desenha();
			return;
		}
		
		// Se não filtra os items
		this.filtrados = new Array();
		for (var i = 0; i < this.elementos.length; i++) {
			if (this.filtraItem(this.elementos[i])) {
				this.filtrados.push(this.elementos[i]);
			}
		}
		
		this.desenha();
	},
	
	/**
	 * Redesenha a lista.
	 */
	desenha : function() {
		this.lista.innerHTML = '';
		
		// O primeiro elemento de cada página
		var i = (this.paginaAtual - 1) * this.porPagina;
		
		// Até qual elemento deverá ir
		var irAte = i + this.porPagina;
		if (irAte > this.filtrados.length) irAte = this.filtrados.length;
		
		for (; i < irAte; i++) {
			dojo.place(this.criaNo(this.filtrados[i]), this.lista);
		}
		
		this.desenhaBotoes(); 
	},
	
	/**
	 * Desenha os botões com os números das páginas e próxima e 
	 * anterior. Também desenha os botões de primeira e última 
	 * página.
	 */
	desenhaBotoes : function () {
		dojo.empty(this.botoes);
		var totalPaginas = this.getNumeroPaginas();
		
		for (var i = 1; i <= totalPaginas; i++) {
			dojo.place(this.criaLinkPagina(i), this.botoes);
		}
	},
	
	/**
	 * Cria um link que muda este paginador para uma
	 * determinada página.
	 * 
	 * @param indice {Number} 
	 * 			O índice da página para o qual
	 * 			este link deverá mudar.
	 * @return {DOMNode} 	Um elemento do tipo anchor que levará 
	 * 						o usuário para a página desejada quando 
	 * 						clicado.
	 */
	criaLinkPagina : function (indice) {
		var resultado = dojo.create('a');
		resultado.innerHTML = indice;
		
		if (indice == this.paginaAtual) {
			dojo.addClass(resultado, 'atual');
		}
		
		var irPara = dojo.hitch(this, this.irPara);
		
		dojo.connect(resultado, 'onclick', function (evt) {
			evt.preventDefault();
			irPara(indice);
		});
		
		return resultado;
	},
	
	/**
	 * Retorna o número de páginas que esta lista precisa.
	 */
	getNumeroPaginas : function () {
		return Math.ceil(this.filtrados.length / this.porPagina);
	},
	
	/**
	 * Muda a lista para uma determinada página.
	 */
	irPara : function (numeroPagina) {
		if (numeroPagina == this.paginaAtual) return;
		
		// Não deixa ir para uma página que não existe
		var totalPaginas = this.getNumeroPaginas();
		if (numeroPagina > totalPaginas) this.irPara(totalPagina);
		
		this.paginaAtual = numeroPagina;
		this.desenha();
	}
});