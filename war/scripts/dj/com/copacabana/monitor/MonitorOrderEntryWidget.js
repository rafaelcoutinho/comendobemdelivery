/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.monitor.MonitorOrderEntryWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.monitor.MonitorOrderEntryWidget"] = true;
dojo.provide("com.copacabana.monitor.MonitorOrderEntryWidget");
dojo.require("com.copacabana.order.ViewOrderDetailsWidget");
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
		"MonitorOrderEntryWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.monitor.MonitorOrderEntryWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templateString:"<tr dojoAttachEvent=\"onclick:viewOrderDetails\"> \r\n\t<td style=\"text-align:center\"><a href=\"#\">${order.idXlated}</a></td>\r\n\t<td style=\"text-align:center\">${order.orderedTime}</td>\r\n\t<td style=\"text-align:center\" class=\"${order.statusCss}\">${order.status}</td>\r\n\t<td style=\"text-align:center\" class=\"elapsedLastStatusChange\"></td>\r\n\t<td style=\"text-align:center\" class=\"elapsedTotal\"></td>\r\n\t<td style=\"text-align:center\" >${order.restaurant.name}</td>\r\n</tr>\r\n",
	constructor : function(order,timeBased) {
		this.order = order;
		if(!this.order.idXlated){
			this.order.idXlated="";
		}
		this.order.statusCss = this.i18nStrings['CSS_'+this.order.status];
		this.order.statusImage = this.i18nStrings['IMAGE_'+this.order.status];
		this.order.statusImageAlt = this.i18nStrings['ALT_IMAGE_'+this.order.status];
		console.log(this.order.restaurant);
		this.i18nStrings= dojo.i18n.getLocalization("com.copacabana.monitor","MonitorOrderEntryWidgetStrings");
		

	},
	timeBased:true,
	destroyRecursive : function() {
		dojo.forEach(this.getDescendants(), function(widget) {
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	order : null,

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		
	},

	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			if(this.timeBased==true){
				dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateElapsedTime));
				this.updateElapsedTime();
			}
		} catch (e) {
			console.error(e);
		}
	},
	updateElapsedTime:function(data){		
		dojo.query(".elapsedTotal", this.domNode)[0].innerHTML=com.copacabana.util.getElapsedTime(this.orderedTime);		
		dojo.query(".elapsedLastStatusChange", this.domNode)[0].innerHTML=com.copacabana.util.getElapsedTime(this.lastStatusUpdateTime);		
	},
	viewOrderDetails:function(){		
		var v=new com.copacabana.order.ViewOrderDetailsWidget();
		v.order=this.order;
		v.startup();
	}

});

}
