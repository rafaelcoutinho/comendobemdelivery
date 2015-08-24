<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.com.copacabana.cb.entities.UserBean"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@page import="br.copacabana.spring.RestaurantManager"%><%
String id=request.getParameter("id");
	
Address address = new Address();

String street=request.getParameter("street");
address.setStreet(street);
String phone=request.getParameter("phone");
address.setPhone(phone);
String additionalInfo=request.getParameter("additionalInfo");
address.setAdditionalInfo(additionalInfo);
String number=request.getParameter("number");
address.setNumber(number);



NeighborhoodManager nman = new NeighborhoodManager();
String neighId=request.getParameter("neighborhood[id]");
Neighborhood n = nman.get(KeyFactory.stringToKey(neighId));

address.setNeighborhood(n);

AddressManager addMan = new AddressManager();
address=addMan.createAddres(address);
Key addKey = address.getId();
String clientId=request.getParameter("clientId");
Key cId = KeyFactory.stringToKey(clientId);

if(cId.getKind().equals("CLIENT")){
	Client c = new ClientManager().get(cId);
	c.getAddresses().add(addKey);
	new ClientManager().persist(c);
}else{
	RestaurantClient c=new RestaurantClientManager().get(cId);
	c.getAddresses().add(addKey);
	new RestaurantClientManager().persist(c);
}


%>{"status":"ok","id":"<%=KeyFactory.keyToString(addKey) %>","oldId":"<%=id %>"}