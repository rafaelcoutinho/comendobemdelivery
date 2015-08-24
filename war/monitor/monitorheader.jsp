<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="barraWelcome">
<script>


</script>


</div>

<div id="abas" class="fundoCinza"><a href="monitorOrders.jsp" id="dadosLink"
	<c:if test="${param.isMonitoring}">class="active"</c:if><c:if test="${!param.isMonitoring}">class="inactive"</c:if>>Monitora&ccedil;&atilde;o</a>
	<a href="monitorLogins.jsp" id="dadosLink" 
	<c:if test="${param.isSession}">class="active"</c:if><c:if test="${!param.isSession}">class="inactive"</c:if>>Logados</a>  
	
	</div>
	
	
