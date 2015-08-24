/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.central.CompactOrderEntry"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.central.CompactOrderEntry"] = true;
dojo.provide("com.copacabana.central.CompactOrderEntry");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.order.ViewOrderDetailsWidget");

//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana.central", "CompactOrderEntryStrings", null, "ROOT,pt");


dojo.declare("com.copacabana.central.CompactOrderEntry", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templateString:"<div style=\"width: 100%;min-width: 620px; border-bottom: 1px solid black;cursor: pointer;\">\r\n<div style=\"width: 90px;\" class=\"orderState orderDataEntry\" dojoAttachPoint=\"status\"></div>\r\n<div style=\"width: 90px;\" class=\"orderDataEntry\" dojoAttachPoint=\"orderId\"></div>\r\n<div class=\"orderDataEntry\" dojoAttachPoint=\"orderedTime\"></div>\r\n<div class=\"orderDataEntry\" dojoAttachPoint=\"lastChange\"></div>\r\n<div class=\"orderDataEntry\" dojoAttachPoint=\"totalTime\"></div>\r\n<div style=\"display: inline-block; width: 205px;font-style: italic;\" dojoAttachPoint=\"summary\"></div>\r\n</div>\r\n",
	constructor : function(order) {
		this.order=order;
		if(!this.order.idXlated){
			this.order.idXlated="";
		}
		this.order.orderedHour=com.copacabana.util.parseTime(order.orderedTime);
		this.order.orderedDate=com.copacabana.util.parseDate(order.orderedTime);
		this.order.lastStatusUpdateHour=com.copacabana.util.parseTime(order.lastStatusUpdateTime);
	},
	order:null,
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
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.central", "CompactOrderEntryStrings");
		
	},
	isRestaurantViewer:false,
	click:function(evt){
		console.info('must change status to VISUALIZEDBYRESTAURANT? '+this.isRestaurantViewer);
		if(this.order.status=='NEW' && this.isRestaurantViewer==true){
			dojo.publish("displayingNewOrder");
			var form = dojo.create("form",{action:"/changeOrderStatus.do",method:"post"});
			dojo.create("input",{type:"text",name:"id",value:this.order.id},form);
			dojo.create("input",{type:"text",name:"key",value:this.order.id},form);
			dojo.create("input",{type:"text",name:"status",value:'VISUALIZEDBYRESTAURANT'},form);
			dojo.create("input",{type:"text",name:"reason",value:''},form);
			dojo.create("input",{type:"text",name:"delay",value:0},form);
			var xhrArgs = {
					form : form,//dojo.query(".updateOrderForm", this.domNode)[0],
					handleAs : "json",
					load : dojo.hitch(this, function(data) {
						this.order.status='VISUALIZEDBYRESTAURANT';
						this.viewOrderDetails();
					}),
					error:function(error){console.error(error)}
			};
			var deferred = dojo.xhrPost(xhrArgs);
		}else{
			this.viewOrderDetails();
		}
	},
	viewOrderDetails:function(){
		var v=new com.copacabana.order.ViewOrderDetailsWidget();
		v.detailsEndpoint="/central/verDetalhesPedido.do";			
		v.order=this.order;				
		v.startup();
	},
	updateElapsedTime:function(){
		console.log('updateElapsedTime',this);
		this.totalTime.innerHTML = com.copacabana.util.getElapsedTime(this.order.orderedHour,this.order.orderedTime);
	},
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateElapsedTime));
			
			dojo.connect(this,'onClick',this,this.click);
			var formatOptions ={
				datePattern:'',
				timePattern:'kk:mm',
				selector:'time'
				
			}
			
			var time=dojo.date.locale.format(com.copacabana.util.getDate(this.order.orderedTime),formatOptions);
			var lastStatusUpdateTimeString=dojo.date.locale.format(com.copacabana.util.getDate(this.order.lastStatusUpdateTime),formatOptions);
			
			
			this.orderId.innerHTML=this.order.idXlated;
			if(!this.status){
				this.status=dojo.query(".orderState",this.domNode)[0];
			}
			this.status.innerHTML=this.i18nStrings["label_"+this.order.status];
			this.status.title=this.order.status;
			dojo.addClass(this.status,'orderState_'+this.order.status);
			this.orderedTime.innerHTML=time;
			this.updateElapsedTime();
			this.lastChange.innerHTML=lastStatusUpdateTimeString;			
			var summaryStr = this.i18nStrings.summaryStr;
			var totalCost = com.copacabana.util.moneyFormatter(this.order.paymentTotalValue/100);
			
			this.summary.innerHTML=dojo.string.substitute(summaryStr,[this.i18nStrings["paymentType_"+this.order.paymentType],totalCost]);
			if(this.order.orderType=="ERP"){
				this.summary.innerHTML="ERP:"+this.summary.innerHTML;	
			}
		} catch (e) {
			console.error(e);
		}
	}

});

}
