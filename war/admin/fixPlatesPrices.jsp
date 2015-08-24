
<%@page import="javax.persistence.Query"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%
	PlateManager pm = new PlateManager();
	Datastore.getPersistanceManager().getTransaction().begin();
	Query q = Datastore.getPersistanceManager().createNamedQuery("getPlate");
	
	for(Iterator<Plate> iter = q.getResultList().iterator();iter.hasNext();){
		Plate p = iter.next();
		Integer priceInCents = Double.valueOf(p.getPrice()*100).intValue();
		Integer originalPriceInCents = Double.valueOf(p.getOriginalPrice()*100).intValue();
		p.setOriginalPriceInCents(originalPriceInCents);
		p.setPriceInCents(priceInCents);
		
	}
	
	Datastore.getPersistanceManager().getTransaction().commit();
%>