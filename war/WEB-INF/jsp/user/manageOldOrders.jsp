<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%><html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - Histórico de Pedidos</title>
	
	<cb:header />
	
	<link href="/styles/user/profile.css" type="text/css" rel="stylesheet" />
	<link href="/styles/user/manageOrders.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/user/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<%@include file="/static/commonScript.html" %>
<script type="text/javascript">
	dojo.require("com.copacabana.order.UserViewOrderWidget");
</script>	
	
</head>
<cb:body closedMenu="true">
	<jsp:include page="clientheader.jsp" ><jsp:param name="isOldOrderStatusPage" value="true"></jsp:param></jsp:include>
	<br/>
	<div dojoType="com.copacabana.order.UserViewOrderWidget" statusList="'CANCELLED,EXPIRED,DELIVERED,EVALUATED'" muteStatusMsgs="true">
	</div> 
	
	
</cb:body>
</html>