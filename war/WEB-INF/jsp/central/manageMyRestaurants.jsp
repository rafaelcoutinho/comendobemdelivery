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
<title>ComendoBem - Meus Restaurantes</title>

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
<script type="text/javascript">
		    
			
</script>
<style type="text/css">
#conteudo {
	min-height: 500px;
}

#borderContainer {
	width: 100%;
	height: 100%;
}

.selectedRest {
	background-image: url("/resources/img/arrows.png");
	background-position: -25px 0;
	cursor: pointer;
	display: inline-block;
	height: 15px;
	margin: 0 0 -3px;
	width: 15px;
}

#borderContainer a {
	font-size: x-small;
	line-height: 20px;
}

.hasNew {
	font-weight: bold;
}

#monitorDash  .dijitAccordionTitle {
	font-size: x-small;
	padding: 0;
}

#newRequests  .dijitAccordionTitle {
	font-size: xx-small;
	padding: 0;
	background: none repeat scroll 0 0 #e9362C;
}

#newRequests  .dijitAccordionTitle-selected {
	background: none repeat scroll 0 0 #D9261C;
}

#newRequests .dijitAccordionText {
	color: white;
	text-shadow: 1px 1px 0 black;
}

#ongoingRequests  .dijitAccordionTitle {
	font-size: xx-small;
	padding: 0;
	background: none repeat scroll 0 0 #EB7D4B;
}

#ongoingRequests .dijitAccordionText {
	color: white;
	text-shadow: 1px 1px 0 black;
}

#ongoingRequests  .dijitAccordionTitle-selected {
	background: none repeat scroll 0 0 #fB8D5B;
}

#monitorDash .dijitAccordionText {
	
}

#monitorDash table {
	width: 90%;
	margin-bottom: 0px;
}

#monitorDash th {
	background: none repeat scroll 0 0 #DEDEDE;
	font-weight: bold;
}

#monitorDash td {
	background: white;
	padding: 0;
	border-bottom: 1px black solid;
}
.orderState{
color:white;
	font-weight: bold;
}
.orderState_NEW{
	background-color: #D9261C;
	
}
.orderState_PREPARING{
	background-color: orange;
	
}
.orderState_INTRANSIT{
	background-color: green;
	
}
.orderState_VISUALIZEDBYRESTAURANT{
	background-color: #D9261C;

}
.orderState_WAITING_CUSTOMER{
	background-color: green;

}
</style>
</head>
<cb:body closedMenu="true">
	<jsp:include page="centralheader.jsp"><jsp:param
			name="isMyRests" value="true"></jsp:param></jsp:include>
			
<h2 style="color: #EB7D4B">Meus estabelecimentos</h2>			
	Estes são os estabelecimentos associados a sua central. Clique em 'gerenciar' para poder alterar configurações específicas de cada um deles. 
<ul>
	<c:forEach items="${entity}" var="rbean" varStatus="status">
		<li>${rbean.restaurant.name} - <a href="#" onclick="loginAs('${rbean.restaurantKey}','${rbean.restaurant.name}');return false;">gerenciar</a></li>		
	</c:forEach>
	</ul>
	
	<style>
.orderDataEntry {
	display: inline-table;
	width: 60px;
	margin-right: 5px;
	text-align: center;
}

.ordersHeader {
	background-color: #EEEEEE;
	border-bottom: 1px solid black;
	font-weight: bold;
	text-align: center;
	width: 100%;
}
</style>
	<div id="hiddenSection"></div>
</cb:body>
<script>
function loginAs(id,name){
	var a = confirm('Você sera redirecionado para a página de gerenciamento do estabelecimento:\n'+name);
	console.info(a);
	if(a==true){
		var form = dojo.create("form",{action:"/central/gerenciarRestaurante.do",method:"post"},dojo.byId('hiddenSection'));
		dojo.create("input",{type:"hidden",name:"key",value:id},form);
		form.submit();
		console.log("done")
	}
	return false;
	
}
</script>
</html>