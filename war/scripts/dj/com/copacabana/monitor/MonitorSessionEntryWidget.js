/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.monitor.MonitorSessionEntryWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.monitor.MonitorSessionEntryWidget"] = true;
dojo.provide("com.copacabana.monitor.MonitorSessionEntryWidget");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");

// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.monitor",
		"MonitorSessionEntryWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.monitor.MonitorSessionEntryWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templateString:"<tr > \r\n\t<td style=\"text-align:center\"><a href=\"/jsp/main/main.jsp?showRestaurant=true&restaurantId=${rest.loggedKey}\">${rest.basicInfo}</a></td>\r\n\t<td style=\"text-align:center\">${rest.loggedIn}</td>\r\n</tr>\r\n",
	constructor : function(rest) {
		this.rest=rest;
	},
	timeBased:true,
	destroyRecursive : function() {
		dojo.forEach(this.getDescendants(), function(widget) {
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	rest : null,

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings = dojo.i18n.getLocalization("com.copacabana.monitor",
		"MonitorSessionEntryWidgetStrings");
		
	},

	startup : function() {
		try {
			dojo.parser.parse(this.domNode);			
//			dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateList));
		//	this.updateList();			
		} catch (e) {
			console.error(e);
		}
	},
	updateList:function(data){		
				
	}

});

}
