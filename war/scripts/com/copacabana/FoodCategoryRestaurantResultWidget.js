dojo.provide("com.copacabana.FoodCategoryRestaurantResultWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");

dojo.declare("com.copacabana.FoodCategoryRestaurantResultWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nString : null,
	title : "",
	formattedName:"",
	maxlength:18,
	templatePath : dojo.moduleUrl("com.copacabana",
			"templates/FoodCategoryRestaurantResult.html"),
	constructor : function(args) {
		this.rest=args.rest;
		this.formattedName=this.rest.name;
		if(this.formattedName.length>this.maxlength){
			this.formattedName=this.formattedName.substr(0,this.maxlength-3)+"..."
		}
		
		if(this.rest.siteStatus=='TEMPUNAVAILABLE'){
			this.rest.isOpenStatusCSS="notActive";
			this.statusLabel="indisp.";
		}else if (this.rest.siteStatus!='ACTIVE'){
			this.rest.isOpenStatusCSS="notActive";
			this.statusLabel="breve";
		}else{
			if(this.rest.isOpen){
				this.rest.isOpenStatusCSS="aberto";
				this.statusLabel="aberto";
			}else{
				this.rest.isOpenStatusCSS="fechado";
				this.statusLabel="fechado";
			}
		}
//		if(this.rest.currentDelay>300){
//			this.rest.isOpenStatusCSS="notActive";
//			this.statusLabel="indisp.";
//		}else if(this.rest.siteStatus!='ACTIVE'){
//			this.rest.isOpenStatusCSS="notActive";
//			this.statusLabel="breve";
//		}else{
//			if(this.rest.isOpen){
//				this.rest.isOpenStatusCSS="aberto";
//				this.statusLabel="aberto";
//			}else{
//				this.rest.isOpenStatusCSS="fechado";
//				this.statusLabel="fechado";
//			}
//		}
		
	},
	statusLabel:'fechado',
	rest : {},
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		dojo.parser.parse(this.domNode);

	},

	startup : function() {

	},
	execute:function(){
		dojo.publish("onOpenRestaurant",[this.rest]);
		return false;
	},
	voidExecution:function(){
		return false;
	}
	

});