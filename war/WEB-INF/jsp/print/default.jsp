<%@page import="br.copacabana.spring.AddressManager"%><%@page import="br.com.copacabana.cb.entities.Address"%><%@page import="br.com.copacabana.cb.entities.MealOrder"%><%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/><fmt:setBundle basename='messages'/><html>
<head>
<title>ComendoBem - ${order.xlatedId }</title>
<style type="text/css">
@media print {
  @page{
   display: none; 
  }
  @page :left { 
  	margin: 0;
  	size: 20em 100mm;  	 	
  } 
 
  #printSection{
  display:block;
  }
  @page :right {
  display: none; 
  }
}
</style>
</head>
<body style="width: 20em;min-height:600px;" onload="window.print()">
<div id="printSection" style="border: solid black 1px;">
<div style="font-family: monospace;padding: 5px;">
<div style="font-weight: bold;text-align: center;">Pedido 
<c:if test="${not empty order.dailyCounter && order.dailyCounter>0 }">
# ${order.dailyCounter } (${order.xlatedId})</div><br/>
</c:if>
Data: <fmt:formatDate value="${order.orderedTime}" type="both" timeStyle="long" dateStyle="short" pattern="dd MMMM 'às' kk:mm" timeZone="America/Sao_Paulo" /> <br/>
-------------------------------------<br/>
<b>Cliente</b> <br>
 Nome: ${order.clientName}<br/>
 Telefone: ${order.clientPhone}<br/>
 <c:if test="${not empty order.cpf}"> 
 CPF: ${order.cpf}<br/>
 </c:if>
-------------------------------------<br/>
<b>Itens</b><br/>
<table>
<th>Qtd</th><th>Desc.</th><th>Unit.</th><th>Valor</th>
<c:forEach items="${order.plates}" var="plate">
<tr style="vertical-align: top;"><td>${plate.qty}</td>
<td style="width: 100px;">${plate.name}</td>
<td>R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${plate.priceInCents/100.0}" default="0"/></fmt:formatNumber></td>
<td>R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${plate.qty*(plate.priceInCents/100.0)}" default="0"/></fmt:formatNumber></td>
</c:forEach>
<tr><td>1</td><td>Custo entrega</td><td>-</td><td>R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.deliveryCostInCents/100.0}" default="0"/></fmt:formatNumber></td></td></tr>
<c:if test="${not empty order.discountInfo and order.discountInfo.value>0}">
<tr><td>1</td><td>Deconto</td><td>-</td><td>R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.discountInfo.value/100.0}" default="0"/></fmt:formatNumber></td></td></tr>
</c:if>
<tr><td colspan=5>-------------------------------------</td></tr>
<tr><td colspan="3" style="text-align: right;font-weight: bold;">TOTAL</td><td style="font-weight: bold;">R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.totalAmountInCents/100.0}" default="0"/></fmt:formatNumber></td></tr>
<tr><td colspan="3">
<c:if test="${order.payment.type eq 'INCASH'}">
Dinheiro    R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.payment.amountInCash}" default="0"/></fmt:formatNumber><br> 
Troco       R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.payment.amountInCash-(order.totalAmountInCents/100.0)}" default="0"/></fmt:formatNumber>
</c:if>
<c:if test="${order.payment.type ne 'INCASH'}">
Pagamento: <fmt:message key='payment.${order.payment.type}'/>
<c:if test="${order.payment.type eq 'PAYPAL' }">
<br>* NECESSARIO DOCUMENTO DE * <br>
* IDENTIDADE E ASSINATURA *<br></c:if>
</c:if>
</td></tr>
</table>
-------------------------------------<br/>
<c:if test="${order.retrieveAtRestaurant}">
 Pedido a ser retirado no estabelecimento.
</c:if>
<c:if test="${order.retrieveAtRestaurant==false}">
<%
MealOrder mo = (MealOrder) request.getAttribute("order");
Address add = new AddressManager().get(mo.getAddress());
request.setAttribute("address", add);
%>
End. Entrega:<br/>	
<i>${address.street}, ${address.number}<br/>
<c:if test="${not empty address.additionalInfo}"> ${address.additionalInfo} - </c:if>${address.neighborhood.name}<br/>
<span class="fieldLabel">Tel:</span> ${address.phone }</i><br/>
</c:if>
<c:if test="${not empty order.observation}">
-------------------------------------<br/>
Observa&ccedil;&atilde;o<br/>
<div style="width: 21em;border: 1px solid gray;padding:3px;">${order.observation }</div>

</c:if>
-------------------------------------<br/>
ComendoBem.com.br 
- O seu site de delivery online
</div>
</div>

</body>
</html>