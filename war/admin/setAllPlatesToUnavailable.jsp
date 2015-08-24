<%@page import="br.com.copacabana.cb.entities.PlateStatus"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="com.google.appengine.api.datastore.Category"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.CityIdentifierFilter"%>
<%
 WebApplicationContext applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
 PlateManager pm = (PlateManager)applicationContext.getBean("plateManager");
 FoodCategoryManager fm = (FoodCategoryManager)applicationContext.getBean("foodcategoryManager");
 FoodCategory fc=null;
 try{fc= fm.getFoodCategoryByName("Bebida");}catch(Exception e){e.printStackTrace();
 if(fc==null){
	 fc = fm.getFoodCategoryByName("Bebidas");
 }
 }
 RestaurantManager rm = (RestaurantManager)applicationContext.getBean("restaurantManager");
 Key rest = Authentication.getLoggedUserKey(session);
 Restaurant r = rm.getRestaurant(rest);
 Set<Plate> plates =  r.getPlates();
 for(Iterator<Plate> iter = plates.iterator();iter.hasNext();){
	 Plate p = iter.next();
	 if(p.getStatus().equals(PlateStatus.AVAILABLE) && !p.getFoodCategory().equals(fc.getId())){
		 p.setStatus(PlateStatus.UNAVAILABLE);
		 
		 pm.persist(p);
	 }
 }
 response.sendRedirect("/cardapio.do");
%>