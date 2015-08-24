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
<title>ComendoBem - Identificação do Usuário</title>
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
<script>
var executeLogin=function(isFacebook,fbuser){
	com.copacabana.util.showLoading();
	var success=function(){		
		<c:if test="${not empty param.forwardUrl}">
		window.location='${param.forwardUrl}';
		</c:if>
		<c:if test="${empty param.forwardUrl}">
		window.location='/home.do';
		</c:if>
	}
	com.copacabana.util.executeLogin('','',true,fbuser,success,function(response){com.copacabana.util.hideLoading();alert("Erro ao iniciar sessão.")});
	
}
</script>
</head>
<cb:body closedMenu="true">
<div style="padding: 10px;">
	<h2>Quero acessar o ComendoBem com meu Facebook</h2>	
	<a class="fb_button fb_button_medium" target="_fbauth" href="/fbresponse.jsp"  ><span class="fb_button_text">Conectar com Facebook</span></a>
<br />
</div>
<div  class="fundoCinza" style="text-align: center;font-size: large;">
ou
</div><br>
	<div id="camposUsuario" style="width:375px;padding:5px;margin:0px;margin-left:10px;margin-right: 10px;" >
	
	<h2>Quero me cadastrar no ComendoBem</h2>	
	<form id="dadosUsuario" method="post" dojoType="dijit.form.Form"
	action="/registerNewUser.do">
	<table border="0">
		<tr>
			<td><label for="name">Nome:</label></td>
			<td><input type="text" id="name" width="273" class="required"
				name="name" dojoType="dijit.form.ValidationTextBox" required="true" trim="true" properCase="true"/>
			<span class="required">*</span></td>
		</tr>

		<tr>
			<td><label for="email">E-mail:</label></td>
			<td><input type="text" id="user.login" width="270"
				class="required" required="true" name="user.login" regExpGen="com.copacabana.util.emailFormat"
				dojoType="dijit.form.ValidationTextBox" trim="true"/> <span class="required">*</span>
			</td>
		</tr>
		<%--<tr>
			<td><label for="phone">Telefone:</label></td>
			<td><input type="text" dojoType="dijit.form.ValidationTextBox"
				id="contact.phone" width="220" required="true" class="required"
				cssClass="required" name="contact.phone" required="true" regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN" trim="true" 
				class="required" /> <span class="required">*</span></td>
		</tr> --%>	
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
		</tr><tr><td></td><td style="font-size: x-small;">(<span class="required">*</span>) Campos obrigat&oacute;rios</td></tr>

	</table>
	
	<input type="checkbox" name="receiveNewsletter" id="receiveNewsletter"
		checked="checked" /> <span style="font-size: x-small;">Desejo receber  promoções e not&iacute;cias do ComendoBem por e-mail.</span>

	</form>
	<br><div style="text-align: right;margin-right:15px;">
	<button baseClass="orangeButton" dojoType="dijit.form.Button" onClick="submitForm"  >Cadastrar</button>
	</div>
	<br/>
	</div>
	<div id="camposEndereco" class="adjustHeight campos" style="padding:5px">
	
	<h2>J&aacute; sou cadastrado</h2>
	
	
	<div id="login" baseClass="quadrado" style="height: 120px;"
		dojoType="com.copacabana.UserProfileWidget"
		templateStr="loginTemplate" forwardPage="'${param.forwardUrl}'"></div>
	
	</div>
	<br style="clear: both;"/>
	

	
	<br/>
	<br style="clear:both;"/>
	<br />
	
</cb:body>
</html>