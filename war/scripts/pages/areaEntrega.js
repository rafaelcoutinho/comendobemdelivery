dojo.require("com.copacabana.RoundedButton");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.TitlePane");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.page.AreaEntrega");

function myLabelFunc(item, store) {
    var label = store.getValue(item, 'name');
    if(currentNeighs[store.getValue(item, 'id')]==true){
    	label = "--> "+label+"";
    	item.wasadded=true
    }else{
    	item.wasadded=false
    }
    return label;
}
var currentNeighs = [];
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
		if (dijit.byId("neighSelection").store.getValue(items[0], "city") != dijit
				.byId("citySelection").attr("value")) {
			dijit.byId("citySelection").attr(
					"value",
					dijit.byId("neighSelection").store.getValue(items[0],
							"city"));
		}
	}
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

var loadNeighsAux = function(){
	var url = "/listNeighborsByCity.do?key=" + dijit.byId("citySelection").attr("value")

	var xhrArgs = {
		url : url,
		handleAs : "json",
		load : function(data) {
			var entity = data;
			var allItems={id:-1,name:'Todos os bairros',zip:'',city: dijit.byId("citySelection").attr("value")};
			data.items.push(allItems);
			updateNeighCombo(data);
		}
			
		,
		error : function(error) {
			console.log("failed to list neig range data." ,error);
		}
	}
	var deferred = dojo.xhrGet(xhrArgs);
}

