<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%session.removeAttribute("delayedPayment"); %>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description"
	content="ComendoBem.com.br - Veja como fazer seu pedido." />
<title>ComendoBem.com.br - Problemas no pagamento online</title>

<link href="../../styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html" %>
<cb:header />
</head>
<cb:body closedMenu="true">
<div class="fundoTelaEstatica">
<h2>Pagamento não autorizado</h2>

<p>O pagamento não foi autorizado pelo PayPal.</p>
São várias as possíveis causas para isso.<br> Visite a site do <a href="http://www.paypal.com" target="_blank">PayPal</a> ou contacte-os para maiores esclarecimentos.<br/>
<br>Para utilizar outras formas de pagamento no seu pedido <a href="/replaceOrder.do">clique aqui</a>
<br><br>
<button onclick="window.location='/replaceOrder.do'">Utilizar outra forma de pagamento</button>

</div>
</cb:body>
	
</html>