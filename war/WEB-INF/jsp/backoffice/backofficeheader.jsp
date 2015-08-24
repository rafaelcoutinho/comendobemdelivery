<%@page import="com.google.appengine.api.users.UserService"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="barraWelcome">

<%UserService userService = UserServiceFactory.getUserService(); String thisURL = request.getRequestURI();%>
<h2><%= "Olá " + request.getUserPrincipal().getName() + "  <a href=\"" + userService.createLogoutURL(thisURL) + "\">sign out</a>"%><span id="restName" style="font-size: large;"></span></h2>
</div>

<div id="abas" class="fundoCinza">
	
	<a href="/backoffice/listRestaurantes.do" id="dadosLink"
	<c:if test="${param.isMyRests}">class="active"</c:if><c:if test="${!param.isMyRests}">class="inactive"</c:if>>Estabelecimentos</a>
	 
	<a href="/backoffice/monitorar.do"
	id="cardapioLink" <c:if test="${param.isOrders}">class="active"</c:if><c:if test="${!param.isOrders}">class="inactive"</c:if>>Monitorar</a>
	<a href="/backoffice/fechamento.do"
	id="cardapioLink" <c:if test="${param.isConsolidation}">class="active"</c:if><c:if test="${!param.isConsolidation}">class="inactive"</c:if>>Fechamento</a>
	<a href="/backoffice/listFeedbacks.do"
	id="cardapioLink" <c:if test="${param.isFeedbacks}">class="active"</c:if><c:if test="${!param.isFeedbacks}">class="inactive"</c:if>>Feedbacks</a>
	
	
	
</div>
	
	
