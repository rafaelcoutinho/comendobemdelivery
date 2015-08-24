<%@page import="com.google.appengine.api.taskqueue.TaskOptions.Method"%>
<%@page import="com.google.appengine.api.taskqueue.TaskOptions"%>
<%@page import="com.google.appengine.api.taskqueue.QueueFactory"%>
<%@page import="com.google.appengine.api.taskqueue.Queue"%>
<%@page import="br.copacabana.OrderDispatcher"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.usecase.beans.UpdateOrderStatus"%>
<%@page import="br.com.copacabana.cb.entities.MealOrderStatus"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn"
	uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%><%@page
	import="com.google.gson.JsonParser"%><%@page
	import="com.google.gson.JsonElement"%><%@page
	import="com.google.gson.JsonObject"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt' />
<%
	Key id = KeyFactory.stringToKey(request.getParameter("id"));
	OrderManager om = new OrderManager();
	MealOrder mo = om.get(id);
	RestaurantManager rm = new RestaurantManager();
	if (request.getParameter("obs") != null) {
		mo.setStatus(MealOrderStatus.CANCELLED);		
		new OrderDispatcher().removeOrder(mo);
		mo.setReason(request.getParameter("obs"));
		om.persist(mo);
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(TaskOptions.Builder.withUrl("/tasks/onOrderCancelled.do").param("id", KeyFactory.keyToString(mo.getId())).method(Method.GET));
		response.sendRedirect("pedidosatuais.jsp");
		
	}
	request.setAttribute("order", mo);
%><jsp:include page="/admin/adminHeader.jsp"></jsp:include>
<br>
Voce quer mesmo cancelar o pedido:
<b><%=mo.getXlatedId()%></b>
<br>
De:
<%=mo.getClientName()%>
-
<%=mo.getClient().getMainPhone()%>
-
<%=mo.getClient().getUser().getLogin()%>
- isFB:<%=mo.getClient().getUser().getIsFacebook()%><br>
Para: <%=rm.get(mo.getRestaurant()).getName()%><br>
Data:
<fmt:formatDate value="${order.orderedTime}" type="both"
	timeStyle="long" dateStyle="short" pattern="dd MMMM 'às' kk:mm"
	timeZone="America/Sao_Paulo" />
<br>
Status:
<%=mo.getStatus().name()%><br>
<small> IP:<%=mo.getClientIp()%><br>
Lat/Lng: <%=mo.getY()%>,<%=mo.getX()%><br>
</small>
<form action="cancelOrder.jsp" onsubmit="return confirm('Tem certeza?');"><input name="id" type="hidden"
	value="${param.id }"> Justificativa para o cliente:<br><textarea
	rows="4" cols="80" name="obs"></textarea><br>
	<input type="submit" value="CANCELAR PEDIDO">
</form>