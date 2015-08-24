
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%
	
	Datastore.getPersistanceManager().getTransaction().begin();
	Query q = Datastore.getPersistanceManager().createNamedQuery("getDeliveryRange");
	
	for(Iterator<DeliveryRange> iter = q.getResultList().iterator();iter.hasNext();){
		DeliveryRange p = iter.next();
		Integer costInCents = Double.valueOf(p.getCost()*100).intValue();
		Integer minInCents = Double.valueOf(p.getMinimumOrderValue()*100).intValue();
		p.setCostInCents(costInCents);
		p.setMinimumOrderValueInCents(minInCents);
		
	}
	
	Datastore.getPersistanceManager().getTransaction().commit();
%>