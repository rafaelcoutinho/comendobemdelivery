<%@page import="br.com.copacabana.cb.entities.ContactInfo"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%
RestaurantManager rman=new RestaurantManager();
Restaurant muit=rman.getRestaurantByUniqueURL("muito");
RestaurantClientManager rcman = new RestaurantClientManager();
RestaurantClient cl =new RestaurantClient();
UserBean ub = new UserBean();
ub.setLogin("test");

cl.setUser(ub);

cl.setName("JOoo");
cl.setCpf("");
cl.addPhone("19 1222 2223");
cl.addRest(muit.getId());
rcman.create(cl);
%>