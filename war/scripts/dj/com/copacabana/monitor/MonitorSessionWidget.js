/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.monitor.MonitorSessionWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.monitor.MonitorSessionWidget"] = true;
dojo.provide("com.copacabana.monitor.MonitorSessionWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.monitor.MonitorSessionEntryWidget");
// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.monitor", "MonitorSessionWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.monitor.MonitorSessionWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templateString:"<div>\r\n<p class=\"mensagem\">H&aacute <span class=\"totalRequests\">0</span> restaurantes logados.</p>\r\n\r\n<table class=\"andamento\">\r\n\t<thead>\r\n\t\t<tr>\r\n\t\t\t<th>Nome</th>\r\n\t\t\t<th>Logou-se</th>\r\n\t\t\t<th></th>\r\n\r\n\t\t</tr>\r\n\t</thead>\r\n\t<tbody class=\"tbody\" >\t\t\r\n\t</tbody>\r\n</table>\r\n</div>\r\n",
	constructor : function() {
	},
	
	destroyRecursive : function() {
		dojo.forEach(this.getDescendants(), function(widget) {

			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	orderList : null,

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings =dojo.i18n.getLocalization("com.copacabana.monitor",
		"MonitorSessionWidgetStrings");
		
	},	
	displaySessionList:function(){
		this.resultsNode = dojo.query(".tbody", this.domNode)[0];
		
		com.copacabana.util.cleanNode(this.resultsNode);
		var results = this.orderList;

		var counter=0;
		if(results.length===0){
			//this.resultsNode.innerHTML="Nenhuma ordem em andamento.";	
		}else{
			dojo.query(".totalRequests", this.domNode)[0].innerHTML=results.length;
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];				
					var wid = new com.copacabana.monitor.MonitorSessionEntryWidget(p);
					wid.startup();
					this.resultsNode.appendChild(wid.domNode);
					this.entryList.push(wid);
				
			}			
		}
	},
	entryList:[],
	resultsNode:null,
	getServerList:function(response){
		
		this.orderList=response;
		for ( var i = 0; i < this.entryList.length; i++) {
			this.entryList[i].destroyRecursive();
		}
		this.entryList=[];
		this.displaySessionList();
	},	
	status:null,
	updateList:function(){
		
			var xhrArgs = {
				url : "/monitor/loginsJson.jsp",
				handleAs : "json",
				load : dojo.hitch(this, this.getServerList),
				error : function(error) {
					console.error(error)
				}
			}
			var deferred = dojo.xhrPost(xhrArgs);
			//dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateList));
			
		
		
	},
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.updateList();
			
			
		} catch (e) {
			console.error(e);
		}
	}
});

}