var updateNeighCombo = function(data){
	var stateStore = new dojo.data.ItemFileReadStore( {
		data:data
	});
	dijit.byId("neighSelection").reset();
	dijit.byId("neighSelection").store = stateStore;
	dijit.byId("neighSelection").attr('value',-1);
	
}
var onCityUpdate = function() {
	if(1==1){
		loadNeighsAux();
		return;	
	}
	try {
		var stateStore = new dojo.data.ItemFileReadStore( {
			url : "/listNeighborsByCity.do?key="
					+ dijit.byId("citySelection").attr("value")
		});
		dijit.byId("neighSelection").reset();
		console.log("state store",stateStore);		
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
	dojo.connect(dijit.byId("citySelection"), "onChange", onCityUpdate);
}
var delRange =[];
function loadRestaurantDeliveryRange() {

	var url = "/listDeliveryRangeForRestaurant.do?key=" + id;

	var xhrArgs = {
		url : url,
		handleAs : "text",
		load : function(data) {
			try{
			var entity = dojo.fromJson(data);
			var delTable = dojo.byId('deliveryRangesTable');
			
			for ( var i = 0; i < entity.length; i++) {
				var data = entity[i];				
				var deliveryId = entity[i].deliveryRange.id;				
				delRange[deliveryId]=entity[i].deliveryRange;
				
				dijit.byId("citySelection").attr("value",data.city.id);
				console.log("data.neighborhood",data.neighborhood);
				if(!data.neighborhood){
					var allNeigh = {id:-1,name:'Todos os bairros',city:{id:data.city.id,name:data.city.name},zip:''};
					delTable.appendChild(addAllInfo(data.city, null, allNeigh,deliveryId));
				}else{
					loadNeighbor(data.neighborhood,null,deliveryId);
				}
			}
			}catch (e) {
				console.error("failed to list del ranges",e);
			}
			
		},
		error : function(error) {
			console.log("failed to list del range data." ,error);
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
}

dojo.addOnLoad(function() {
	
	try{
	com.copacabana.util.showLoading();
	//loadRestaurantDeliveryRange();
	
	loadCities();
	
	prepareForm();
	dojo.connect(dijit.byId('addDeliveryBtn'), "onClick", null, "onToolButtonClick2");
	com.copacabana.util.hideLoading();
	}catch (e) {
		console.error(e);
		com.copacabana.util.hideLoading();
	}
});
var submitForm = function() {
	
}
function prepareForm() {
	var button = dijit.byId("btAdd");

	dojo.connect(button, "onClick", submitForm);

	console.log("ID " + id);
	if (id) {
		loadFormEntiy("/getRestaurant.do?id=" + id, "restform");
	}
}

var loadNeighbor = function(neigh, request,deliveryId) {
	var fct = function(city, request2) {		
		var dom = addAllInfo(city, request2, neigh,deliveryId);
		dojo.byId('deliveryRangesTable').appendChild(dom);
	}
	var args = {
		identity : neigh.city.id,
		onItem : fct,
		onError : function(item, request) {
			console.error("failed to load city info.",item);
		}
	}
	dijit.byId("citySelection").store.fetchItemByIdentity(args);

}

function onToolButtonClick2() {
	var id = dijit.byId("neighSelection").attr("value");
	var cityId = dijit.byId("citySelection").attr("value");
	var fct = function(item,request){
		
		item.city={id:cityId};
		if(item.id.length){
			item.id=item.id[0];
		}
		loadNeighbor(item,request,null);
	}
	
	var args = {
		identity : id,
		onItem : fct,
		onError : function(item, request) {
			console.error(item);
		}
	}
	dijit.byId("neighSelection").store.fetchItemByIdentity(args);
	

}

function loadFormEntiy(url, content, formId) {

	var xhrArgs = {
		url : url,
		content : content,
		handleAs : "text",
		load : function(data) {
			var entity = dojo.fromJson(data);
			if(entity.onlyForRetrieval==true){
				dijit.byId('onlyForRetrieval').attr('value',true);
			}else{
				dijit.byId('onlyForRetrieval').attr('value',false);
			}
			

		},
		error : function(error) {
			console.log("failed to get data.",error);
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
}

var toRemove = [];

var removeNeigh = function(id, idDelivery) {
	console.log("removing " + "nid_" + id);
	var list = document.getElementById("listaBairros");
	var item = dojo.byId("nid_" + id);
	list.removeChild(item);
	if(dojo.isIE){
		var removeX = document.getElementById("span_" + id);
		list.removeChild(removeX);
	}
	if (idDelivery && idDelivery != "") {
		toRemove.push(idDelivery);
	}
}
var removeNeighNewer = function(idDelivery) {
	removeNeighNew(dojo.byId("tr_"+idDelivery),idDelivery);
	
}
var removeNeighNew = function(dom,idDelivery) {
	dojo.empty(dom);
	dojo.destroy(dom);
	
	if (idDelivery && idDelivery != "") {
		toRemove.push(idDelivery);
	}
	currentNeighs[idDelivery]=false;
	
//	var sortAttributes = [{attribute: "name", descending: false}];
//	function completed(items, findResult){
//		var store = dijit.byId("neighSelection").store
//		  for(var i = 0; i < items.length; i++){
//		    var value = store.getValue(items[i], "name");
//		    console.log("Item ID: [" + store.getValue(items[i], "name") + "]");
//		  }
//	  var stateStore = new dojo.data.ItemFileReadStore( {
//		  data:{
//				'identifier':'id',
//				'label':'name',
//				
//				'items':items
//			}
//	  });
//	  dijit.byId("neighSelection").store=stateStore;
//	  
//	}
//	function error(errData, request){
//	  console.log("Failed in sorting data.");
//	}
//
//	//Invoke the fetch.
//	dijit.byId("neighSelection").store.fetch({onComplete: completed, onError: error, sort: sortAttributes});

	
}

var counter = 0;
var addNewDelRangeLine=function(city,request,neigh,delId){
	
	currentNeighs[neigh]=true;
	var index=counter++;	
	var line = dojo.create('tr',null);
	dojo.create('td',{style:{textAlign:'center'},innerHTML:city.name},line);
	dojo.create('td',{style:{textAlign:'center'},innerHTML:neigh.name},line);
	
	dojo.create('input',{type:'hidden',name:prefix+'['+index+'].id',value:delId},line);
	if(neigh.id!=-1){
		dojo.create('input',{type:'hidden',name:prefix+ '['+index+'].neighborhood',value:neigh.id},line);
	}else{
		dojo.create('input',{type:'hidden',name:prefix+ '['+index+'].city',value:neigh.city.id},line);
		dojo.create('input',{type:'hidden',name:prefix+ '['+index+'].neighborhood',value:null},line);
	}
	var td = dojo.create('td',{style:{textAlign:'center'}},line);
	var costName = prefix+'['+index+'].cost';
	
	var costVal =0;
	if(this.delRange[delId]){
		costVal=this.delRange[delId].cost;
	}
	
	var cost = dojo.create('input',{selectOnClick:'true',required:"true",type:'text',name:costName,id:costName,value:costVal},td);
	td=dojo.create('td',{style:{textAlign:'center'}},line);
	var minCostname=prefix+'['+index+'].minimumOrderValue';
	
	var minCostVal =0;
	if(this.delRange[delId]){
		minCostVal=this.delRange[delId].minimumOrderValue;
	}
	var min = dojo.create('input',{selectOnClick:'true',type:'text',name:minCostname,id:minCostname,value:minCostVal},td);
	var props = {
			fractional:true,required:true,
			value: 0.0,
			lang: 'pt-BR',
			selectOnClick:true,			
			currency: "",
			invalidMessage: "Digite o valor com centavos, por exemplo 10,90.",
			style:{width:'60px',height:'18px'}
	};
	var dijitCost = new dijit.form.CurrencyTextBox(props, cost);
	
	dijitCost.attr('value',costVal);
	var dijitMin = new dijit.form.CurrencyTextBox(props, min);
	dijitMin.attr('value',minCostVal);
	td=dojo.create('td',{style:{textAlign:'center'}},line);
	var deletediv = dojo.create('div',{style:{textAlign:'center'}},td);

	var button = new dijit.form.Button({
		label: "Apagar",
		baseClass:'orangeButton',
		onClick: function() {
		removeNeighNew(line,delId);
	}
	},
	deletediv);
	return line;
}

var addAllInfo = function(city, request, neigh,delId) {
	return addNewDelRangeLine(city, request, neigh,delId);
}

var cleanForm = function() {
	var form = dojo.byId("createDeliveries");
	form.innerHTML = "";
}
var prefix='delRangeItem';
var realPref='deliveryRanges';
function getCentsFromCurrency(value){
	var a = dojo.number.format((value*100),{fractional:false,strict:false})
	return a.replace(/\D/g,'');
}
function save(){
	com.copacabana.util.showLoading();
	var section = dojo.byId('deliveriesFormSection' );
	dojo.empty(section);
	
	
	if(dijit.byId('onlyForRetrieval').attr('value')=='on'){
		dojo.create("input",{type:'hidden',name:"onlyForRetrieval",value:'true'},section);	
	}else{
		dojo.create("input",{type:'hidden',name:"onlyForRetrieval",value:'false'},section);
	}
	
	dojo.create("input",{type:'hidden',name:"restaurantId",value:loggedRestaurant.id},section);
	var k=0;
	while (toRemove.length > 0) {
		var kdel = toRemove.pop();
		var dnid = dojo.create("input",{type:'hidden',name:"toDeleteDeliveries[" + k + "]",value:kdel},section);		
		k++;
	}
	
	var normalized = 0;
	for(var i = 0;i<counter;i++){
		var idDom = getDom(i,'id');
		if(idDom){
			var id = idDom.value;
			var neigborhood = getDom(i,'neighborhood').value;
			var cost = getDijit(i,'cost');
			var minimumOrderValue = getDijit(i,'minimumOrderValue');
			
			
			if (id && id != undefined && id != "undefined") {
				dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].id',value:id},section);
			}
			if(!neigborhood){
				var city = getDom(i,'city').value;
				dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].city',value:city},section);
			}
			dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].neighborhood',value:neigborhood},section);
			dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].cost',value:cost},section);
			
			dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].costInCents',value:getCentsFromCurrency(cost)},section);
			dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].minimumOrderValue',value:minimumOrderValue},section);
			dojo.create('input',{type:'hidden',name:'deliveryRanges['+normalized+'].minimumOrderValueInCents',value:getCentsFromCurrency(minimumOrderValue)},section);
			normalized++;
		}

	}
			
	var xhrArgs = {
			form : dojo.byId("createDeliveryNew"),
			handleAs : "json",
			load : function(data) {
				console.log(data);
				//com.copacabana.util.cleanNode(document.getElementById("deliveryRangesTable"));
				
				//loadRestaurantDeliveryRange();
				//com.copacabana.util.hideLoading();
//				var msg = new com.copacabana.MessageWidget();
//				msg.showMsg("Dados salvos.");
				com.copacabana.util.showSuccessAction();
				window.location=window.location;
				
			},
			error : function(error) {
				// We'll 404 in the demo, but that's okay. We don't have a 'postIt'
				// service on the
			// docs server.
			console.error(error);
			com.copacabana.util.hideLoading();
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Erro ao salvar dados: " + error.message);
		}
		}
		// Call the asynchronous xhrPost
		var deferred = dojo.xhrPost(xhrArgs);
	
}
function getDijit(index,attr){
	return dijit.byId('delRangeItem['+index+'].'+attr).attr('value');
}
function getDom(index,attr){
	return dojo.query('[name=\"delRangeItem['+index+'].'+attr+'\"]')[0];
	
}

