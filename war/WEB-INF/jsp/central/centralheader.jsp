<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="barraWelcome">
<script>

</script>

<h2><span id="restName" style="font-size: large;"></span></h2>
</div>

<div id="abas" class="fundoCinza">
	<a href="/central/profile.do" id="dadosLink"
	<c:if test="${param.isProfile}">class="active"</c:if><c:if test="${!param.isProfile}">class="inactive"</c:if>>Dados cadastrais</a>
	<a href="/central/configuracoes.do" id="dadosLink"
	<c:if test="${param.isConfs}">class="active"</c:if><c:if test="${!param.isConfs}">class="inactive"</c:if>>Funcionalidades</a>
	<a href="/central/meusRestaurantes.do" id="dadosLink"
	<c:if test="${param.isMyRests}">class="active"</c:if><c:if test="${!param.isMyRests}">class="inactive"</c:if>>Meus estabelecimentos</a>
	 
	<a href="/central/monitorar.do"
	id="cardapioLink" <c:if test="${param.isOrders}">class="active"</c:if><c:if test="${!param.isOrders}">class="inactive"</c:if>>Pedidos</a>
	<a href="/central/fechamento.do"
	id="cardapioLink" <c:if test="${param.isConsolidation}">class="active"</c:if><c:if test="${!param.isConsolidation}">class="inactive"</c:if>>Fechamento</a>
	
	<a href="/central/trocarSenha.do"
	id="cardapioLink" <c:if test="${param.isPwd}">class="active"</c:if><c:if test="${!param.isPwd}">class="inactive"</c:if>>Trocar senha</a>
	
</div>
	
	
