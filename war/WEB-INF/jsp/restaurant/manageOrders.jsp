<%@page import="br.copacabana.Authentication"%>
<%@page import="com.google.appengine.api.channel.ChannelServiceFactory"%>
<%@page import="com.google.appengine.api.channel.ChannelService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%
ChannelService channelService = ChannelServiceFactory.getChannelService();

String token = channelService.createChannel("Rest_"+KeyFactory.keyToString(Authentication.getLoggedUserKey(session)));
%>
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Acompanhar Pedidos Online</title>

<cb:header />

<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/restaurant/order.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/order_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<script type="text/javascript" src="/_ah/channel/jsapi"></script>
<link href="/styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />

<%@include file="/static/commonScript.html" %>

<script type="text/javascript">
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
	      	        
	        
	        var channelControl = {
	        		onOpened : function() {
	        			connected = true;

	        		},
	        		onMessage : function(msg) {
	        			console.info("chegou!",msg);	
	        			
	        			refreshTable();
	        			checkForExistingNewOrders();

	        		},
	        		onError : function(err) {
	        			console.error(err)
	        		},
	        		onClose : function() {
	        			console.log('close');
	        		}
	        	}
	        function refreshTable(){	        	
				dojo.publish("onEachMinute",[60]);
	        }	        
	        function checkForExistingNewOrders(){
	        	var list = dijit.byId('andamento').orderList;
	        	if(list.length>0){
	        		for(var id in list){
	        			var entry = list[id];
	        			console.log(id,entry);
	        			console.log(entry.status);
	        			if(entry.status=='NEW'){
	        				console.log("achou um com NEW "+entry.id);
	        				try{
	        					if(dijit.byId(entry.id).order.status=='NEW'){
	        						notifyNewOrder();
	        						return;
	        					}	        					
	        				}catch(e){
	        					console.log("pode ser um NEW ");
	        					notifyNewOrder();
	        					return;
	        				}
	        			}
	        		}
	        	}
	        }
			dojo.addOnLoad(function() {	
				
				channel = new goog.appengine.Channel('<%=token%>');
	    		socket = channel.open();
	    		socket.onopen = channelControl.onOpened;
	    		socket.onmessage = channelControl.onMessage;
	    		socket.onerror = channelControl.onError;
	    		socket.onclose = channelControl.onClose;
	    		setInterval ("refreshTable()",60000);
	    		setInterval ("checkForExistingNewOrders()",20000);
	    		
				updateCurrentDelay();
				dojo.subscribe("onNewOrders",notifyNewOrder);
			});
			var lastNotification = new Date(0);
			var notifyNewOrder=function(){		
				
				if(dojo.date.difference(lastNotification,null,"second")<5){
					console.warn('it was notified just now');
					return;
				}
				console.log("notifying")
				lastNotification = new Date();
				customNotification();
			}
			function customNotification(){
				if(dojo.byId('sound1')==null){						
					dojo.create('embed',{src:'/resources/bell.wav',autostart:false,width:0,height:0,id:'sound1',enablejavascript:'true'},dojo.body());
				}
				dojo.byId('sound1').Play();
			}
			var updateCurrentDelay=function(){
				loggedRestaurant.currentDelay;
				console.log(loggedRestaurant.currentDelay);
				
				var store= new dojo.data.ItemFileReadStore({
			        data: {
							identifier:'id',
							labelAttr:'name',
							items:[
									{ id:'15',name:'15 mins'},
									{ id:'30',name:'30 mins'},
							       { id:'45',name:'45 mins'},
							       { id:'60',name:'1 hora'},
							       { id:'90',name:'90 mins'},
							       { id:'ONCEADAY',name:'1x ao dia'},
							       { id:'TEMPUNAVAILABLE',name:'Indisponível'}
									]
			        	}
			    });
				dijit.byId("currentDelay").store = store;
				dijit.byId('currentDelay').attr('value',loggedRestaurant.currentDelay);
			}
			var submitForm = function(){
				console.log('enviar');
				console.log(dijit.byId('currentDelay').attr('value'));								
				var xhrArgs = {
						form: dojo.byId("changeDelayForm"),
						handleAs: "text",
						load : successUpdate,
						error: errorUpdate
				};
				
				var deferred = dojo.xhrPost(xhrArgs);
			}
			successUpdate=function(data){
				console.log('ok');
				dijit.showTooltip("Prazo de entrega alterado", dojo.byId("currentDelay"),['after','above']);
				setTimeout(hideTooltip, 2000);
				
			}
			var hideTooltip=function(){
				dijit.hideTooltip( dojo.byId("currentDelay"));
			}
			errorUpdate=function(error){
				console.error('nok',error);
			}
</script>
</head>
<cb:body closedMenu="true">
	<jsp:include page="restheader.jsp"><jsp:param
			name="isOrders" value="true"></jsp:param></jsp:include>
<div style="text-align: right; margin: 2px 10px 2px 2px; background-color: rgb(238, 238, 238);">


<form id="changeDelayForm" action="/mudarPrazo.do" method="post">Prazo de entrega atual: 
<input dojoType="dijit.form.FilteringSelect"  id="currentDelay" name="currentDelay" style="width: 95px">

<button baseClass="orangeButton" dojoType="dijit.form.Button" onclick="submitForm" onkeypress="submitForm" dojoAttachEvent="onclick:submitForm">Alterar</button></form>
 
</div>
	<div dojoType="com.copacabana.order.RestaurantOrdersWidget"
		id="andamento" showElapsed="true" typeOfRequests="newRequests"></div>

	<br>
	
	
	<div id="emexecucao"
		dojoType="com.copacabana.order.RestaurantOrdersWidget"
		status="'WAITING_CUSTOMER,PREPARING,INTRANSIT'" showElapsed="true" typeOfRequests="acceptedRequests"></div>

	<div id="vencidosHoje"
		dojoType="com.copacabana.order.RestaurantOrdersWidget"
		status="'EXPIRED'" showElapsed="true" typeOfRequests="expiredRequests"></div>

	<div dojoType="dijit.Dialog" id="orderdialog" title="Pedido"
		style="display: none; border: 1px solid black;" execute=""></div>
</cb:body>
</html>