<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>


<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description"
	content="ComendoBem.com.br - Saiba quem somos. Informações sobre nossa equipe." />
<title>ComendoBem.com.br - Quem Somos</title>
<%@include file="/static/commonScript.html" %>
<cb:header />
</head>
<cb:body closedMenu="true">
<%@include file="/static/quemsomos.html" %>
</cb:body>
<%@include file="/scripts/ganalytics.js" %>	
</html>