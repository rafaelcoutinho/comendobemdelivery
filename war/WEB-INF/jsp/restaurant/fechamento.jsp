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
<title>ComendoBem - Fechamento</title>

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

			
			function printFacture(){
				var inicio = dijit.byId('startDate').attr('value');
				var fim = dijit.byId('endDate').attr('value');
				
				var datePattern='dd-MM-yyyy';
				var startStr = "00:00:00 "+dojo.date.locale.format(inicio,{datePattern:datePattern,selector:'date'});
				var endStr = "23:59:59 "+dojo.date.locale.format(fim,{datePattern:datePattern,selector:'date'});
				window.open('/printFacture.jsp?type=closing&restName='+loggedRestaurant.name+'&start='+startStr+'&end='+endStr,'Fechamento','width=800,height:400,resizable=yes,toolbar=no'); 
			}
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
			function printIt(){
				var inicio = dijit.byId('startDate').attr('value');
				var fim = dijit.byId('endDate').attr('value');
				
				var datePattern='dd-MM-yyyy';
				var startStr = "00:00:00 "+dojo.date.locale.format(inicio,{datePattern:datePattern,selector:'date'});
				var endStr = "23:59:59 "+dojo.date.locale.format(fim,{datePattern:datePattern,selector:'date'});
				dojo.byId('startPrint').value=startStr;
				dojo.byId('endPrint').value=endStr;
				dojo.byId('printForm').submit();
			}
			
</script>
</head>

<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp"><jsp:param
			name="isClosing" value="true"></jsp:param></jsp:include>
	<form action="/fechamento.do" method="GET" id="factureForm"
		style="text-align: center;" >
		
		
	Fechamento para o período de <input width="58" dojoType="dijit.form.DateTextBox" id="startDate" /> a <input width="58" dojoType="dijit.form.DateTextBox" id="endDate" />
		
	<input id="start" type="hidden" name="start" /> <input id="end"
		type="hidden" name="end" format="hh:mm:ss dd-mm-yyyy" /> <input
		dojoType="dijit.form.TextBox" type="hidden" name="status"
		value="DELIVERED"></input>
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:loadFactureData" onclick="submitIt();return false">Gerar fechamento</button>
	</form>
	<style>
	#tbheader{
		
		background-color: rgb(230,230,230);
		font-weight: bold;
		
	}
	.headerCol{
		width:150px;
		display: inline-table;
		padding: 2px;
	}
	.tableCol{
	display: inline-table;
		width:150px;
	}
	.tbentry{
		
		
	}
	</style>
	<div id="facturePlace" style="border-top: 1px solid grey;padding: 30px">
	<c:if test="${not empty entity}"><div style="float: right;"><button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:printIt" onclick="printIt()"><img
		src="/resources/img/printer.png"></img> Imprimir</button></div>
	<h3>Fechamento do período de <fmt:formatDate pattern="dd/MM/yyyy" value="${entity.start}" /> à <fmt:formatDate pattern="dd/MM/yyyy" value="${entity.end}" /></h3>
	
	</c:if>
	
	<div id="tbheader"><div class="headerCol" style="width: 200px">Forma de pagamento</div><div class="headerCol">Valor total</div><div class="headerCol">N&uacute;mero de pedidos</div></div>
	<c:set var="totalPedidos" value="0"></c:set>
	<c:set var="restBillBean" value="${entity}"></c:set>
		<div class="tbentry">
		</div>
		<div style="border-bottom: 1px solid black; ">
		<c:forEach items="${restBillBean.byPayment}" var="paymentTypeTotal">
		<div style="width: 500px;">
		
		<div class="tableCol" style="width: 200px"><fmt:message key='payment.${paymentTypeTotal.key}'/></div>
		<div class="tableCol">R$ <fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${paymentTypeTotal.value[0]/100}" default="0"/></fmt:formatNumber> <c:if test="${paymentTypeTotal.key=='PAYPAL'}">(R$ <fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${paymentTypeTotal.value[3]/100}" default="0"/></fmt:formatNumber>)</c:if></div>
		<div class="tableCol" style="display:inline">${paymentTypeTotal.value[2]}</div>
		<c:set var="totalPedidos" value="${totalPedidos+ paymentTypeTotal.value[2]}"></c:set>
		</div>
		</c:forEach>
		<div style="width: 500px;">	
		<div class="tableCol"></div>
		
		</div> 
		</div>		
	
	<div class="tbentry" style="background-color:rgb(240,240,240);font-size: large;font-weight: bold; "> 
		
		<div class="tableCol" style="font-style: italic;text-align: right;width: 200px;" >Total:</div>
		<div class="tableCol" style="font-weight: bold;">R$ <fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${entity.totals/100.0}" default="0"/></fmt:formatNumber></div>
		<div class="tableCol">${totalPedidos}</div>
		</div>
	<div id="finalSection" style="display: none;">
	<div style="text-align: right; margin-right: 10px;">
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:printFacture" onclick="printFacture()"><img
		src="/resources/img/printer.png"></img> Imprimir</button>
	</div>
	<div style="margin-left: 10px;" id="legenda">
	<p>Legenda:
	<ol>
		<li>Valor dos pedidos referente ao restaurante.</li>
		<li>Valor dos pedidos pagos pelo site.</li>
		<li>Valor dos pedidos pagos diretamente ao restaurante.</li>
		<li>Valor da comiss&atilde;o j&aacute; retida pelo site.</li>
		<li>Valor da comiss&atilde;o devida ao site.</li>
	</ol>
	</p>
	</div>
	</div>

	</div>


	<br>
	<br />
</cb:body>
<form action="/printFechamento.do" method="get" id="printForm" target="_blank"
		><input type="hidden" name="start" id="startPrint">
		<input type="hidden" name="end" id="endPrint">
		<input type="hidden" name="status"
		value="DELIVERED"></input>
		</form>
</html>