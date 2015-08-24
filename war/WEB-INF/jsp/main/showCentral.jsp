<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb"
	tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">


<%@page import="br.com.copacabana.web.Constants"%><html>
<head>
<%--START of FB TAGS --%>
<meta property="og:title" content="${entity.central.name}" />
<meta property="og:type" content="restaurant" />
<meta property="og:url"
	content="<%=Constants.HOSTNAME%>${entity.central.directAccess}" />
<meta property="og:image"
	content="<%=Constants.HOSTNAME%>resources/img/logo.png" />
<c:if test="${not empty entity.central.imageUrl}">
	<meta property="og:image"
		content="<%=Constants.HOSTNAME%>${entity.central.imageUrl}" />
</c:if>
<meta property="og:site_name" content="ComendoBem.com.br" />
<meta property="fb:admins" content="832414726" />


<c:if test="${not empty entity.central.contact}">
	<meta property="og:email" content="${entity.central.contact.email}" />
	<meta property="og:phone_number"
		content="${entity.central.contact.phone}" />
</c:if>
<meta property="og:description"
	content="O ${entity.central.name} também está no ComendoBem.com.br - O site de delivery e pedidos pela internet com pagamento online." />
<meta property="og:locality" content="Campinas" />
<meta property="og:region" content="SP" />

<meta property="og:country-name" content="BRASIL" />



<%--End of FB TAGS --%>

<meta name="description"
	content="O ${entity.central.name} também está no ComendoBem.com.br - O site de delivery pela internet com pagamento online." />
<meta name="google-site-verification"
	content="q9GHMsu3ikoVWZkcr10WsCCCVzo0VTv74uq4rvcUJkA" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>O ${entity.central.name} também está no ComendoBem.com.br
- O site de delivery pela internet com pagamento online.</title>

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

<cb:header keywordsAppend="${entity.central.name}," />

<script type="text/javascript">
	
</script>

</head>
<cb:body closedMenu="true">


	<div id="tituloRestaurante" style="min-height: 120px;"
		typeof="vcard:VCard org"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
		xmlns:v="http://rdf.data-vocabulary.org/#"
		xmlns:commerce="http://search.yahoo.com/searchmonkey/commerce/">
	<div class="canto cantoSupDir"></div>
	<div class="canto cantoInfDir"></div>
	<div class="rightPanel"
		style="float: right; width: 130px; margin: 10px;">
	<div style="float: right; width: 130px; margin: 10px;"
		class="recommendation"></div>

	</div>
	<c:if test="${not empty entity.central.imageUrl}">
		<div
			style="float: left; height: 100px; margin: 2px 5px 2px 2px; max-height: 120px; padding-top: 0pt;"><a
			href="/${entity.central.directAccess}" rel="vcard:photo"><img
			title="${entity.central.name}" alt="${entity.central.name}"
			src="${entity.central.imageUrl}" class="restLogoPlace"
			style="max-height: 115px; max-width: 170px"></a></div>
	</c:if>
	<div style="margin-left: 5px">
	<h2><a rel="vcard:url" href="/${entity.central.directAccess}"
		style="font-size: 1.4em;" property="rdfs:label vcard:fn">${entity.central.name}</a></h2>

	<div class="desc" style="font-style: italic; margin-left: 5px"
		property="rdfs:comment">${entity.central.description}</div>


	<c:if test="${not empty entity.central.url}">
		<div style="font-size: x-small; margin-left: 5px;"
			property="vcard:website"><a
			href="<c:if test="${fn:startsWith(entity.central.url,'http://')==false}">http://</c:if>${entity.central.url}">${entity.central.url}</a></div>
	</c:if> <c:if test="${not empty entity.central.contact.phone}">
		<div style="font-size: x-small; margin-left: 5px;"
			property="vcard:tel">Telefone: ${entity.central.contact.phone}</div>
	</c:if></div>
	</div>
	<div id="topoResultado">
	<div class="canto cantoSupDir"></div>
	<h2></h2>
	<p class="resultadoMensagem" id="resultadoMensagem">O ${entity.central.name} oferece o serviço de ${fn:length(entity.rests)} estabelecimentos. Confira:</p>
	<div class="canto cantoInfDir"></div>
	</div>
	<div style="width: 100%">
	<div style="display: block;" id="conteudo_search">

<div class="widgetContent" id="searchResultsManager" widgetid="searchResultsManager">
	
<div class="resultsList" id="itensBusca"><div class="widgetContent" >
<style>
.item:HOVER{
background-color:silver;
}
</style>
<c:forEach items="${entity.rests}" var="rest">
	
<div style="cursor: pointer;" class="item">
<span class="status" title="Restaurante aberto.">&nbsp;</span><c:if test="${not empty rest.restaurant.imageUrl}"><img src="${rest.restaurant.imageUrl}.small"/></c:if> 
<span class="titulo">${rest.restaurant.name}</span> <br>
<span class="quantidade">${rest.restaurant.description}</span></div>
	
	</c:forEach>
<div style="clear: both;"></div>
</div></div>
</div>
	</div><Br>
	</div>
</cb:body>

</html>