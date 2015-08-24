<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8" isErrorPage="true"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta name="description" content="ComendoBem.com.br - Erro no servidor." />
<title>ComendoBem.com.br - Erro no servidor</title>

<link href="/styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="/styles/main/pedido.css" type="text/css" rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html" %>

<cb:header />
</head>
<cb:body closedMenu="true">
	<%@include file="/static/default_error.html"%>
</cb:body>
<%@include file="/scripts/ganalytics.js"%>
</html>