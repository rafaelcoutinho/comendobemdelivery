dojo.provide("com.copacabana.order.OrderEntryWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");

//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana.order", "OrderEntryWidgetStrings");

dojo.declare("com.copacabana.order.OrderEntryWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templatePath : dojo.moduleUrl("com.copacabana.order","templates/OrderEntryWidget.html"),
	constructor : function(plate,qty) {
		this.plate=plate;
		this.orderedPlate=plate;
		this.orderedPlate.priceFormatted=com.copacabana.util.moneyFormatter(this.orderedPlate.price);
		console.log(this.plate.name);
		console.log("k"+this.plate.k);
		this.qty=qty;
	},
	destroyRecursive: function(){
        dojo.forEach(this.getDescendants(), function(widget){
         
        	widget.destroyRecursive();
        });
        this.inherited(arguments);
    },
    orderedPlate:null,
    plate:null,
    qty:0,
    isReadonly:false,
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order", "OrderEntryWidgetStrings");
	},
	
	
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			dojo.query(".totalCost", this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.getTotalCost());			
		} catch (e) {
			console.error(e);
		}
	},
	increase:function(){
		if(this.isReadonly==false){
			var qtyNode = dijit.byNode(dojo.query(".quantidadeValue", this.domNode)[0]);
			qtyNode.attr("value",parseFloat(qtyNode.attr("value"))+1);
			this.qty=qtyNode.attr("value");
			dojo.query(".totalCost", this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.getTotalCost());;
			dojo.publish("onQuantityChanged");			
		}else{
			this.showReadOnlyMsg();
		}
		
	},
	getTotalCost:function(){
		return parseFloat(this.qty*this.orderedPlate.price);
	},
	decrease:function(){
		if(this.isReadonly==false){
			var qtyNode = dijit.byNode(dojo.query(".quantidadeValue", this.domNode)[0]);
			if(parseFloat(qtyNode.attr("value"))>0){
				qtyNode.attr("value",parseFloat(qtyNode.attr("value"))-1);
				this.qty=parseFloat(qtyNode.attr("value"));
			}		
			dojo.query(".totalCost", this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.getTotalCost());
			dojo.publish("onQuantityChanged");
		}else{
			this.showReadOnlyMsg();
		}
	},
	readOnlyMsg:"Este item &eacute; obrigat&oacute;rio.",
	showReadOnlyMsg:function(){
	var node = dojo.query(".quantidadeValue", this.domNode)[0];
	com.copacabana.util.showTimedMessage(this.readOnlyMsg,node,5000);
	}
	

});
