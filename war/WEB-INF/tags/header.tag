<%@ tag body-content="scriptless" pageEncoding="UTF-8"
	isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="keywordsAppend" required="false" rtexprvalue="true" %>
<%@ attribute name="nogeneralcss" required="false" rtexprvalue="true" %>
<meta name="robots" content="index, follow" />
<meta name="keywords"
	content="${keywordsAppend} Campinas, delivery, pizza, delivery de massas, delivery de comida japonesa, delivery de pizza,delivery, comida, restaurante, restaurantes, almoco, almoço, jantar, lanches, pizza, pizzaria, hamburger, disk-pizza, cardapio virtual, cardapio online, cardapio on-line, cardapio restaurante" />

<META HTTP-EQUIV="Content-Language" CONTENT="EN-US">
<META NAME="author" CONTENT="contato@comendobem.com.br">
<META NAME="copyright" CONTENT="ComendoBem.com.br">
<meta name="google-site-verification" content="Zq3B7L3rm-wUfPc4i3h-HX4rm9suCi0yHL9fsn6ZhMc" />
<META name="y_key" content="e383f44aa0ce3588">
<META NAME="robots" CONTENT="FOLLOW,INDEX">

<c:if test="${empty nogeneralcss}">
	<link href="/styles/general.css" type="text/css" rel="stylesheet" />
</c:if>	
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/general_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>


<link rel='index' title='Comendobem.com.br'
	href='/home.do' />
<link rel="shortcut icon"
	href="/favicon.png"
	type="image/x-icon" />

<script type="text/javascript">
	var sessionId = '<%=session.getId()%>';
	</script>