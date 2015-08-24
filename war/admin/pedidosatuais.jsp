<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.copacabana.util.TimeController"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/>
<%@page import="java.util.Locale"%>
<c:if test="${param.isMobile ne 'true'}">
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> <br>
</c:if>
<%
	StringBuilder sb = new StringBuilder();
	try {
		String patternDay = "kk:mm dd";
		SimpleDateFormat day = new SimpleDateFormat(patternDay, new Locale("pt", "br"));

		day.setTimeZone(TimeController.getDefaultTimeZone());
		
		OrderManager cman = new OrderManager();

		OrderManager om = new OrderManager();
		RestaurantManager rm = new RestaurantManager();
		List<MealOrder> mlist = new ArrayList<MealOrder>();
		if("true".equals(request.getParameter("showall"))){
			mlist = om.getAllNotDeliveredOrders();
		}else{
			mlist = om.getAllPendingOrders();
		}
		
%>
Lista de pedidos ativos no site às <%=day.format(new Date()) %>: 

<br />

<table >
	<thead>
	<tr>
		<th>Id</th>
		<th>Cliente</th>
		<th>Rest</th>
		
		<th>Ordered</th>
		<th>LastUpdt</th>
		<th>Status</th>
		<th></th>
		</tr>
	</thead>
	<tbody>
	
	<%
		for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
				MealOrder mo = iter.next();
	%><tr nowrap=nowrap>
		<td><%=mo.getClient().getId().getId()%> . <%=mo.getId().getId()%></td>
		<td><%=mo.getClientName()%></td>
		<td><span style="text-decoration: underline;cursor: help;" title="mail: <%=rm.getRestaurant(mo.getRestaurant()).getUser().getLogin() %> tel: <%=rm.getRestaurant(mo.getRestaurant()).getContact().getPhone() %>"><%=rm.getRestaurant(mo.getRestaurant()).getName()%></span><br> <%=rm.getRestaurant(mo.getRestaurant()).getContact().getPhone() %></td>
		
		<td><%=day.format(mo.getOrderedTime())%></td>
		<td><%=day.format(mo.getLastStatusUpdateTime())%></td>
		<td ><%=mo.getStatus().name()%></td>
		<td><a href="manageorder.jsp?id=<%=mo.getIdStr()%>">gerenciar</a></td>
		<td> <a href="cancelOrder.jsp?id=<%=mo.getIdStr()%>" >cancelar</a> </td>		
	</tr>
	<tr><td colspan=8><hr></td></tr>
	<%
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	</tbody>
</table>
<br><a href="pedidosatuais.jsp?isMobile=${param.isMobile }&showall=true">Mostrar todos</a> - <a href="pedidosatuais.jsp?isMobile=${param.isMobile }">Só pendentes</a><br/>
<br><br>
<c:if test="${param.isMobile}">
<a href="pedidosatuais.jsp?showall=${param.showall }">versão completa</a>
</c:if>
<c:if test="${empty param.isMobile or param.isMobile==false}">
<a href="pedidosatuais.jsp?showall=${param.showall }&isMobile=true">versão mobile</a>
</c:if>