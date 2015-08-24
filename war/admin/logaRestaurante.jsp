<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantManager"%><%

	RestaurantManager rman= new RestaurantManager();
	String key="";
	Restaurant r=null;
	if(request.getParameter("key")!=null){
	key=request.getParameter("key");
	r = rman.find(KeyFactory.stringToKey(key),Restaurant.class);
}else{
	r= rman.list().get(0);
}

request.getSession().setAttribute("restaurantJson","{name:\'"+r.getName()+"\',id:\'"+KeyFactory.keyToString(r.getId())+"\'}");

%><%=r.getName()%> foi autenticado: ${sessionScope.restaurantJson}