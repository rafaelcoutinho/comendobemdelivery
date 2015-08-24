<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Cadastro Restaurante</title>
	
	<cb:header />
	<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dijit/themes/tundra/tundra.css">
	<link href="../../styles/restaurant/profile.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="../../styles/restaurant/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
		<link href="../../styles/restaurant/profile_ie_8.css" type="text/css" rel="stylesheet" />
	</c:if>

<%@include file="/static/commonScript.html" %>
<script type="text/javascript">
dojo.require("com.copacabana.RoundedButton");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("com.copacabana.RestaurantWheelWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser"); 
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.TitlePane");
</script>
</head>
<cb:body closedMenu="true">
	
	<div id="barraWelcome">
		<h2>Olá Burdog,</h2>
	</div>
	
	<div id="abas" class="fundoCinza">
		<a href="profile.jsp" id="dadosLink" class="inactive">Dados cadastrais</a>
		<a href="#funcionalidades" id="funcionalidadesLink" class="active">Funcionalidades</a>
		<a href="profileCardapio.jsp" id="cardapioLink" class="inactive">Cardápio</a>
	</div>
	
	<div id="dadosFuncionalidades">
		<div id="funcionalidade">
			<p>
				Como cliente <span class="highlight">GOLD</span> 
				você tem direito de cadastrar <span class="highlight">5 palavras-chave</span>.
			</p>
			
			<p>
				<label for="word1">Palavra-chave 1:</label>
				<cb:roundedInput tagId="word1" width="250" />
				<br />
				
				<label for="word2">Palavra-chave 2:</label>
				<cb:roundedInput tagId="word2" width="250" />
				<br />
				
				<label for="word3">Palavra-chave 3:</label>
				<cb:roundedInput tagId="word3" width="250" />
				<br />
				
				<label for="word4">Palavra-chave 4:</label>
				<cb:roundedInput tagId="word4" width="250" />
				<br />
				
				<label for="word5">Palavra-chave 5:</label>
				<cb:roundedInput tagId="word5" width="250" />
				<br />
			</p>
			
			<div id="barraSalvar" class="fundoCinza barraSalvar">
				<a href="#" id="enviarFuncionalidades">
					<img src="../../resources/img/btSalvar.png" alt="salvar" />
				</a>
			</div>
		</div>
		
		<ul class="menu">
		<li><a href="#" class="selecionado">Palavras-Chave</a></li>
		<li><a href="profileFuncionalidades.jsp">Atendimento - Área e
		Taxa</a></li>
		<li ><a href="profileHorarios">Horário de Funcionamento</a></li>
		<li><a href="#">Relatórios</a></li>
	</ul>
	</div>
	
</cb:body>
</html>