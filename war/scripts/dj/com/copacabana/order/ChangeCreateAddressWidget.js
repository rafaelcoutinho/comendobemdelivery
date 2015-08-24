/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.order.ChangeCreateAddressWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.order.ChangeCreateAddressWidget"] = true;
dojo.provide("com.copacabana.order.ChangeCreateAddressWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.ComboBox");
dojo.require("com.copacabana.lbs.FindUserLocation");
// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.order", "ChangeCreateAddressWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.order.ChangeCreateAddressWidget", 
		[ dijit._Widget, dijit._Templated ], {
	i18nStrings : null,
	templateString:"<div style=\"margin: 5px;\">\r\n<form action=\"/addAddressToUser.do\" method=\"post\"\r\n\tdojoType=\"dijit.form.Form\" class=\"updateUserForm\">\t\r\n</form>\r\n<div class=\"eraseTables\">\r\n<div class=\"fundoCinza\">\r\n<h2>Selecione um de seus endere&ccedil;os</h2>\r\n</div>\r\n<table>\r\n\t<tr>\r\n\t\t<td><select dojoType=\"dijit.form.FilteringSelect\"\r\n\t\t\tclass=\"existingSelection\" autoComplete=\"true\"\r\n\t\t\tinvalidMessage=\"Endereco inv&aacute;lido\" selectOnClick=\"true\" \t></select></td>\r\n\t\t<td>\r\n\t\t<div><img src=\"/resources/img/btOk.png\" alt=\"salvar\"\r\n\t\t\tdojoAttachEvent=\"onclick:selectAddress\" /></div>\r\n\t\t</td>\r\n\t</tr>\r\n</table>\r\n<br/>\r\n\r\n<div class=\"fundoCinza\">\r\n<h2>Criar novo Endere&ccedil;o</h2>\r\n</div>\r\n<form action=\"/addAddressToUser.do\" method=\"post\"\r\n\tdojoType=\"dijit.form.Form\" class=\"newAddressForm\">\r\n\r\n<input type=\"hidden\" name=\"address.id\" class=\"addressId\" dojoType=\"dijit.form.TextBox\"/>\r\n<table>\r\n\t<tr>\r\n\t\t<td><label for=\"street\">Endere&ccedil;o:<img alt=\"Sua localiza��o atual\" src=\"/resources/img/locPin.png\" class=\"autoLocImg\" style=\"display: none\"></label></td>\r\n\t\t<td><input dojoType=\"dijit.form.ValidationTextBox\" type=\"text\" required=\"true\" trim=\"true\" properCase=\"true\"\r\n\t\t\tname=\"address.street\" class=\"addressStreet\" width=\"260\" class=\"required\" /></td>\r\n\t\t<td><span class=\"required\">*</span></td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td><label for=\"number\">N&uacute;mero:</label></td>\r\n\t\t<td><input dojoType=\"dijit.form.ValidationTextBox\" type=\"text\" required=\"true\" trim=\"true\"\r\n\t\t\tname=\"address.number\" width=\"70\" class=\"required\" /></td>\r\n\t\t<td width=\"5\"><span class=\"required\">*</span></td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td><label for=\"additionalInfo\">Complemento:</label></td>\r\n\t\t<td><input dojoType=\"dijit.form.ValidationTextBox\" type=\"text\" required=\"false\" trim=\"true\"\r\n\t\t\tname=\"address.additionalInfo\" width=\"70\"  width=\"80\" /></td>\r\n\t\t<td></td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td><label for=\"number\">Telefone:</label></td>\r\n\t\t<td><input dojoType=\"dijit.form.ValidationTextBox\" type=\"text\" required=\"true\" trim=\"true\" regExpGen=\"com.copacabana.util.phoneFormat\" invalidMessage=\"Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN\"\r\n\t\t\tname=\"address.phone\" width=\"70\" class=\"required\" /></td>\r\n\t\t<td width=\"5\"><span class=\"required\">*</span></td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td><label for=\"city\">Cidade:</label></td>\r\n\t\t<td><select dojoType=\"dijit.form.FilteringSelect\" selectOnClick=\"true\"\r\n\t\t\t autoComplete=\"true\"  class=\"citySelection\" dojoAttachPoint=\"citySelection\"\r\n\t\t\tinvalidMessage=\"Cidade inv&aacute;lida\"></select></td>\r\n\t\t<td></td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td><label for=\"neighborhood\">Bairro:</label></td>\r\n\t\t<td><select dojoType=\"dijit.form.FilteringSelect\"\r\n\t\t\tname=\"address.neighborhood\" autoComplete=\"false\" dojoAttachPoint=\"neighbor\" selectOnClick=\"true\" class=\"neighSelection required\" required=\"true\" \r\n\t\t\tinvalidMessage=\"Bairro inv&aacute;lido\"></select></td>\r\n\t\t<td><span class=\"required\">*</span></td>\r\n\t</tr>\t\r\n\t<tr>\r\n\t\t<td></td>\r\n\t\t<td></td>\r\n\t\t<td>\r\n\t\t<div><img src=\"/resources/img/btOk.png\" alt=\"salvar\"\r\n\t\t\tdojoAttachEvent=\"onclick:createAddress\" /></div>\r\n\t\t</td>\r\n\t</tr>\r\n</table>\r\n</form>\r\n\r\n</div>\r\n</div>\r\n",
	constructor : function(data) {
		this.clientId=data.clientId;
		console.log(data.currAddress);
		this.currAddress=data.currAddress;
	},
	currAddress:null,
	destroyRecursive : function() {
		console.log("destroying!");
		//dijit.byNode(dojo.byId("updateUserForm")).destroy(false);
		//this.domNode.removeChild(dojo.byId("updateUserForm"));
		dojo.forEach(this.getDescendants(), function(widget) {
			widget.destroyRecursive(false);
		});
	},
	
	
	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order", "ChangeCreateAddressWidgetStrings");
		dojo.subscribe("onUserLocation",dojo.hitch(this,this.updateDefaultComboValues));
		
	},
	
	geoLocator:null,
	geolocateUserLocation:function(){
		if(this.geoLocator==null){
			this.geoLocator = new com.copacabana.lbs.FindUserLocation();
			this.geoLocator.startup();
		}
		this.geoLocator.findLocation();
	},
	clearOldCList:function(){
		
	},
	
	hideToolTip:function(){
    	dijit.hideTooltip(dojo.query('.autoLocImg',this.domNode)[0]);
    },
	 gotCity:function(items, request){        	
    	//dojo.style(dojo.byId('autoLocImg'),'display','inline');
    	
    	if(items.length==0){
    		return;
    	}
    	this.autolocated=true;

    	var i;
    	for (i = 0; i < items.length; i++) {
    		var item = items[i];
    		this.getCitySelection().attr('value',item.id);                    
    	}
    	console.log('gotCity');
    	//this.onCityUpdate();

    	
    },
	fetchFailed:function(){
		
	},
	getCitySelection:function(){
		return dijit.byNode(dojo.query(".citySelection",this.domNode)[0]);
	},
	updateDefaultComboValues:function(data){
    	try{
    		this.autolocationData=data;
    		if(data.street){
    			var iconLoc = dojo.query('.autoLocImg',this.domNode)[0];
    			dojo.style(iconLoc,'display','inline');
    	    	dijit.showTooltip("Localiza&ccedil;&atilde;o autom&aacute;tica", iconLoc,['before','above']);
    	    	setTimeout(dojo.hitch(this, this.hideToolTip), 2000);
    			
    			dijit.byNode(dojo.query(".addressStreet",this.domNode)[0]).attr('value',data.street.long_name);
    		}
    		var citySelection = this.getCitySelection();
    		
    		citySelection.store.fetch({
    			query: {
    			name: data.city
    		},
    		onBegin: dojo.hitch(this,this.clearOldCList),
    		onComplete: dojo.hitch(this,this.gotCity),
    		onError: dojo.hitch(this,this.fetchFailed), 
    		queryOptions: {
    			deep: true
    		}
    		});
    	}catch(e){
    		console.error("update?",e);
    	}

    },

	startup:function(){
		try{
		dojo.parser.parse(this.domNode);
		//this.loadNeighborhood();
		this.loadCities();
		this.loadAddresses();
		this.geolocateUserLocation();
		console.log(dojo.byId('changeaddressbtn'));
			if(dojo.byId('changeaddressbtn')){
				dijit.hideTooltip(dojo.byId('changeaddressbtn'));
			}
		}catch(e){
			console.error("failed to start changecreateaddress",e);
		}
	},
	clientId:null,
	loadAddresses:function (){
		console.log("loadingC address ", "/listClientAddresses.do?id="+this.clientId)
		var xhrArgs = {
				url : "/listClientAddresses.do?id="+this.clientId,
				handleAs : "json",
				load :dojo.hitch(this,this.renderAddresses),
				error : function(error) {
					console.error("cannot list client addresses",error);
				}
			};
			var deferred = dojo.xhrPost(xhrArgs);	
    },
   
    
    addressesList:[],
    renderAddresses:function(response){
    	console.log("renderAddresses",response);
    	this.addressesList=[];
    	//TODO maybe changing the json that comes from server would be better
    	var arrayItemStore ={'identifier':"id",'label':"street",'items':[]};
    	for ( var i = 0; i < response.length; i++) {
    		arrayItemStore.items.push(
    				{
    					id:response[i].id,
    					street:response[i].street,
    					number:response[i].number,
    					name:response[i].street
    					
    		});    		
    		this.addressesList[response[i].id]=response[i];			
		}
    	var args={data:arrayItemStore};
    	var stateStore = new dojo.data.ItemFileReadStore(args);
    	var existingFilterSelection = dijit.byNode(dojo.query(".existingSelection",this.domNode)[0]);
    	
    	existingFilterSelection.store = stateStore;    	
    	existingFilterSelection.store.fetch({onComplete: dojo.hitch(this,this.completeFecth), onError: dojo.hitch(this,this.completeFecth)});
    },
    completeFecth:function(items, findResult){
    	if(this.currAddress){
    		dijit.byNode(dojo.query(".existingSelection",this.domNode)[0]).attr("value",this.currAddress.id);
    	}
    	

    },
	loadNeighborhood:function (){
    	var stateStore = new dojo.data.ItemFileReadStore({
            url: "/listNeighborsItemFileReadStore.do"
        });
    	var nSelection = dijit.byNode(dojo.query(".neighSelection",this.domNode)[0]);
    	nSelection.store.reset();
    	nSelection.store.queryExpr="*${0}*";    	
    	nSelection.store = stateStore;
    	
    	
        
    },
    loadCities:function(){
    	var stateStore = new dojo.data.ItemFileReadStore({
            url: "/listCitiesItemFileReadStore.do"
        });
        
        dijit.byNode(dojo.query(".citySelection",this.domNode)[0]).store = stateStore;
        dojo.connect(dijit.byNode(dojo.query(".citySelection",this.domNode)[0]), "onChange", dojo.hitch(this,this.onCityUpdate));
    },
    autolocated:false,
    onCityUpdate:function(){        
        try{   
	    	var stateStore = new dojo.data.ItemFileReadStore({
	            url: "/listNeighborsByCity.do?key="+dijit.byNode(dojo.query(".citySelection",this.domNode)[0]).attr("value")
	        });
	    	
	    	this.getNeighSelection().reset();	    	
	    	this.getNeighSelection().queryExpr="*${0}*";
	    	this.getNeighSelection().store = stateStore;
	    	if(this.autolocated==true){
	    		if(this.autolocationData.neighborhood){
	        		this.changeNeighborhood(this.autolocationData);
	        	}
	    	}
        }catch(e){
			console.error(e);
        }
    },
    changeNeighborhood:function(locationData){
    	this.getNeighSelection().store.fetch({
            query: {
                name: locationData.neighborhood
            },
            onBegin: dojo.hitch(this,this.clearOldCList),
            onComplete: dojo.hitch(this,this.gotAutoNeighbor),
            onError: dojo.hitch(this,this.fetchNeigFailed), 
            queryOptions: {
                deep: true
            }
        });
    },
    fetchNeigFailed:function(error){
    	console.error('failed to set the neighborhood',error);
    },
    gotAutoNeighbor:function(items){
    	    
        var i;
    	if(items.length>0){    		
            for (i = 0; i < items.length; i++) {
                var item = items[i];
                this.getNeighSelection().attr('value',item.id);
                
            }
    	}
    },
    getNeighSelection:function(){
    	return dijit.byNode(dojo.query(".neighSelection",this.domNode)[0]);
    },
    selectAddress:function(evt){
    	console.log("selectAddress:"+dijit.byNode(dojo.query(".existingSelection",this.domNode)[0]).attr("value"));
    	var selectedId=dijit.byNode(dojo.query(".existingSelection",this.domNode)[0]).attr("value");
    	this.selectedAddress=this.addressesList[selectedId];
    	dojo.publish("onAddressSelected",[this.selectedAddress]);    	
    	this.destroyRecursive();
    },
    
    createAddress:function(evt){
    	if (!com.copacabana.util.checkValidForm('.required',this.domNode)) {
    		return;
    	}
    	
    	com.copacabana.util.showLoading();
    	var xhrArgs = {
			form : dojo.query(".newAddressForm",this.domNode)[0],
			handleAs : "json",
			load : dojo.hitch(this,function(data) {
				
				com.copacabana.util.hideLoading();
				var entity = data;
				entity.neighborhood.city={
						id:dijit.byNode(dojo.query(".citySelection",this.domNode)[0]).attr('value')						
				}				
				dojo.publish("onAddressSelected",[data]);
				this.destroyRecursive();
			}),
			error : function(error) {
    			
    			console.log("Form error ", error);
    			com.copacabana.util.hideLoading();
			}
		};
		//Call the asynchronous xhrPost
    	
    	var deferred = dojo.xhrPost(xhrArgs);
    	
    },
    
    addressIdNode:null,
    userNode:null,
    selectedAddress:null,
    
    
    updateUser:function(data){
    	var form=dojo.query(".updateUserForm", this.domNode)[0];//dojo.byId("updateUserForm")
    	if(this.userNode!=null){
    		form.removeChild(this.userNode);     		
    	}
    	if(this.addressIdNode!=null){
    		form.removeChild(this.addressIdNode);     		
    	}
    	
    	this.userNode = document.createElement("input");
    	this.userNode.setAttribute("name","id");
    	this.userNode.setAttribute("value",this.clientId);
    	this.userNode.setAttribute("type","hidden");
    	form.appendChild(this.userNode);
    	 this.addressIdNode = document.createElement("input");
    	 this.addressIdNode.setAttribute("name","addresses[0].k");
    	 this.addressIdNode.setAttribute("value",data.id);
    	 this.addressIdNode.setAttribute("type","hidden");
    	 form.appendChild(this.addressIdNode);
     	this.selectedAddress=data;
     	
    	var xhrArgs = {
    			form : form,
    			handleAs : "json",
    			load : dojo.hitch(this,function(data) {
    				var entity = data;   				    				
    				
    				dojo.publish("onAddressSelected",[this.selectedAddress]);
    				
    				
    			}),
    			error : function(error) {
    				//We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
    			//docs server.
    			console.log("Form error ", error);
    			}
    		};
    		//Call the asynchronous xhrPost
        	console.log("sending");
        	var deferred = dojo.xhrPost(xhrArgs);
    }
    
});

}
