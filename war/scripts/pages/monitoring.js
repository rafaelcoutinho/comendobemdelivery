dojo.require("com.copacabana.PlateEntryWidget");
	dojo.require("dijit.form.Textarea");
	dojo.require("com.copacabana.RoundedButton");
	dojo.require("com.copacabana.order.RestaurantOrdersWidget");
	dojo.require("dijit.form.FilteringSelect");
	dojo.require("dojo.parser");
	dojo.require("dojo.data.ItemFileReadStore");
	dojo.require("dijit.form.Button");
	dojo.require("dijit.form.TextBox");
	dojo.require("dijit.form.CheckBox");
	dojo.require("dijit.Dialog");
	dojo.require("dijit.form.TimeTextBox");
	dojo.require("dijit.form.Button");
	dojo.require("dijit.form.ComboBox");

	function refreshTable() {
		dojo.publish("onEachMinute", [ 60 ]);
	}

	var updateCurrentDelay = function() {

		var store = new dojo.data.ItemFileReadStore({
			data : {
				identifier : 'id',
				labelAttr : 'name',
				items : [ {
					id : '15',
					name : '15 mins'
				}, {
					id : '30',
					name : '30 mins'
				}, {
					id : '45',
					name : '45 mins'
				}, {
					id : '60',
					name : '1 hora'
				}, {
					id : '90',
					name : '90 mins'
				}, {
					id : 'ONCEADAY',
					name : '1x ao dia'
				}, {
					id : 'TEMPUNAVAILABLE',
					name : 'Indisponível'
				} ]
			}
		});
		dijit.byId("currentDelay").store = store;
		dijit.byId('currentDelay').attr('value', '30 mins');
	}
	var submitForm = function() {
		console.log('enviar');
		console.log(dijit.byId('currentDelay').attr('value'));
		var xhrArgs = {
			form : dojo.byId("changeDelayForm"),
			handleAs : "text",
			load : successUpdate,
			error : errorUpdate
		};

		var deferred = dojo.xhrPost(xhrArgs);
	}
	showToolTip = function(msg,dom,placement,delay) {
		
		currtooltipdom=dom;
		var where =[ 'after', 'above' ]
		if(placement){
			where = placement;
		}
		if(!delay || delay<10){
			delay=2000;
		}
		dijit.showTooltip(msg, dom, where);
		setTimeout(hideTooltip, delay);

	}
	var currtooltipdom;
	var hideTooltip = function() {
		dijit.hideTooltip(currtooltipdom);
	}
	errorUpdate = function(error) {
		console.error('nok', error);
	}
	dojo.require("dijit.layout.ContentPane");
	dojo.require("dijit.layout.BorderContainer");
	dojo.require("dijit.layout.AccordionContainer");
	dojo.require("dojo.regexp");
	function maximize() {
		dojo.style(dojo.byId('borderContainer'), 'position', 'absolute');
		dojo.style(dojo.byId('borderContainer'), 'top', '0');

		dojo.style(dojo.byId('mainAccordion'), 'height', '100%');

	}
	function addNewRequest() {

		var entry = new com.copacabana.central.CompactOrderEntry();
		entry.isRestaurantViewer=isRestaurant;
		entry.startup();
		dojo.byId('newOrdersList').appendChild(entry.domNode);

	}
	dojo.require("com.copacabana.central.CompactOrderEntry");
	dojo.require("com.copacabana.central.OrderDetailsWidget");
	function orderChangedStatus() {
		console.log("orderChangedStatus");
		showOrders(currRestId);
	}
	function updateList() {

	}
	function refreshTable() {
		dojo.publish("onEachMinute", [ 60 ]);
	}
	var channelControl = {
		onOpened : function() {
			connected = true;

		},
		onMessage : function(msg) {
			console.info(msg);
			var notification = dojo.fromJson(msg.data);
			console.info(dojo.query('[restId=' + notification.restId + ']'));
			notifyNewRequest(notification);

		},
		onError : function(err) {
			console.error(err)
		},
		onClose : function() {
			console.log('close');
		}
	}
	var newOrdersCounter=0;
	var displayingOrder=function(){
		newOrdersCounter--;
		console.log("newOrdersCounter",newOrdersCounter);
		if(newOrdersCounter<=0){
			keepAlerting=false
		}
	}
	var keepAlerting=false;
	var originalTitle="ComendoBem - Acompanhar Pedidos Online";
	var newRequestStrTitle="Há novos pedidos";
	var keepToggling=function(){		
		var titleDom = dojo.query("title")[0];
		if(keepAlerting==true){
			if(titleDom.innerHTML==originalTitle){
				titleDom.innerHTML=newRequestStrTitle;
			}else{
				titleDom.innerHTML=originalTitle;
			}
			setTimeout(keepToggling,1000);
		}else{
			titleDom.innerHTML=originalTitle;
		}
	}
	
	var notifyNewRequest = function(notification) {
		keepAlerting=true;
		keepToggling();
		newOrdersCounter++;
		var ahref = dojo.query('[restId=' + notification.restId + ']')[0];
		var x = ahref.children[1].innerHTML;
		x++;
		ahref.children[1].innerHTML = x;
		var list = dojo.byId('startRests');		
		dojo.place(ahref, list, "first");
		
		
		if(currRestId!=notification.restId){
			dojo.addClass(ahref.children[1], "hasNewRequests");
			showToolTip("Novo pedido aqui",ahref.children[1],[  'above','after' ],5000);
		}else{
			
			var entry = new com.copacabana.central.CompactOrderEntry(notification.mealOrder);
			entry.isRestaurantViewer=isRestaurant;
			entry.startup();
			dojo.byId('newOrdersList').appendChild(entry.domNode);
			var currTitle = dojo.byId('newRequests_button_title').innerHTML;
			var pos1= currTitle.indexOf("(", 0);
			var pos2= currTitle.indexOf(")", 0);
			var total = currTitle.substr(pos1+1,pos2-pos1-1)
			total++;
			dojo.byId('newRequests_button_title').innerHTML = "Novo ("+ total + ")";
			showToolTip("Há novos pedidos",dojo.byId('newRequests_button_title'))
			
		}
		if(customNotification!=null){
			customNotification();	
		}
	}
	function EvalSound(soundobj) {
		  var thissound=document.getElementById(soundobj);
		  thissound.Play();
		}

		function customNotification(){
			if(dojo.byId('sound1')==null){
				dojo.create('embed',{src:'/resources/bell.wav',autostart:false,width:0,height:0,id:'sound1',enablejavascript:'true'},dojo.body());
			}
			EvalSound('sound1');
		}
		
	http: // localhost:8888/listRestaurantPendingOrderList.do?key=ag5jb21lbmRvYmVtYmV0YXIRCxIKUkVTVEFVUkFOVBjmCAw
	dojo.addOnLoad(function() {
		setInterval("refreshTable()", 60000);
		// updateCurrentDelay();//TODO
		dojo.subscribe("onChangeOrderStatus", orderChangedStatus);
		dojo.subscribe("onEachMinute", updateList);
		dojo.subscribe("displayingNewOrder",displayingOrder);
		if(shouldShowSelected && shouldShowSelected==true){
			showOrders(selectedKey)	
		}
		
		channel = new goog.appengine.Channel(token);
		socket = channel.open();
		socket.onopen = channelControl.onOpened;
		socket.onmessage = channelControl.onMessage;
		socket.onerror = channelControl.onError;
		socket.onclose = channelControl.onClose;

	});
	// TODO close connection
	function showThisOrders(_this) {
		try{			
			try {
				var selectedList = dojo.query(".selectedRest");
				console.log()
				for ( var i = 0; i<selectedList.length; i++) {
					if(selectedList[i]){
						dojo.removeClass(selectedList[i], "selectedRest");
					}
				}
			} catch (e) {
				console.log("removeing selectedRest",e);
			}
			dojo.addClass(_this.children[0], "selectedRest");

			dojo.removeClass(_this.children[1],"hasNewRequests");
			showOrders(_this.attributes.restId.value);
		}catch(e){
			console.warn("error showing orders",e);
		}
		return false;
	}
	var currRestId = "";
	function showOrders(restId) {
		currRestId = restId;
		var xhrParams = {
			error : function(error) {
				console.error(error);
			},
			handleAs : 'json',
			load : loadedList,
			url : loadOrdersUrl + restId
		};
		dojo.xhrGet(xhrParams);
	}
	function createSection() {
		var txt = '<div class="ordersHeader"><div class="orderDataEntry" style="width: 90px;"></div><div class="orderDataEntry" style="width: 90px;">Pedido No</div><div class="orderDataEntry ">Entrada</div><div class="orderDataEntry">&Uacute;ltima mudan&ccedil;a</div><div class="orderDataEntry">Tempo total</div><div style="display: inline-block;width: 205px;">Resumo</div>';
		txt += ' 	</div><div id="newOrdersList"></div>';
		return txt;
	}
	function createOnGoingSection() {
		var txt = '<div class="ordersHeader"><div class="orderDataEntry" style="width: 90px;"></div><div class="orderDataEntry" style="width: 90px;">Pedido No</div><div class="orderDataEntry ">Entrada</div><div class="orderDataEntry">&Uacute;ltima mudan&ccedil;a</div><div class="orderDataEntry">Tempo total</div><div style="display: inline-block;width: 205px;">Resumo</div>';
		txt += ' 	</div><div id="onGoingOrdersList"></div>';
		return txt;
	}
	var loadedList = function(data, response) {
		console.log(data);
		
		var ahref = dojo.query('[restId=' + currRestId + ']')[0];
		ahref.children[1].innerHTML = data.newOrders.length
				+ data.onGoingOrders.length;
		if (data.newOrders.length == 0 && data.onGoingOrders.length > 0) {
			dijit.byId('mainAccordion').selectChild('onGoingRequests', true);

		} else {
			dijit.byId('mainAccordion').selectChild('newRequests', true);
		}
		dojo.byId('newRequests_button_title').innerHTML = "Novo ("
				+ data.newOrders.length + ")";
		dijit.byId('newRequests').cancel();
		dijit.byId('newRequests').attr('content', createSection());
		for ( var i = 0; i < data.newOrders.length; i++) {
			var order = data.newOrders[i];
			var entry = new com.copacabana.central.CompactOrderEntry(order);
			entry.isRestaurantViewer=isRestaurant;
			entry.startup();
			dojo.byId('newOrdersList').appendChild(entry.domNode);
		}

		dojo.byId('onGoingRequests_button_title').innerHTML = "Em andamento ("
				+ data.onGoingOrders.length + ")";
		dijit.byId('onGoingRequests').cancel();
		dijit.byId('onGoingRequests').attr('content', createOnGoingSection());
		for ( var i = 0; i < data.onGoingOrders.length; i++) {
			var order = data.onGoingOrders[i];
			var entry = new com.copacabana.central.CompactOrderEntry(order);
			entry.isRestaurantViewer=isRestaurant;
			entry.startup();
			dojo.byId('onGoingOrdersList').appendChild(entry.domNode);
		}

	}