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
	content="ComendoBem.com.br - Registre-se ou autentique seu usuario. Faca seu cadastro no comendobem.com.br" />
<title>ComendoBem - Convite</title>
<cb:header />

<link href="/styles/user/login.css" type="text/css" rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/user/login_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html"%>
<script type="text/javascript">
	var loggedUser = <c:out value='${sessionScope.loggedUser}' default='null'/>;
</script>
<script type="text/javascript" src="/scripts/pages/registro.js"></script>
<style type="text/css">
#camposUsuario td {
	text-align: right;
}

.campos input {
	margin: 0px;
}

label {
	width: 120px;
	display: block;
}
</style>
</head>
<cb:body closedMenu="true">
	<div id="titulo"><c:if test="${param.err==1}"><div style='color:red'>E-mail n&atilde;o encontrado em nossa base.</div></c:if>
	<c:if test="${param.err==2}"><div>E-mail foi removido de nossa base com sucesso.</div></c:if>
	<h2>Remover e-mail da Newsletter do ComendoBem</h2>
	</div>
	<div style="margin: 15px;">
	<form action="/removeEmail" method="post">
	<p>Por favor, forne&ccedil;a seu email:<input type="text"
		name="email">.</p>
	<br>
	Esperamos rev&ecirc;-lo novamente participando da nossa newsletter.
	Ajude-nos a melhorar o nosso servi&ccedil;o, Ficaremos gratos se
	voc&ecirc; puder nos dizer porque est&aacute; se descadastrando:<br>
	<textarea rows="4" cols="100" name="comments"></textarea>
	<input type="submit" value="Enviar"/>
	</form>
	</div>
	
</cb:body>
</html>