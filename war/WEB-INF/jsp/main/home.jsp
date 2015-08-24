<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="cb"	tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
<META NAME="ROBOTS" CONTENT="INDEX, FOLLOW, ARCHIVE" />
<meta property="og:title" content="ComendoBem delivery online" />

<meta property="og:type" content="website" />
<meta property="og:url" content="http://www.comendobem.com.br/" />
<meta property="og:image" content="http://www.comendobem.com.br/resources/img/logo.png" />
<meta property="og:site_name" content="ComendoBem.com.br" />
<meta property="fb:admins" content="832414726" />
<meta property="fb:app_id" content="188850524473998">

<meta property="og:description"
	content="O site de delivery e pedidos pela internet com pagamento online. Faça pedidos de entrega de pizzas, sanduíches, massas, carnes e etc e pague com cartão de crédito via internet." />

<meta property="og:locality" content="Campinas"/>
<meta property="og:region" content="SP"/>
<meta property="og:postal-code" content="13023"/>
<meta property="og:country-name" content="BRASIL"/>
<meta property="fb:app_id" content="188850524473998"/>
<meta name="description"
	content="ComendoBem.com.br - O site de delivery mais gostoso da internet." />
<meta name="google-site-verification"
	content="q9GHMsu3ikoVWZkcr10WsCCCVzo0VTv74uq4rvcUJkA" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${param.showRestaurant==true}">
<title>Comendo Bem - O site de delivery pela internet com
pagamento online.</title>
</c:if>
<c:if test="${param.showRestaurant!=true}">
<c:if test="${isDirectSearch==true}">
<title>Comendo Bem - Há ${fn:length(restaurants)} restaurantes<c:if test="${not empty neigh}"> ${neigh}</c:if> em ${city}.</title>
</c:if>
<c:if test="${isDirectSearch!=true}">
<title>Comendo Bem - O site de delivery pela internet com pagamento online.</title>
</c:if>
</c:if>

<link href="/styles/home.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') == -1}">
<style>
	.loginBtnClass{
		float:right;
		margin-right:4px;
	}
	</style>
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />	
	<style>
	.ieRememberBtn{
		font-size:xx-small;
	}
	</style>
</c:if>


<%@include file="/static/commonScript.html"%>
<script type="text/javascript" src="/scripts/pages/main.js"></script>

<cb:header nogeneralcss="true" />
<script type="text/javascript">
	//caching data quickly
	var daily=<c:out  escapeXml='false' default="null" value='${entity.daily};'  />;
	var weekly=<c:out  escapeXml='false' default="null" value='${entity.weekly};'  />;
	var foodCatList=<c:out escapeXml='false' default="null" value='${entity.catList};'  />;
	var cachedCityList = <c:out escapeXml='false' default="null" value='${entity.citiesList};'  />;
	var defaultNeighborList = <c:out escapeXml='false' default='null' value='${entity.defaultNeighborList};'  />;
	var defaultCityKey = <c:out escapeXml='false' default="null" value='${entity.defaultCityKey};' />;
		
</script>

</head>
<cb:body showTwitter="true">
	<div id="mensagem">&nbsp;</div>
	<div id="conteudo_main">
	<c:if test="${param.showRestaurant==true or isDirectSearch==true}"></div></c:if>
<c:if test="${param.showRestaurant!=true && (isDirectSearch==false or isDirectSearch==null)}">
	<div id="homeLeft" class="quadrado">
		<h2 style="cursor: help;"
			title="Faça seus pedidos pela internet, pague com cartão de crédito online com todo o conforto.">Fa&ccedil;a
		pedidos online!</h2>
		<div id="hto">
			<ul>
				<li title="Selecione o bairro de entrega usando o formulário acima.">Indique
				a regi&atilde;o de entrega</li>
				<li
					title="Selecione dentre nossa grande base de restaurante aquele que mais te agrada. Temos pizzarias, hamburguerias, churrascarias. Certamente um vai lhe agradar.">Escolha
				seu restaurante</li>
				<li
					title="Escolha os pratos que você deseja, coloque os detalhes de seu endereço.">Fa&ccedil;a
				seu pedido</li>
				<li
					title="Faça seu pagamento diretamente pela internet, com toda segurança e conforto. As formas tradicionais de pagamento (dinheiro, cheque) também são disponíveis!">Pague
				<b>online</b></li>
				<li
					title="Acompanhe o status do seu pedido, monitore a preparação e envio até você do seu pedido.">Aguarde
				seu pedido e...</li>
			</ul>
		</div>
		<h2 style="text-align: center"
			title="O ComendoBem lhe deseja bom apetite.">Bom
		Apetite!</h2>
		<div style="text-align: right; margin-top: 20px; font-size: x-small;"><a
			href="/jsp/comopedir.jsp" 
			title="Quer saber mais sobre como pedir?">Quer saber mais?</a>
		</div>
	</div>
	<div id="homeCenter" class="quadrado" title="Opções do site">
	<jsp:include page="/rotatingOptions.jsp"></jsp:include>		
	</div>
	

	<div id="empty"></div>
	<c:if test="${empty sessionScope.loggedUser}">
		<div id="homeRight" baseClass="quadrado"
			dojoType="com.copacabana.UserProfileWidget"></div>
	</c:if>
	<c:if test="${not empty sessionScope.loggedUser}"><div id="homeRight" baseClass="quadrado"
		dojoType="com.copacabana.HighLightWidget" title="Dica do Dia"
		url="'/getDailyHighlight.do'" object="daily"></div></c:if>
	
	</div>
		
	</c:if>
	<c:if test="${(isDirectSearch==false or isDirectSearch==null)}">
	<div id="conteudo_search" style="display: none">
	<div id="searchResultsManager" dojoType="com.copacabana.search.SearchResultsManagerWidget">
	</div></div>
	</c:if>	
	<c:if test="${isDirectSearch}">
	<style>
				.item:HOVER{
				background-color:silver;
				}	
			</style>	
	<div id="conteudo_search" style="display: block">
	<div class="widgetContent" id="searchResultsManager"  dojoType="com.copacabana.search.SearchResultsManagerWidget">
		<div id="topoResultado">
			<div class="canto cantoSupDir"></div>
			<h2></h2>
			<p class="resultadoMensagem" id="resultadoMensagem">Encontramos ${fn:length(restaurants)} restaurantes<c:if test="${not empty neigh}"> no bairro ${neigh}</c:if> em ${city}.</p>
			<div class="canto cantoInfDir"></div>
			</div>
			<div class="resultsList" id="itensBusca">
			<c:forEach items="${restaurants}" var="bean">
	
	
			<div class="widgetContent vcard" dojoType="com.copacabana.search.SearchResultsItem">			
		   <a href="${bean.directAccessUrl}"><div dojoAttachEvent="onclick:onClick" dojoAttachPoint="sectionItem"  style="cursor: pointer;" class="item" >
		   
		   <c:if test="${bean.restaurant.open==false}">
		   	<span class="status" title="Restaurante fechado, verique o horario de abetura e fechamento.">Fechado</span>
		   </c:if> 
		   <c:if test="${bean.restaurant.open==true}">
		   	<span class="status" title="Restaurante aberto.">Aberto</span>
		   </c:if>
		   <span class="titulo fn org" >${bean.restaurant.name}</span> <br><span class="quantidade">${bean.restaurant.description}</span>
		   </div></a>
		   </div>
		   </c:forEach>
			</div>
	</div>
	</div>
	</c:if>
	
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

<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false"></script>

</html>