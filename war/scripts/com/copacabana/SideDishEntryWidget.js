dojo.provide("com.copacabana.SideDishEntryWidget");
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
 
//dojo.requireLocalization("com.copacabana", "PlatesListWidgetStrings");

dojo.declare("com.copacabana.SideDishEntryWidget", [
		dijit._Widget, dijit._Templated ], {
	//i18nStrings: dojo.i18n.getLocalization("com.copacabana", "PlatesListWidgetStrings"),
	templatePath : dojo.moduleUrl("com.copacabana","templates/SideDishEntryWidget.html"),
	constructor : function(sidedish) {
	this.item=sidedish;
	},

	

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);		

	},
	item:null,
	headerNode:null,
	resultsNode:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);		
			
			
		} catch (e) {
console.error("sidedish start",e);
		}
	},
	onClick:function(evt){
		console.log("click");
		dojo.publish("editSideDish",[this.item]);
		dojo.parser.parse(this.domNode);			

	},
	onMouseEnter:function(evt){
		console.log("enter");
		var panel = dojo.query(".panel",this.domNode)[0];
		dojo.style(panel,"backgroundColor","silver");
		
		dojo.parser.parse(this.domNode);			

	},
	onMouseOut:function(evt){
		console.log("ount");
		var panel = dojo.query(".panel",this.domNode)[0];
		dojo.style(panel,"backgroundColor","white");
	}	
});
