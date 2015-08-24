<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="com.google.appengine.api.datastore.Key"%>

<html>
<head><link href="/styles/labstyle.css" rel="stylesheet" type="text/css" />
<link
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></
	$(document).ready(function()
 {
				
	});
	</script>
</head>
<body>
<jsp:include page="labheader.jsp"><jsp:param value="summary" name="step"/></jsp:include>
<div class="body">
<div id="header">Pedido registrado</div>
Código para acompanhamento: ${param.trac }<br>
<a href="/printOrder?orderId=${param.orderId}" target="_blank"><img border=0 src="/resources/img/printer.png"> Imprimir</a>
<a href="/pedidos.do">Ir para monitoramento de pedidos</a>
</div>
</body>

</html>