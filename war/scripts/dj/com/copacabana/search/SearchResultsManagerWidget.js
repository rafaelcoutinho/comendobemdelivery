/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.search.SearchResultsManagerWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.search.SearchResultsManagerWidget"] = true;
dojo.provide("com.copacabana.search.SearchResultsManagerWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.DeclarativeTemplate");

dojo.require("com.copacabana.util");
dojo.require("com.copacabana.search.SearchResultsItem");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana.search", "SearchResultsManagerWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.search.SearchResultsManagerWidget", [
		dijit._Widget, dijit._Templated,com.copacabana.DeclarativeTemplate ], {
	i18nStrings: null,
	templateString:"<div class=\"widgetContent\">\r\n\r\n<div id=\"topoResultado\">\r\n<div class=\"canto cantoSupDir\"></div>\r\n\r\n\r\n<h2>${i18nStrings.resultsTitleLabel}</h2>\r\n\r\n<p id=\"resultadoMensagem\" class=\"resultadoMensagem\"></p>\r\n<div class=\"canto cantoInfDir\"></div>\r\n</div>\r\n\r\n<div id=\"itensBusca\" class=\"resultsList\">\r\n\r\n</div>\r\n\r\n<!-- <div id=\"paginacao\"><span class=\"voltar\">Primeira |\r\nAnterior</span> <span class=\"paginas\">1, <span class=\"selecionado\">2</span>,\r\n3, 4</span> <span class=\"avancar\">Pr&oacute;xima | &Uacute;ltima</span></div>-->\r\n</div>\r\n",
	constructor : function() {
		console.log('manager created');
	},
	
	domValues : {
		totalRestaurants : 0,
		totalItems : 0,
		showingStart : 0,
		showingEnd : 0,
		searchedValue : ''
	},

	postMixInProperties : function() {
		this.inherited(arguments);
		console.log('manager postMixInProperties')
	},

	postCreate : function() {
		this.inherited(arguments);
		console.log('manager postCreate')
		dojo.subscribe("onSearchBeingExecuted",this,"cleanResultsNWait");
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.search", "SearchResultsManagerWidgetStrings");
        

	},
	headerNode:null,
	resultsNode:null,
	startup : function() {
		try {
			console.log('starting manager')
			
			
			this.headerNode = dojo.query(".resultadoMensagem",this.domNode)[0];
			this.resultsNode = dojo.query(".resultsList",this.domNode)[0];
			console.log("this.resultsNode",this.resultsNode);
			//this.imageNode =  dojo.create('img',{src:dojo.moduleUrl("com.copacabana", "images/loader.gif"),title:'buscando...',alt:'buscando...'});
			
			//dojo.parser.parse(this.domNode);
			
		} catch (e) {
			console.error(e);
		}
	},
	
	cleanResultsNWait:function(){
		console.log('cleanResultsNWait',this.resultsNode);
		com.copacabana.util.cleanNode(this.resultsNode);
		//this.resultsNode.appendChild(this.imageNode);
		dojo.create('img',{src:dojo.moduleUrl("com.copacabana", "images/loader.gif"),title:'buscando...',alt:'buscando...',width:32,height:32},this.resultsNode)
	},
	updateResults:function(results,searchCriteria){
		com.copacabana.util.cleanNode(this.resultsNode);
		if(searchCriteria.openStatus==true){
			var auxList=[];
			for ( var i = 0; i < results.length; i++) {					
				if(results[i].isOpen==true){
					auxList.push(results[i]);
				}					
			}
			results=auxList;
		}
		var criteria;
		if(searchCriteria.value && searchCriteria.value!=''){
			if(searchCriteria.openStatus==true){
				criteria= dojo.string.substitute(this.i18nStrings.searchCriteriaOpenNeigFreeform, [searchCriteria.neighborName,searchCriteria.value ]);
			}else{
				criteria= dojo.string.substitute(this.i18nStrings.searchCriteriaNeigFreeform, [searchCriteria.neighborName,searchCriteria.value ]);
			}
		}else{
			if(searchCriteria.openStatus==true){
				criteria= dojo.string.substitute(this.i18nStrings.searchCriteriaNeigOpen, [searchCriteria.neighborName ]);
			}else{
				criteria= dojo.string.substitute(this.i18nStrings.searchCriteriaNeig, [searchCriteria.neighborName ]);
			}
		}
		if(results.length===0){
			criteria+= this.i18nStrings.suggestLink;
			this.headerNode.innerHTML = dojo.string.substitute(this.i18nStrings.noResultsFoundLable, [criteria]);
		} else {
			var str = dojo.string.substitute(this.i18nStrings.foundResultsLabel, [results.length, 0,criteria]);			
			var start = 1;
			str += dojo.string.substitute(this.i18nStrings.showingLabel, [ start, results.length]);
			this.headerNode.innerHTML = str;
			for ( var j = 0; j < results.length; j++) {
				var item = new com.copacabana.search.SearchResultsItem();
				item.setRestaurant(results[j]);				
				item.startup();
				this.resultsNode.appendChild(item.domNode);
			}

			dojo.parser.parse(this.domNode);
		}
		
	}

});

}
