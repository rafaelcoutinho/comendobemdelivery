dojo.provide("com.copacabana.page.AreaEntrega");

com.copacabana.page.AreaEntrega.loadNeighborhood = function() {
	var stateStore = new dojo.data.ItemFileReadStore( {
		url : "/listNeighborsItemFileReadStore.do"
	});
	dijit.byId("neighSelection").store = stateStore;
};
com.copacabana.page.AreaEntrega.delRange = [];
com.copacabana.page.AreaEntrega.loadRestaurantDeliveryRange = function() {
	var url = "/listDeliveryRangeForRestaurant.do?key=" + id;

	var xhrArgs = {
		url : url,
		handleAs : "text",
		load : function(data) {
			var entity = dojo.fromJson(data);
			for ( var i = 0; i < entity.length; i++) {
				var n = entity[i];
				var deliveryId = entity[i].deliveryRange.id;
				com.copacabana.page.AreaEntrega.delRange[deliveryId] = entity[i].deliveryRange;
				dijit.byId("citySelection").attr("value", n.city.id);
				com.copacabana.page.AreaEntrega.loadNeighbor(n.neighborhood,null, deliveryId);
			}
		},
		error : function(error) {
			console.log("failed to list del range data.", error);
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
};

com.copacabana.page.AreaEntrega.loadNeighbor = function(neigh, request,
		deliveryId) {
	var fct = function(city, request2) {
		com.copacabana.page.AreaEntrega.addNewDelRangeLine(city, request2,
				neigh, deliveryId);
	}
	var args = {
		identity : neigh.city.id,
		onItem : fct,
		onError : function(item, request) {
			console.error("failed to load city info.", item);
		}
	}
	dijit.byId("citySelection").store.fetchItemByIdentity(args);

};

com.copacabana.page.AreaEntrega.prefix = 'delRangeItem';
com.copacabana.page.AreaEntrega.counter = 0;

com.copacabana.page.AreaEntrega.addNewDelRangeLine = function(city, request,
		neigh, delId) {
	var index = com.copacabana.page.AreaEntrega.counter++;
	console.log(com.copacabana.page.AreaEntrega.delRange[delId]);

	var delTable = dojo.byId('deliveryRangesTable');
	var line = dojo.create('tr', null, delTable);
	dojo.create('td', {
		style : {
			textAlign : 'center'
		},
		innerHTML : city.name
	}, line);
	dojo.create('td', {
		style : {
			textAlign : 'center'
		},
		innerHTML : neigh.name
	}, line);

	dojo.create('input', {
		type : 'hidden',
		name : com.copacabana.page.AreaEntrega.prefix + '[' + index + '].id',
		value : delId
	}, line);
	dojo.create('input', {
		type : 'hidden',
		name : com.copacabana.page.AreaEntrega.prefix + '[' + index
				+ '].neighborhood',
		value : neigh.id
	}, line);
	var td = dojo.create('td', {
		style : {
			textAlign : 'center'
		}
	}, line);
	var costName = com.copacabana.page.AreaEntrega.prefix + '[' + index
			+ '].cost';

	var costVal = 0;
	if (com.copacabana.page.AreaEntrega.delRange[delId]) {
		costVal = com.copacabana.page.AreaEntrega.delRange[delId].cost;
	}
	console.log(costVal);
	var cost = dojo.create('input', {
		required : "true",
		type : 'text',
		name : costName,
		//id : costName,
		value : costVal
	}, td);
	td = dojo.create('td', {
		style : {
			textAlign : 'center'
		}
	}, line);
	var minCostname = com.copacabana.page.AreaEntrega.prefix + '[' + index
			+ '].minimumOrderValue';

	var minCostVal = 0;
	if (com.copacabana.page.AreaEntrega.delRange[delId]) {
		minCostVal = com.copacabana.page.AreaEntrega.delRange[delId].minimumOrderValue;
	}
	var min = dojo.create('input', {
		type : 'text',
		name : minCostname,
		//id : minCostname,
		value : minCostVal
	}, td);
	var props = {
		fractional : true,
		required : true,
		value : 0.0,
		lang : 'pt-BR',
		currency : "",
		invalidMessage : "Digite o valor com centavos, por exemplo 10,90.",
		style : {
			width : '60px',
			height : '18px'
		}
	};
	
	
	var dijitCost = new dijit.form.CurrencyTextBox(props, cost);
	dijitCost.attr('value', costVal);
	var dijitMin = new dijit.form.CurrencyTextBox(props, min);
	dijitMin.attr('value', minCostVal);
	td = dojo.create('td', {
		style : {
			textAlign : 'center'
		}
	}, line);

	var button = new dijit.form.Button( {
		label : "Apagar",
		baseClass : 'orangeButton',
		onClick : function() {
			com.copacabana.page.AreaEntrega.removeNeighNew(line, delId);
		}
	}, td);
};

com.copacabana.page.AreaEntrega.loadNeighbor = function(neigh, request,
		deliveryId) {
	var fct = function(city, request2) {
		com.copacabana.page.AreaEntrega.addNewDelRangeLine(city, request2,
				neigh, deliveryId);
	}
	var args = {
		identity : neigh.city.id,
		onItem : fct,
		onError : function(item, request) {
			console.error("failed to load city info.", item);
		}
	}
	dijit.byId("citySelection").store.fetchItemByIdentity(args);

};
com.copacabana.page.AreaEntrega.loadCities = function() {
	var stateStore = new dojo.data.ItemFileReadStore( {
		url : "/listCitiesItemFileReadStore.do"
	});
	dijit.byId("citySelection").store = stateStore;
	dojo.connect(dijit.byId("citySelection"), "onChange",
			com.copacabana.page.AreaEntrega.onCityUpdate);
};

com.copacabana.page.AreaEntrega.onCityUpdate = function() {

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

};

com.copacabana.page.AreaEntrega.prepareForm = function() {
	var button = dijit.byId("btAdd");

	dojo.connect(button, "onClick", submitForm);

	console.log("ID " + id);
	if (id) {
		com.copacabana.page.AreaEntrega.loadFormEntiy("/getRestaurant.do?id="
				+ id, "restform");
	}
};

com.copacabana.page.AreaEntrega.toRemove = [];
com.copacabana.page.AreaEntrega.loadFormEntiy = function(url, content, formId) {

	var xhrArgs = {
		url : url,
		content : content,
		handleAs : "text",
		load : function(data) {
			var entity = dojo.fromJson(data);
			if (entity.allowGetInPlace == true) {
				dijit.byId('allowGetInPlace').attr('value', true);
			} else {
				dijit.byId('allowGetInPlace').attr('value', false);
			}

		},
		error : function(error) {
			console.log("failed to get data.", error);
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
};

com.copacabana.page.AreaEntrega.removeNeighNew = function(dom, idDelivery) {
	dojo.empty(dom);
	dojo.destroy(dom);

	if (idDelivery && idDelivery != "") {
		com.copacabana.page.AreaEntrega.toRemove.push(idDelivery);
	}
}

com.copacabana.page.AreaEntrega.save = function() {
	var section = dojo.byId('deliveriesFormSection');
	
	dojo.empty(section);

	if (dijit.byId('allowGetInPlace').attr('value') == 'on') {
		dojo.create("input", {
			type : 'hidden',
			name : "allowGetInPlace",
			value : 'true'
		}, section);
	} else {
		dojo.create("input", {
			type : 'hidden',
			name : "allowGetInPlace",
			value : 'false'
		}, section);
	}

	dojo.create("input", {
		type : 'hidden',
		name : "restaurantId",
		value : loggedRestaurant.id
	}, section);
	var k = 0;
	while (com.copacabana.page.AreaEntrega.toRemove.length > 0) {
		var kdel = toRemove.pop();
		var dnid = dojo.create("input", {
			type : 'hidden',
			name : "toDeleteDeliveries[" + k + "]",
			value : kdel
		}, section);
		k++;
	}

	var normalized = 0;
	for ( var i = 0; i < com.copacabana.page.AreaEntrega.counter; i++) {
		var idDom = com.copacabana.page.AreaEntrega.getDom(i, 'id');
		if (idDom) {
			var id = idDom.value;
			var neigborhood = com.copacabana.page.AreaEntrega.getDom(i, 'neighborhood').value;
			var cost = com.copacabana.page.AreaEntrega.getDijit(i, 'cost');
			var minimumOrderValue = com.copacabana.page.AreaEntrega.getDijit(i, 'minimumOrderValue');

			if (id && id != undefined && id != "undefined") {
				dojo.create('input', {
					type : 'hidden',
					name : 'deliveryRanges[' + normalized + '].id',
					value : id
				}, section);
			}
			dojo.create('input', {
				type : 'hidden',
				name : 'deliveryRanges[' + normalized + '].neighborhood',
				value : neigborhood
			}, section);
			dojo.create('input', {
				type : 'hidden',
				name : 'deliveryRanges[' + normalized + '].cost',
				value : cost
			}, section);
			dojo.create('input', {
				type : 'hidden',
				name : 'deliveryRanges[' + normalized + '].minimumOrderValue',
				value : minimumOrderValue
			}, section);
			normalized++;
		}

	}

	var xhrArgs = {
		form : dojo.byId("createDeliveryNew"),
		handleAs : "json",
		load : function(data) {
			console.log(data);
			com.copacabana.util.cleanNode(document
					.getElementById("deliveryRangesTable"));

			com.copacabana.page.AreaEntrega.loadRestaurantDeliveryRange();
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Dados salvos.");
		},
		error : function(error) {
			// We'll 404 in the demo, but that's okay. We don't have a 'postIt'
		// service on the
		// docs server.
		console.error(error);
		var msg = new com.copacabana.MessageWidget();
		msg.showMsg("Erro ao salvar dados: " + error.message);
	}
	}
	// Call the asynchronous xhrPost
	var deferred = dojo.xhrPost(xhrArgs);

};
com.copacabana.page.AreaEntrega.getDijit=function(index,attr){
	//return dijit.byId('delRangeItem['+index+'].'+attr).attr('value');
//	console.log("getDijit"+index,attr);
//	console.log('[name=\"delRangeItem['+index+'].'+attr+'\"]');
//	console.log(dojo.query('[name=\"delRangeItem['+index+'].'+attr+'\"]')[0]);
	return dijit.byNode(dojo.query('[name=\"delRangeItem['+index+'].'+attr+'\"]')[0]).attr('value');
}
com.copacabana.page.AreaEntrega.getDom=function(index,attr){
	return dojo.query('[name=\"delRangeItem['+index+'].'+attr+'\"]')[0];
	
}