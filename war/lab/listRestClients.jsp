<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="java.util.List"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="java.util.Iterator"%><%@page import="java.util.HashSet"%><%@page import="br.copacabana.spring.ClientManager"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@page import="java.util.List"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.CacheController"%>
<%@page import="java.util.Set"%>
<%
RestaurantClientManager manager = new RestaurantClientManager();
List<RestaurantClient> list = manager.getRestaurantClients(Authentication.getLoggedUserKey(session));
request.setAttribute("allRestClients", list);
%>{"status":"ok","results":[<c:forEach var="client" items="${allRestClients}" begin="0" varStatus="status">
{
"id":${client.id.id},
"name":"${client.name}",
"email":"${client.tempEmail }",
"phones":[<c:forEach var="phone" items="${client.phones}" begin="0" varStatus="status2">
"${phone}"<c:if test="${status2.last==false}">,</c:if>
</c:forEach>]
}

<c:if test="${status.last==false}">,</c:if></c:forEach>]}