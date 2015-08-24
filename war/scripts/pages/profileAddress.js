dojo.require("dijit.form.ValidationTextBox");
dojo.require("dojox.validate.regexp");
dojo.require("dojo.parser");
dojo.require("com.copacabana.AddressPaneWidget");
dojo.require("com.copacabana.order.UserViewOrderWidget");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dojox.form.PasswordValidator");
dojo.require("com.copacabana.RestaurantWheelWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.AddressPaneWidget");
dojo.addOnLoad(function() {
	allNeighborsStore = new dojo.data.ItemFileReadStore( {
		url : "/listNeighborsItemFileReadStore.do"
	});
	cityStore = new dojo.data.ItemFileReadStore( {
		url : "/listCitiesItemFileReadStore.do"
	});
	var xhrArgs = {
			url : "/listClientAddresses.do?id=" + loggedUser.entity.id,
			handleAs : "json",
			load : renderAddresses,
			error : function(error) {
				console.error('Error listing client addresses',error);
			}
		};
		var deferred = dojo.xhrPost(xhrArgs);
});

var renderAddresses = function(response) {
	console.log(response);
	// TODO maybe changing the json that comes from server would be better

	var nodeAddresses = dojo.byId("enderecos");
	if(response.length==0){
		dojo.byId("semEnderecos").innerHTML="Nenhum endere&ccedil;o cadastrado.";
	}
	for ( var i = 0; i < response.length; i++) {
		var address = new com.copacabana.AddressPaneWidget(response[i],loggedUser.entity.id);

		address.allNeighbors = allNeighborsStore;
		address.allCitiesStore = cityStore;
		address.startup();
		nodeAddresses.appendChild(address.domNode);
	}

}
var allNeighborsStore;
var cityStore;
var createNewAddress = function() {
	var nodeAddresses = dojo.byId("enderecos");
	var newAddress = {
		street : "",
		number : "",
		phone : "",
		neighborhood : {
			k : "",
			city : {
				id : ""					
			}
		},
		zipCode : "",
		additionalInfo : ""
	};
	var address = new com.copacabana.AddressPaneWidget(newAddress,loggedUser.entity.id);
	address.allNeighbors = allNeighborsStore;
	address.allCitiesStore = cityStore;
	address.startup();
	nodeAddresses.insertBefore(address.domNode, nodeAddresses.firstChild);
	dojo.byId("semEnderecos").innerHTML="";
	return false;

}
