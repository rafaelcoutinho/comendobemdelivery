<%@page import="java.util.ArrayList"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="java.util.List"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/><fmt:setBundle basename='messages'/>
<%@page import="java.util.Date"%><%@page import="java.text.SimpleDateFormat"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="java.util.Iterator"%><%@page import="br.copacabana.spring.ClientManager"%>{"clients":[<%

ClientManager cm = new ClientManager();
RestaurantClientManager manager = new RestaurantClientManager();
List<Client> allRestClientsList = new ArrayList();
allRestClientsList.addAll(manager.getRestaurantClients(Authentication.getLoggedUserKey(session)));
allRestClientsList.addAll(cm.list());

for(Iterator iter = allRestClientsList.iterator();iter.hasNext();){
	Client client = (Client)iter.next();
	request.setAttribute("client",client);
	%>{"id":"${client.idStr}", "kind":"${client.id.kind}","name":"${client.name }","phone":"${client.mainPhone }","email":"${client.email}","registeredOn":"${client.registeredOn.time}"}<%
	if(iter.hasNext()){
		%>,<%
	}
}
%>],"status":"online"}