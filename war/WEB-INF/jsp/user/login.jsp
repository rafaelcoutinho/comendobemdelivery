<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="description"
	content="ComendoBem.com.br - Login. Autentique seu usuario." />
	<title>ComendoBem - Identificação do Usuário</title>
	<cb:header />
	
	<link href="../../styles/user/login.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="../../styles/user/login_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
</head>
<cb:body closedMenu="true">

	<div id="login" class="fundoCinza">
		<h2>Já sou Cadastrado</h2>
		<form method="post" action="${initParam['loginUrl']}">	
			E-mail: <cb:roundedInput tagId="user" width="200" /><br />
			Senha: <cb:roundedInput tagId="password" width="145" inputType="password" />
			<input type="hidden" name="redirect" value="/jsp/user/order.jsp" />
			<cb:roundedInput tagId="btLogin" inputType="submit" width="60" inputValue="Entrar" />
			<br />
		</form>
	</div>
	
	<div class="fundoCinza" id="titulo">
		<h2>Novo Cadastro</h2>
		(<span class="required">*</span>) Campos obrigatórios 
	</div>
	
	<form id="dadosUsuario" method="post" action="${initParam['criaUsuario']}">
		<div id="camposUsuario" class="campos">
			<label for="email">E-mail:</label>
			<cb:roundedInput tagId="email" width="270" cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="newPassword">Senha:</label>
			<cb:roundedInput tagId="newPassword" width="270" inputType="password" cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="confirmPassword">Confirmar Senha:</label>
			<cb:roundedInput tagId="confirmPassword" width="199" inputType="password" cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="name">Nome:</label> 
			<cb:roundedInput tagId="name" width="273"  cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="phone">Telefone:</label> 
			<cb:roundedInput tagId="regionCode" width="40" />
			<cb:roundedInput tagId="phone" width="208"  cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<input type="checkbox" name="receiveNewsLetter" id="receiveNewsLetter" />
			Desejo receber por e-mail informações sobre o Comendo Bem
		</div>
		
		<div id="camposEndereco" class="campos">
			<label for="zip">CEP:</label> 
			<cb:roundedInput tagId="zip" width="200" cssClass="required" />
			<span class="required">*</span>
			<a id="acharCEP" href="#" >Ache seu CEP</a>
			<br />
			
			<label for="street">Endereço:</label>
			<cb:roundedInput tagId="street" width="290" cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="addressNumber">Número:</label>
			<cb:roundedInput tagId="addressNumber" width="70" cssClass="required" />
			<span class="required">*</span>
			
			<label for="additionalInfo">Complemento:</label>
			<cb:roundedInput tagId="additionalInfo" width="105" />
			<br />
			
			<label for="neighborhood">Bairro:</label>
			<cb:roundedInput tagId="neighborhood" width="314"  cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="city">Cidade:</label>
			<cb:roundedInput tagId="city" width="309"  cssClass="required" />
			<span class="required">*</span>
			<br />
			
			<label for="state">Estado:</label>
			<cb:roundedInput tagId="state" width="310"  cssClass="required" />
			<span class="required">*</span>
			<br />
		</div>
	</form>
	
	<div id="barraEmbaixo" class="fundoCinza">
		<a href="#" id="cadastrarUsuario">
			<img src="../../resources/img/btCadastrar.png" alt="cadastrar" />
		</a>
	</div>
	
</cb:body>
</html>