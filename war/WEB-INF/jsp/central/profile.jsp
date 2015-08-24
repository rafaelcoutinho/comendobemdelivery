<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Dados de Central</title>

<cb:header />

<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
	<link href="/styles/restaurant/profile_ie_8.css" type="text/css"
		rel="stylesheet" />
</c:if>
</head>
<%@include file="/static/commonScript.html"%>

<style>
.requiredBig {
	font-size: medium;
}

.adjustHeight {
	height: auto;;
}
</style>
<cb:body closedMenu="true">

	<jsp:include page="centralheader.jsp"><jsp:param
			name="isProfile" value="true"></jsp:param></jsp:include>
	<div id="dadosCadastrais" class="conteudo">
	<form id="centralForm" method="post" action="/central/profile.do"	dojoType="dijit.form.Form">
	<h2>Nome: <input type="text" id="central.name" width="270" value="${central.name}"
		baseClass="required requiredBig" name="central.name" required="true"
		class="required" dojoType="dijit.form.ValidationTextBox" trim="true" /></h2>
	<hr />
	<input dojoType="dijit.form.TextBox" type="hidden" name="central.id" value="${central.idStr }"
		style="display: none"></input>

	<div  class="campos adjustHeight">
	<table border="0">
		<tr>
			<td><label for="restaurant.description">Descrição:</label></td>
			<td><input type="text" dojoType="dijit.form.TextBox" id="description" trim="true"
				width="320" class="required" name="central.description"  value="${central.description}"/></td>

		</tr>
		
		<tr>
			<td><label for="restaurant.url">Website:</label></td>
			<td><input type="text" dojoType="dijit.form.TextBox" id="url" trim="true"
				width="320" class="required" name="central.url"  value="${central.url}"/></td>

		</tr>
		
		<tr>
			<td><label for="email1">E-mail p&uacute;blico:</label></td>
			<td><input type="text" 
				dojoType="dijit.form.ValidationTextBox" id="central.contact.email" value="${central.contact.email}"
				width="305" name="central.contact.email"  trim="true" regExpGen="com.copacabana.util.emailFormat"/></td>
		</tr>
		<tr>
			<td><label for="phone">Telefone:</label></td>
			<td><input type="text" required="true" class="required" trim="true"   value="${central.contact.phone}"
				dojoType="dijit.form.ValidationTextBox" id="central.contact.phone"
				width="220" name="central.contact.phone" regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN" /> <span class="required">*</span>
			</td>
		</tr>
		
	</table>
	<input dojoType="dijit.form.TextBox" type="hidden" name="central.user.id"  value="${central.userId}
		style="display: none"></input>
<input dojoType="dijit.form.TextBox" type="hidden" name="central.contactId"  value="${central.contactId}"
		style="display: none"></input>


	<br />
	<hr />
	<h2>Dados de acesso: </h2>
	<table border="0">
			<tr>
			<td><label for="name1">Nome respons&aacute;vel:</label></td>
			<td><input type="text" propercase="true" required="true"
				class="required" dojoType="dijit.form.ValidationTextBox"
				id="central.personInCharge" width="310" class="required" trim="true" properCase="true"
				name="central.personInCharge" value="${central.personInCharge }" /> <span class="required">*</span></td>
		</tr>
	
		<tr>
			<td><label for="email">E-mail de acesso:</label></td>
			<td><input id="central.user.login" width="310" required="true"
				dojoType="dijit.form.ValidationTextBox" class="required" trim="true" regExpGen="com.copacabana.util.emailFormat" value="${central.user.login}"
				name="central.user.login" /> <span class="required">*</span></td>
		</tr>
		
	</table>








	<br />

	</div>
	<div  class="campos adjustHeight">
	


</div>

	</form>
	
	</div>

	<div id="barraEmbaixo" class="fundoCinza barraSalvar"><a
		href="javascript:submitForm()" id="submitButton"> <img
		src="/resources/img/btSalvar.png" alt="salvar" /> </a></div>
	<div id="response"></div>



</cb:body>
<script>
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dojox.validate.regexp");
dojo.require("dojo.parser");

dojo.require("dojox.form.PasswordValidator");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.util");
function submitForm(){
	dojo.byId('centralForm').submit();
}

</script>
</html>