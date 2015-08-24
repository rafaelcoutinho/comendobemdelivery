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
<script type="text/javascript" src="/scripts/pages/registro.js"></script>
<style type="text/css">
#camposUsuario td {
	text-align: right;
}
.campos input {
	margin: 0px;
}
label{
width: 120px;
display: block;

}
</style>
</head>
<cb:body closedMenu="true">
	<div id="titulo">
	<h2>Ol&aacute; ${invitation.name}, seja bem-vindo ao ComendoBem</h2>
	</div>
	<div style="margin: 15px;">
	<p>Voc&ecirc; foi convidado por <b>${inviter.name}</b> para participar do nosso site. No ComendoBem voc&ecirc; pode fazer pedidos online a diversos restaurantes e estabelecimentos da cidade.</p>
	<p>Al&eacute;m disso voc&ecirc; participa do nosso programa de vantagens onde a cada ponto ganho no nosso programa voc&ecirc; concorre a pr&ecirc;mios. Voc&ecirc; pode ganhar pontos convidando amigos, fazendo pedidos e at&eacute; mesmo com os pedidos de seus convidados.</p>
	<p style="font-weight: bold;">Cadastre-se j&aacute; e bom apetite!</p>
	</div>
	<form id="dadosUsuario" method="post" dojoType="dijit.form.Form"
	action="/registerNewUser.do">
	<input type="hidden" name="invitationId" value="${invitation.id}">
	<div style="margin-left:10px;">
	<table border="0">
		<tr>
			<td><label for="name">Nome:</label></td>
			<td><input type="text" id="name" width="273" class="required" value="${invitation.name }"
				name="name" dojoType="dijit.form.ValidationTextBox" required="true" trim="true" properCase="true"/>
			<span class="required">*</span></td>
		</tr>

		<tr>
			<td><label for="email">E-mail:</label></td>
			<td><input type="text" id="user.login" width="270"  value="${invitation.email}"
				class="required" required="true" name="user.login" regExpGen="com.copacabana.util.emailFormat"
				dojoType="dijit.form.ValidationTextBox" trim="true"/> <span class="required">*</span>
			</td>
		</tr>
		<tr>
			<td><label for="phone">Telefone:</label></td>
			<td><input type="text" dojoType="dijit.form.ValidationTextBox"
				id="contact.phone" width="220" required="false" 
				name="contact.phone" required="true" regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN" trim="true" 
				 /></td>
		</tr>
		
	
		<tr>
			<td colspan="2">
			<div dojoType="dojox.form.PasswordValidator" name="user.password"
				class="required" required="true" id="pwdVal">
			<table border="0">
				<tr>
					<td><script type="dojo/method" event="pwCheck" args="pwdVal">                
                return password != ""
            	</script> <label for="newPassword">Senha:</label></td>
					<td><input type="text" dojoType="dijit.form.TextBox"
						name="user.password" pwType="new" type="password" /> <span
						class="required">*</span></td>
				</tr>

				<tr>
					<td><label for="confirmPassword">Confirmar Senha:</label></td>
					<td><input type="text" dojoType="dijit.form.TextBox"
						type="password" pwType="verify" /> <span class="required">*</span>

					</td>
				</tr>
			</table>
			</div>
			</td>
		</tr>

	</table>
	<input type="checkbox" name="receiveNewsletter" id="receiveNewsletter"
		checked="checked" /> Desejo receber  promo&ccedil;&otilde;es e not&iacute;cias do Comendo Bem por e-mail.</div>

	</form>
	<br style="clear: both;"/>
	<div id="barraEmbaixo" class="fundoCinza" style="margin-top:10px;"><a
		href="javascript:submitForm()" id="submitButton"> <img
		src="/resources/img/btCadastrar.png" alt="cadastrar" /> </a></div>


	
	<br/>
	<br />
	<br />
	<div style="display: none;"> 
	<div id="login" baseClass="quadrado" style="height: 120px;"
		dojoType="com.copacabana.UserProfileWidget"
		templateStr="loginTemplate" forwardPage="'${param.forwardUrl}'"></div>
		</div>
</cb:body>
</html>