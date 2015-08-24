dojo.provide('comum.CampoRedondo');

dojo.declare('comum.CampoRedondo', null, {
	altura : 20,
	largura : null, // campo obrigatório
	tipo : 'text',
	domNode : null,
	value : '',
	
	constructor : function (args) {
		dojo.mixin(this, args);
		
		if (this.largura == null) throw new Error("Obrigatório passar uma largura.");
		
		this.selecionaImagem();
		
		this.domNode = dojo.create('span');
		dojo.addClass(this.domNode, 'roundedInput');
		dojo.addClass(this.domNode, this.tipo);
		
		var imagem = dojo.place('<img />', this.domNode);
		var input = dojo.place('<input />', this.domNode);
		
		var altura = this.altura;
		var largura = this.largura;
		
		// Primeiro o span
		dojo.style(this.domNode, { height : altura + 'px', width : largura + 'px'});
		if (this.id && this.id != '') {
			dojo.attr(this.domNode, 'id', this.id + 'Wrap');
			dojo.attr(input, {'id': this.id, 'name': this.id});
		}
		
		// Depois o input
		dojo.style(input, { height : altura + 'px', width : (largura - 5) + 'px'});
		dojo.attr(input, 'type', this.tipo);
		dojo.attr(input, 'value', this.value);
		
		if (this.name && this.name != '') {
			dojo.attr(input, 'name', this.name);
		}
		
		
		
		if (this.cssClass && this.cssClass != '') {
			if (dojo.isArray(this.cssClass)) {
				dojo.forEach(this.cssClass, function (c) {dojo.addClass(input, c);});
			} else {
				dojo.addClass(input, this.cssClass);
			}
		}
		
		// E por último a imagem
		dojo.attr(imagem, {height : altura + 'px', width : largura + 'px', src : this.imagem});
	},
	
	/**
	 * Altera o valor do campo deste widget.
	 */
	setValor : function (valor) {
		if (! valor || valor == null) valor = '';
		dojo.query('input', this.domNode)[0].value = valor;
	},
	
	/**
	 * Retorna o valor do campo representado por esta widget.
	 */
	getValor : function () {
		return dojo.query('input', this.domNode)[0].value;
	},
	
	/**
	 * Checa se este campo é um botão ou um campo de texto.
	 */
	eBotao : function () {
		return this.tipo == 'button' || this.tipo == 'submit';
	},
	
	/**
	 * Seleciona qual imagem de fundo deverá ser usada.
	 */
	selecionaImagem : function () {
		if (this.largura <= 50) {
			if (this.eBotao()) this.imagem = contexto + '/resources/img/botao50px.png';
			else this.imagem = contexto + '/resources/img/campo50px.png';
			return;
		}
		
		if (this.largura <= 100) {
			if (this.eBotao()) this.imagem = contexto + '/resources/img/botao100px.png';
			else this.imagem = contexto + '/resources/img/campo100px.png';
			return;
		}
		
		if (this.largura <= 150) {
			if (this.eBotao()) this.imagem = contexto + '/resources/img/botao150px.png';
			else this.imagem = contexto + '/resources/img/campo150px.png';
			return;
		}
		
		if (this.eBotao()) this.imagem = contexto + '/resources/img/botao250px.png';
		else this.imagem = contexto + '/resources/img/campo250px.png';
		return;
	}
});