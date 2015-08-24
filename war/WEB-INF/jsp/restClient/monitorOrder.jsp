<%@page import="br.copacabana.Authentication"%>
<%@page import="com.google.appengine.api.channel.ChannelServiceFactory"%>
<%@page import="com.google.appengine.api.channel.ChannelService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%><html>
<head>
<%
ChannelService channelService = ChannelServiceFactory.getChannelService();

String token = channelService.createChannel("Client_"+KeyFactory.keyToString(Authentication.getLoggedUserKey(session)));
%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - Acompanhar pedidos</title>
	
	<cb:header />
	
	<link href="/styles/user/profile.css" type="text/css" rel="stylesheet" />
	<link href="/styles/user/manageOrders.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/user/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<%@include file="/static/commonScript.html" %>
	<script type="text/javascript" src="/_ah/channel/jsapi"></script>
<script type="text/javascript">
			
			
			dojo.require("dojo.parser"); 
	        dojo.require("com.copacabana.order.UserViewOrderWidget");	        
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");	        
	        dojo.require("com.copacabana.MessageWidget");
	        function refreshTable(){
				dojo.publish("onEachMinute",[60]);
	        }	        
	        
	        var channelControl = {
	        		onOpened : function() {
	        			connected = true;

	        		},
	        		onMessage : function(msg) {
	        			console.info(msg);	
	        			refreshTable();

	        		},
	        		onError : function(err) {
	        			console.error(err)
	        		},
	        		onClose : function() {
	        			console.log('close');
	        		}
	        	}
			dojo.addOnLoad(function() {
				setInterval ("refreshTable()",60000);
				dijit.byId("userOrdersView").startRefreshing();
				//basicWipeinSetup();
				dojo.subscribe("onOrderPreparing",suggestions);
				suggestions();
				channel = new goog.appengine.Channel('<%=token%>');
	    		socket = channel.open();
	    		socket.onopen = channelControl.onOpened;
	    		socket.onmessage = channelControl.onMessage;
	    		socket.onerror = channelControl.onError;
	    		socket.onclose = channelControl.onClose;
			});
			
	        
			var suggestions=function(){
				var nodes = dojo.query(".msgPlace");
				for(var id in nodes){
				    var node = nodes[id];
				    dijit.hideTooltip(node);
				}
				dojo.style(dojo.byId('suggestionButton'),'visibility','visible')
				dojo.anim(dojo.byId('suggestionButton'), {color: "#fff"},null,null,function(){
					dojo.anim(dojo.byId('suggestionButton'), {color: "#EB7D4B"});
				});
				basicWipeinSetup();
				
				
			}
			
			var toggler;
			  dojo.require("dijit.form.Button");
			    dojo.require("dojo.fx");
			    var state=false;
			    var toggleIt=function(){		        	
		        	state=!state;
		        	if(state==true){
		        		toggler.show();
		        	}else{
		        		toggler.hide();
		        	}
		        }
			    function basicWipeinSetup() {
			    	
			    	 toggler = new dojo.fx.Toggler({
			            node: "basicWipeNode",
			            showFunc: dojo.fx.wipeIn,
			            showDuration:1000,
			            hideFunc: dojo.fx.wipeOut,
			            hideDuration:1000
			            
			        });

			       
			        dojo.connect(dojo.byId("suggestionButton"), "onclick", toggleIt);
			        dojo.connect(dijit.byId("basicWipeButton"), "onClick", dojo.hitch(toggler,toggler.hide));
			        
			    }			   
			    
			    
</script>	
<style>
#suggestionButton {
	visibility: visible;
	height: 20px;
	background-color: rgb(255, 255, 255);
	padding: 4px;
	text-align: center;
	text-decoration: underline;
	font-weight: bold;
	cursor: pointer;
}
</style>	
</head>
<cb:body closedMenu="true">
	<jsp:include page="../user/clientheader.jsp" ><jsp:param name="isOrderStatusPage" value="true"></jsp:param></jsp:include>
	<br/>
	<div id="suggestionButton" onclick="">Que tal um passatempo enquanto aguarda seu pedido? Clique aqui e veja algumas sugest&otilde;es!</div>
	<div id="basicWipeNode" style="color:#EB7D4B;display: none;background-color: wheat;border:1px solid orange;">
	<div style="height: 90px;padding:10px;margin:10px;">
	
		<jsp:include page="/suggestions.jsp"></jsp:include>
	   
    	</div>
	</div>
	<div dojoType="com.copacabana.order.UserViewOrderWidget" id="userOrdersView">
	</div> 
	
	
</cb:body>
</html>