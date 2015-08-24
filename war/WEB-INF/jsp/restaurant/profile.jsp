<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Dados de Restaurante</title>

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
<script type="text/javascript" src="/scripts/pages/restaurantProfile.js"></script>
<style>
.requiredBig {
	font-size: medium;
}

.adjustHeight {
	height: auto;;
}
</style>
<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp"><jsp:param
			name="isProfile" value="true"></jsp:param></jsp:include>
	<div id="dadosCadastrais" class="conteudo">
	<form id="restform" method="post" action="/createRestJson.do"
		dojoType="dijit.form.Form">
	<h2>Nome: <input type="text" id="restaurant.name" width="270"
		baseClass="required requiredBig" name="restaurant.name" required="true" value="${entity.name }"
		class="required" dojoType="dijit.form.ValidationTextBox" trim="true" /></h2>
	<hr />
	<input dojoType="dijit.form.TextBox" type="hidden" name="restaurant.id"  value="${entity.idStr}"
		style="display: none"></input>

	<div id="camposRestaurante" class="campos adjustHeight">
	<table border="0">
		<tr>
			<td><label for="restaurant.description">Descri&ccedil;&atilde;o:</label></td>
			<td><input type="text" propercase="true" trim="true"
				dojoType="dijit.form.ValidationTextBox" id="restaurant.description" width="270" value="${entity.description}"
				class="required" name="restaurant.description" /><span class="required">*</span></td>
		</tr>
		<tr>
		<td colspan="2"><span style="font-size: xx-small;">(exemplos: 'O melhor bolinho de bacalhau' ou 'Massas italianas')</span></td></tr>
		<tr>
			<td><label for="restaurant.formalName">Razão Social:</label></td>
			<td><input type="text" properCase="true" trim="true"
				dojoType="dijit.form.TextBox" id="restaurant.formalName" width="270"
				class="required" name="restaurant.formalName" value="${entity.formalName}" /></td>
		</tr>

		<tr>
			<td><label for="restaurant.formalDocumentId">CNPJ:</label></td>
			<td><input type="text" dojoType="dijit.form.TextBox" id="cnpj" value="${entity.formalDocumentId}"
				width="320" class="required" name="restaurant.formalDocumentId" trim="true"/></td>

		</tr>
		<tr>
			<td><label for="restaurant.url">Website:</label></td>
			<td><input type="text" dojoType="dijit.form.TextBox" id="url" trim="true"
				width="320" class="required" name="restaurant.url" value="${entity.url}" /></td>

		</tr>
		
		<tr>
			<td><label for="email1">E-mail p&uacute;blico:</label></td>
			<td><input type="text" 
				dojoType="dijit.form.ValidationTextBox" id="restaurant.contact.email"
				width="305" name="restaurant.contact.email"  trim="true" regExpGen="com.copacabana.util.emailFormat" value="${entity.contact.email}"/></td>
		</tr>
		<tr>
			<td><label for="phone">Telefone:</label></td>
			<td><input type="text" required="true" class="required" trim="true" 
				dojoType="dijit.form.ValidationTextBox" id="restaurant.contact.phone" value="${entity.contact.phone}"
				width="220" name="restaurant.contact.phone" regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN" /> <span class="required">*</span>
			</td>
		</tr>
		
	</table>
	<input dojoType="dijit.form.TextBox" type="hidden" name="user.id"  value="${entity.user.idStr}"
		style="display: none"></input>
<input dojoType="dijit.form.TextBox" type="hidden" name="restaurant.contact.id" value="${entity.contact.idStr}"
		style="display: none"></input>


	<br />
	<hr />
	<h2>Dados de acesso: </h2>
	<table border="0">
			<tr>
			<td><label for="name1">Nome respons&aacute;vel:</label></td>
			<td><input type="text" propercase="true" required="true"
				class="required" dojoType="dijit.form.ValidationTextBox" value="${entity.personInChargeName}"
				id="restaurant.personInChargeName" width="310" class="required" trim="true" properCase="true"
				name="restaurant.personInChargeName" /> <span class="required">*</span></td>
		</tr>
	
		<tr>
			<td><label for="email">E-mail de acesso:</label></td>
			<td><input id="restaurant.email" width="310" required="true" value="${entity.user.login}"
				dojoType="dijit.form.ValidationTextBox" class="required" trim="true" regExpGen="com.copacabana.util.emailFormat"
				name="user.login" /> <span class="required">*</span></td>
		</tr>
		
	</table>








	<br />

	</div>
	<div  class="campos adjustHeight">
<input type="hidden" name="address.id" id="address.id" dojoType="dijit.form.TextBox"/>
<h2>Endere&ccedil;o: </h2>
	<table border="0">
		<tr>
			<td><label for="street">Endereço:</label></td>
			<td><input type="text" required="true" class="required" trim="true" properCase="true"
				dojoType="dijit.form.ValidationTextBox" name="address.street" 
				width="260" /> <span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="number">N&uacute;mero:</label></td>
			<td><input type="text" required="true" class="required" trim="true" 
				dojoType="dijit.form.ValidationTextBox" name="address.number"
				width="70" /> <span class="required">*</span></td>
		</tr>

		<tr>
			<td><label for="additionalInfo">Complemento:</label></td>
			<td><input type="text" dojoType="dijit.form.TextBox" trim="true" 
				name="address.additionalInfo" width="80" /></td>

		</tr>
		<tr>
			<td><label for="city">Cidade:</label></td>
			<td><select dojoType="dijit.form.FilteringSelect"
				id="citySelection" autoComplete="true" 
				required="true" class="required" invalidMessage="Cidade inv&aacute;lida"></select>
			<span class="required">*</span></td>
		</tr>

		<tr>
			<td><label for="neighborhood">Bairro:</label></td>
			<td><select dojoType="dijit.form.FilteringSelect"
				id="neighSelection" required="true" class="required"
				name="neighborhood.id" autoComplete="true"
				invalidMessage="Bairro inv&aacute;lido"></select> <span
				class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="zipCode">CEP:</label></td>
			<td><input type="text" dojoType="dijit.form.ValidationTextBox" trim="true"  regExpGen="com.copacabana.util.cepFormat"  invalidMessage="Cep deve ser como exemplo 13.000-000"
				name="address.zipCode" width="180" /></td>
		</tr>
	</table>
	


</div>

	</form>
	
	</div>

	<div id="barraEmbaixo" class="fundoCinza barraSalvar"><a
		href="javascript:submitForm()" id="submitButton"> <img
		src="/resources/img/btSalvar.png" alt="salvar" /> </a></div>
	<div id="response"></div>



</cb:body>
</html>