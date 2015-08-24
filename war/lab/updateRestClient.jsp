<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%
String id=request.getParameter("id");
String email=request.getParameter("email");
RestaurantClientManager manager= new RestaurantClientManager();
RestaurantClient rc= manager.get(KeyFactory.stringToKey(id));
rc.setTempEmail(email);
manager.persist(rc);
%>{"status":"ok"}