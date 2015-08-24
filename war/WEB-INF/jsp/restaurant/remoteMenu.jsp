<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb"
	tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">


<%@page import="br.com.copacabana.web.Constants"%><html>
<head>
<%--START of FB TAGS --%>
<meta property="og:title"
	content="${entity.restaurant.name}" />
<meta property="og:type" content="restaurant" />
<meta property="og:url"
	content="<%=Constants.HOSTNAME%>${entity.restaurant.uniqueUrlName}" />
<meta property="og:image"
	content="<%=Constants.HOSTNAME%>resources/img/logo.png" />
<c:if test="${not empty entity.restaurant.imageUrl}">	
<meta property="og:image"
	content="<%=Constants.HOSTNAME%>${entity.restaurant.imageUrl}" />
</c:if>
<c:forEach var="imgUrl" items="${entity.plateImages}">
<meta property="og:image"
	content="<%=Constants.HOSTNAME%>${imgUrl}" />
</c:forEach>
<meta property="og:site_name" content="ComendoBem.com.br" />
<meta property="fb:admins" content="832414726" />
	
<c:if test="${not empty entity.address}">
	<meta property="og:street-address"
		content="${entity.address.number} ${entity.address.street}" />
	<meta property="og:postal-code" content="${entity.address.zipCode}" />
	<c:if test="${entity.address.x !=0}">
		<meta property="og:latitude" content="${entity.address.y}" />
		<meta property="og:longitude" content="${entity.address.x}" />
	</c:if>
</c:if>
<c:if test="${not empty entity.restaurant.contact}">
	<meta property="og:email" content="${entity.restaurant.contact.email}" />
	<meta property="og:phone_number"
		content="${entity.restaurant.contact.phone}" />
</c:if>
<meta property="og:description"
	content="O ${entity.restaurant.name} também está no ComendoBem.com.br - O site de delivery e pedidos pela internet com pagamento online." />
<meta property="og:locality" content="Campinas" />
<meta property="og:region" content="SP" />

<meta property="og:country-name" content="BRASIL" />



<%--End of FB TAGS --%>

<meta name="description"
	content="O ${entity.restaurant.name} também está no ComendoBem.com.br - O site de delivery pela internet com pagamento online." />
<meta name="google-site-verification"
	content="q9GHMsu3ikoVWZkcr10WsCCCVzo0VTv74uq4rvcUJkA" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>O ${entity.restaurant.name} também está no
ComendoBem.com.br - O site de delivery pela internet com pagamento
online.</title>

<link href="/styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/main/pedido.css" type="text/css" rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="/styles/main/main_busca.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/main/pedido.css" type="text/css" rel="stylesheet" />
<link href="/styles/main/main.css" type="text/css" rel="stylesheet" />

<%@include file="/static/commonScript.html"%>

<cb:header keywordsAppend="${entity.restaurant.name},${entity.address.neighborhood.name},${entity.address.neighborhood.city.name}," />

<script type="text/javascript">
	
</script>

