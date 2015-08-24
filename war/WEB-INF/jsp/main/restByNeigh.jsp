<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">

<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.Iterator"%><html>
<head>
<%
	NeighborhoodManager nman = new NeighborhoodManager();
	String neighborStr = request.getParameter("key");
	Key neighKey = KeyFactory.stringToKey(neighborStr);
	Neighborhood n = nman.find(neighKey, Neighborhood.class);

	Map<String, Object> m = new HashMap<String, Object>();
	m.put("neighborhood", neighKey);
	List<Restaurant> restList = new RestaurantManager().list("getRestaurantInNeighborhood", m);
	StringBuilder sb = new StringBuilder();
	sb.append(n.getName()).append(",").append(n.getCity().getName()).append(",");

	for (Iterator<Restaurant> iter = restList.iterator(); iter.hasNext();) {
		Restaurant r = iter.next();
		sb.append(r.getName()).append(",");
	}
	request.setAttribute("keywords", sb.toString());
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description"
	content="ComendoBem.com.br - Saiba quais bairros servimos delivery em <%=n.getCity().getName()%>." />
<title>ComendoBem.com.br - Restaurantes no <%=n.getName()%>, em
<%=n.getCity().getName()%>, com delivery do ComendoBem</title>

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
<cb:body closedMenu="true">

	<jsp:include page="/jsp/restByNeigh.jsp"></jsp:include>
</cb:body>
<%@include file="/scripts/ganalytics.js"%>
</html>