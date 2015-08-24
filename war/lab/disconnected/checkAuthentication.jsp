<%@page import="com.google.gson.JsonObject"%>
<%@page import="br.copacabana.Authentication"%>
<%
if(Authentication.isUserLoggedIn(session)){
	JsonObject obj = Authentication.getLoggedUser(session);
	%>{"status":"logged","loginData":<%=obj.toString() %>}<%
}else{
	%>{"status":"notlogged"}<%
}

%>
