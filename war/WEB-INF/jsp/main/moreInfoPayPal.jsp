<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>


<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description"
	content="ComendoBem.com.br - Pagamento via PayPal." />
<title>ComendoBem.com.br - Pagamento via PayPal</title>

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
<body>
<div style="background-color: white;width: 380px;margin: 10px;padding: 15px;">
<h2>Sobre o pagamento online</h2>

<p>O ComendoBem utiliza o PayPal como parceiro de pagamento online.</p>
<p>Ao fazer seu pagamento no ComendoBem via PayPal o voc&ecirc; s&oacute; ser&aacute; cobrado quando o restaurante aceitar seu pedido.<br/>
Os passos s&atilde;o:<ul><li>Voc&ecirc; faz uma autoriza&ccedil;&atilde;o de cobran&ccedil;a para o ComendoBem no PayPal.</li>
<li>Quando o restaurante recebe seu pedido e confirma, o ComendoBem utiliza a autoriza&ccedil;&atilde;o para realizar a cobran&ccedil;</li>
<li>Caso o restaurante cancele ou n&atilde;o confirme seu pedido o ComendoBem cancela a autoriza&ccedil;&atilde;o e <b>nada &eacute; cobrado</b> de voc&ecirc;</li> 
</ul>
</p>
<p>Viu como &eacute; f&aacute;cil e seguro pagar seu delivery online pelo ComendoBem!</p>
 
</div>
</body>
<%@include file="/scripts/ganalytics.js"%>
</html>


	
</html>

