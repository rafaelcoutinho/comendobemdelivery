<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="java.util.List"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/><fmt:setBundle basename='messages'/>
<%@page import="java.util.Date"%><%@page import="java.text.SimpleDateFormat"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="java.util.Iterator"%><%@page import="br.copacabana.spring.ClientManager"%>{"addresses":[<%

ClientManager cm = new ClientManager();
AddressManager am = new AddressManager();
RestaurantClientManager manager = new RestaurantClientManager();
List<Client> allRestClientsList = new ArrayList();
allRestClientsList.addAll(manager.getRestaurantClients(Authentication.getLoggedUserKey(session)));
allRestClientsList.addAll(cm.list());
int counter=0;
boolean alreadyStarted=false;
for (Iterator iter = allRestClientsList.iterator(); iter.hasNext();) {
	Client c = (Client)iter.next();
	if(!c.getAddresses().isEmpty()){

		if(alreadyStarted){
			%>,<%
		}
		alreadyStarted=true;
	for (Iterator<Key> iter2 = c.getAddresses().iterator(); iter2.hasNext();) {
		Key addressK = iter2.next();
		Address address = am.getAddress(addressK);
		request.setAttribute("address",address);
		
		%>{"id":"${address.idStr}", "idClient":"<%=c.getIdStr() %>",
		"street":"${fn:replace(address.street, "\"", "\\\"")}",
		"phone":"${address.phone }",
		"additionalInfo":"${fn:replace(address.additionalInfo, "\"", "\\\"")}",
		"neighborhood":{
			"name":"${address.neighborhood.name}",
			"id":"${address.neighborhood.idStr}",
			"cidade":"${address.neighborhood.city.name}"
		},
		"number":"${address.number}"}<%
		
		if(iter2.hasNext()){
			%>,<%
		}
		
	}
	
}
	
}
	
%>],"neighborhoods":[<%
    for (Iterator<Neighborhood> iter = new NeighborhoodManager().list().iterator(); iter.hasNext();) {
    	Neighborhood n = iter.next();
    	request.setAttribute("n",n);
    	%>{"id":"${n.idStr}","name":"${n.name}","city":"${n.city.name}"}<%
    	if(iter.hasNext()){
    		%>,<%
    	}
    }
%>],"status":"online"}