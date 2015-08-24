dojo.provide("com.copacabana.order.UserViewOrderEntryWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.order.ViewOrderDetailsWidget");


//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana.order", "UserViewOrderEntryWidgetStrings");

dojo.declare("com.copacabana.order.UserViewOrderEntryWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templatePath : dojo.moduleUrl("com.copacabana.order","templates/UserViewOrderEntryWidget.html"),
	orderStatusClass:'',
	constructor : function(order) {
		this.order=order;
		if(!this.order.restaurant.name){
			this.order.restaurant.name="";
		}
		
		this.order.orderedHour=com.copacabana.util.parseTime(this.order.orderedTime);
		this.order.lastStatusUpdateHour=com.copacabana.util.parseTime(this.order.lastStatusUpdateTime);
		
		
		var lastChangeDate = com.copacabana.util.getDate(this.order.lastStatusUpdateTime);		
		var diff = dojo.date.difference(lastChangeDate,new Date(),'day');
		if(diff>1){
			var formatOptions ={
				datePattern:'dd \'de\' MMMM \'&agrave;s\'',
				timePattern:'kk:mm'
			}
			this.order.orderedTimeString=dojo.date.locale.format(com.copacabana.util.getDate(this.order.orderedTime),formatOptions);
			this.order.lastStatusUpdateTimeString=dojo.date.locale.format(com.copacabana.util.getDate(this.order.lastStatusUpdateTime),formatOptions);			
		}else{
			this.order.orderedTimeString=this.order.orderedHour;
			this.order.lastStatusUpdateTimeString=this.order.lastStatusUpdateHour;
		}
		
		
		
	},
	muteStatusMsgs:false,
	orderStatusAltText:'',
	 destroyRecursive: function(){
		try{
			dijit.hideTooltip(dojo.query(".msgPlace",this.domNode)[0])
			clearTimeout(this.timerHandler);
		}
		catch (e) {

		}
		dojo.forEach(this.getDescendants(), function(widget){
         
        	widget.destroyRecursive();
        });
        this.inherited(arguments);
    },
    order:null,
    
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order", "UserViewOrderEntryWidgetStrings");
		this.order.statusTranslated=eval('this.i18nStrings.orderstatus_'+this.order.status);
		console.log('loaded'+'this.i18nStrings.orderstatus_'+this.order.status,this.order.statusTranslated)
		
	},
	
	viewOrderDetails:function(){
		var v=new com.copacabana.order.ViewOrderDetailsWidget();
		v.order=this.order;
		v.userView=true;
		dijit.hideTooltip(dojo.query(".msgPlace",this.domNode)[0]);
		v.startup();
	},
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);	
			
			console.log("this.order.status",this.order.status);
			var altk = "orderstatus_"+this.order.status+"_ALT";
			var title = eval('this.i18nStrings.'+altk);			
			this.orderStatusAltText=title;
			console.log("alt",this.orderStatusAltText);
			this.orderStatusClass='orderstatus_'+this.order.status;
			
			console.log("class",this.orderStatusClass);
			dojo.addClass(this.statusSec,this.orderStatusClass);
			this.statusSec.title=this.orderStatusAltText;
			console.log(this.order.statusTranslated);
			this.statusXlated.innerHTML=this.order.statusTranslated;
			dojo.addClass(this.statusXlated,this.orderStatusClass);
			if(this.timerHandler){
				clearTimeout(this.timerHandler);
			}
			if(this.muteStatusMsgs==false){
				if(this.order.status=='NEW'){
					this.orderedTime=com.copacabana.util.getDate(this.order.orderedTime);
					setTimeout(dojo.hitch(this,this.showTimer), 2000);								
				}else
					if(this.order.status=='EXPIRED'){
						var lastChangeDate = com.copacabana.util.getDate(this.order.lastStatusUpdateTime);
						console.log("lastChangeDate",lastChangeDate);
						console.log("this.order.lastStatusUpdateTime",this.order.lastStatusUpdateTime);
						var diff = dojo.date.difference(lastChangeDate,new Date(),'day');
						console.log("diff",diff);
						if(diff<1){
							setTimeout(dojo.hitch(this,this.showExpiredToolTip), 3000);
						}

					}else
						if(this.order.status=='CANCELLED'){
							var lastChangeDate = com.copacabana.util.getDate(this.order.lastStatusUpdateTime);
							var diff = dojo.date.difference(lastChangeDate,new Date(),'day');
							if(diff<1){
								setTimeout(dojo.hitch(this,this.showCancelledToolTip), 1000);
							}
						}
				if(this.order.retrieveAtRestaurant==true){
					if(this.order.status=='WAITING_CUSTOMER'){
						setTimeout(dojo.hitch(this,this.showToolTip), 1000);					
					}else{
						if(this.order.status=='PREPARING'){
							if(this.order.prepareForeCast!=null && this.order.prepareForeCast!=''){
								this.foreCastText="Tempo estimado para preparo do pedido: "+this.order.prepareForeCast;
								setTimeout(dojo.hitch(this,this.showForeCast), 1000);
								this.publishPreparingState();

							}
						}
					}
				}
			}
			
			
		} catch (e) {
			console.error(e);
		}
	},
	publishPreparingState:function(){
		dojo.publish("onOrderPreparing");
	},
	showToolTip:function(){
		dijit.showTooltip(this.i18nStrings.orderIsReadyToRetrieve, dojo.query(".msgPlace",this.domNode)[0]);	
	},
	foreCastText:'',
	showForeCast:function(){
		dijit.showTooltip(this.foreCastText, dojo.query(".msgPlace",this.domNode)[0],['below','above']);	
	},
	orderedTime:null,
	timerHandler:null,
	maxWaitingTime:60*6,
	warnWaitingTime:60*5,
	notifiedDelay:false,
	showTimer:function(){
		var d = new Date();		
		var ss = dojo.date.difference(this.orderedTime,d,'second');
		if(ss>this.maxWaitingTime && this.notifiedDelay==false){			
			var msg = dojo.string.substitute(this.i18nStrings.maxWaitingTimeReached, [this.order.restaurantName,this.order.restaurantPhone]);			
			dijit.showTooltip(msg, dojo.query(".msgPlace",this.domNode)[0],['below','above']);
			this.notifiedDelay=true;
		}
		var mm = parseInt(ss/60);
		ss=ss%60;
		if(ss<10){
			ss='0'+ss;
		}
		
		if(this.timerPlace){
			this.timerPlace.innerHTML=mm+":"+ss;
			this.timerHandler = setTimeout(dojo.hitch(this,this.showTimer), 1000);
		}
		
	},
	showExpiredToolTip:function(){
		dijit.showTooltip(this.i18nStrings.expiredExplain, dojo.query(".msgPlace",this.domNode)[0],['below','above']);
		var fct = dojo.hitch(this,function(){dijit.hideTooltip(dojo.query(".msgPlace",this.domNode)[0])})
		setTimeout(fct, 15000);
		
	},
	showCancelledToolTip:function(){
		dijit.showTooltip(this.i18nStrings.cancelledExplain, dojo.query(".msgPlace",this.domNode)[0],['below','above']);
		var fct = dojo.hitch(this,function(){dijit.hideTooltip(dojo.query(".msgPlace",this.domNode)[0])})
		setTimeout(fct, 15000);
		
	}

});
