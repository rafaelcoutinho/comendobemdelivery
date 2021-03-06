<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn"
	uri="http://java.sun.com/jsp/jstl/functions"%><%@page
	import="com.google.gson.JsonParser"%><%@page
	import="com.google.gson.JsonElement"%><%@page
	import="com.google.gson.JsonObject"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt' />
<fmt:setBundle basename='messages' />
<html>
<link href="/styles/user/general.css" type="text/css" rel="stylesheet" />

<head>
<style type="text/css">
.sectionTitle {
	font-size: large;
	font-weight: bold;
	display: block;
	margin-top: 5px;
}

th {
	background-color: #f9f9f9;
	margin-right: 2px;
}

.cost {
	text-align: right;
}

td {
	border-bottom: 1px inset #f9f9f9;
}

.qty {
	text-align: center;
}

tr {
	vertical-align: top;
}

.descItem {
	width: 280px;
}

.mytable {
	border: 1px solid;
	border-collapse: collapse;
	width: 100%;
}

.pagebreak {
	page-break-before: always;
	margin-top: 10px;
	margin-bottom: 10px;
}

.comanda {
	
}

.plateCode {
	font-style: italic;
}
</style>
<%
	MealOrder mo = (MealOrder) request.getAttribute("order");
	Restaurant r = new RestaurantManager().get(mo.getRestaurant());
	Address add = new AddressManager().get(mo.getAddress());
	request.setAttribute("address", add);
%>
<title>ComendoBem - ${order.id.id }</title>
</head>
<body style="width: 178mm;" onload="window.print()">
<div class="comanda" id="copiaCliente">
<div class="logo" style="float: right; padding: 5px;"><img
	alt="wwwcomendobem.com.br" src="/resources/img/logo.png"
	style="height: 100px;"></div>
<div class="logo"
	style="float: left; text-align: center; font-size: large; margin-right: 10px;">
<img alt="diskfacil" src="/resources/img/diskfacil.jpg"
	style="width: 150px;"><br>
3251-5050</div>
<div style="font-size: xx-large; text-align: left;">${order.xlatedId}<br /><%=r.getName()%></div>
<div style="padding: 5px; font-size: medium;">Data do pedido <fmt:formatDate
	pattern="kk:mm dd/MM/yyyy" value="${order.orderedTime}"
	timeZone="America/Sao_Paulo" /></div>

<hr style="clear: both;">
<div style="padding: 5px;"><span class="sectionTitle">Cliente</span>
<span class="fieldLabel">Nome:</span> <i>${order.clientName}</i><br />
<span class="fieldLabel">Telefone:</span> <i>${order.clientPhone}</i><br />
<c:if test="${not empty order.cpf}">
	<span class="fieldLabel">CPF:</span>
	<i>${order.cpf}</i>
</c:if>
<div style="padding: 10px; font-size: large;"><c:if
	test="${order.retrieveAtRestaurant}">Pedido a ser retirado no estabelecimento.</c:if>
<c:if test="${not order.retrieveAtRestaurant}">
	<span class="sectionTitle" style="background-color: #f9f9f9">Endere&ccedil;o
	para entrega:</span>
	${address.street}, ${address.number}<br />
	${address.additionalInfo} - ${address.neighborhood.name}<br />
	<span class="fieldLabel">Tel:</span>
	<%=add.getPhone()%>
</c:if></div>
<span class="fieldLabel">Forma de Pagamento:</span> <fmt:message
	key='payment.${order.payment.type}' /><br />
<span class="sectionTitle">Motoboy:</span> <br />
<c:if test="${not empty order.observation}">
	<span class="sectionTitle">Observa&ccedil;&atilde;o do cliente:</span>
	<div
		style="width: 90%; border: 1px solid gray; padding: 5px; font-style: italic;">${order.observation
	}</div>
