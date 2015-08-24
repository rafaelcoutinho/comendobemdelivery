<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%><%@page import="com.google.appengine.api.datastore.KeyFactory"%><%@page import="br.copacabana.spring.NeighborhoodManager"%><%@page import="br.com.copacabana.cb.entities.DeliveryRange"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%
	String nid = request.getParameter("nId");
	Double cost = Double.valueOf(request.getParameter("cost"));
	Double mincost = Double.valueOf(request.getParameter("minimum"));
	RestaurantManager rm = new RestaurantManager();
	Restaurant rest2 = rm.get(Authentication.getLoggedUserKey(session));
	
	DeliveryRange delRange = new DeliveryRange();

	delRange.setRestaurant(rest2);

	delRange.setCost(cost);
	Double dd = cost * 100;
	delRange.setCostInCents(dd.intValue());
	if (mincost != null && mincost > 0) {
		delRange.setMinimumOrderValue(Double.valueOf(mincost));
		Double dd2 = mincost * 100;
		delRange.setMinimumOrderValueInCents(dd2.intValue());
	}

	NeighborhoodManager nm = new NeighborhoodManager();	
	delRange.setNeighborhood(KeyFactory.stringToKey(nid));
	rest2.addDeliveryRange(delRange);
	Datastore.getPersistanceManager().getTransaction().begin();
	rm.persist(rest2);
	Datastore.getPersistanceManager().getTransaction().commit();
%>{"status":"ok","delId":"<%=delRange.getIdStr() %>","delCostInCents":"<%=delRange.getCostInCents() %>"}