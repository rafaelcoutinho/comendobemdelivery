/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.RestaurantViewWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.RestaurantViewWidget"] = true;
dojo.provide("com.copacabana.RestaurantViewWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.RestPlateMenuWidget");
dojo.require("com.copacabana.ClientOrderWidget");
//Require the Tooltip class
dojo.require("dijit.Tooltip");

//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana", "RestaurantViewWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.RestaurantViewWidget", 
		[ dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	openingStr:null,
	templateString:"<div style=\"font-family: Arial,sans-serif;font-size: 62.5%;color: #555;\">\r\n<div class=\"restaurantinfo\" style=\"background: #F7F7F7;padding: 10px 10px 22px 10px;margin-bottom: 1em;border: 1px solid #DDD;\">\r\n<div class=\"ratingbox\" dojoAttachPoint=\"facebookDom\"></div>\r\n<h1 class=\"consumer\">\r\n\t\t<a class=\"VendorName\" dojoAttachPoint=\"restName\">\r\n\t\t    </a>&nbsp;<span class=\"priceRating\"></span></h1>\r\n\t\t<div style=\"float:right;\" dojoAttachPoint=\"logoNode\"></div>\r\n\t    <p style=\"margin:2px;max-height: 105px;\">\r\n\t\t<span dojoAttachPoint=\"restDescription\"></span><br/>\r\n\t\t<span dojoAttachPoint=\"restAddress\" style=\"clear:both;\"></span>\r\n\t\t</p>\r\n\t\t<div dojoAttachPoint=\"openStatus\"></div>\r\n\t    <div class=\"restaurantdetails\">\r\n\t    <p class=\"paymenttype\">\r\n\t\t   Aceita <strong dojoAttachPoint=\"paymentTypes\"></strong>. \r\n\t\t</p>\r\n\t\t<p class=\"info\" style=\"display:none;\" dojoAttachPoint=\"neighSelected\">\r\n\t\t    Taxa de entrega <strong dojoAttachPoint=\"delCost\"><img src=\"/resources/img/loading.gif\"></strong> <span dojoAttachPoint=\"minSection\"></span><br> para o bairro <span dojoAttachPoint=\"destNeigh\" title=\"Clique para trocar o bairro\" style=\"cursor: pointer; text-decoration: underline; font-weight: bold;\"></span> (<a class=\"tooltip-header\" dojoAttachPoint=\"infoSectionDelivery\">mais informa&ccedil;&otilde;es</a>) \r\n\t\t</p>\r\n\t\t<p class=\"info\" style=\"display:none;\" dojoAttachPoint=\"entireCity\">\r\n\t\t    Taxa de entrega <strong dojoAttachPoint=\"delCostCity\"><img src=\"/resources/img/loading.gif\"></strong> <span dojoAttachPoint=\"minSectionCity\"></span><br> para todos os bairros de <span dojoAttachPoint=\"cityName\"></span> (<a class=\"tooltip-header\" dojoAttachPoint=\"infoSectionCity\">mais informa&ccedil;&otilde;es</a>) \r\n\t\t</p>\r\n\t\t<p class=\"info\" style=\"display:none;\" dojoAttachPoint=\"neighNotSelected\">\r\n\t\t     Selecione um bairro da &aacute;rea de entrega: <select dojoType=\"dijit.form.FilteringSelect\" class=\"nSelection\"\r\n\t\t      autoComplete=\"false\" selectOnClick=\"true\" hasDownArrow=\"false\" invalidMessage=\"Bairro fora da &aacute;rea do restaurante\" promptMessage=\"Digite o bairro\"  style=\"background-color: white;width: 150px;margin-bottom:0px;margin-top: 0px;\" ></select>\r\n\t\t</p>\r\n\t\t\r\n\t\t<p class=\"readytime\">\r\n\t\t    Prazo de entrega estimado <strong dojoAttachPoint=\"estimateForecast\">30 min</strong> (<a class=\"tooltip-header\" dojoAttachPoint=\"alertaEntrega\" >mais informa&ccedil;&otilde;es</a>).\r\n\t\t</p>\r\n\t\t\r\n\t    </div>\r\n\t</div>\r\n<div id=\"pedido\" class=\"pedidoWidget\" style=\"float:right;position:relative;top:0px;\"></div>\r\n<div style=\"width: 650px;\">\r\n<div  class=\"cardapioPanel\" dojoAttachPoint=\"cardapioDomNode\"></div>\r\n</div>\r\n\r\n</div>\r\n",
	constructor : function(rest) {
		
		this.rest=rest;
		
		

//		if(this.rest.onlyForRetrieval==true){
//			this.strings.moredata+=' * Somente pedidos para retirar no restaurante.';	
//		}
		this.id=rest.id+"_RestaurantView";



	},
	postMixInProperties: function(){
		if (dijit.byId(this.id)) {
			dijit.byId(this.id).destroyRecursive();
		}
	}, 
	destroyRecursive: function(){

		if(this.restPlateMenu!=null){
			console.log("destroying restPlateMenu");
			this.restPlateMenu.destroy();
			this.restPlateMenu.destroyDescendants(false);
			this.restPlateMenu.destroyRecursive(false);
		}
		if(this.order!=null){
			console.log("destroying order");
			this.order.destroy(false);
			this.order.destroyDescendants(false);
			this.order.destroyRecursive(false);
		}

		dojo.forEach(this.getDescendants(), function(widget){
			console.log(" RestaurantViewWidget destroying "+widget.id);
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	imageNode:null,
	

	postCreate : function() {
		this.inherited(arguments);	
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana", "RestaurantViewWidgetStrings");
	},
	rest:null,
	setRestaurant:function(rest){
		this.rest=rest;
	},
	strings:{
		restName:"",
		description:""
	},

	showPanel:function(){
		
		
		/*
		//this.strings.restName=this.rest.name;
		if(this.rest.uniqueUrlName && this.rest.uniqueUrlName.length>0){
			dojo.create("a",{href:'/'+ this.rest.uniqueUrlName ,innerHTML:this.rest.name,style:{fontSize: '1.4em'}},this.restNamePlace);

		}else{
			var url = '/?showRestaurant=true&restaurantId='+this.rest.id;
			dojo.create("a",{href:url,innerHTML:this.rest.name,style:{fontSize: '1.4em',color:'#605D5D'}},this.restNamePlace);		

		}
		this.strings.description=this.rest.description;
		dojo.parser.parse(this.domNode);
		

		if(this.rest.imgUrl && this.rest.imgUrl !=""){
			this.imageNode =  document.createElement('img');
			this.imageNode.src = this.rest.imgUrl;
			this.imageNode.alt=this.rest.name;
			this.imageNode.title=this.rest.name;
			var imgNode = dojo.query(".imagem",this.domNode)[0];
			imgNode.appendChild(this.imageNode);
		}

		if(this.rest.imgKeyString && this.rest.imgKeyString !=""){
			this.imageNode =  document.createElement('img');
			dojo.addClass(this.imageNode,'restLogoPlace');

			this.imageNode.src = this.rest.imageUrl+".small";
			this.imageNode.alt=this.rest.name;
			this.imageNode.title=this.rest.name;
			if(!dojo.isIE){
				console.log('noneed');
			}else{
				this.imageNode.height=70;
				this.imageNode.width=70;
			}
			var imgNodelogo = dojo.query(".imagemRestLogo",this.domNode)[0];

			imgNodelogo.appendChild(this.imageNode);


		}

		var orderPosition = dojo.query(".pedidoWidget",this.domNode)[0];
		if(this.rest.isOpen==true && this.rest.siteStatus=='ACTIVE'){
			this.order = new com.copacabana.ClientOrderWidget();
			this.order.setRestaurant(this.rest);
			this.order.startup();		
			orderPosition.appendChild(this.order.domNode);
		}*/


	},
	selectedNeighborhood:function(evt){		
		this.showDelRangeInfo({id:evt});
	},
	order:null,
	restPlateMenu:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.delRangeSelection = dijit.byNode(dojo.query(".nSelection",this.domNode)[0]);			
			dojo.connect(this.delRangeSelection, "onChange", dojo.hitch(this,this.selectedNeighborhood));			
			dojo.connect(this.destNeigh, "onclick", dojo.hitch(this,this.switchToSelectNeigh));
			dojo.create("span",{innerHTML:this.rest.name,style:{fontSize:'large',color:'#EB7D4B'}},this.restName);
			
			if(this.rest.uniqueUrlName && this.rest.uniqueUrlName.length>0){
				this.restName.href='/'+ this.rest.uniqueUrlName;
			}else{
				var url = '/?showRestaurant=true&restaurantId='+this.rest.id;
				this.restName.href=url;		

			}
			
			if(this.rest.description && this.rest.description!=''){
				this.restDescription.innerHTML=this.rest.description;
			}
			this.restAddress.innerHTML = 'Telefone: '+this.rest.contact.phone;			
			
			if(this.rest.opensToday==false){
				this.openingStr='N&atilde;o abre hoje.';
			}else{
				this.openingStr="Hoje das "+this.rest.openingString+' &agrave;s '+this.rest.closingString;
				if(this.rest.hasSecondTurn==true){
					this.openingStr+=' e das ' + this.rest.secTurnOpeningString+' &agrave;s '+this.rest.secTurnClosingString;
				}
				this.openingStr+='.';
			}
			
			if(this.rest.siteStatus!='ACTIVE'){
				if(this.rest.siteStatus=='TEMPUNAVAILABLE'){
					this.openStatus.innerHTML='Indisponível';
					dojo.addClass(this.openStatus,"restaurantClosed");
					this.openStatus.title=this.i18nStrings.tempUnavailable;
				}else{
					this.openStatus.innerHTML='Breve';
					dojo.addClass(this.openStatus,"restaurantSoon");
					this.openStatus.title=this.i18nStrings.soonNoComendoBem;
				}
				//dojo.addClass(this.oStatusDom,'restaurantSoon');
				//dojo.removeClass(this.oStatusDom,'restaurantClosed');				

			}else{
				if(this.rest.isOpen!=true){
					this.openStatus.innerHTML='Restaurante está fechado neste momento.<br>';
					this.openStatus.innerHTML+=this.openingStr;
					dojo.addClass(this.openStatus,"alertMsg");
					this.openStatus.title=this.i18nStrings.closedInfo;								
					dojo.style(this.openStatus,'display','block');

				}else{
					this.openStatus.innerHTML=this.openingStr;
					//dojo.empty(this.oStatusDom);

					if(!this.rest.currentDelay || this.rest.currentDelay==null){
						this.rest.currentDelay='30 min';
					}

					var style={};
					switch (this.rest.currentDelay) {
					case 'ONCEADAY':
						this.estimateForecast.innerHTML='1x ao dia';						
						break;

					default:
						if(this.rest.currentDelay>45){
							//style={textDecoration:'blink'};
						}
					
					this.estimateForecast.innerHTML=this.rest.currentDelay+' mins';
					break;
					}					
				}
			}
			
			if(this.rest.acceptablePayments && this.rest.acceptablePayments.length>0){
				for(var i=0;i<this.rest.acceptablePayments.length;i++){
					if(this.i18nStrings["paymentType_"+this.rest.acceptablePayments[i]]){
						this.paymentTypes.innerHTML+=this.i18nStrings["paymentType_"+this.rest.acceptablePayments[i]];
						if((i+1)<this.rest.acceptablePayments.length){
							this.paymentTypes.innerHTML+=", "
						}
					}					
				}
			}

			if(this.rest.uniqueUrlName && this.rest.uniqueUrlName!=''){
				var host = window.location.hostname;
				if(!host){
					host=window.host;
				}				
								
				com.copacabana.util.createFacebookButtonCurrent(this.facebookDom,"http://"+host+"/"+this.rest.uniqueUrlName);
			}
			
			if(this.rest.imgUrl && this.rest.imgUrl !=""){
				this.imageNode = dojo.create("img",{src:this.rest.imgUrl,alt:this.rest.name,title:this.rest.name},this.logoNode)				
			}

			if(this.rest.imgKeyString && this.rest.imgKeyString !=""){
				this.imageNode = dojo.create("img",{style:{maxHeight:'100px'},src:this.rest.imageUrl,alt:this.rest.name,title:this.rest.name},this.logoNode)

				if(!dojo.isIE){
					console.log('noneed');
				}else{
					this.imageNode.height=100;
					this.imageNode.width=100;
				}
				
			}
			
			this.restPlateMenu = new com.copacabana.RestPlateMenuWidget();
			this.restPlateMenu.setRestaurant(this.rest);

			//var menu = dojo.query(".cardapioPanel",this.domNode)[0];
			var menu = this.cardapioDomNode;
			this.restPlateMenu.startup();
			this.restPlateMenu.show();
			
			menu.appendChild(this.restPlateMenu.domNode);
			
			var orderPosition = dojo.query(".pedidoWidget",this.domNode)[0];
			if(this.rest.isOpen==true && this.rest.siteStatus=='ACTIVE'){
				this.order = new com.copacabana.ClientOrderWidget();
				this.order.setRestaurant(this.rest);
				this.order.startup();		
				orderPosition.appendChild(this.order.domNode);
			}
			
			this.starttooltips();
			
			var searchWidget = dijit.byId('formularioBusca');
			var neighborhood = searchWidget.getSelectedNeighborhood();

			this.showDelRangeInfo(neighborhood);
			
		} catch (e) {
			console.error("RestViewWidget startup failed ",e.message);
		}
	},
	switchToSelectNeigh:function(){		
		this.showDelRangeInfo({id:null});
	},
	showDelRangeInfo:function(neighborhood){
		this.currentDelNeigh=neighborhood;
		if(neighborhood==null||!neighborhood.id){
			dojo.style(this.entireCity,"display","none");
			dojo.style(this.neighSelected,"display","none");
			this.delRangeSelection.reset();
			dojo.style(this.neighNotSelected,"display","block");
		}else{
			dojo.style(this.entireCity,"display","none");
			dojo.style(this.entireCity,"display","none");
			dojo.style(this.neighSelected,"display","block");
			dojo.style(this.neighNotSelected,"display","none");			
		}
		com.copacabana.util.loadDeliveryRange(this.rest.id,dojo.hitch(this,this.loadedDeliveryRange),function(error){console.error(error)});
	},
	currentDelNeigh:{id:null,name:null},
	loadedDeliveryRange:function(delRange){
		var dupefixes={};
		if(delRange.length==1 && delRange[0].neighborhood==null && delRange[0].city && delRange[0].city.id){
			dojo.style(this.neighNotSelected,"display","none");
			dojo.style(this.neighSelected,"display","none");
			dojo.style(this.entireCity,"display","block");
			var range= delRange[0];
			this.cityName.innerHTML=range.city.name;
			this.delCostCity.innerHTML=com.copacabana.util.moneyFormatter(range.deliveryRange.costInCents/100.0);
			if(range.deliveryRange.minimumOrderValueInCents && range.deliveryRange.minimumOrderValueInCents>0){
				this.minSectionCity.innerHTML=" com pedido m&iacute;nimo de <b>"+com.copacabana.util.moneyFormatter(range.deliveryRange.minimumOrderValueInCents/100.0)+"</b> ";	
			}else{
				this.minSectionCity.innerHTML="";
			}

		}else{
			var neighborhood = this.currentDelNeigh;
			var storeData = [];	
			var entireCityEntry=null;
			var foundNeigh=false;
			if(delRange.length>0) {		
				for(var i=0;i<delRange.length;i++){
					var range = delRange[i];
					if(range.neighborhood==null && range.city && range.city.id){
						entireCityEntry={
								costInCents:range.deliveryRange.costInCents,
								minimumOrderValueInCents:range.deliveryRange.minimumOrderValueInCents
						}
						continue;
					}
					if(dupefixes[range.neighborhood.id]==true){
						continue;
					}
					dupefixes[range.neighborhood.id]=true;
					
					storeData.push({name:range.neighborhood.name,id:range.neighborhood.id});;
					if(range.neighborhood.id==neighborhood.id){
						foundNeigh=true;
						this.destNeigh.innerHTML=range.neighborhood.name;
						this.delCost.innerHTML=com.copacabana.util.moneyFormatter(range.deliveryRange.costInCents/100.0);
						if(range.deliveryRange.minimumOrderValueInCents && range.deliveryRange.minimumOrderValueInCents>0){
							this.minSection.innerHTML=" com pedido m&iacute;nimo de <b>"+com.copacabana.util.moneyFormatter(range.deliveryRange.minimumOrderValueInCents/100.0)+"</b> ";	
						}else{
							this.minSection.innerHTML="";
						}
						console.log("minimumOrderValueInCents",range.deliveryRange.minimumOrderValueInCents);
					}
				}
				if(foundNeigh==false && entireCityEntry!=null){
					this.destNeigh.innerHTML=neighborhood.name;
					this.delCost.innerHTML=com.copacabana.util.moneyFormatter(entireCityEntry.costInCents/100.0);
					if(entireCityEntry.minimumOrderValueInCents && entireCityEntry.minimumOrderValueInCents>0){
						this.minSection.innerHTML=" com pedido m&iacute;nimo de <b>"+com.copacabana.util.moneyFormatter(entireCityEntry.minimumOrderValueInCents/100.0)+"</b> ";	
					}else{
						this.minSection.innerHTML="";
					}
					foundNeigh=true;
					
				}
				
				if(foundNeigh==false){
					dojo.style(this.entireCity,"display","none");
					dojo.style(this.neighSelected,"display","none");					
					dojo.style(this.neighNotSelected,"display","block");
				}
				
			}else{
				console.log("não entrega!!");
			}
			var store=new dojo.data.ItemFileReadStore({
				data:{
					'identifier':'id',
					'label':'name',
					'items':storeData
				}
			});
			this.delRangeSelection.store=store;
		}

	},
	starttooltips:function(){
		var taxaStr = "<b>Taxa de entrega estimada</b><br>A taxa de entrega pode variar dependendo do valor total do seu pedido.<br>Para trocar o bairro clique no nome do bairro ao lado ou utilize a busca no formulário acima (Onde você está?).";	
		// Add tooltip of his picture
		new dijit.Tooltip({
			connectId: [this.infoSectionDelivery],
			label: taxaStr
		});
		new dijit.Tooltip({
			connectId: [this.infoSectionCity],
			label: taxaStr
		});
		var deliveryTxt = "<b>Sobre prazos de entrega</b><br>"+
		"Pedidos online feitos pelo ComendoBem são geralmente entregues mais rapidamente que pedidos feitos por telefone.<br>Entretanto saiba que " +
		"ele é baseado na melhor estimativa do restaurante. Se o dia é agitado no estabelecimento, como dias chuvosos ou feriados, é comum pedidos exigirem alguns minutos extras (e, claro, é também possível ter o pedido entregue antes).<br />Quando seu pedido é completo o restaurante é imediatamente notificado. " +
		"O momento que o restaurante confirma seu pedido ele fornece estimativas mais precisas que podem ser vistas nos detalhes do pedido. <br>Mas tenha certeza que todo restaurante vai preparar e entregar seu pedido o mais rápido possível";
		new dijit.Tooltip({
			connectId: [this.alertaEntrega],
			label: deliveryTxt
		});
		
	
	}
});

}