</head>
<cb:body closedMenu="true">
	<div id="tituloRestaurante" style="min-height: 120px;" typeof="vcard:VCard org"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:vcard="http://www.w3.org/2006/vcard/ns#"  xmlns:v="http://rdf.data-vocabulary.org/#"
    xmlns:commerce="http://search.yahoo.com/searchmonkey/commerce/">
	<div class="canto cantoSupDir"></div>
	<div class="canto cantoInfDir"></div>
	<div class="rightPanel" style="float: right; width: 130px; margin: 10px;">
	<div style="float: right; width: 130px; margin: 10px;"
		class="recommendation"></div>
	<c:if test="${entity.restaurant.open==false}">		
	<div class="openStatus"  style="float: right; margin-right: 30px; width: 55px; color: white; padding: 3px; background: none repeat scroll 0pt 0pt rgb(217, 38, 28); display: block;">Fechado</div>
	</c:if>
	<c:if test="${entity.restaurant.open==true && entity.restaurant.siteStatus eq 'ACTIVE'}">
		<div class="openStatus">
			<c:choose>
			<c:when test="${entity.restaurant.currentDelay=='ONCEADAY'}">
				<span class="deliveryTime" title="Entregas feitas uma vez ao dia." >1x ao dia</span>
			</c:when>
			<c:otherwise>
				<span class="deliveryTime" title="Tempo médio para entrega." >${entity.restaurant.currentDelay} min</span>
			</c:otherwise>
			</c:choose>			
		</div>
	</c:if>
	</div>
	<c:if test="${not empty entity.restaurant.imageUrl}">
		<div
			style="float: left; height: 100px; margin: 2px 5px 2px 2px; max-height: 120px; padding-top: 0pt;"><a
			href="/${entity.restaurant.uniqueUrlName}"  rel="vcard:photo"><img
			title="${entity.restaurant.name}" alt="${entity.restaurant.name}"
			src="${entity.restaurant.imageUrl}"
			class="restLogoPlace" style="max-height: 115px; max-width: 170px"></a></div>
	</c:if>
	<div style="margin-left:5px">
	<h2><a rel="vcard:url" href="/${entity.restaurant.uniqueUrlName}"
		style="font-size: 1.4em;" property="rdfs:label vcard:fn">${entity.restaurant.name}</a></h2>
	
	<div class="desc" style="font-style: italic;margin-left:5px" property="rdfs:comment">${entity.restaurant.description}</div>
	<c:if test="${not empty entity.address}">
	<div rel="vcard:adr">
         <div typeof="vcard:Address"  style="font-size: x-small;margin-left:5px;">	
		Endere&ccedil;o: <span property="vcard:street-address" style="font-size: inherit;">${entity.address.number} ${entity.address.street}</span>,  <span style="font-size: inherit;" property="vcard:locality">${entity.address.neighborhood.name}</span></div>
		</div>
	</c:if>
	<c:if test="${entity.restaurant.open!=false}">
	<c:if test="${not empty entity.restaurant.url}">
	<div style="font-size: x-small;margin-left:5px;" property="vcard:website"><a href="<c:if test="${fn:startsWith(entity.restaurant.url,'http://')==false}">http://</c:if>${entity.restaurant.url}">${entity.restaurant.url}</a></div>
	</c:if>
	<c:if test="${not empty entity.restaurant.contact.phone}">
	<div style="font-size: x-small;margin-left:5px;" property="vcard:tel">Telefone: ${entity.restaurant.contact.phone}</div>
	</c:if>
	</c:if>
	
	<div style="font-size: x-small;margin-left:5px" ><c:if test="${entity.restaurant.opensToday==false}">Fechado hoje.</c:if><c:if test="${entity.restaurant.opensToday==true}">Hor&aacute;rio: <span style="font-size: inherit;"  property="commerce:hoursOfOperation">Hoje das
	${entity.restaurant.todaysWO.startingHour}:<c:if test="${entity.restaurant.todaysWO.startingMinute<10}">0</c:if>${entity.restaurant.todaysWO.startingMinute}
	&agrave;s
	${entity.restaurant.todaysWO.closingHour}:<c:if test="${entity.restaurant.todaysWO.closingMinute<10}">0</c:if>${entity.restaurant.todaysWO.closingMinute}<c:if test="${entity.restaurant.todaysWO.hasSecondTurn}"> e das 
	${entity.restaurant.todaysWO.secondTurn[0]}:<c:if test="${entity.restaurant.todaysWO.secondTurn[1]<10}">0</c:if>${entity.restaurant.todaysWO.secondTurn[1]}
	&agrave;s
	${entity.restaurant.todaysWO.secondTurn[2]}:<c:if test="${entity.restaurant.todaysWO.secondTurn[3]<10}">0</c:if>${entity.restaurant.todaysWO.secondTurn[3]}</c:if>.</span></c:if></div>
	</div>
	</div>
	<div style="width: 500px;">
	<c:if test="${entity.restaurant.siteStatus=='TEMPUNAVAILABLE'}">
	<div style="margin: 10px; font-size: large; float: right; padding: 20px; color: rgb(187, 0, 0); background: none repeat scroll 0pt 0pt rgb(34, 34, 34);">Estabelecimento temporariamente indispon&iacute;vel.</div>
	</c:if>	
	<div class="cardapioPanel"></div>
	</div>
	<div id="pedido" class="pedidoWidget"></div>

	<script>
dojo.require("com.copacabana.search.SearchRestaurantsWidget");
dojo.require("com.copacabana.search.SearchResultsManagerWidget");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("com.copacabana.ClientOrderWidget");
dojo.require("dijit.form.Form");
dojo.require('com.copacabana.util');
dojo.require("com.copacabana.RestaurantViewWidget");
dojo.require("com.copacabana.RestPlateMenuWidget");
var restPlateMenu;
var order;
var rest = {
	
	isOpen:${entity.restaurant.open},
	siteStatus:'${entity.restaurant.siteStatus}',	
	currentDelay:'${entity.restaurant.currentDelay}',
	id:'${entity.restaurantKeyStr}',
	name:'${fn:replace(entity.restaurant.name, "'", "\\'")}',
	acceptablePayments:${entity.paymentsArrayString},
	
	warning:null,
	warningDate:null
}

var plistCache = ${entity.platesItemStoreOnlyAvailable};

var foodCategoriesCache;
dojo.addOnLoad(function() {
	com.copacabana.util.showLoading();
	foodCategoriesCache = new dojo.data.ItemFileReadStore( {
		url : "/listFoodCategoriesItemFileReadStore.do"
	});	
	restPlateMenu = new com.copacabana.RestPlateMenuWidget();
	restPlateMenu.setRestaurant(rest);
	var menu = dojo.query(".cardapioPanel")[0];
	restPlateMenu.startup();
	menu.appendChild(restPlateMenu.domNode);
	restPlateMenu.preFetched=plistCache;
	restPlateMenu.show();
	
	var orderPosition = dojo.query(".pedidoWidget")[0];
	if(rest.siteStatus=='ACTIVE' && rest.isOpen==true){
		order = new com.copacabana.ClientOrderWidget();
		order.setRestaurant(rest);
		order.startup();		
		orderPosition.appendChild(order.domNode);
	}
	var recDomNode = dojo.query(".recommendation")[0];
	com.copacabana.util.createFacebookButtonCurrent(recDomNode);
	com.copacabana.util.hideLoading();
});
</script>

</cb:body>

</html>