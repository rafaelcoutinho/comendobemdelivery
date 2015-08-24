dojo.provide("com.copacabana.order.RestaurantOrderEntryWidget");
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

dojo.requireLocalization("com.copacabana.order",
		"RestaurantOrderEntryWidgetStrings");

dojo.declare("com.copacabana.order.RestaurantOrderEntryWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templatePath : dojo.moduleUrl("com.copacabana.order",
			"templates/RestaurantOrderEntryWidget.html"),
	constructor : function(order,timeBased) {
		this.order = order;
		if(!this.order.idXlated){
			this.order.idXlated="";
		}
		if(!this.order.dailyCounter ||this.order.dailyCounter==0){
			this.order.dailyCounter="";
		}
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order",	"RestaurantOrderEntryWidgetStrings");
		this.order.statusCss = this.i18nStrings['CSS_'+this.order.status];
		this.order.statusImage = this.i18nStrings['IMAGE_'+this.order.status];
		this.order.statusImageAlt = this.i18nStrings['ALT_IMAGE_'+this.order.status];
		this.timeBased=timeBased;
		if(timeBased==false){
			this.templatePath=dojo.moduleUrl("com.copacabana.order",
			"templates/RestaurantOrderEntryNoTimeWidget.html");
		}		
		this.order.orderedHour=com.copacabana.util.parseTime(order.orderedTime);
		this.order.orderedDate=com.copacabana.util.parseDate(order.orderedTime);
		this.order.lastStatusUpdateHour=com.copacabana.util.parseTime(order.lastStatusUpdateTime);

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
			if(this.order.status=='NEW'){
				console.log("startup of a NEW one")
				dojo.publish("onNewOrders",[this.order]);
			}
			if(this.timeBased==true){				
				dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateElapsedTime));
				this.updateElapsedTime();
			}
		} catch (e) {
			console.error(e);
		}
	},
	updateElapsedTime:function(data){	
		if(dojo.query(".elapsedTotal", this.domNode)[0]){
			dojo.query(".elapsedTotal", this.domNode)[0].innerHTML=com.copacabana.util.getElapsedTime(this.order.orderedHour,this.order.orderedTime);
		}
		if(dojo.query(".elapsedTotal", this.domNode)[0]){
			dojo.query(".elapsedLastStatusChange", this.domNode)[0].innerHTML=com.copacabana.util.getElapsedTime(this.order.lastStatusUpdateHour,this.order.lastStatusUpdateTime);
		}
	},
	viewOrderDetails:function(){	
		var v=new com.copacabana.order.ViewOrderDetailsWidget();
		v.currentDelay=loggedRestaurant.currentDelay;
		v.order=this.order;
		v.startup();		
	}

});
