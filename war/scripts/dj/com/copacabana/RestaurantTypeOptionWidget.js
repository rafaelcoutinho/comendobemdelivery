/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.RestaurantTypeOptionWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.RestaurantTypeOptionWidget"] = true;
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
	templateString:"<div>\r\n<div class=\"tipo ${cat.type} cheio\" style=\"top: ${cat.top}px;\" id=\"${cat.id}\" dojoAttachEvent=\"onclick:showRestaurantList\">${cat.name}</div>\r\n</div>\r\n",
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

}
