<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.com.copacabana.cb.entities.DiscountType"%>
<%@page import="br.com.copacabana.cb.entities.DiscountCoupom"%>
<%@page import="br.com.copacabana.cb.entities.mgr.DiscountManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb"
	tagdir="/WEB-INF/tags"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn"
	uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value='pt' />
<fmt:setBundle basename='messages' />
<%

	if(request.getParameter("openOrder")!=null){
		String code = request.getParameter("openOrder");
		MealOrder m = new OrderManager().getMealOrderByDiscount(code);
		response.sendRedirect("manageorder.jsp?id="+m.getIdStr());
	}
	DiscountManager dm = new DiscountManager();

	DiscountCoupom d = new DiscountCoupom();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	List<DiscountCoupom> existing = new ArrayList<DiscountCoupom>();
	if ("create".equals(request.getParameter("action"))) {

		DiscountType t = DiscountType.valueOf(request.getParameter("type"));
		d.setType(t);
		d.setValue(Integer.parseInt(request.getParameter("value")));
		Date dd = sdf.parse(request.getParameter("validade"));
		d.setExpireDate(dd);
		String[] restKeysStr = request.getParameterValues("validRestsOnly");
		if (restKeysStr != null) {
			for (int i = 0; i < restKeysStr.length; i++) {
				Key k = KeyFactory.stringToKey(restKeysStr[i]);
				d.getValidRestaurants().add(k);
			}
		}

		d = dm.create(d);
	}
	if ("delete".equals(request.getParameter("action"))) {
		
		DiscountCoupom disc= dm.get(request.getParameter("id"));
		Datastore.getPersistanceManager().getTransaction().begin();			
		Datastore.getPersistanceManager().remove(disc);
		Datastore.getPersistanceManager().getTransaction().commit();		
	}

	existing = dm.list();
	request.setAttribute("list", existing);
%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br />
Code:<%=d.getCode()%><br>
<form action="manageCupom.jsp"><input type="hidden" name="action"
	value="create"> Tipo:<select name="type">
	<option value="<%=DiscountType.VALUE.name()%>"><%=DiscountType.VALUE.name()%></option>
	<option value="<%=DiscountType.FREE_DELIVERY.name()%>"><%=DiscountType.FREE_DELIVERY.name()%></option>
	<option value="<%=DiscountType.PERCENTAGE.name()%>"><%=DiscountType.PERCENTAGE.name()%></option>
</select><br>
Valor: <input type="text" name="value"><br>
Validade: <input type="text" name="validade" value="12/12/2011"><br>
<br>
Restaurante:<select name="validRestsOnly" multiple="multiple">


	<%
		RestaurantManager rm = new RestaurantManager();
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
	%><option value="<%=restKey%>"><%=r.getName()%></option>
	<%
		}
	%>
</select> <input type="submit"></form>
<hr>
<table cellpadding="1">
	<tr>
		<th>Código</th>
		<th>crc</th>
		<th>Tipo</th>
		<th>Valor</th>
		<th>Validade</th>
		<th>estado</th>
		<th>Restaurantes</th>
	</tr>
	<c:forEach items="${list}" var="discount">
		<tr style="vertical-align: top;">
			<td>${discount.code}</td>
			<td>${discount.crc}</td>
			<td>${discount.type }</td>
			<td>${discount.value}</td>
			<td><fmt:formatDate value="${discount.expireDate}" type="date"
				timeStyle="long" dateStyle="short" timeZone="America/Sao_Paulo" />
			</td>
			<td>${discount.status} <c:if test="${discount.status eq 'USED'}"><a href="manageCupom.jsp?openOrder=${discount.code}">ver pedido</a></c:if></td>
			<td><c:forEach items="${discount.validRestaurants}" var="rest">
				<%
					Key str = (Key) pageContext.getAttribute("rest");
				%><%=rm.get(str).getName()%><br>
			</c:forEach></td>
			<td><a href="manageCupom.jsp?action=delete&id=${discount.code}">apagar</a></td>
	</c:forEach>
</table>