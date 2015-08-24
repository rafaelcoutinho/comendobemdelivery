<%@page import="br.copacabana.CacheController"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%
String name=request.getParameter("name");
String phone=request.getParameter("phone");
String email=request.getParameter("email");
RestaurantManager rman=new RestaurantManager();
Restaurant rest =rman.getRestaurant(Authentication.getLoggedUserKey(session));
RestaurantClientManager rcman = new RestaurantClientManager();
RestaurantClient novo =new RestaurantClient();
novo.setTempEmail(email);
novo.addRest(rest.getId());
novo.setName(name);
novo.addPhone(phone);
rcman.create(novo);


response.sendRedirect("selectDeliveryAddress.jsp?client="+novo.getIdStr());

%>