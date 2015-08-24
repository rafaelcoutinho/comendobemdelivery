dojo.provide("com.copacabana.search.SearchResultsItem");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
dojo.require("com.copacabana.DeclarativeTemplate"); 
 
//dojo.requireLocalization("com.copacabana.search", "SearchResultsItemStrings");

dojo.declare("com.copacabana.search.SearchResultsItem", [
		dijit._Widget, dijit._Templated,com.copacabana.DeclarativeTemplate  ], {
	//i18nStrings: dojo.i18n.getLocalization("com.copacabana.search", "SearchResultsManagerWidgetStrings"),
	templatePath : dojo.moduleUrl("com.copacabana.search","templates/SearchResultsItem.html"),
	constructor : function() {
		console.log('created',this.id);
	},
	postMixInProperties : function() {
		console.log('postMixInProperties',this.id);
		this.inherited(arguments);
		console.log('postMixInProperties',this.id);
	},

	postCreate : function() {
		console.log('postCreate',this.id);
		this.inherited(arguments);	
		console.log('postCreate',this.id);
	},
	
	headerNode:null,
	initialized:false,
	startup : function() {
		try {
			console.log('going to start?',this.id)
			dojo.parser.parse(this.domNode);
			
			if(dojo.query('[dojoAttachPoint=sectionItem]',this.domNode).length>0){
				var dom = dojo.query('[dojoattachpoint=sectionItem]',this.domNode)[0]
				this.sectionItem=dom;
				
				this.sectionItem.onclick=this.onClick;
			}
			
			console.log('sectionItem',this.sectionItem);
		} catch (e) {
			console.error(e)
		}
	},
	rest:null,
	setRestaurant:function(rest){
		this.rest=rest;
		var restNameNode = dojo.query(".titulo",this.domNode)[0];
		restNameNode.innerHTML=rest.name;
		var restStatusNode = dojo.query(".status",this.domNode)[0];
		
		console.log(rest.isOpen,rest.siteStatus);
		if(rest.siteStatus!='ACTIVE'){
			restStatusNode.title="Brevemente disponivel no ComendoBem."
			dojo.addClass(restStatusNode,'restaurantSoon');
			dojo.removeClass(restStatusNode,'restaurantClosed');
			restStatusNode.innerHTML='Breve';
		}else{
			
			
			if(rest.isOpen === true){
				restStatusNode.title="Restaurante aberto."				
				
				restStatusNode.innerHTML="Aberto";
			}else{
				restStatusNode.title="Restaurante fechado, verique o horario de abetura e fechamento."
				restStatusNode.innerHTML="Fechado";
			}
		}
		var restDetailsNode = dojo.query(".quantidade",this.domNode)[0];
		restDetailsNode.innerHTML=rest.description;
		dojo.parser.parse(this.domNode);
	},	
	onClick:function(evt){
		if(this.rest){
			dojo.publish("onOpenRestaurant",[this.rest]);	
		}else{
			
		}
		
	},
	onMouseEnter:function(evt){		
		/*var panel = dojo.query(".item",this.domNode)[0];
		dojo.style(panel,"backgroundColor","silver");		
		dojo.parser.parse(this.domNode);	*/		
	},
	onMouseOut:function(evt){
		/*
		var panel = dojo.query(".item",this.domNode)[0];
		dojo.style(panel,"backgroundColor","white");
		dojo.parser.parse(this.domNode);*/		
	}

});
