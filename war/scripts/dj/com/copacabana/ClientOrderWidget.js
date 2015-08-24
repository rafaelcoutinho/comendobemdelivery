/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.ClientOrderWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.ClientOrderWidget"] = true;
dojo.provide("com.copacabana.ClientOrderWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.form.DropDownButton");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.Dialog");
dojo.require("dijit.form.TextBox");  
dojo.require("dijit.form.TimeTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dijit.form.SimpleTextarea");
dojo.require("com.copacabana.util");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana", "ClientOrderWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.ClientOrderWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templateString:"<div id=\"pedidoWrapper\" style=\"right: 0px;\">\r\n\r\n<div class=\"canto cantoSupEsq\"></div>\r\n<div class=\"canto cantoInfEsq\"></div>\r\n\r\n<h2>Seu Pedido</h2>\r\n\r\n<ul class=\"orderList\">\t\r\n</ul>\r\n<form action=\"/placeOrder.do\" method=\"post\" dojoType=\"dijit.form.Form\" class=\"orderForm\">\r\n<input type=\"hidden\" class=\"orderData\" name=\"orderData\" dojoType=\"dijit.form.TextBox\"/>\r\n</form>\r\n<p>Prato:<br />\r\n<span class=\"itemSelecionado\">&nbsp;</span><br />\r\nCusto: <span class=\"valorUnitario\"> 0,00</span><br />\r\n\r\n</p>\r\n<hr />\r\n<p><div class=\"dropdownButtonContainer\" style=\"background: #C8C8C8 none repeat scroll 0 0;margin-top:2px;margin-bottom:2px;margin-left:3px;margin-right:3px; font-size:x-small;\">\r\n</div>\r\n\t<br/>\r\nTotal de Pratos: <span class=\"totalPratos\">0</span><br />\r\nSub-Total: <br /><span class=\"subTotal\">0,00</span><br />\r\n</p>\r\n\r\n<div class=\"confirmarPedido\" > <img alt=\"Confirmar Pedido\" style=\"cursor: pointer;\" alt=\"Confirmar Pedido\"\r\n\tsrc=\"/resources/img/btConfirmar.png\" dojoAttachEvent=\"onclick:confirmOrder\"/> </div>\r\n\r\n</div>\r\n",
	constructor : function() {
		this.id="pedidoWrapper";	
	},
	connections:[],
	destroyRecursive : function() {
		console.log("destroyingOrder..");
		while(this.connections.length>0) {
			dojo.disconnect(this.connections.pop());
		}
		
		this.plateList=[];
		var i =0;
		dojo.forEach(this.getDescendants(), function(widget) {
			console.log("destroyingOrder.."+(i++));
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings= dojo.i18n.getLocalization("com.copacabana", "ClientOrderWidgetStrings");
	},
	rest:null,
	setRestaurant:function(rest){
		this.rest=rest;
	},
	dropDown:null,
	dialog:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			console.log('starting up');
			this.dropDown=dojo.query(".dropdownButtonContainer",this.domNode)[0];
			this.dialog = new dijit.TooltipDialog({
				content: '<p>'+this.i18nStrings.obsText+'</p><textarea dojoType="dijit.form.SimpleTextarea" cols="30" rows="4" class="observationArea"  name="observation"></textarea>'	            
	        });

			var button = new dijit.form.DropDownButton({
	            label: "<span>"+this.i18nStrings.obsTitle+"</span>",
	            dropDown: this.dialog,
	            style:"background: #C8C8C8 none repeat scroll 0 0;margin-top:2px;margin-bottom:2px;margin-left:3px;margin-right:3px; font-size:x-small;"
	        });
			
	        this.dropDown.appendChild(button.domNode);
	        this.plateList=[];
			
		} catch (e) {
			console.log(e);
			console.log(e.message);
		}
	},
	obsdialog:null,
	
	addFractionPlate:function(plate1,plate2,qty,title,cost){
		var plate = {
			id:plate1.id+"|"+plate2.id,
			title:title,
			price:cost,
			firstHalf:plate1,
			secondHalf:plate2,
			isFraction:true
		};
		
		if(this.plateList[plate.id]!=null){
			var v = this.plateList[plate.id];
			qty=v.qty+qty;		
			this.removeIt(plate.id,v.qty);			                       
		}
		
		var item = document.createElement("li");
		item.setAttribute("class","order_"+plate.id);
		item.setAttribute("plateId",plate.id);
		item.setAttribute("firstHalfId",plate1.id);
		item.setAttribute("secondHalfId",plate2.id);
		item.setAttribute("qty",qty);
		var label = document.createTextNode(qty+" "+plate.title);
		item.appendChild(label);
		var removeNode = document.createElement("span");
		removeNode.setAttribute("title",this.i18nStrings.removeLabel);		
		var fctRemove = dojo.hitch(this,function(evt){
			this.removeIt(plate.id,qty);
		});
		this.connections.push(dojo.connect(removeNode, "onclick", this, fctRemove,false));
		var fctShowCurrentItemData = dojo.hitch(this,function(evt){			
			this.showCurrentItemData(plate);
		});
		this.connections.push(dojo.connect(item, "onclick", this, fctShowCurrentItemData,false));

		removeNode.appendChild(document.createTextNode("X"));
		item.appendChild(removeNode);
		
		this.plateList[plate.id]={plate:plate,qty:qty};
		(dojo.query(".orderList", this.domNode)[0]).appendChild(item);
		this.updateOrderData();
		
	},
	
	
	addPlate:function(plate,qty){
		
		if(this.plateList[plate.id]!=null){
			var v = this.plateList[plate.id];
			qty=v.qty+qty;		
			this.removeIt(plate.id,v.qty);
			                       
		}
		plate.isFraction=false;
		var item = document.createElement("li");
		item.setAttribute("class","order_"+plate.id);
		item.setAttribute("plateId",plate.id);
		item.setAttribute("qty",qty);
		var label = document.createTextNode(qty+" "+plate.title);
		item.appendChild(label);
		var removeNode = document.createElement("span");
		removeNode.setAttribute("title",this.i18nStrings.removeLabel);		
		var fctRemove = dojo.hitch(this,function(evt){
			this.removeIt(plate.id,qty);
		});
		this.connections.push(dojo.connect(removeNode, "onclick", this, fctRemove,false));
		var fctShowCurrentItemData = dojo.hitch(this,function(evt){
			
			this.showCurrentItemData(plate);
		});
		this.connections.push(dojo.connect(item, "onclick", this, fctShowCurrentItemData,false));

		removeNode.appendChild(document.createTextNode("X"));
		item.appendChild(removeNode);
		
		this.plateList[plate.id]={plate:plate,qty:qty};
		(dojo.query(".orderList", this.domNode)[0]).appendChild(item);
		this.updateOrderData();
		
	},
	lastPanel:null,
	showCurrentItemData:function(plate){
		
		if(this.lastPanel && this.lastPanel!=null){			
			dojo.style(this.lastPanel,"backgroundColor","white");
		}
		var panel=this.getNode("order_"+plate.id,(dojo.query(".orderList", this.domNode)[0]));

		this.lastPanel=panel;
		
		dojo.style(panel,"backgroundColor","silver");
		(dojo.query(".itemSelecionado", this.domNode)[0]).innerHTML=plate.title;
		(dojo.query(".valorUnitario", this.domNode)[0]).innerHTML=com.copacabana.util.moneyFormatter(plate.price);
		
	},
	plateList:[],
	confirmOrder:function(){
		com.copacabana.util.showLoading();
		try{
			console.log("dialog",this.dialog.domNode);			
			console.log(dojo.query(".observationArea",this.dialog.domNode)[0].value);
			}catch(e){
				console.log(e);
			}
		
		var orderData ={plates:[],observation:dojo.query(".observationArea",this.dialog.domNode)[0].value};
		for ( var p in this.plateList) {
			var plateObj = this.plateList[p];
			
			if(plateObj!=null){				
				orderData.restaurant={
						id:this.rest.id,
						name:this.rest.name,
						acceptablePayments:this.rest.acceptablePayments,
						warning:this.rest.warning,
						warningDate:this.rest.warningDate
				}
				plateObj.plate.restaurant=null;
				//orderData.restaurant=plateObj.plate.restaurant;
				//TODO maybe reduce the bandwidth used by filtering fieldss
				//orderData.plates.push({id:plateObj.plate.id,qty:plateObj.qty});
				
				var pp = {
						qty:plateObj.qty,
						name:plateObj.plate.title,
						price:plateObj.plate.price,
						plate:plateObj.plate.id,
						isFraction:plateObj.plate.isFraction					
					};
				if(plateObj.plate.isFraction==true){
					pp.fractionKeys=[];
					pp.fractionKeys.push(plateObj.plate.firstHalf.id);
					pp.fractionKeys.push(plateObj.plate.secondHalf.id);					
				}
				orderData.plates.push(pp);
				
//				orderData.plates.push({
//					qty:plateObj.qty,
//					name:plateObj.plate.title,
//					price:plateObj.plate.price,
//					plate:plateObj.plate
//				});
			}			
		}
		
		if(!orderData.plates|| orderData.plates.length==0){
			com.copacabana.util.hideLoading();
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg(this.i18nStrings.atLeastOneItem,msg.errorType);
			
			return;
		}
		dijit.byNode(dojo.query(".orderData",this.domNode)[0]).attr("value",dojo.toJson(orderData));
		dijit.byNode(dojo.query(".orderForm", this.domNode)[0]).submit();
		
	},
	getNode:function(nodeClassName,domNode){
		var node = dojo.query("."+nodeClassName,domNode )[0];
		try{
			if (!node) {
				console.log('IE bug, cannot find node:'+node);
				for (var i = 0; i < (domNode).childNodes.length; i++) {
					var classS = (domNode).childNodes[i].getAttribute('class');
					if (classS == nodeClassName) {
						node = (domNode).childNodes[i];
					}
				}
			}
			console.log('node',node);
		}catch (e) {			
			console.log(e);
		}
			return node;
	},
	removeIt:function(id,qty){
		console.log("remove:"+id);				
		this.plateList[id]=null;		
		var node = this.getNode("order_"+id,(dojo.query(".orderList", this.domNode)[0]));
		(dojo.query(".orderList", this.domNode)[0]).removeChild(node);		
		this.updateOrderData();
	},
	updateOrderData:function(){
		var totalItems=0;
		var totalCost=0;
		for ( var p in this.plateList) {
			var plateObj = this.plateList[p];
			if(plateObj!=null){
				totalItems++;
				totalCost+=plateObj.qty*plateObj.plate.price;
			}			
		}
		dojo.query(".totalPratos", this.domNode)[0].innerHTML=totalItems;
		dojo.query(".subTotal" , this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(totalCost);
	}

});

}
