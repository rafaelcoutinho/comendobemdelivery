<%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.com.copacabana.cb.entities.UserBean"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@page import="br.copacabana.spring.RestaurantManager"%><%
String idClient=request.getParameter("idClient");
String street=request.getParameter("street");
String number=request.getParameter("number");
String addtionalInfo=request.getParameter("additionalInfo");
String neighborhoodId=request.getParameter("neighborhoodId");
String phone=request.getParameter("phone");
System.out.println(idClient);
System.out.println(street);
System.out.println(number);
System.out.println(addtionalInfo);
System.out.println(neighborhoodId);
System.out.println(phone);

%>{"status":"fail","id":"-1"}