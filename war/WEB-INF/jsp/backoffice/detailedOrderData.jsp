<%@page import="com.ibm.icu.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.com.copacabana.cb.entities.Feedback"%>
<%@page import="java.util.List"%>

<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value='pt'/>
<fmt:setBundle basename='messages'/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Detalhes status pedido</title>

<cb:header />

<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
	<link href="/styles/restaurant/profile_ie_8.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="/styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />
<link
	href="/styles/user/manageOrders.css"
	type="text/css" rel="stylesheet" />
<%@include file="/static/commonScript.html"%>

<script type="text/javascript" src="/scripts/pages/faturas.js"></script>
<script type="text/javascript">	        
			dojo.addOnLoad(function() {			
				dijit.byId('startDate').attr('value',new Date());
				dijit.byId('endDate').attr('value',new Date());
				var datePattern='dd/MM/yyyy';
				console.log(dojo.date.locale.parse('01/12/2009',{datePattern:datePattern}));
				
			});

			
			function submitIt(){
				var inicio = dijit.byId('startDate').attr('value');
				var fim = dijit.byId('endDate').attr('value');
				
				var datePattern='dd-MM-yyyy';
				var startStr = "00:00:00 "+dojo.date.locale.format(inicio,{datePattern:datePattern,selector:'date'});
				var endStr = "23:59:59 "+dojo.date.locale.format(fim,{datePattern:datePattern,selector:'date'});
				dojo.byId('start').value=startStr;
				dojo.byId('end').value=endStr;
				dojo.byId('factureForm').submit();
			}
			
			
</script>
<style>
	#tbheader{
		
		background-color: rgb(230,230,230);
		font-weight: bold;
		
	}
	.headerCol{
		width:150px;
		display: inline-table;
	}
	.tableCol{
	display: inline-table;
		width:150px;
	}
	.tbentry{
		
		
	}
	</style>
</head>

<cb:body closedMenu="true">

	<jsp:include page="backofficeheader.jsp"><jsp:param
			name="isFeedbacks" value="true"></jsp:param></jsp:include>
	<form action="/backoffice/listFeedbacks.do" method="post" id="factureForm"
		style="text-align: center;" >
		Cliente: ${entity.mo.clientName} Restaurante: ${entity.restaurant.name }<br/>
		Status: ${entity.mo.status} Previsão de preparo: ${entity.mo.prepareForeCast} Razão: ${entity.mo.reason }<hr>
		<table><tr><th>De</th><th>Para</th><th>Hora</th><th>Ultima transicao</th></tr>
		
		<c:forEach var="change" items="${entity.updates }">
		<tr><td>${change.fromStatus}</td><td>${change.toStatus }</td><td><fmt:formatDate pattern="dd/MM/yyyy kk:mm" value="${change.time }" timeZone="America/Sao_Paulo"/></td><td><fmt:formatDate pattern="dd/MM/yyyy kk:mm" value="${change.lastStatusStatedtime}" timeZone="America/Sao_Paulo"/></td></tr>
		</c:forEach>
		</table>
		
	

	<br>
	<br />
</cb:body>
</html>