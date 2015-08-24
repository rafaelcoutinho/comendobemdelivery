<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="barraWelcome">
<script>
var loggedUser = ${sessionScope.loggedUser};
var loggedClient = loggedUser.entity;
var id=loggedClient.id;
dojo.addOnLoad(function() {	
	dojo.byId("clientName").innerHTML=loggedClient.name;
});
</script>

<h2>Olá <span id="clientName" style="font-size: large;"></span>,</h2>
</div>
<c:if test="${!param.isOrderPage}">
<div id="abas" class="fundoCinza">
<a href="/meusDados.do" id="dadosLink" 
      <c:if test="${param.isProfile}">class="active"</c:if><c:if test="${!param.isProfile}">class="inactive"</c:if>>Meus Dados</a> <a
	href="/enderecos.do" id="addressesLink"
	<c:if test="${param.isAddresses}">class="active"</c:if><c:if test="${!param.isAddresses}">class="inactive"</c:if>>Endere&ccedil;os</a>
	<a
	href="/meusConvidados" id="inviteesLink"
	<c:if test="${param.isMyInvitations}">class="active"</c:if><c:if test="${!param.isMyInvitations}">class="inactive"</c:if>>Meus convidados</a>	
	<a href="/meusPedidos.do"
	id="orderLink" <c:if test="${param.isOrderStatusPage}">class="active"</c:if><c:if test="${!param.isOrderStatusPage}">class="inactive"</c:if>>Acompanhar Pedido</a>
	
	<a href="/historico.do"
	id="orderLink" <c:if test="${param.isOldOrderStatusPage}">class="active"</c:if><c:if test="${!param.isOldOrderStatusPage}">class="inactive"</c:if>>
	Hist&oacute;rico</a>
	<a href="/meusPontos"
	id="loyalyLink" <c:if test="${param.isMyPoints}">class="active"</c:if><c:if test="${!param.isMyPoints}">class="inactive"</c:if>>
	Pontos</a>
	
	
	
	</div>
</c:if>