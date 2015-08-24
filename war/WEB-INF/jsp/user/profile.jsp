<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - Perfil do Usuário</title>
	
	<cb:header />
	
	<link href="/styles/user/profile.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/user/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<%@include file="/static/commonScript.html" %>
<script type="text/javascript" src="/scripts/pages/clientProfile.js"></script>
<style type="text/css">		
.dijitCheckBoxInput{
opacity:1;
}
#camposUsuario td{
padding-top: 10px
}
</style>
</head>
<cb:body closedMenu="true">
	
	<jsp:include page="clientheader.jsp" ><jsp:param name="isProfile" value="true"></jsp:param></jsp:include>
	
	<div id="dadosCadastrais" class="conteudo">
		<form id="dadosUsuario" method="post" dojoType="dijit.form.Form" action="/createUserJson.do">
		<input type="hidden" name="id" dojoType="dijit.form.TextBox" id="id">
		<div id="camposUsuario" >
		<table>
				<tr><td>
				<table>
				<tr><td><label for="name">Nome:</label></td><td><input id="name" width="273" cssClass="required requiredBig" name="name"
			class="mandatory" required="true" properCase="true" trim="true"
			dojoType="dijit.form.ValidationTextBox" />
				<span class="required">*</span></td></tr>
				<tr><td>
				<label for="email">E-mail:</label>
				</td><td>
				<input id="user.login" width="270"
			cssClass="required requiredBig" name="user.login" 
			class="mandatory" required="true" regExpGen="com.copacabana.util.emailFormat" trim="true"
			dojoType="dijit.form.ValidationTextBox"  />
			<span class="required">*</span>
			</td></tr>
			
			<tr><td>
				<label for="phone">Telefone:</label>
				</td><td>
			<input class="mandatory" required="true"
			dojoType="dijit.form.ValidationTextBox"  id="contact.phone" width="220" title='N&uacute;mero de telefone'
		cssClass="required" trim="true" name="contact.phone" regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN"/>
			<span class="required">*</span>
			</td></tr>
			
			<tr><td>
				<label for="rg">RG:</label> 
				</td><td>
			<input id="rg" width="292" name="rg" dojoType="dijit.form.TextBox"/>
			</td></tr>
			<tr><td>
				<label for="cpf">CPF:</label>
				</td><td>
			<input id="cpf" width="286" name="cpf" dojoType="dijit.form.TextBox" onBlur="checkCpf()"/> <span style="font-size: small;">(Campo opcional, uitilizado para nota fiscal com CPF)</span>
			</td></tr>
			
			<tr><td>
				<label for="bDay">Data de Nascimento:</label>
				</td><td>
			<input id="bDay" width="58" dojoType="dijit.form.DateTextBox" name="birthday"/>
			</td></tr>
			<tr><td>
				<label for="gender">Sexo:</label>
				</td><td>
				<input type="radio" name="gender" value="MALE" checked="checked" dojoType="dijit.form.RadioButton"/>Masculino
				<input type="radio" name="gender" value="FEMALE" dojoType="dijit.form.RadioButton"/>Feminino
			</td></tr>
			
			<tr><td colspan="2">
			<input id="receiveNewsletter" name="receiveNewsletter" type="hidden" dojoType="dijit.form.TextBox" value="off"></input>
				<input id="receiveNewslettercb" name="receiveNewslettercb" dojoType="dijit.form.CheckBox" value="on" onChange="if(dijit.byId('receiveNewslettercb').attr('value')==false){dijit.byId('receiveNewsletter').attr('value','false');}else{dijit.byId('receiveNewsletter').attr('value','on');}">
				
				<label for="receiveNewsletter"> Desejo receber  promoções e not&iacute;cias do Comendo Bem por e-mail.</label>
			</td></tr>
			
				</table>
				
				</td>
				</tr>
				<tr>
				<td align="center">
				<a href="javascript:submitForm()" id="submitButton">
					<img src="/resources/img/btSalvar.png" alt="salvar" />
				</a>
				</td>
				</tr>
				</table>	
			</div>
			
			</form>
			 <div id="preferencias" class="campos">
			 <label for="gender">Trocar senha:</label>
			 
		<form action="/changePwd.do" method="post" id="changePwd"
		name="changePwd" dojoType="dijit.form.Form">
		<div dojoType="dojox.form.PasswordValidator" name="newPwd" required="false" invalidMessage="Confirmacao de senha incorreta" lang="pt">
	<table align="center">
		<tr>
			<td><label for="name">Senha atual: </label></td>
			<td><input dojoType="dijit.form.TextBox" type="password"
				name="currentPwd" class="dijitTextBox dijitComboBox dijitSpinner"  style="margin:0px;" id="currentPwd">			<span class="required">*</span>
				</td>
		</tr>
		<tr>
			<td><label for="name">Nova senha: </label>			
			</td>
			<td><input dojoType="dijit.form.TextBox" type="text"
				name="newPasswd" pwType="new"> <span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="name">Confirme nova senha: </label></td>
			<td><input dojoType="dijit.form.TextBox" type="text"
				name="confirmNewPwd"  pwType="verify" >			<span class="required">*</span>
				</td>
		</tr>		
		<tr>
			<td colspan="2" align="center"><img
				src="/resources/img/btOk.png" alt="salvar"
				onclick="javascript:submitPwdChange()" /></td>
		</tr>
	</table></div>
	
	</form>
			 <%--
				
				
				<hr />
				
				Minhas comidas preferidas são:<br />
				
				<span class="option"><input type="checkbox" name="preferredFood" value="arabe" />Árabe</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="brasileira" />Brasileira</span>
				<br />
				
				<span class="option"><input type="checkbox" name="preferredFood" value="carnes" />Carnes</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="chinesa" />Chinesa</span>
				<br />
				
				<span class="option"><input type="checkbox" name="preferredFood" value="congelados" />Congelados</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="delicatessen" />Delicatessen</span>
				<br />
	
				<span class="option"><input type="checkbox" name="preferredFood" value="espanhola" />Espanhola</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="frutosDoMar" />Frutos do Mar</span>
				<br />
	
				<span class="option"><input type="checkbox" name="preferredFood" value="indiana" />Indiana</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="italiana" />Italiana</span>
				<br />
				
				<span class="option"><input type="checkbox" name="preferredFood" value="japonesa" />Japonesa</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="lanches" />Lanches</span>
				<br />
				
				<span class="option"><input type="checkbox" name="preferredFood" value="mexicana" />Mexicana</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="pizza" />Pizza</span>
				<br />
				
				<span class="option"><input type="checkbox" name="preferredFood" value="saladas" />Saladas</span>
				<span class="option"><input type="checkbox" name="preferredFood" value="vegetariana" />Vegetariana</span>
				<br />  --%>
			</div>
			
			<div id="barraEmbaixo" class="fundoCinza">
				
			</div>
		
	</div>

	
</cb:body>
</html>