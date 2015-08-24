dojo.provide("com.copacabana.central.OrderDetailsWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");

//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana.central", "OrderDetailsStrings");

dojo.declare("com.copacabana.central.OrderDetailsWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templatePath : dojo.moduleUrl("com.copacabana.central","templates/OrderDetails.html"),
	constructor : function() {		
	},
	 destroyRecursive: function(){
        dojo.forEach(this.getDescendants(), function(widget){
         
        	widget.destroyRecursive();
        });
        this.inherited(arguments);
    },
   
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.central", "OrderDetailsStrings");
	},
	getLabel:function(){
		return "Pedido número 1231231";
		
	},
	
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.orderNumber="aaa"+this.id;
		} catch (e) {
			console.error(e);
		}
	}

});