</c:if> <span class="sectionTitle">Itens</span>
<table class="mytable" cellpadding="2px;">
	<th>Descri&ccedil;&atilde;o</th>
	<th>Qtd</th>
	<th>Pre&ccedil;o (R$)</th>
	<th>Valor (R$)</th>
	<c:forEach items="${order.plates}" var="plate">
		<tr>
			<td class="descItem">${plate.name}<c:if
				test="${not empty plate.forceRestInternalCode }">
				<span class="plateCode">c&oacute;digo
				${plate.forceRestInternalCode}</span>
			</c:if></td>
			<td class="qty">${plate.qty}</td>
			<td class="cost"><fmt:formatNumber pattern="##"
				minFractionDigits="2" minIntegerDigits="1">
				<c:out value="${plate.priceInCents/100.0}" default="0" />
			</fmt:formatNumber></td>
			<td class="cost"><fmt:formatNumber pattern="##"
				minFractionDigits="2" minIntegerDigits="1">
				<c:out value="${plate.qty*(plate.priceInCents/100.0)}" default="0" />
			</fmt:formatNumber></td>
	</c:forEach>
	<tr>

		<td class="descItem">Taxa entrega</td>
		<td class="qty">1</td>
		<td class="cost"></td>
		<td class="cost"><fmt:formatNumber pattern="##"
			minFractionDigits="2" minIntegerDigits="1">
			<c:out value="${order.deliveryCostInCents/100.0}" default="0" />
		</fmt:formatNumber></td>

	</tr>
	<c:if
		test="${not empty order.discountInfo and order.discountInfo.value>0}">
		<tr>
			<td class="descItem">Desconto</td>
			<td class="qty">1</td>
			<td class="cost"></td>
			<td class="cost">- <fmt:formatNumber pattern="##"
				minFractionDigits="2" minIntegerDigits="1">
				<c:out value="${order.discountInfo.value/100.0}" default="0" />
			</fmt:formatNumber></td>
			</td>
		</tr>
	</c:if>
	<tr>
		<td colspan=5 style="border: 0px; border-top: 3px solid black;"></td>
	</tr>
	<tr>
		<td colspan="5"
			style="text-align: right; font-weight: bold; font-size: large;">TOTAL:
		<span
			style="font-weight: bold; font-size: xx-large; text-align: right;"
			colspan="2">R$ <fmt:formatNumber pattern="##"
			minFractionDigits="2" minIntegerDigits="1">
			<c:out value="${order.totalAmountInCents/100.0}" default="0" />
		</fmt:formatNumber></span></td>
	</tr>

	<%
		if (request.getParameter("pType").startsWith("t")) {
	%>
	<%
		if (request.getParameter("pType").startsWith("tINCASH")) {
	%>
	<tr>
		<td colspan="5" style="text-align: right;">Dinheiro <%=request.getParameter("moneyAmount")%></td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: right;">Troco <%=request.getParameter("moneyChange")%></td>
	</tr>
	<%
		} else {
	%>
	<tr>
		<td colspan="5"><%=request.getParameter("pTypeName")%></td>
	</tr>
	<%
		}
	%>
	<%
		} else {
	%>

	<tr>
		<td colspan="5">Pagamento online *</td>
	</tr>
	<%
		}
	%>

</table>




<hr />
<span style="font-style: italic;">ComendoBem.com.br - O site de
delivery mais gostoso da internet</span></div>
</div>
<div class="pagebreak"></div>
<br style="clear: both;" />
<div class="comanda" id="copiaRestaurante">

<div class="logo"
	style="float: left; text-align: center; font-size: large; margin-right: 10px;">
<img alt="diskfacil" src="/resources/img/diskfacil.jpg"
	style="width: 150px;"><br>
3251-5050</div>
<div class="logo" style="float: right; padding: 5px;"><img
	alt="wwwcomendobem.com.br" src="/resources/img/logo.png"
	style="height: 100px;"></div>
<div style="font-size: xx-large; text-align: left;">${order.xlatedId}<br /><%=r.getName()%></div>
<div style="padding: 5px; font-size: medium;">Data do pedido <fmt:formatDate
	pattern="kk:mm dd/MM/yyyy" value="${order.orderedTime}"
	timeZone="America/Sao_Paulo" /></div>
