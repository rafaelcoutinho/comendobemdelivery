dojo.provide("com.copacabana.order.ChangeDeliveryAddressWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.DialogUnderlay");
dojo.require("dijit.Dialog");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("com.copacabana.order.ChangeCreateAddressWidget");
dojo.require("dijit.form.CheckBox");

// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
dojo.require("dojo.cookie");

dojo.requireLocalization("com.copacabana.order", "ChangeDeliveryAddressWidgetStrings");

dojo.declare("com.copacabana.order.ChangeDeliveryAddressWidget", 
		[ dijit._Widget, dijit._Templated ], {
	i18nStrings : null,
	templatePath : dojo.moduleUrl("com.copacabana.order",	"templates/ChangeDeliveryAddressWidget.html"),
	constructor : function(data) {
		dojo.mixin(this,data);
		this.clientId = data.clientId;
		this.restId = data.restId;
		this.clientAddress=data.clientAddress;		
		this.selectedAddress=data.selectedAddress;
		this.isDeliverable=false;
		console.log("is",this.deliveryRange)
		console.log("is",data)
		this.id="deliveryManager";		
	},
	destroyRecursive : function() {		
		dojo.forEach(this.getDescendants(), function(widget) {			
			widget.destroyRecursive();
		});
	},
	clientAddress:null,
	selectedAddress:null,
	restId : null,
	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings= dojo.i18n.getLocalization("com.copacabana.order", "ChangeDeliveryAddressWidgetStrings");
		console.log("if restaddress is null it will get loaded",this.restaurantAddress);
		if(this.restaurantAddress==null){			
			this.loadRestAddress();
		}
		
	},
	deliveryRange:null,
	isDeliverable:false,
	loadDeliveryRange:function(data) {
		
		var entity = dojo.fromJson(data);
		
		this.deliveryRange=entity;		
		console.log("selected",this.selectedAddress);
		this.checkIfAddressInRange(this.selectedAddress);
		
		
		this.updateAddressPanel(this.selectedAddress,this.clientAddress);
		
	},
	
	loadRestAddress:function (){
		console.log('Loading restaurant Address');
		if(this.restaurantAddress==null){
    	var xhrArgs = {				
				url : "/loadAddress.do?id="+this.restaurantAddressKey,
				handleAs : "json",
				load:dojo.hitch(this,this.setRestaurantAddress),
				error : function(error) {
					console.warn("cannot list restaurnt addresses",error);
				}
			};
			var deferred = dojo.xhrPost(xhrArgs);
		}
    },
    setRestaurantAddress:function(address){
    	console.log('restAdd',address);
    	this.restaurantAddress=address;
    },
	updateAddressPanel:function(selectedAddress,clientAddress){
		
		var panel = dojo.query(".endereco", this.domNode)[0];
		panel.innerHTML="";
		com.copacabana.util.cleanNode(panel);		
		
		var errorPanel = dojo.query(".enderecoError", this.domNode)[0];
		com.copacabana.util.cleanNode(errorPanel);	
		if(selectedAddress==null && clientAddress==null){
			errorPanel.appendChild(document.createElement("br"));
			var bold = document.createElement("b");
			dojo.style(bold,'color','red');
			bold.innerHTML=this.i18nStrings.noAddressSelected;
			errorPanel.appendChild(bold);dojo.style(panel, "textDecoration" ,"line-through" );			
			dijit.showTooltip(this.i18nStrings.createAddress, dojo.byId('changeaddressbtn'));
			console.log("ASAAAAAA2")
			return;
		}else{
			console.log("ASAAAAAA3")
			dijit.hideTooltip(dojo.byId('changeaddressbtn'));	
		}
		
		var address=clientAddress;
		if(address==null){
			address=selectedAddress;
		}
		var formatedAddress=address.street+", "+address.number+".";
		if(address.additionalInfo && address.additionalInfo!=""){
			formatedAddress+=" "+address.additionalInfo+".";		
		}
		if(address.phone && address.phone!=""){
			formatedAddress+="Tel:"+address.phone;
		}else{
			
		}
		if(this.isDeliverable==false){
			dojo.create('br',null,errorPanel);
			dojo.create('b',{style:{color:'red'},innerHTML:this.i18nStrings.notInDeliveryRange},errorPanel);
			
			dojo.style(panel, "textDecoration" ,"line-through" );
			dijit.showTooltip(this.i18nStrings.mustSelectAnotherAddress, dojo.byId('changeaddressbtn'));
		}else{
			errorPanel.innerHTML="";
			dojo.style(panel, "textDecoration" ,"none" );
		}
		if(selectedAddress.isRetrieveAtRestaurant==true){
			var labelPlace = dojo.byId('deliveryLabel');
			dojo.empty(labelPlace);
			dojo.create('span',{style:{color:'black'},innerHTML:this.i18nStrings.deliveryLabelToRetrieve},labelPlace);
			
			
		}else{		
			var labelPlace = dojo.byId('deliveryLabel');
			dojo.empty(labelPlace);
			dojo.create('span',{style:{color:'black'},innerHTML:this.i18nStrings.deliveryLabel},labelPlace);
			
		}
		panel.appendChild(document.createTextNode(formatedAddress));
		
				
	},
	onlyForRetrieval:false,
	startup : function() {
		try {
			
			dojo.parser.parse(this.domNode);
			
			dojo.subscribe("onChangeAddressRequest",dojo.hitch(this,this.onChangeAddressRequest));
			dojo.subscribe("onAddressSelected",dojo.hitch(this,this.onAddressSelected));
			dojo.subscribe("onRetrieveInRestaurant",dojo.hitch(this,this.onRetrieveInRestaurant));
			if(this.onlyForRetrieval==true){
				this.onRetrieveInRestaurant([]);				
			} else {
				this.isDeliverable = false;
				
				
				
				if (this.selectedAddress == undefined
						|| this.selectedAddress == null) {
					this.selectedAddress = this.clientAddress;
					if (this.selectedAddress == null
							|| this.selectedAddress == '') {
						try {
							this.selectedAddress = dojo
							.fromJson(dojo
									.cookie("lastDeliveryAddress"));

						} catch (e) {
							console
							.warn(
									'failed to load address cookie;',
									e);
						}
					}
				}
				if(this.deliveryRange==null){
				var url = "/listDeliveryRangeForRestaurant.do?key="	+ this.restId;
				var xhrArgs = {
						url : url,
						handleAs : "text",
						load : dojo.hitch(this, this.loadDeliveryRange),
						error : function(error) {
								console
								.error("Failed to load delivery Range ",error);
							}
				};
				var deferred = dojo.xhrPost(xhrArgs);
				}
			}
			
		} catch (e) {
			console.error("Error to load delivery Range ",error);
		}
	},
	changeAddressWidget:null,
	dialog:null,
	onChangeAddressRequest:function(data){		
		this.changeAddressWidget= new com.copacabana.order.ChangeCreateAddressWidget({clientId:this.clientId,currAddress:this.selectedAddress});
		this.changeAddressWidget.startup();
		var options ={
			closable:true,
			title : this.i18nStrings.changeDeliveryAddress,
			style : 'border:1px solid black;',
			content:this.changeAddressWidget.domNode
		}
		
		this.dialog = new dijit.Dialog(options);		
		dojo.style(this.dialog.containerNode, 'zIndex', '99'); 

		this.dialog.show();
	},
	renderAddresses:function(response,dialog){
		// Limpa o Dialog
		dialog.containerNode.innerHTML = '';		
		dojo.forEach(response.items, function(endereco) {
			if (endereco.id != enderecoEntrega.id) {
				dojo.place("endereco1",	dialog.containerNode);
			}
		});
	},
	checkIfAddressInRange:function(){
		try{
			this.isDeliverable=false;
			if(this.selectedAddress==null){
				this.isDeliverable=false;
				return;
			}
			//this is extremely ugly
			var sN =this.selectedAddress.neighborhood.id;
			if(!sN){
				sN=this.selectedAddress.neighborhood;
			}
			console.log("Selected city",this.selectedAddress.neighborhood.city)
			for ( var i = 0; i < this.deliveryRange.length; i++) {	
				if(this.deliveryRange[i].neighborhood){
					var n = this.deliveryRange[i].neighborhood.id;

					if(!n){
						n=this.deliveryRange[i].neighborhood;
					}
					if(n==sN){
						this.updateDeliverableInfo(this.deliveryRange[i].deliveryRange);
						break;
					}else{
						this.isDeliverable=false;
					}			
				}
			}
			// entire city logic
			if(this.isDeliverable===false){
				for ( var i = 0; i < this.deliveryRange.length; i++) {
					if(this.deliveryRange[i].neighborhood==null){
						console.log(this.deliveryRange[i].city.id);
						console.log("selectedAddress",this.selectedAddress);
						console.log("selectedAddress.neighborhood",this.selectedAddress.neighborhood);
						console.log("deliveryRange[i].city",this.deliveryRange[i].city)
						if(this.selectedAddress.neighborhood.city.id==this.deliveryRange[i].city.id){
							this.updateDeliverableInfo(this.deliveryRange[i].deliveryRange);
							break;
						}						
					}
				}
			}
		}catch(e){
			this.isDeliverable=false;
			console.error("Não foi possivel determinar endereço de entrega!");
			console.error(e.message);
			
		}
		try{
			if(this.isDeliverable==false){
				this.registerOutOfRange();
			}
		}catch(e){
			
		}
	},
	registerOutOfRange:function(){
		try{
			var nId="";
			if(this.selectedAddress && this.selectedAddress.neighborhood){
				if(this.selectedAddress.neighborhood.id){
					nId="nid="+this.selectedAddress.neighborhood.id;
				}else{
					nId="nid="+this.selectedAddress.neighborhood;
				}
			}
				
			console.log("selectedAddress",this.selectedAddress.neighborhood);
			console.log("order",order);			
			
			var xhrParams = {
					error :function(error){},					
					load : function(data){},
					preventCache:true,
					failOk:true,
					url : '/notInRange.jsp?restid='+order.restaurant+"&"+nId
			};
			dojo.xhrGet(xhrParams);	
		}catch(e){
			
		}
	},
	onAddressSelected:function(data){
		this.selectedAddress=data;
		this.selectedAddress.isRetrieveAtRestaurant=false;
		this.checkIfAddressInRange(data);
		this.updateAddressPanel(data);		
		try{
			this.dialog.hide();
			this.dialog.destroyRecursive(false);
		}catch(e){
			console.log('dialog',e);	
		}
		this.changeAddressWidget.destroyRecursive();

	},
	onRetrieveInRestaurant:function(data){
		this.isDeliverable=true;
		this.selectedAddress=this.restaurantAddress;
		this.selectedAddress.isRetrieveAtRestaurant=true;
		this.customDeliveryCostFct(this.selectedAddress,true);
		dojo.publish("onDeliveryCostChange",[0,0]);
		dojo.publish("onDeliveryMinimumCostChange",[0,0]);
		
		dojo.cookie("lastDeliveryAddress", '', {
            expires: 100
        });
		
		this.updateAddressPanel(this.selectedAddress);
		if(this.changeAddressWidget){
			try{
			this.changeAddressWidget.destroyRecursive();
			}catch (e) {

			}
		}
		
	},
	customDeliveryCostFct:function(deliveryInfo,takeaway){
		
	},
	updateDeliverableInfo:function(deliveryRange){

		this.isDeliverable=true;
		this.customDeliveryCostFct(deliveryRange);
		var selectedDelRange = deliveryRange;
		if (selectedDelRange.cost) {
			dojo.publish("onDeliveryCostChange",[selectedDelRange.cost,selectedDelRange.costInCents]);
		}
		if (selectedDelRange.minimumOrderValue) {
			dojo.publish("onDeliveryMinimumCostChange",[selectedDelRange.minimumOrderValue,selectedDelRange.minimumOrderValueInCents]);
		}

		dojo.cookie("lastDeliveryAddress", dojo.toJson(this.selectedAddress), {
			expires: 30
		});



	}

});
