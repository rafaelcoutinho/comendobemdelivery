dojo.require("dojox.form.PasswordValidator");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.MessageWidget");

function loadNeighborhood() {
	var stateStore = new dojo.data.ItemFileReadStore( {
		url : "/listNeighborsItemFileReadStore.do"
	});
	dijit.byId("neighSelection").store = stateStore;

}
var clearOldCList = function(size, request) {
	console.log("clearOldCList");

}
var gotNewNeighborhood = function(items, request) {
	if (items[0]) {
		console.log(items[0]);
		if (dijit.byId("neighSelection").store.getValue(items[0], "city") != dijit
				.byId("citySelection").attr("value")) {
			dijit.byId("citySelection").attr(
					"value",
					dijit.byId("neighSelection").store.getValue(items[0],
							"city"));
		}
		if (!dijit.byId("address.zipCode").attr("value")
				|| dijit.byId("address.zipCode").attr("value") == "") {
			!dijit.byId("address.zipCode").attr(
					"value",
					dijit.byId("neighSelection").store
							.getValue(items[0], "zip"))
		}
	}
}

var cityhandler;
var fetchFailed = function(error, request) {
	console.log("fetchFailed", error);
}
function updateCity(id) {
	var a = dijit.byId("neighSelection").store.fetch( {
		query : {
			id : id
		},
		onBegin : clearOldCList,
		onComplete : gotNewNeighborhood,
		onError : fetchFailed,
		queryOptions : {
			deep : true
		}
	});
}

var onCityUpdate = function() {

	try {
		var stateStore = new dojo.data.ItemFileReadStore( {
			url : "/listNeighborsByCity.do?key="
					+ dijit.byId("citySelection").attr("value")
		});
		dijit.byId("neighSelection").reset();
		dijit.byId("neighSelection").store = stateStore;
	} catch (e) {
		console.error(e);
	}
}
function loadCities() {
	var stateStore = new dojo.data.ItemFileReadStore( {
		url : "/listCitiesItemFileReadStore.do"
	});
	dijit.byId("citySelection").store = stateStore;

}

dojo.addOnLoad(function() {
	// loadNeighborhood();
		//loadCities();
		//cityhandler = dojo.connect(dijit.byId("citySelection"), "onChange",
			//	onCityUpdate);
		// = dojo.connect(dijit.byId("neighSelection"), "onChange",
		// onNeigUpdate);
		//identifyCity();

	});
var onNeigUpdate = function() {
	var a = dijit.byId("neighSelection").store.fetch( {
		query : {
			id : id
		},
		onBegin : clearOldCList,
		onComplete : gotNewNeighborhood,
		onError : fetchFailed,
		queryOptions : {
			deep : true
		}
	});
}
var identifyCity = function() {
	if (userCity && userCity != "") {
		dijit.byId("citySelection").attr("value", userCity);
	}
}
var registeringPage = true;
var userCity = "${sessionScope.identifiedCity}";

var submitForm = function(event) {
	if (!com.copacabana.util.checkValidForm('.required')) {
		return;
	} else {
		if (event) {
			// Stop the submit event since we want to control form
			// submission.
			event.preventDefault();
			event.stopPropagation();
		}
		com.copacabana.util.showLoading();
		var xhrArgs = {
			form : dojo.byId("dadosUsuario"),
			handleAs : "text",
			load : function(data) {
				console.log(data);
				var entity = dojo.fromJson(data);
				var userLogin = dijit.byId("login");
				
				dijit.byNode(dojo.query(".password", userLogin.domNode)[0]).attr('value',dojo.byId('pwdVal').value);
				dijit.byNode(dojo.query(".username", userLogin.domNode)[0]).attr('value',dojo.byId('user.login').value);
				
				userLogin.executeLogin();
				com.copacabana.util.hideLoading();
				
			},
			error : function(error) {
				try {
					com.copacabana.util.hideLoading();
					var errorjson = dojo.fromJson(error.responseText);
					var msg = new com.copacabana.MessageWidget();
					if (errorjson.errorCode == "USERALREADYEXISTS") {
						msg.showMsg("Usu&aacute;rio '" + errorjson.errorMsg
								+ "' j&aacute; existe.");
						
					} else {
						msg.showMsg("Erro: " + errorjson.errorCode + "='"
								+ errorjson.errorMsg + "'");
					}
				} catch (e) {
					var msg = new com.copacabana.MessageWidget();
					msg.showMsg("Erro ao salvar dados: " + error.responseText);
				}
				com.copacabana.util.hideLoading();
			}
		}
		// Call the asynchronous xhrPost

		var deferred = dojo.xhrPost(xhrArgs);
	}
}