function saveOld() {
	cleanForm();

	var k = 0;
	console.log(toRemove.length);
	while (toRemove.length > 0) {
		var kdel = toRemove.pop();
		var dnid = document.createElement("input");
		dnid.setAttribute("type", "text");
		dnid.setAttribute("name", "toDeleteDeliveries[" + k + "]");
		dnid.setAttribute("value", kdel);		
		dojo.byId("createDeliveries").appendChild(dnid);
		k++;

	}

	var list = document.getElementById("listaBairros");
	var x = list.childNodes;

	var minimumValue = dijit.byId("minimumValue").attr("value");
	var taxValue = dijit.byId("delCost").attr("value");// dojo.byId("delCost").value;
	// <input type="text" name="restaurantId" id="restaurantId"/>
	var restId = document.createElement("input");
	restId.setAttribute("type", "hidden");
	restId.setAttribute("name", "restaurantId");
	restId.setAttribute("value", id);
	dojo.byId("createDeliveries").appendChild(restId);

	// dojo.byId("restaurantId").setAttribute("value",id);
	var j = 0;
	console.log("childNodes: "+list.childNodes.length);
	for (i = 0; i < list.childNodes.length; i++) {
		try {
			
			var node = x[i];			
			var idDel = node.getAttribute("deliveryId");			
			var dnid = document.createElement("input");
			dnid.setAttribute("type", "hidden");
			dnid.setAttribute("name", "deliveryRanges[" + j	+ "].neighborhood");
			console.log("nid",list.childNodes[i].getAttribute("nid"));
			if(dojo.isIE){
				var myNeighId=list.childNodes[i].getAttribute("nid")[0];
				if(!myNeighId){
					var myNeighId=list.childNodes[i].getAttribute("nid");	
				}
				if(myNeighId){					
					console.log("ie:",myNeighId);
					dnid.value=myNeighId;
				}else{
					throw "Neigh id undefined:"+myNeighId;
				}
			}else{
				console.log("ff:",list.childNodes[i].getAttribute("nid"));
				dnid.setAttribute("value", list.childNodes[i].getAttribute("nid"));
			}

			var dCostCost = document.createElement("input");
			dCostCost.setAttribute("type", "hidden");
			dCostCost.setAttribute("name", "deliveryRanges[" + j+ "].cost");
			console.log("taxValue",taxValue);
			console.log("minimumValue",minimumValue);
			dCostCost.setAttribute("value", taxValue);

			var dCostMinumum = document.createElement("input");
			dCostMinumum.setAttribute("type", "hidden");
			dCostMinumum.setAttribute("name", "deliveryRanges[" + j
					+ "].minimumOrderValue");
			dCostMinumum.setAttribute("value", minimumValue);
			if (idDel && idDel != undefined && idDel != "undefined") {
				var dId = document.createElement("input");
				dId.setAttribute("type", "hidden");
				dId.setAttribute("name", "deliveryRanges[" + j + "].id");
				dId.setAttribute("value", idDel);
				dojo.byId("createDeliveries").appendChild(dId);
			}
			j++;

			dojo.byId("createDeliveries").appendChild(dnid);
			dojo.byId("createDeliveries").appendChild(dCostCost);
			dojo.byId("createDeliveries").appendChild(dCostMinumum);

		} catch (e) {
			console.log(e);
		}
	}
	var xhrArgs = {
		form : dojo.byId("createDeliveries"),
		handleAs : "json",
		load : function(data) {
			console.log(data);
			com.copacabana.util.cleanNode(document.getElementById("listaBairros"));
			loadRestaurantDeliveryRange();
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

}
