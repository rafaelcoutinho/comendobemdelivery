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
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%>
<fmt:setLocale value='pt'/>
<fmt:setBundle basename='messages'/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Feedbacks</title>

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
	<form action="/backoffice/listFeedbacks.do" method="GET" id="factureForm"
		style="text-align: center;" >
		
		
	Feedbacks para o período de <input width="58" dojoType="dijit.form.DateTextBox" id="startDate" /> a <input width="58" dojoType="dijit.form.DateTextBox" id="endDate" />
		
	<input id="start" type="hidden" name="start" /> <input id="end"
		type="hidden" name="end" format="hh:mm:ss dd-mm-yyyy" /> 
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:loadFactureData" onclick="submitIt();return false">Filtrar</button>
	</form>
	
	
	<form action="/backoffice/sendFeedbacksToRestaurant.do" ><input type="submit" value="Enviar email com selecionados">
	<table><tr><th></th><th>Id</th><th>Restaurante</th><th>Sent</th><th>Cliente</th><th>Data</th><th>Como um todo</th><th>Tempo de entrega</th><th>Atualização</th><th>Informação no site</th><th>Qualidade da comida</th><th>Comentário</th></tr>
	
	<c:forEach items="${entity}" var="feedback" varStatus="status">
	 <tr>
	 <td><input type="checkbox" name="idFeedBack" value="${feedback.f.id}"></td>
	 <td>${feedback.mealOrder.client.id.id}.${feedback.mealOrder.id.id}</td><td>${feedback.restaurant.name}</td>
	 <td>${feedback.f.sentToRestaurant}</td>
	 <td title="${feedback.mealOrder.client.email}">${feedback.mealOrder.clientName}</td>
	 <td><a href="/backoffice/getMealOrderDetails.do?id=${feedback.mealOrderIdStr }" target="_blank"><fmt:formatDate pattern="dd/MM/yyyy kk:mm" value="${feedback.mealOrder.orderedTime}" timeZone="America/Sao_Paulo"/></a></td>
	 <td><span title="Nota Geral">${feedback.f.overall}</span> </td>
	 <td><span title="Nota Tempo de entrega">${feedback.f.deliveryTime}</span> </td>
	 <td><span title="Nota Atualização do stats">${feedback.f.statusUpdate}</span> </td>
	 <td><span title="Nota Informação no site">${feedback.f.restaurantInfo}</span></td>
	 <td><span title="Nota Qualidade da Comida">${feedback.f.foodQuality}</span></td>
	 <td>${feedback.f.comment}</td></tr>
		
	</c:forEach>
	</table>
	
</form>

	<br>
	<br />
</cb:body>
</html>