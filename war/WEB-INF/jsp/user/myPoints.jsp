<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb"
	tagdir="/WEB-INF/tags"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn"
	uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value='pt' />
<fmt:setBundle basename='messages' />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Meus pontos</title>

<cb:header />

<link href="/styles/user/profile.css" type="text/css" rel="stylesheet" />
<link href="/styles/user/manageOrders.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/user/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html"%>
<style>
label {
	display: inline-block;
	text-align: right;
	width: 150px;
}

th {
	background-color: #D9261C;
	color: white;
	font-weight: bold;
}

.pontos {
	   color: #EB7D4B;
    font-size: x-large;
    font-weight: bold;
}
.pontuacao{
	width: 100%;
	
}
</style>
<cb:body closedMenu="true">

	<jsp:include page="clientheader.jsp"><jsp:param
			name="isMyPoints" value="true"></jsp:param></jsp:include>

	<div>
	<div style="margin: 15px;">

	<h2>ComendoBem e com Vantagens</h2>

	<c:if
		test="${empty currentMonth or currentMonth.total==0}">
		<h3>Voc&ecirc; ainda n&atilde;o pontuou este m&ecirc;s</h3>
		<br>
	</c:if> <c:if test="${not empty currentMonth and currentMonth.total>0}">
			<div class="pontuacao">Este m&ecirc;s voc&ecirc; tem <span class="pontos">${currentMonth.total}</span> pontos.</div>
		<ul>
			<li>${currentMonth.myOrders} de pontos nos pedidos feitos por voc&ecirc;
			(um centavo vale 1 ponto do total do pedido).</li>
			<li>${currentMonth.confirmedInvitations} convites confirmados
			(${currentMonth.perInvitation} por confirma&ccedil;&atilde;o).</li>
			<li>${currentMonth.friendsOrders} pedidos feitos pelos seus
			convidados (${currentMonth.perFriendsOrder} por pedido).</li>
			

		</ul>

	</c:if></div>
	<div style="padding: 10px">No ComendoBem voc&ecirc; ganha pontos ao utilizar nosso
	site. Os clientes que fizerem mais pontos a cada m&ecirc;s ganham
	pr&ecirc;mios. <br>
	Os pontos tamb&eacute;m s&atilde;o convertidos em cupons para concorrer
	a pr&ecirc;mios todo m&ecirc;s.<br />
	Consulte o <a href="/regulamento.html">regulamento</a> e os <a
		href="premios.html">pr&ecirc;mios deste m&ecirc;s</a>.<br />


	<br>

	<c:if test="${fn:length(previousMonths)>0}">
			Hist&oacute;rico de pontos:<br>
		<table>
			<th>M&ecirc;s</th>
			<th>Convites confirmados</th>
			<th>Pedidos de amigos</th>
			<th>Pedidos pr&oacute;prios</th>
			<th>Total</th>
			</tr>
			<c:forEach var="pontos" items="${previousMonths }" varStatus="status">
				<tr>
					<td>${pontos.month+1}/${pontos.year}</td>
					<td>${pontos.confirmedInvitations}</td>
					<td>${pontos.friendsOrders}</td>
					<td>${pontos.myOrders}</td>
					<td>${pontos.total}</td>
				</tr>

			</c:forEach>
		</table>
	</c:if></div>
	</div>
</cb:body>
</html>