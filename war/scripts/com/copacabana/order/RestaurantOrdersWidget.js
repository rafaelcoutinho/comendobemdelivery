dojo.provide("com.copacabana.order.RestaurantOrdersWidget");
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

dojo.require("com.copacabana.order.RestaurantOrderEntryWidget");
// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.order", "RestaurantOrdersWidgetStrings");

dojo.declare("com.copacabana.order.RestaurantOrdersWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templatePath : dojo.moduleUrl("com.copacabana.order",
			"templates/RestaurantOrdersWidget.html"),
	constructor : function() {
		console.log(this.status);
		
	},
	
	destroyRecursive : function() {
		dojo.forEach(this.getDescendants(), function(widget) {

			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	orderList : null,
	isNoTime:false,
	postMixInProperties : function() {
		this.inherited(arguments);
		if(this.isNoTime==true){
			this.templatePath=dojo.moduleUrl("com.copacabana.order","templates/RestaurantOrdersNoTimeWidget.html");
		}
		
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order",
		"RestaurantOrdersWidgetStrings");
		
	},	
	typeOfRequests:"oldRequests",
	displayOrderList:function(){
		
		this.resultsNode = dojo.query(".tbody", this.domNode)[0];
		
		
		com.copacabana.util.cleanNode(this.resultsNode);
		var results = this.orderList;

		var counter=0;
		/*if(this.isNoTime==true){
			
			var msgnode = dojo.query(".mensagem", this.domNode)[0];			
			dojo.empty(msgnode);			
			var confMsg = dojo.string.substitute(this.i18nStrings.totalLabelDateRange,[results.length]);			
			msgnode.innerHTML=confMsg;
			
		}else{
			dojo.query(".totalRequests", this.domNode)[0].innerHTML=results.length;
		}*/
		
		if(results.length===0){
			var msg = dojo.string.substitute(this.i18nStrings.titleNoRequests, [this.i18nStrings[this.typeOfRequests]]);
			this.ordersTitle.innerHTML=msg;
		}else{			
			var msg = dojo.string.substitute(this.i18nStrings.titleNumberOfRequests, [results.length,this.i18nStrings[this.typeOfRequests]]);
			this.ordersTitle.innerHTML=msg;
			
			
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];
				//don't show old expired requests.
				if(p.status=='EXPIRED' && this.typeOfRequests!="inPeriodRequests"){			
					var lastChangeDate = com.copacabana.util.getDate(p.lastStatusUpdateTime);
					var diff = dojo.date.difference(lastChangeDate,new Date(),'day');
					if(diff>1){
						continue;
					}
				}
				if(!this.showElapsed){
					var wid = new com.copacabana.order.RestaurantOrderEntryWidget(p,false);
					wid.startup();
					this.resultsNode.appendChild(wid.domNode);
					this.entryList.push(wid);
				}else{
					var wid = new com.copacabana.order.RestaurantOrderEntryWidget(p,true);
					wid.startup();
					this.resultsNode.appendChild(wid.domNode);
					this.entryList.push(wid);
				}
			}			
		}
		
		com.copacabana.util.blink(dojo.query(".tbody", this.domNode)[0]);
	},
	showElapsed:false,
	entryList:[],
	resultsNode:null,
	getServerList:function(response){
		
		this.deferred=null;
		com.copacabana.util.hideLoading();
		this.orderList=response;
		
		for ( var i = 0; i < this.entryList.length; i++) {
			this.entryList[i].destroyRecursive();
		}
		this.entryList=[];
		
		this.displayOrderList();
	},	
	status:null,
	errorLoading:function(error){
		console.error(error);
		com.copacabana.util.hideLoading();
		
		if(error.status==0){
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg(this.i18nStrings.cannotReachServer,msg.errorType);
		}else{
			if(error.status==403){
				//login session expired
				window.location=window.location;
			}
		}
	},
	deferred:null,
	updateList:function(){		
		if(this.deferred==null){
			try{
				this.deferred.cancel();
			}catch (e) {

			}
		}
		if(!this.status){
			var xhrArgs = {
				url : "/listRestaurantPendingOrderList.do",
				handleAs : "json",
				load : dojo.hitch(this, this.getServerList),
				error : dojo.hitch(this, this.errorLoading)
			}
			this.deferred = dojo.xhrPost(xhrArgs);			
			
		}else{
			if(this.isDateRangeable==true){
				var drange = dojo.query('.dateRangeSelection',this.domNode)[0];				
				dojo.style(drange,'display','block');
				
				
				var startDijit = dijit.byNode(dojo.query('.startDate',this.domNode)[0]);
				var endDijit = dijit.byNode(dojo.query('.endDate',this.domNode)[0]);
				
				var datePattern='dd-MM-yyyy';
				var dateStartStr = "00:00:00 "+dojo.date.locale.format(startDijit.attr('value'),{datePattern:datePattern,selector:'date'});
				var dateEndStr = "23:59:59 "+dojo.date.locale.format(endDijit.attr('value'),{datePattern:datePattern,selector:'date'});
				
				
				var xhrArgs = {
						url : "/restOrdersByDate.do?status=EXPIRED&status=EVALUATED&status=DELIVERED&status=CANCELLED&start="+dateStartStr+"&end="+dateEndStr,
						
						handleAs : "json",
						load : dojo.hitch(this, this.getServerList),
						error : dojo.hitch(this, this.errorLoading)						
					}
				this.deferred = dojo.xhrPost(xhrArgs);
			}else{
				if(this.status=='EXPIRED'){
					var start = new Date();
					//var dateStartStr = "00:00:00 01-"+(d.getMonth()-1)+"-2010";
					var formatOptions ={
							selector:'date',
							datePattern:'00:00:01 dd-MM-yyyy'
					}
					var dateStartStr = dojo.date.locale.format(dojo.date.add(start,"day",-1),formatOptions);
					var dateEndStr = dojo.date.locale.format(start,formatOptions);
					console.log(dateStartStr);
					console.log(dateEndStr);
					var xhrArgs = {
							url : "/restOrdersByDate.do?status=EXPIRED&start="+dateStartStr+"&end="+dateEndStr,
							handleAs : "json",
							load : dojo.hitch(this, this.getServerList),
							error : dojo.hitch(this, this.errorLoading)
					}
					this.deferred = dojo.xhrPost(xhrArgs);
				}else{
					var xhrArgs = {
							url : "/listRestaurantOrderListByStatus.do?status="+this.status,
							handleAs : "json",
							load : dojo.hitch(this, this.getServerList),
							error : dojo.hitch(this, this.errorLoading)
					}
					this.deferred = dojo.xhrPost(xhrArgs);
				}
				
			}
		}
		
	},
	isDateRangeable:false,
	month:null,
	year:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			com.copacabana.util.showLoading();
			if(this.isDateRangeable==true){
				var startDijit = dijit.byNode(dojo.query('.startDate',this.domNode)[0]);
				startDijit.attr('value',new Date());
				var endDijit = dijit.byNode(dojo.query('.endDate',this.domNode)[0]);
				endDijit.attr('value',new Date());
				
			}
			
			this.updateList();
			if(this.status=='EXPIRED'){
				
			}else{
				dojo.subscribe("onChangeOrderStatus",dojo.hitch(this,this.orderChangedStatus));
				if(!this.status){
					dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateList));
				}
				if(this.isNoTime==true){
					dijit.byNode(dojo.query('.updateOrdersByDateRange',this.domNode)[0]).onClick=dojo.hitch(this,this.updateOrdersByDateRange);
				}
			}
		} catch (e) {
			console.error(e);
		}
	},
	
	orderChangedStatus:function(data){
		try {
			
			console.log("Updating status of "+this.id);
			
			if (this.status) {
				
				var newList = [];
				for ( var i = 0; i < this.entryList.length; i++) {
					if(this.entryList[i].id!=data.id){
						newList.push(this.entryList[i]);
					}					
				}
				this.entryList=newList;
				dijit.byId(data.id).destroyRecursive();
				if (data.status != 'DELIVERED') {
					var p = data;
					
					if (!this.showElapsed) {
						var wid = new com.copacabana.order.RestaurantOrderEntryWidget(
								p, false);
						wid.startup();
						this.resultsNode
								.appendChild(wid.domNode);
						this.entryList.push(wid);
					} else {
						var wid = new com.copacabana.order.RestaurantOrderEntryWidget(
								p, true);
						wid.startup();
						this.resultsNode.appendChild(wid.domNode);
						this.entryList.push(wid);
					}
					
				}else{					
					if (data.status == 'PREPARING' && this.status) {
						var wid = new com.copacabana.order.RestaurantOrderEntryWidget(data,false);
						this.resultsNode.appendChild(wid.domNode);
						this.entryList.push(wid);
						this.resultsNode.addChild(dijit.byId(data.id).domNode);
					}
					
				}
				var msg = dojo.string.substitute(this.i18nStrings.titleNumberOfRequests, [this.entryList.length,this.i18nStrings[this.typeOfRequests]]);
				this.ordersTitle.innerHTML=msg;
			}else{
				if (data.status == 'PREPARING' && this.status) {
					this.resultsNode.removeChild(dijit.byId(data.id).domNode);
				}
				var newList = [];
				for ( var i = 0; i < this.entryList.length; i++) {
					if(this.entryList[i].id!=data.id){
						newList.push(this.entryList[i]);
					}
					
				}
				this.entryList=newList;
				
				if(this.isNoTime==true){
					var msgnode = dojo.query(".mensagem", this.domNode)[0];
					dojo.empty(msgnode);
					var confMsg = dojo.string.substitute(this.i18nStrings.totalLabelDateRange,[this.entryList.length]);
					msgnode.innerHTML=confMsg;
				}else{
					//dojo.query(".totalRequests", this.domNode)[0].innerHTML=this.entryList.length;
					var msg = dojo.string.substitute(this.i18nStrings.titleNumberOfRequests, [this.entryList.length,this.i18nStrings[this.typeOfRequests]]);
					this.ordersTitle.innerHTML=msg;
				}
			}
			
		} catch (e) {
			console.log('failed to change status',e);
		}
		
	},
	getDate:function(dDijit){
		var smonth = dDijit.getMonth()+1;
		var sday = dDijit.getDate();
		var syear = dDijit.getYear();
		
		if(!dojo.isIE){
			syear+=1900;
		}
		
		var dateStr = "00:00:00 "+sday+"-"+smonth+"-"+syear;
		return dateStr;
		
	},
	updateOrdersByDateRange:function(){
		this.updateList()
	}
});
