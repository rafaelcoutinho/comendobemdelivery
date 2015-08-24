<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta name="description"
	content="ComendoBem.com.br - O site de delivery pela internet com pagamento online." />
<meta name="google-site-verification" content="q9GHMsu3ikoVWZkcr10WsCCCVzo0VTv74uq4rvcUJkA" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Comendo Bem - O site de delivery pela internet com pagamento online.</title>

<link href="/styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />  
</c:if>

<link href="/styles/main/main_busca.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/main/main.css" type="text/css" rel="stylesheet" />

<%@include file="/static/commonScript.html" %>

<script type="text/javascript" src="/scripts/pages/main.js"></script>

<cb:header />
<script type="text/javascript">
	//caching data quickly
	var daily=<c:out  escapeXml='false' default="null" value='${entity.daily};'  />;
	var weekly=<c:out  escapeXml='false' default="null" value='${entity.weekly};'  />;
	var foodCatList=<c:out escapeXml='false' default="null" value='${entity.catList};'  />;
	var cachedCityList = <c:out escapeXml='false' default="null" value='${entity.citiesList};'  />;
		
</script>
</head>
<cb:body>
	<div id="mensagem">&nbsp;</div>

	<div id="conteudo_main">
	<div id="dica_do_dia" class="quadrado">
	
	<h2>
	Como funciona?
	</h2>
	<p>Fa&ccedil;a pedidos pela da internet e pague online. </p>
<ul>
<li>Selecione onde voc&ecirc; se encontra.</li>
<li>Escolha o Restaurante.</li>
<li>Selecione os pratos que deseja.</li>
<li>Insira o endere&ccedil;o de entrega.</li>
<li>Fa&ccedil;a o pagamento online.</li>
<li><b>Pronto! Bom Apetite!!!</b> <br/></li>
</ul>
	
	
	
	</div>
	<div id="login" baseClass="quadrado"
		dojoType="com.copacabana.HighLightWidget" title="Dica do Dia"
		url="'/getDailyHighlight.do'" object="daily"></div>

	<div id="novidade_da_semana" baseClass="quadrado"
		dojoType="com.copacabana.HighLightWidget" title="Novidade da Semana"
		url="'/getWeeklyHighlight.do'" object="weekly"></div>

	<div baseClass="quadrado"
		dojoType="com.copacabana.UserProfileWidget"></div>

	<div id="empty"></div>
	</div>
	<div id="conteudo_search" style="display: none">
	<div id="searchResultsManager"
		dojoType="com.copacabana.search.SearchResultsManagerWidget"></div>
	</div>
	<div id="conteudo_restaurante" style="display: none">
	<div id="restaurantView"></div>
	</div>

</cb:body>

<script type="text/javascript">
			var loggedUser= <c:out escapeXml='false' value='${sessionScope.loggedUser}' default='null'/>;
			var userCity=<c:out  escapeXml='false' default="null" value='${entity.defaultCityKey}'  />;//"ahByY291dG9jb3BhY2FiYW5hchULEgVTdGF0ZRgBDAsSBENpdHkYAgw";
			var identifiedCity={"id":<c:out  escapeXml='false' default="null" value='${entity.defaultCityKey}'  />,"name":<c:out  escapeXml='false' default="null" value='${entity.defaultCityName}'  />};					
			var showRestaurantAtStart = <c:out  escapeXml='false' default="false" value='${param.showRestaurant}'  />;
			var restaurantId = '<c:out escapeXml='false' default='-1' value='${param.restaurantId}'  />';
			
	</script>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	
</html>