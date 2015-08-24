<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%><html>
<head>
<%
	NeighborhoodManager nman = new NeighborhoodManager();
	String restaurantIdStr = request.getParameter("r");
	Key restaurantId = KeyFactory.stringToKey(restaurantIdStr);

	RestaurantManager restMan = new RestaurantManager();
	Restaurant r = restMan.find(restaurantId, Restaurant.class);

	request.setAttribute("keywords", r.getName() + ",regiao de entrega, regiao de delivery, pizzaria, restaurante, delivery");
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description"
	content="ComendoBem.com.br - Saiba quais bairros o restaurante <%=r.getName()%> faz entregas." />
<title>ComendoBem.com.br - Saiba quais bairros o restaurante <%=r.getName()%>
faz entregas.</title>

<link href="../../styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html"%>
<cb:header keywordsAppend="${keywords}" />

</head>
<body>
<div
	style="background-color: white; width: 380px; margin: 10px; padding: 15px;">
&Aacute;rea de entrega do <b><%=r.getName()%></b>:<br />
<ul>
	<%
		for (Iterator<DeliveryRange> iterP = r.getDeliveryRanges().iterator(); iterP.hasNext();) {
			DeliveryRange pp = iterP.next();
			Neighborhood othern = (Neighborhood) nman.find(pp.getNeighborhood(), Neighborhood.class);
	%><li><%=othern.getName()%> - <%=othern.getCity().getName()%></li>
	<%
		}
	%>
	<%%>
</ul>
</div>
</body>
<%@include file="/scripts/ganalytics.js"%>
</html>