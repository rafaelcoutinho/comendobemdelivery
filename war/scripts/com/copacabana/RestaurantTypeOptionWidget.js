dojo.provide("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");

dojo.declare("com.copacabana.RestaurantTypeOptionWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nString : null,
	title : "",
	url : null,
	templatePath : dojo.moduleUrl("com.copacabana",
			"templates/RestaurantTypeOption.html"),
	constructor : function(cat) {
		
		this.cat = cat;
		this.cat.top = 35 + 35 * cat.index;
	},
	cat : {},
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		dojo.parser.parse(this.domNode);

	},

	startup : function() {

	},	
	delegateFctToDisplayRestaurants:null,
	showRestaurantList : function() {
		this.delegateFctToDisplayRestaurants(this.cat);
				
	}

});