<%@page import="br.com.copacabana.web.Constants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="cb"	tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@page import="com.google.gson.JsonObject"%>
<%@page import="org.springframework.web.servlet.ModelAndView"%>
<%@page import="br.copacabana.AuthenticationController"%>
<%
String inviter=null;
if(session.getAttribute("inviter")!=null){
	inviter=(String)session.getAttribute("inviter");
	session.removeAttribute("inviter");
}else{
	if(request.getParameter("inviter")!=null){
		session.setAttribute("inviter",inviter);
	}
}
request.setAttribute("inviter",inviter);

%>
<html><head>
<%@include file="/static/commonScript.html"%>
</head>
<body>
<% request.setAttribute("fbid",Constants.FBID); %>
  <script> 
  	dojo.require("com.copacabana.util");
     function completeAuthentication(user) {
    	 <c:if test="${not empty param.inviter}">
    	 user.cb_inviter_id='${param.inviter}';
    	 </c:if>
    	 <c:if test="${not empty param.request_ids or not empty param.inviter}">
    	 var successCallback=function(){
    		 window.location="/";
    	 }
    	 var errorCallback=function(){
    		 alert("Erro ao conectar com Facebook.");
    	 }
    	 com.copacabana.util.executeLogin(null,"",true,user,successCallback,errorCallback);
    	 </c:if>
    	 <c:if test="${empty param.request_ids and empty param.inviter}">
    	opener.executeLogin(true,user);    	
		var userName = document.getElementById('userName');
		var greetingText = document.createTextNode('Bem vindo ' + user.name
				+ '.');
		userName.appendChild(greetingText);
		window.close();
		</c:if>
	}
	var appID = '<c:out value="${param.fbId}" default="${fbid}"/>';
	
	if (window.location.hash.length == 0) {
		
		var path = 'https://www.facebook.com/dialog/oauth?';
		var queryParams = [ 'client_id=' + appID,
				'redirect_uri=' + window.location, 'response_type=token' ,"scope=email,user_birthday,user_location,read_requests"];
		var query = queryParams.join('&');
		var url = path + query;
		location=url;
	} else {
		var accessToken = window.location.hash.substring(1);
		var path = "https://graph.facebook.com/me?";
		var queryParams = [ accessToken, 'callback=completeAuthentication' ];
		var query = queryParams.join('&');
		var url = path + query;

		// use jsonp to call the graph
		var script = document.createElement('script');
		script.src = url;
		document.body.appendChild(script);
	}
</script> 
   <p id="userName"></p>
</body>
</html>