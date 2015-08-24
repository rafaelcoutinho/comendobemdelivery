dojo.require("dijit.form.ValidationTextBox");
dojo.require("dojox.validate.regexp");
dojo.require("dojo.parser");

dojo.require("dojox.form.PasswordValidator");
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
	console.log("gotNewNeighborhood");
	if (items[0]) {
		console.log(items[0]);

		if (dijit.byId("neighSelection").store.getValue(items[0], "city") != dijit
				.byId("citySelection").attr("value")) {
			dijit.byId("citySelection").attr(
					"value",
					dijit.byId("neighSelection").store.getValue(items[0],
							"city"));
		}
	}
	cityhandler = dojo.connect(dijit.byId("citySelection"), "onChange",
			onCityUpdate);
}

var cityhandler;
var fetchFailed = function(error, request) {
	console.log("fetchFailed", error);
}
function updateCity(id) {
	console.log(dijit.byId("neighSelection").attr("value") + " or " + id);
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
var firstTime = 0;
var onCityUpdate = function() {
	if (firstTime === 0) {
		firstTime = 1;
		return;
	}
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
	com.copacabana.util.hideLoading();
}

dojo.addOnLoad(function() {
	try{
		com.copacabana.util.showLoading();
		loadNeighborhood();	
		loadCities();	
		prepareForm();	
	}catch (e) {
		console.log(e);
	}
});

var submitForm = function(event) {
	if (!com.copacabana.util.checkValidFormAdv(".required")) {
		return;
	} else {
		if (event) {
			// Stop the submit event since we want to control form submission.
			event.preventDefault();
			event.stopPropagation();
		}
		com.copacabana.util.showLoading();
		// The parameters to pass to xhrPost, the form, how to handle it, and
		// the callbacks.
		// Note that there isn't a url passed. xhrPost will extract the url to
		// call from the form's
		// 'action' attribute. You could also leave off the action attribute and
		// set the url of the xhrPost object
		// either should work.
		var xhrArgs = {
			form : dijit.byId("restform").domNode,
			handleAs : "text",
			load : function(data) {
				console.log(data);
				var entity = dojo.fromJson(data);
				
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg("Dados salvos.");
			},
			error : function(error) {
				// We'll 404 in the demo, but that's okay. We don't have a
				// 'postIt' service on the
			// docs server.
			//dojo.byId("response").innerHTML = "failed to post data." + error;
				com.copacabana.util.hideLoading();
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Erro ao salvar dados: " + error.message);
		}
		}
		// Call the asynchronous xhrPost
		console.log(" Form being sent...");
		var deferred = dojo.xhrPost(xhrArgs);
	}

}

function prepareForm() {
	var button = dijit.byId("submitButton");

	dojo.connect(button, "onClick", submitForm);
	console.log("ID " + id);
	if (id) {		
		loadFormEntiy("/getRestaurant.do?id=" + id, "restform");
	}
}

function loadFormEntiy(url, content, formId) {

	var xhrArgs = {
		url : url,
		content : content,
		handleAs : "text",
		load : function(data) {
			var entity = dojo.fromJson(data);
			
			//updateCity(entity.address.neighborhood.k);
			try {
				var addressId = entity.address;
				//clear address
				//entity.address={};
				
				
				loadAddress(addressId,entity);
			} catch (e) {
				console.error(e);
			}

		},
		error : function(error) {
			console.error("failed to get data.",error);
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
}



function loadAddress(id,entity){
	var url="/loadAddress.do?id=" + id;	
	var xhrArgs = {
			url : url,			
			handleAs : "text",
			load : function(data) {
				var entity2 = dojo.fromJson(data);
				dijit.byId("neighSelection").attr('value',entity2.neighborhood.id);
				
				updateCity(entity2.neighborhood.id);
				console.log("e1",entity);
				entity.address=entity2;
				entity.restaurant=entity;
				console.log(entity2);
				dijit.byId("restform").attr('value', entity);
				
				
//				var formE ={
//						addresss:entity
//				}
//				dijit.byId("restform").attr('value', formE);
			},
			error : function(error) {
				console.error("failed to get data.",error);
			}
		}
		var deferred = dojo.xhrPost(xhrArgs);
	
	
}

