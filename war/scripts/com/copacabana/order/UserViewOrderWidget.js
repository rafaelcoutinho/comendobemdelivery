dojo.provide("com.copacabana.order.UserViewOrderWidget");
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

dojo.require("com.copacabana.order.UserViewOrderEntryWidget");
// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.order", "UserViewOrderWidgetStrings");

dojo.declare("com.copacabana.order.UserViewOrderWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templatePath : dojo.moduleUrl("com.copacabana.order",
			"templates/UserViewOrderWidget.html"),
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
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order",
		"UserViewOrderWidgetStrings");
	},	
	msgNode:null,
	muteStatusMsgs:false,
	displayOrderList:function(){
		this.resultsNode = dojo.query(".tbody", this.domNode)[0];
		this.msgNode = dojo.query(".msgNode", this.domNode)[0];
		
		com.copacabana.util.cleanNode(this.resultsNode);
		com.copacabana.util.cleanNode(this.msgNode);
		var results = this.orderList;
		var counter=0;
		if(results.length===0){
			if(this.statusList){
				this.msgNode.appendChild(document.createTextNode("Nenhuma ordem."));
			}else{				
				this.msgNode.appendChild(document.createTextNode("Nenhuma ordem em andamento."));				
			}
		
		}else{
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];
				var wid = new com.copacabana.order.UserViewOrderEntryWidget(p);
				wid.muteStatusMsgs=this.muteStatusMsgs;
				
				wid.startup();
				this.resultsNode.appendChild(wid.domNode);
				this.entryList.push(wid);
			}
			
		}
		
		if(this.recentOrderList.length>0){
			
			for ( var i = 0; i < this.recentEntryList.length; i++) {
				this.recentEntryList[i].destroyRecursive();
			}
			this.recentEntryList=[];
			var recentResultsNode = dojo.query(".tbodyultimos", this.domNode)[0];
			
			for ( var i = 0; i < this.recentOrderList.length; i++) {
				var p = this.recentOrderList[i];
				var wid = new com.copacabana.order.UserViewOrderEntryWidget(p);
				
				wid.startup();
				recentResultsNode.appendChild(wid.domNode);
				this.recentEntryList.push(wid);
			}
			dojo.style(dojo.query(".latestDiv", this.domNode)[0],'display','block');
		
		
		}else{
			dojo.style(dojo.query(".latestDiv", this.domNode)[0],'display','none');
			
		}
	},
	resultsNode:null,
	entryList:[],
	clientOrderBean:null,
	recentOrderList:null,
	recentEntryList:[],
	getServerList:function(response){
		this.clientOrderBean=response;
		this.orderList=this.clientOrderBean.orders;	
		this.recentOrderList=this.clientOrderBean.recentOrders;
		for ( var i = 0; i < this.entryList.length; i++) {
			this.entryList[i].destroyRecursive();
		}
		this.entryList=[];
		this.displayOrderList();
	},
	retrieveServerList:function(){
		var xhrArgs;
		if(this.statusList){
			xhrArgs = {
				url : "/listClientOrders.do?status="+this.statusList,
				handleAs : "json",
				load : dojo.hitch(this, this.getServerList),
				error : function(error,ioArgs) {
					console.error(error.message,ioArgs);
					
					if(ioArgs.xhr.status==403){
						window.location=window.location;
					}
				}
			}
		}else{
			xhrArgs = {
					url : "/getMyPendingOrderList.do?addLatestOnes=true",
					handleAs : "json",
					load : dojo.hitch(this, this.getServerList),
					error : function(error,ioArgs) {
						console.error(error.message,ioArgs);
						console.error(ioArgs.xhr.status);
						if(ioArgs.xhr.status==403){
							window.location=window.location;
						}
					}
				}
		}		
		
		var deferred = dojo.xhrPost(xhrArgs);
	},
	statusList:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.retrieveServerList();
		} catch (e) {
			console.error(e);
		}
	},
	startRefreshing:function(){
		dojo.subscribe("onEachMinute",dojo.hitch(this,this.retrieveServerList));
	}
});

