<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="br.copacabana.util.HttpUtils"%><%
String url = "http://"+request.getServerName()+":"+request.getServerPort()+request.getParameter("uri");
String jsonp = request.getParameter("callback");
%><%=jsonp%>(<%=HttpUtils.getHttpContent(url+"?"+request.getQueryString(),"utf-8",new HashMap())%>)