dojo.provide("com.copacabana.PlateOrderOptionsWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");
dojo.require("dojo.fx");	


//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana", "PlateOrderOptionsWidgetStrings");

dojo.declare("com.copacabana.PlateOrderOptionsWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templatePath : dojo.moduleUrl("com.copacabana","templates/PlateOrderOptionsWidget.html"),
	orderDisabled:false,
	optionsList:null,
	mainPlateTitle:null,
	constructor : function(optionsList,mainPlateTitle,disabled) {
		
		this.mainPlateTitle=mainPlateTitle;
		this.optionsList=optionsList;		
		this.orderDisabled=disabled;
		
	},
	
	plate:null,
	
	postCreate : function() {
		
		//this.inherited(arguments);//Not sure why it was breaking..
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana", "PlateOrderOptionsWidgetStrings");
		
	},	
	connections:[],
	destroyRecursive : function() {
		dojo.unsubscribe(this.subscribeAddOption);
		while(this.connections.length>0){
			dojo.disconnect(this.connections.pop());
		}
		dojo.forEach(this.getDescendants(), function(widget) {
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	subscribeAddOption:null,
	largeImgDiv:null,
	startup : function() {
		try {
			
			dojo.parser.parse(this.domNode);

			if(this.optionsList.length>1){				
				this.moreOptions.innerHTML =  dojo.string.substitute(this.i18nStrings.optionsLabel,[this.optionsList.length]); 
			}else if(this.optionsList.length==1){
				this.moreOptions.innerHTML =  dojo.string.substitute(this.i18nStrings.singleOptionLabel,[this.optionsList.length]);
			}			
			var trStyle={borderBottom:'1px solid #EB7D4B'};


			this.subscribeAddOption=dojo.subscribe('onAddPlateOption',dojo.hitch(this,this.onClick));
			for ( var i = 0; i < this.optionsList.length; i++) {
				var option = this.optionsList[i];
				//<tr><td>Tamanho médio</td><td>R$ 10,00</td><td><td><img alt="Pedir" src="/resources/img/btPedir.png" dojoAttachEvent="onclick:onClick" style="cursor: pointer;"/></td></tr>
				var tr;
				if((i+1) < this.optionsList.length){
					tr = dojo.create('tr',{style:trStyle},this.optList);
				}else{
					tr = dojo.create('tr',{},this.optList);
				}
				dojo.create('td',{innerHTML:option.title},tr);
				var price = com.copacabana.util.moneyFormatter(option.price);
				
				dojo.create('td',{innerHTML:price},tr);
				dojo.create('td',{},tr);
				var action = dojo.create('td',{},tr);
				if(this.orderDisabled!=true){

					var btn = dojo.create('img',{alt:'Pedir',src:'/resources/img/btPedir.png',style:{cursor:'pointer'}},action);

					var ff ={ 
							id:option.id,
							date:new Date(),
							title:option.title,
							addToBasket:function(){
								console.log('creation date',this.date);
								//dojo.publish('onAddPlateOption',[this.id]);
								this.addPlate(this.id);
							}							
					}
					ff.addPlate=dojo.hitch(this,this.onClick);
					this.connections.push(dojo.connect(btn, 'onclick', ff,"addToBasket", true));
				}			
			}
			dojo.subscribe('onExpandOptions',dojo.hitch(this,this.onOtherWipeIn));			
		} catch (e) {
			console.error("plateOrder start", e);
		}
	},
	expanded:false,
	onOtherWipeIn:function(id){
		if(this.id!=id && this.expanded==true){
			this.wipeOut();
		}
	},
	wipeOut:function () {		
		
			this.expanded=false;
			dojo.style(this.moreOptionsSection, "height", "");
			dojo.style(this.moreOptionsSection, "display", "block");
			var wipeArgs = {
					node:this.moreOptionsSection
			};
			dojo.fx.wipeOut(wipeArgs).play();
		
    },
   
    wipeIt:function () {
    	if(this.expanded==true){
    		this.wipeOut();    		
    	}else{
    		this.expanded=true;
    		dojo.publish('onExpandOptions',[this.id]);
    		dojo.style(this.moreOptionsSection, "display", "none");
    		var wipeArgs = {
    				node: this.moreOptionsSection
    		};
    		dojo.fx.wipeIn(wipeArgs).play();
    		console.log('efoi?')
    	}
    },
	onClick:function(id){
		if(!this.optionsList){
			return;
		}
		for ( var i = 0; i < this.optionsList.length; i++) {
			if(this.optionsList[i].id==id){
				var pedidoHandler = dijit.byId("pedidoWrapper");
				var p = dojo.clone(this.optionsList[i]);
				p.title=this.mainPlateTitle+':'+p.title;
				pedidoHandler.addPlate(p,1);		
			}
			
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
