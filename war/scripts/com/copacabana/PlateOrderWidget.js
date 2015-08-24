dojo.provide("com.copacabana.PlateOrderWidget");
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
 
dojo.requireLocalization("com.copacabana", "PlateOrderWidgetStrings");

dojo.declare("com.copacabana.PlateOrderWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templatePath : dojo.moduleUrl("com.copacabana","templates/PlateOrderWidget.html"),
	orderDisabled:false,
	constructor : function(plate,disable) {
		this.plate=plate;
		this.id="plate_order_"+plate.id;
		this.plate.priceFormatted = com.copacabana.util.moneyFormatter(this.plate.price);
		if(disable || plate.status=='UNAVAILABLE'){
			this.templatePath= dojo.moduleUrl("com.copacabana","templates/PlateOrderWidgetClosed.html");
			this.orderDisabled=true;
			if(plate.status=='UNAVAILABLE'){
				this.statusStr='* Temporariamente indisponivel.';	
			}
		}else if(this.plate.availableTurn!='ANY'){
			if(this.plate.currentTurn!=this.plate.availableTurn){
				this.templatePath= dojo.moduleUrl("com.copacabana","templates/PlateOrderWidgetUnavailable.html");
				this.orderDisabled=true;
				
				
				
			}
		}
		
		

	},
	statusStr:'',
	 destroyRecursive: function(){
        dojo.forEach(this.getDescendants(), function(widget){
        	widget.destroyRecursive();
        });
        this.inherited(arguments);
    },
	plate:null,
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana", "PlateOrderWidgetStrings");
	},	
	largeSection:null,
	showImage:function(evt){
		
		this.largeImgDiv.src=this.plate.imageUrl;
		
		dojo.style(this.largeSection,'display','block');
		
		
	},
	hideImage:function(evt){
		
		dojo.style(this.largeSection,'display','none');
		
	},
	largeImgDiv:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			if(this.plate.availableTurn!='ANY'){
				if(this.plate.currentTurn!=this.plate.availableTurn){					
					this.statusSection.innerHTML=this.i18nStrings['onlyFor_'+this.plate.availableTurn];
				}
			}
			//<div style="float: left;" class="imgSection"><img style="max-height: 50px;" src="/prato/img/1362"></div>
			if(this.plate.imageUrl!=null && this.plate.imageUrl!=''){
				var fct = dojo.hitch(this,this.showImage);
				var fct2 = dojo.hitch(this,this.hideImage);
				var largerStyle={position:'absolute',display:'none',padding:'5px',border:'1px solid gray','MozBorderRadius':"5px 5px 5px 5px",backgroundColor:'white'};
				this.largeSection=dojo.create('div',{style:largerStyle,onmouseout:fct2},this.imgPlace);
				console.log('is IE !! ',dojo.isIE);
				if(!dojo.isIE){
					this.largeImgDiv= dojo.create('img',{style:{},src:'/resources/img/loader.gif'},this.largeSection);
				}else{
					this.largeImgDiv= dojo.create('img',{style:{minWidth:'300px',minHeight:'300px'},src:this.plate.imageUrl},this.largeSection);
						
				}
				dojo.create('div',{style:{textAlign:'center'},innerHTML:this.plate.title},this.largeSection);
				dojo.create('img',{src:this.plate.imageUrl+'.small',onmouseover:fct},this.imgPlace);
				dojo.style(this.titleSection,'fontSize','large');
				dojo.style(this.titleSection,'paddingLeft','5px');
				
			}
			if (this.orderDisabled == false) {
				
				dijit.byNode(dojo.query(".quantidadeValue", this.domNode)[0])
						.attr("value", 1);
			}

		} catch (e) {
			console.error("plateOrder start", e);
		}
	},
	onClick:function(evt){
		var qtyNode = dijit.byNode(dojo.query(".quantidadeValue", this.domNode)[0]);
		var qty = parseFloat(qtyNode.attr("value"));
		var pedidoHandler = dijit.byId("pedidoWrapper");
		if(qty>0){
			pedidoHandler.addPlate(this.plate,qty);
		}
	},
	increase:function(){
		var qtyNode = dijit.byNode(dojo.query(".quantidadeValue", this.domNode)[0]);
		qtyNode.attr("value",parseFloat(qtyNode.attr("value"))+1);		
	},
	decrease:function(){
		var qtyNode = dijit.byNode(dojo.query(".quantidadeValue", this.domNode)[0]);
		if(parseFloat(qtyNode.attr("value"))>0){
			qtyNode.attr("value",parseFloat(qtyNode.attr("value"))-1);
		}
	}
	

});
