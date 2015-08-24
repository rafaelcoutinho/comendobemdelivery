
<%@page import="br.com.copacabana.cb.entities.OrderedPlate"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%
	
	Datastore.getPersistanceManager().getTransaction().begin();
	Query q = Datastore.getPersistanceManager().createNamedQuery("getOrderedPlate");
	
	for(Iterator<OrderedPlate> iter = q.getResultList().iterator();iter.hasNext();){
		OrderedPlate p = iter.next();
		Integer priceInCents = Double.valueOf(p.getPrice()*100).intValue();				
		p.setPriceInCents(priceInCents);
		
	}
	
	Datastore.getPersistanceManager().getTransaction().commit();
%>