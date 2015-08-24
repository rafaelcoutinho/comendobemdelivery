<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%><html>
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

<link href="/styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />

<%@include file="/static/commonScript.html"%>
<script type="text/javascript" src="/_ah/channel/jsapi"></script>
<script type="text/javascript" src="/scripts/pages/monitoring.js"></script>
<link href="/styles/pages/monitoring.css" type="text/css"
	rel="stylesheet" />
<script type="text/javascript">
var loadOrdersUrl='/backoffice/listCurrOrders.do?key=';
var token = '${entity.token}';
var selectedKey;
var shouldShowSelected;
var isRestaurant=false;
<c:if test="${not empty entity.selected}">
selectedKey="${entity.selectedKey}";
shouldShowSelected=true;
</c:if>


</script>

</head>



<cb:body closedMenu="true">
	<jsp:include page="backofficeheader.jsp"><jsp:param
			name="isOrders" value="true"></jsp:param></jsp:include>
	<div style="width: 100%; height: 500px; border: 1px black solid;">
	<div dojoType="dijit.layout.BorderContainer" design="sidebar"
		gutters="true" liveSplitters="true" id="borderContainer">
	<div dojoType="dijit.layout.ContentPane" splitter="true"
		region="leading" style="width: 130px;">Restaurantes:<br>
	<div id="startRests">
	<c:forEach items="${entity.rests}" var="rbean" varStatus="status">
		<a href="#" onclick="showThisOrders(this);return false;"
			restId="${rbean.restaurantKey}"><span
			<c:if test="${rbean.selected==true}">class="selectedRest"</c:if>
			></span>
		${rbean.restaurant.name} <span class="currReqs">${fn:length(rbean.newOrders)+fn:length(rbean.onGoingOrders)}</span>
		<br></a>
		
	</c:forEach>
	</div>
	</div>
	<div dojoType="dijit.layout.ContentPane" splitter="true"
		region="center" id="monitorDash">
	<div dojoType="dijit.layout.AccordionContainer" style="height: 100%;"
		id="mainAccordion">
	<div dojoType="dijit.layout.ContentPane" title="Novos (0)"
		style="font-size: xx-small;" id="newRequests"></div>
	<div dojoType="dijit.layout.ContentPane" title="Em andamento(0)"
		id="onGoingRequests"></div>

	</div>


	</div>
	</div>
	</div>

	<div dojoType="dijit.Dialog" id="orderdialog" title="Pedido"
		style="display: none; border: 1px solid black;" execute=""></div>
</cb:body>
</html>