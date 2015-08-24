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
	content="Saiba como incluir o seu restaurante no ComendoBem." />
<title>ComendoBem - Identifica&ccedil;ão do Restaurante</title>
<cb:header />

<link href="/styles/user/login.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/user/login_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html" %>
<script type="text/javascript">
var loggedUser= <c:out value='${sessionScope.loggedUser}' default='null'/>;		
</script>
<script type="text/javascript" src="/scripts/pages/registroRestaurante.js"></script>
<style type="text/css">
#camposUsuario td {
	text-align: right;
}
.campos input {
	margin: 0px;
}
</style>
</head>
<cb:body closedMenu="true">
	<div id="login" baseClass="quadrado" style="height: 120px;"
		dojoType="com.copacabana.UserProfileWidget"
		templateStr="loginTemplate" forwardPage="'${param.forwardUrl}'"></div>


	<div class="fundoCinza" id="titulo">
	<h2>Estabelecimento n&atilde;o cadastrado</h2>
	</div>
	<div style="margin: 10px;">
	<p>O ComendoBem permite que seu restaurante ou estabelecimento de delivery tenha acesso a um novo canal de vendas, aumentando seu volume de delivery, pelo acesso de milhares de usu&aacute;rios cadatrados no portal. Disponibilizamos para seu estabelecimento um sistema de card&aacute;pio on-line completo e interativo, permitindo que os usu&aacute;rios da Internet possam efetuar o pedido de forma r&aacute;pida e f&aacute;cil.</p>
<p>Os pedidos recebidos para seu restaurante no site s&atilde;o enviados a seu estabelecimento por meios totalmente automatizados, eliminando erros na elabora&ccedil;&atilde;o do pedido, comuns quando realizados por telefone.</p>
<p>Se seu restaurante tem site voc&ecirc; pode utilizar o sistema de pedidos on-line para receber tamb&eacute;m de seu site, sem custo de compra de sistema ou manuten&ccedil;&atilde;o mensal. Tenha ao seu dispor o mais completo sistema de pedidos on-line, E SEM NENHUM CUSTO DE AQUISI&Ccedil;&Atilde;O OU MENSALIDADE!!</p>
<p>Preencha o formul&aacute;rio abaixo, ou se preferir entre em contato com o ComendoBem no telefone 19 2139.7292 ou pelo email contato@comendobem.com.br.</p>
</div>
	<div class="fundoCinza" id="titulo">
	<h2> Formul&aacute;rio de contato</h2>
	
	(<span class="required">*</span>) Campos obrigat&oacute;rios
</div>
	<form id="dadosUsuario" method="post" dojoType="dijit.form.Form"
		action="/enviaContatoRestaurante.do">
	<div style="display: block;margin: 20px 20px 70px 20px;">
	<table border="0">
		<tr>
			<td><label for="name">Nome do restaurante:</label></td>
			<td><input type="text" id="name" width="273" class="mandatoryf" trim="true"
				name="name" dojoType="dijit.form.ValidationTextBox" required="true" />
			<span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="name">Nome da pessoa respons&aacute;vel:</label></td>
			<td><input type="text" id="contactName" width="273" class="mandatoryf" trim="true"
				name="name" dojoType="dijit.form.ValidationTextBox" required="true" />
			<span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="email">E-mail:</label></td>
			<td><input type="text" id="user.login" width="270"
				class="mandatoryf" required="true" name="email" trim="true" regExpGen="com.copacabana.util.emailFormat" invalidMessage="E-mail inv&aacute;lido."
				dojoType="dijit.form.ValidationTextBox" /> <span class="required">*</span>
			</td>
		</tr>
		<tr>
			<td><label for="phone">Telefone:</label></td>
			<td><input type="text" dojoType="dijit.form.ValidationTextBox"
				id="contact.phone" width="220" required="true" class="mandatoryf"  trim="true"  regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN"
				cssClass="required" name="phone" required="true"
				class="mandatory" /> <span class="required">*</span></td>
		</tr>
		
		</table>
		</div>
		
	</form>
	<div id="barraEmbaixo" class="fundoCinza"><a
		href="javascript:submitForm()" id="submitButton"> <img
		src="/resources/img/btConfirmar.png" alt="confirmar" /> </a></div>


	
	<br/>
	<br />
	<br />
	
</cb:body>
</html>