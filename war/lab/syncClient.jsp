<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.com.copacabana.cb.entities.UserBean"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@page import="br.copacabana.spring.RestaurantManager"%><%
String id=request.getParameter("id");

String name=request.getParameter("name");
String phone=request.getParameter("phone");
String email=request.getParameter("email");
RestaurantManager rman=new RestaurantManager();
Restaurant rest =rman.getRestaurant(Authentication.getLoggedUserKey(session));
RestaurantClientManager rcman = new RestaurantClientManager();
RestaurantClient novo = new RestaurantClient();
try{
	novo=rcman.get(KeyFactory.stringToKey(id));
	if(novo==null){
		novo = new RestaurantClient();
	}
}catch(Exception e){
	
}
novo.setTempEmail(email);
novo.addRest(rest.getId());
novo.setName(name);
novo.addPhone(phone);
rcman.create(novo);

%>{"status":"ok","id":"<%=novo.getIdStr()%>","oldId":"<%=id %>"}