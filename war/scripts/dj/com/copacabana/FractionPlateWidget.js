/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.FractionPlateWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.FractionPlateWidget"] = true;
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

dojo.requireLocalization("com.copacabana", "FractionPlateWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.FractionPlateWidget", [ dijit._Widget,
		dijit._Templated ], {
	// i18nStrings: dojo.i18n.getLocalization("com.copacabana",
	// "PlatesListWidgetStrings"),
	templateString:"<div>\r\n<div style=\"-moz-border-radius: 3px 3px 3px 3px;border: 1px solid;padding: 5px;\"><img src='/resources/img/measure.png'>Qual o tamanho?  <select dojoType=\"dijit.form.FilteringSelect\" class=\"plateSize\" dojoAttachPoint=\"plateSize\" dojoAttachEvent=\"onblur:sizeChanged,onChange:sizeChanged\">\r\n    <option value=\"NONE\" selected>\r\n        Grande\r\n    </option>\r\n    <option value=\"MEDIUM\" >\r\n        Média\r\n    </option>\r\n    <option value=\"SMALL\">\r\n        Pequena\r\n    </option>\r\n</select>\r\n</div>\r\n<div style=\"-moz-border-radius: 3px 3px 3px 3px;border: 1px solid;padding: 5px;\">\r\nQuais são os sabores?\r\n<br />\r\nSelecione cada metade:<br/>\r\n<table style=\"width: 450px;\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td valign=\"top\" style=\"width: 70%;text-align: left;\">\t\r\n\t\t\t<table>\t\t\r\n\t\t\t<tr>\r\n\t\t\t<td>1/2</td><td style=\"text-align: left;\"><select searchAttr=\"title\" labelAttr=\"img\" labelType=\"html\" dojoType=\"dijit.form.FilteringSelect\" class=\"plateOne\" autoComplete=\"false\" selectOnClick=\"true\" invalidMessage=\"Prato n&atilde;o encontrado\"></select></td><td><span dojoAttachPoint='plate1Info'></span></td>\r\n\t\t\t</tr>\r\n\t\t\t<tr>\r\n\t\t\t<td>1/2</td><td style=\"text-align: left;\"><select searchAttr=\"title\" labelAttr=\"img\" labelType=\"html\" dojoType=\"dijit.form.FilteringSelect\" class=\"plateTwo\" autoComplete=\"false\" selectOnClick=\"true\" invalidMessage=\"Prato n&atilde;o encontrado\"  ></select></td><td><span dojoAttachPoint='plate2Info'></span></td>\r\n\t\t\t</tr>\r\n\t\t\t<tr><td></td><td colspan=\"2\"><div dojoAttachPoint='totalInfo' style=\"height: 15px; text-align: right;\"></div></td></tr>\r\n\t\t\t\r\n\t\t\t</table>\r\n\t\t\t</td> \r\n\t\t\t<td>\r\n\t\t\t<div class=\"circle\" style=\"width: 82px; height: 80px;\">\r\n\t\t\t<div class=\"halfOne turnOff\" ></div>\r\n\t\t\t<div class=\"halfTwo turnOff\" ></div>\r\n\t\t\t</div>\r\n\t\t\t</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>\r\n</div>\r\n<div style=\"width: 100%; text-align: center; margin-top: 15px;\">\r\n<img alt=\"Pedir\" src=\"/resources/img/btPedir.png\" dojoAttachEvent=\"onclick:onClick\" style=\"cursor: pointer;\"/>\r\n</div>\r\n</div>\r\n\t\t\t\r\n",
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

}
