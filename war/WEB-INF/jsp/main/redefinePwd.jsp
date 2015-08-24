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
	content="Redefinir minha senha" />
<title>ComendoBem.com.br - Redefinir senha</title>
<%@include file="/static/commonScript.html" %>
<cb:header />
</head>
<cb:body closedMenu="true">
<div class="fundoTelaEstatica">
<c:if test="${empty entity or entity ne 'pwdUpdated' }">
<h2>Redefina a sua senha</h2><br>
<c:if test="${not empty entity and entity eq 'pwdsDontMatch'}">
<span style="color: red">* Senhas n&atilde;o s&atilde;o iguais. </span><Br> 
</c:if>
<c:if test="${not empty entity and entity eq 'notValidPwd'}">
<span style="color: red">* Senhas devem ter ao menos 1 caracter. </span><Br> 
</c:if>

<form action="/redefinir.do" method="post">
<input type="hidden" name="t" value="${param.t }">
<input type="hidden" name="i" value="${param.i }">
Nova senha: <input type="password" name="newPwd"/><br/>
Confirmar senha: <input type="password" name="newPwd2"/><br/>
<input type="submit" value="Enviar">
</form>
</c:if>

<c:if test="${not empty entity and entity eq 'pwdUpdated'}">
<h2>Senha atualizada com sucesso</h2> <br>
<a href="/home.do">Clique aqui</a> para ir para a p&aacute;gina principal e utilizar o ComendoBem.<br/>

</c:if>

</div>
</cb:body>
</html>