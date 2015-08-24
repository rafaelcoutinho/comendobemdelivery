<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Comendo Bem</title>

<link href="../../styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="../../styles/main/main.css" type="text/css" rel="stylesheet" />
<link href="../../styles/main/main_busca.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<%@include file="/static/commonScript.html" %>


<script type="text/javascript">
			var loggedUser= <c:out escapeXml='false' value='${sessionScope.loggedUser}' default='null'/>;
			var userCity="${sessionScope.identifiedCity}";
			var identifiedCity=${sessionScope.jsonIdentifiedCity};
			var showRestaurantAtStart = <c:out  escapeXml='false' default="false" value='${param.showRestaurant}'  />;
			var restaurantId = '<c:out escapeXml='false' default='-1' value='${param.restaurantId}'  />';
</script>
<cb:header />



</head>
<cb:body>

	<div id="mensagem">&nbsp;</div>

	<div id="conteudo_main" style="height: 240px;">
	<div id="dica_do_dia" baseClass="quadrado"
		dojoType="com.copacabana.HighLightWidget" title="Dica do Dia"
		url="'/getDailyHighlight.do'" style="height: 240px;width: 240px"></div>

	<div id="novidade_da_semana" baseClass="quadrado"
		dojoType="com.copacabana.HighLightWidget" title="Novidade da Semana"
		url="'/getWeeklyHighlight.do'"></div>

	<div id="login" baseClass="quadrado"
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

</html>