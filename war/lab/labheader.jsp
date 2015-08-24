<%@page import="br.copacabana.Authentication"%><%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div style="margin-bottom:3px;padding-bottom: 5px;background-color: #D12516;">
<div id="logo"><div style="float: right;margin-right: 100px;"><a href="/pedidos.do" style="color: white;font-weight: normal;font-size: small;">Voltar para tela de pedidos</a></div><div class="headerImage"><img src="/resources/img/logo.png" style="height: 70px">Gerenciador de pedidos</div></div>

<div id="mainnav">
	    <ul id="orderprogress">
		<li id="lookup" class="<c:if test="${param.step eq 'lookup' }">current</c:if> before" onclick="window.location='searchUserByPhone.jsp'">
		    1. Busque o cliente</li>
		<li id="address" class="<c:if test="${param.step eq 'address' }">current</c:if> <c:if test="${param.step eq 'menuSelection' or param.step eq 'checkout'}">before</c:if>" <c:if test="${param.step eq 'menuSelection' or param.step eq 'checkout'}">onclick="window.location='selectDeliveryAddress.jsp?client=${param.client }'"</c:if>>
		    2. Endereço entrega</li>
		<li id="menuSelection" class="<c:if test="${param.step eq 'menuSelection' }">current</c:if> <c:if test="${param.step eq 'checkout'}">before</c:if>" <c:if test="${param.step eq 'checkout'}">onclick="window.location='startOrder.jsp?addressId=${param.addressId}&deliveryRangeCostInCents=${param.deliveryRangeCostInCents }&deliveryRangeId=${param.deliveryRangeId}&&client=${param.client }'"</c:if>>
		    3. Fazer pedido</li>
		<li id="checkout" <c:if test="${param.step eq 'checkout' }">class="current"</c:if>>4. Pagamento</li>
		<li class="last <c:if test="${param.step eq 'summary' }">current</c:if>" id="summary">5. Finalização</li>
	    </ul>
</div>
</div>