/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.SideDishEntryWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.SideDishEntryWidget"] = true;
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
 
//dojo.requireLocalization("com.copacabana", "PlatesListWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.SideDishEntryWidget", [
		dijit._Widget, dijit._Templated ], {
	//i18nStrings: dojo.i18n.getLocalization("com.copacabana", "PlatesListWidgetStrings"),
	templateString:"<div dojoAttachEvent=\"onclick:onClick\">\r\n<div style=\"cursor: pointer;\" dojoAttachEvent=\"onmouseenter:onMouseEnter,onmouseout:onMouseOut\" class=\"panel\">\t\r\n\t<h2>${item.name}</h2>\r\n\r\n\t<span class=\"preco\">R$ ${item.price}</span>\r\n\r\n\t<p>${item.description}</p>\r\n\r\n\t\r\n\t\r\n</div>\r\n</div>\r\n",
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

}
