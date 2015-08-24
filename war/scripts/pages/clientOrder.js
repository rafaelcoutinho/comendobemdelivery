dojo.require("dijit.form.ValidationTextBox");
dojo.require("dojox.validate.regexp");
dojo.require("dojo.parser");
dojo.require("com.copacabana.order.ChangeDeliveryAddressWidget");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.order.OrderManagerWidget");
dojo.require("com.copacabana.order.OrderEntryWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.util");

var publishAddressChangeRequest = function() {
	dijit.hideTooltip(dojo.byId('totalWrapper'));
	dojo.publish("onChangeAddressRequest");
}
var fillOrderWidget = function(restaurantAddress,onlyForRetrieval) {

	var restView = new com.copacabana.order.OrderManagerWidget(order);
	restView.onlyForRetrieval=onlyForRetrieval;
	restView.setDeliveryAddress();
	restView.setCustomer(loggedUser.entity);
	restView.payPalDataController=payPalData;
	if(clientCpf && clientCpf!=null && clientCpf!=''){
		restView.setClientCPF(clientCpf);
	}
	restView.startup();
	dojo.byId("pedidoSection").appendChild(restView.domNode);
	console.log(dojo.toJson(order.restaurant));
	
	if(onlyForRetrieval==true){
		var deliveryRange = new com.copacabana.order.ChangeDeliveryAddressWidget(
				{
					clientId : loggedUser.entity.id,
					restId : order.restaurant,
					selectedAddress : order.address,
					clientAddress : order.address,
					onlyForRetrieval:true,
					restaurantAddress : restaurantAddress
				});
		deliveryRange.startup();
		dojo.byId("deliveryAddress").appendChild(deliveryRange.domNode);
		retrieveInRestaurant();
	} else {

		var deliveryRange = new com.copacabana.order.ChangeDeliveryAddressWidget(
				{
					clientId : loggedUser.entity.id,
					restId : order.restaurant,
					selectedAddress : order.address,
					clientAddress : order.address,
					onlyForRetrieval:false,
					restaurantAddress : restaurantAddress
				});
		deliveryRange.startup();
		dojo.byId("deliveryAddress").appendChild(deliveryRange.domNode);
	}

}
var fillUserData = function() {
	dojo.byId("nome").innerHTML = loggedClient.name;
}
var retrieveInRestaurant = function() {
	dijit.hideTooltip(dojo.byId('totalWrapper'));
	dojo.publish("onRetrieveInRestaurant",[restaurantAddress]); 
}