<hr style="clear: both;">
<div style="padding: 5px;"><span class="fieldLabel">Forma
de Pagamento:</span> <fmt:message key='payment.${order.payment.type}' /><br />
<span class="sectionTitle">Motoboy:</span> <br />
<span class="sectionTitle">Itens</span>
<table class="mytable" cellpadding="2px;">
	<th>Descri&ccedil;&atilde;o</th>
	<th>Qtd</th>
	<th>Pre&ccedil;o (R$)</th>
	<th>Valor (R$)</th>
	<c:forEach items="${order.plates}" var="plate">
		<tr>
			<td class="descItem">${plate.name}<c:if
				test="${not empty plate.forceRestInternalCode }">
				<span class="plateCode">c&oacute;digo
				${plate.forceRestInternalCode}</span>
			</c:if></td>
			<td class="qty">${plate.qty}</td>
			<td class="cost"><fmt:formatNumber pattern="##"
				minFractionDigits="2" minIntegerDigits="1">
				<c:out value="${plate.priceInCents/100.0}" default="0" />
			</fmt:formatNumber></td>
			<td class="cost"><fmt:formatNumber pattern="##"
				minFractionDigits="2" minIntegerDigits="1">
				<c:out value="${plate.qty*(plate.priceInCents/100.0)}" default="0" />
			</fmt:formatNumber></td>
	</c:forEach>
	<tr>

		<td class="descItem">Taxa entrega</td>
		<td class="qty">1</td>
		<td class="cost"></td>
		<td class="cost"><fmt:formatNumber pattern="##"
			minFractionDigits="2" minIntegerDigits="1">
			<c:out value="${order.deliveryCostInCents/100.0}" default="0" />
		</fmt:formatNumber></td>

	</tr>
	<c:if
		test="${not empty order.discountInfo and order.discountInfo.value>0}">
		<tr>
			<td class="descItem">Desconto</td>
			<td class="qty">1</td>
			<td class="cost"></td>
			<td class="cost">- <fmt:formatNumber pattern="##"
				minFractionDigits="2" minIntegerDigits="1">
				<c:out value="${order.discountInfo.value/100.0}" default="0" />
			</fmt:formatNumber></td>
			</td>
		</tr>
	</c:if>
	<tr>
		<td colspan=5 style="border: 0px; border-top: 3px solid black;"></td>
	</tr>
	<tr>
		<td colspan="5"
			style="text-align: right; font-weight: bold; font-size: large;">TOTAL:
		<span
			style="font-weight: bold; font-size: xx-large; text-align: right;"
			colspan="2">R$ <fmt:formatNumber pattern="##"
			minFractionDigits="2" minIntegerDigits="1">
			<c:out value="${order.totalAmountInCents/100.0}" default="0" />
		</fmt:formatNumber></span></td>
	</tr>

	<%
		if (request.getParameter("pType").startsWith("t")) {
	%>
	<%
		if (request.getParameter("pType").startsWith("tINCASH")) {
	%>
	<tr>
		<td colspan="5" style="text-align: right;">Dinheiro <%=request.getParameter("moneyAmount")%></td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: right;">Troco <%=request.getParameter("moneyChange")%></td>
	</tr>
	<%
		} else {
	%>
	<tr>
		<td colspan="5"><%=request.getParameter("pTypeName")%></td>
	</tr>
	<%
		}
	%>
	<%
		} else {
	%>

	<tr>
		<td colspan="5">Pagamento online *</td>
	</tr>
	<%
		}
	%>

</table>


<c:if test="${not empty order.observation}">
	<span class="sectionTitle">Observa&ccedil;&atilde;o do cliente:</span>
	<div
		style="width: 90%; border: 1px solid gray; padding: 5px; font-style: italic;">${order.observation
	}</div>
</c:if>

<hr />
<span style="font-style: italic;">ComendoBem.com.br - O site de
delivery mais gostoso da internet</span></div>
</div>
</body>
</html>