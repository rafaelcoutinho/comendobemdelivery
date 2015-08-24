dojo.provide("com.copacabana.FractionPlateWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");
// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana", "FractionPlateWidgetStrings");

dojo.declare("com.copacabana.FractionPlateWidget", [ dijit._Widget,
		dijit._Templated ], {
	// i18nStrings: dojo.i18n.getLocalization("com.copacabana",
	// "PlatesListWidgetStrings"),
	templatePath : dojo.moduleUrl("com.copacabana",
			"templates/FractionPlateWidget.html"),
	constructor : function(args) {
		this.plates = dojo.clone(args.catPlates);
		this.rest=dojo.clone(args.rest);

	},
	sizeChanged:function(val){		
		console.log('size Changed',val);
		var sortAttributes = [{attribute: "title", descending: false}];
		var queryData= {
				query: {"plateSize":val},
				queryOptions: {},
				sort: sortAttributes,
				onBegin: function(){console.log('begining')},
				onComplete: dojo.hitch(this,function(items, request){
					var availablePlates=[];
					for (i = 0; i < items.length; i++) {
						var item = items[i];
						var title = this.plateStore.getValue(item, "title");
						var imageUrl = this.plateStore.getValue(item, "imageUrl");
						
						if(this.plateStore.getValue(item, "isExtension")==true){
							title=this.plateStore.getValue(item, "name");
							imageUrl=this.plateStore.getValue(item, "mainPlateImageUrl");
							console.log(this.plateStore.getValue(item, "mainPlateTitle"));
							console.log(this.plateStore.getValue(item, "mainPlateImageUrl"));
						}
						var htmlTitle=title;
						if(imageUrl!=null && imageUrl.length>0) {
							htmlTitle='<img src="'+imageUrl+'.small" />'+title;
						}
						availablePlates.push(
								{
									id:this.plateStore.getValue(item, "id"),
									title:title,
									'img':htmlTitle
								}		
						);
						console.log(this.plateStore.getValue(item, "title"));	                        
					}
					var store=new dojo.data.ItemFileReadStore({
						data:{
							'identifier':'id',
							'label':'title',
							'items':availablePlates
						}
					});
					//todo set the value similar to the existing selection
					      	   
					this.prato1.reset();
					this.prato2.reset();					
					this.prato2.queryExpr="*${0}*";
					this.prato1.queryExpr="*${0}*";
					this.prato1.store=store;
					this.prato2.store=store;  
					this.updateTotals();
				}),
				onError: function(err){console.error(err)}
		};
		var items = {
				identifier:'id',
				label:'name',
				items:this.plates
		}
		this.plateStore = new dojo.data.ItemFileReadStore({
			data:items
		});	
		this.plateStore.fetch(queryData);
	},
	prato1:null,
	prato2:null,
	halfDialog:null,
	plateStore:null,
	plateSize:null,
	startup : function() {
		dojo.parser.parse(this.domNode);
		
		this.prato1 = dijit.byNode(dojo.query(".plateOne",this.domNode)[0]);		
		this.plateSize = dijit.byNode(dojo.query(".plateSize",this.domNode)[0]);
		this.prato2 = dijit.byNode(dojo.query(".plateTwo",this.domNode)[0]);
		
		this.sizeChanged('NONE');
		
		dojo.connect(this.plateSize, "onChange", dojo.hitch(this,this.sizeChanged));
		dojo.connect(this.prato1, "onChange", dojo.hitch(this,this.changeHalfOne));		
		dojo.connect(this.prato2, "onChange", dojo.hitch(this,this.changeHalfTwo));
		
		var options ={
				closable:true,
			title : "Meia pizza",
			style : 'border:1px solid black;',
			content: this.domNode
		}	
		
		this.halfDialog = new dijit.Dialog(options);	
		this.halfDialog.show();
		
	},
	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings = dojo.i18n.getLocalization("com.copacabana",	"FractionPlateWidgetStrings");
	},
	onClick:function(evt){		
		if(this.selectedPlate1!=null && this.selectedPlate2!=null){
			console.log('criar pedido');
			var pedidoHandler = dijit.byId("pedidoWrapper");
			
			var title = "";
			console.log("isExtension",this.selectedPlate1.isExtension);
			if(this.selectedPlate1.isExtension.length>0){
				this.selectedPlate1.isExtension=this.selectedPlate1.isExtension[0];
			}
			if(this.selectedPlate2.isExtension.length>0){
				this.selectedPlate2.isExtension=this.selectedPlate2.isExtension[0];
			}
			if(this.selectedPlate1.isExtension==true){
				title = "1/2 "+this.selectedPlate1.mainPlateTitle;
			}else{
				title = "1/2 "+this.selectedPlate1.name;
			}
			if(this.selectedPlate2.isExtension==true){
				title += "1/2 "+this.selectedPlate2.mainPlateTitle;
			}else{
				title += "1/2 "+this.selectedPlate2.name;
			}
			if(this.selectedPlate1.plateSize!='NONE'){
				if(this.selectedPlate1.plateSize=='SMALL'){
					title='Pqna '+title; 
				}
				if(this.selectedPlate1.plateSize=='MEDIUM'){
					title='Média '+title; 
				}
			}
			pedidoHandler.addFractionPlate(this.selectedPlate1,this.selectedPlate2,1,title,this.getCost());
			this.halfDialog.hide();
			
		}else{
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Por favor selecione as duas metades.");
		}
		
		
	},
	changeHalfOne:function(evt){
		this.selectedPlate1=this.changeHalf(this.prato1, ".halfOne", this.plate1Info);
		this.updateTotals();
	},
	changeHalfTwo:function(evt){
		this.selectedPlate2=this.changeHalf(this.prato2, ".halfTwo", this.plate2Info);
		this.updateTotals();
	},
	changeHalf:function(selectWidget,classHalf,domPlace){
		
		var plateHandler;
		if(selectWidget.attr('value')!=null && selectWidget.attr('value')!=''){
			dojo.removeClass(dojo.query(classHalf,this.domNode)[0],'turnOff');
			plateHandler=this.showPlateInfo(selectWidget.attr('value'),domPlace);			
		}else{
			domPlace.innerHTML='';
			dojo.addClass(dojo.query(classHalf,this.domNode)[0],'turnOff');
			plateHandler=null;			
		}
		return plateHandler;
	},
	getPlateInfo:function(pid){
		for ( var i = 0; i < this.plates.length; i++) {
			var p = this.plates[i];
			if(p.id==pid){
				return p;
			}
		}
		console.error('cannot find plate',pid);
	},
	updateTotals:function(){
		if(this.selectedPlate1!=null && this.selectedPlate2!=null){
			var total = this.getCost();
			this.totalInfo.innerHTML="Pre&ccedil;o final: "+com.copacabana.util.moneyFormatter(total);
		}else{
			this.totalInfo.innerHTML='';	
		}
		
	},
	rest:null,	
	getCost:function(){
		console.log("calculus type: ",this.rest.fractionPriceType);
		if(!this.rest.fractionPriceType){
			this.rest.fractionPriceType='HALFHALF';			
		}
		switch (this.rest.fractionPriceType) {
			case 'HALFHALF':
				return (parseFloat(this.selectedPlate1.price)/2)+(parseFloat(this.selectedPlate2.price)/2);	
				break;
			case 'MOREEXPENSIVEWINS':
				if(parseFloat(this.selectedPlate1.price)>parseFloat(this.selectedPlate2.price)){
					return parseFloat(this.selectedPlate1.price); 
				}else{
					return parseFloat(this.selectedPlate2.price); 
				}
				break;
	
			default:
				return (parseFloat(this.selectedPlate1.price)/2)+(parseFloat(this.selectedPlate2.price)/2);
			break;
		}

	},
	selectedPlate1:null,
	selectedPlate2:null,
	showPlateInfo:function(id,domPlace){
		var plateInfo = this.getPlateInfo(id);
		domPlace.innerHTML= com.copacabana.util.moneyFormatter(plateInfo.price);// "1/2
																				// "+plateInfo.name;
		return plateInfo;
		
	}
	

});