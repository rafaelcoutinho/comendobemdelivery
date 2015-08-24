<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>


<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta name="description"
	content="ComendoBem.com.br - Fale conosco. Entre em contato com nossa equipe." />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Comendo Bem - Fale conosco</title>

<link href="../../styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/user/login.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html"%>
<cb:header />
</head>
<cb:body closedMenu="true">

	<body onload="go()">
	<div id="conteudo_main" class="fundoTelaEstatica">
	<div style="margin: 10px 10px 10px 10px; width: 440px;" >
	<h2>Restaurante n&atilde;o encontrado.</h2>
	<br />
	Voc&ecirc; ser&aacute; redirecionado em 3 segundos...
	<br />
	<br />
	</div></div>
	</body>
	<script>

var redirect=function (){
	
	window.location='home.do'

}
function go(){
	setTimeout(redirect,3000);
}
 	
</script>
</cb:body>
</html>
