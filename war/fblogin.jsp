<!DOCTYPE html>
<%@page import="br.copacabana.exception.DataNotFoundException"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.copacabana.AuthenticationController"%>
<%@page import="br.com.copacabana.cb.entities.ContactInfo"%>
<%@page import="br.copacabana.spring.UserBeanManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.CityIdentifierFilter"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="br.copacabana.util.HttpUtils"%>
<%@page import="br.com.copacabana.web.Constants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html xmlns="http://www.w3.org/1999/xhtml"
	xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ComendoBem</title>
<meta property="og:title" content="LoginNOCB" />
<meta property="og:type" content="restaurant" />

<meta property="og:image"
	content="<%=Constants.HOSTNAME%>resources/img/logo.png" />
<meta property="og:site_name" content="ComendoBem.com.br" />
<meta property="fb:admins" content="rafael.coutinho" />
<meta property="fb:appid" content="" />
</head>
<body>
<h1>ComendoBem</h1>
<html>
<head>
<title>My Facebook Registration Page</title>
</head>
<body>
Cookies:
<br>
<%
	String fbUrl = "https://graph.facebook.com/me?";
try{
	for (int i = 0; i < request.getCookies().length; i++) {
		
		Cookie cookie = request.getCookies()[i];
		if (cookie.getName().startsWith("fbs_")) {
			String content = HttpUtils.getHttpContent(fbUrl
					+ cookie.getValue());
			out.print("<pre>" + content + "</pre>");
			JsonObject authentication = new JsonParser().parse(content)
					.getAsJsonObject();
			if(authentication.get("error")!=null){
			out.print("<div>"
					+ authentication.get("name").getAsString()
					+ "</div>");
			out.print("<div>"
					+ authentication.get("email").getAsString()
					+ "</div>");

		}else{
			out.print("error:"+authentication.get("error"));
		}
		}
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
<hr>
<script src="http://connect.facebook.net/pt_BR/all.js"></script>
<div id="fb-root"></div>

<script>
	FB.init({
		appId : '<c:out value="${param.fbId}" default="8704263086"/>',
		cookie : true,
		status : true,
		xfbml : true
	});
	FB.Event.subscribe('auth.login', function(response) {
		document.getElementById('loginForm').submit();
		console.log("beleza!",response);
      });
	
</script>
<form action="/authenticateNoSSL.do" id="loginForm" method="post">
<input  type="text" name="isFacebook" value="true" />
<input type="submit">
</form>
OR
<br />
<fb:login-button perms="email,user_birthday,read_friendlists,user_location">
         Conectar com Facebook
      </fb:login-button>
</body>
</html>