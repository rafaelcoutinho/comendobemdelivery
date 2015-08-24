<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%><html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - Histórico de Pedidos</title>
	
	<cb:header />
	
	<link href="/styles/restaurant/profile.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/restaurant/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
		<link href="/styles/restaurant/profile_ie_8.css" type="text/css" rel="stylesheet" />
	</c:if>
	
	<link href="/styles/restaurant/menu.css" type="text/css" rel="stylesheet" />
<link href="/styles/user/manageOrders.css" type="text/css" rel="stylesheet" />
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
	        dojo.require("dijit.form.DateTextBox");
	      	        
	        function refreshTable(){
				dojo.publish("onEachMinute",[60]);
	        }
			dojo.addOnLoad(function() {			
				console.log("set timeout");
				setInterval ("refreshTable()",60000);
			});
</script>
</head>
<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp" ><jsp:param name="isOldOrders" value="true"></jsp:param></jsp:include>


	<div id="ordens" dojoType="com.copacabana.order.RestaurantOrdersWidget" typeOfRequests="inPeriodRequests" status="'DELIVERED,EVALUATED,EXPIRED,CANCELLED'" isNoTime="true" isDateRangeable="true"></div>
	<br><br/>
</cb:body>
</html>