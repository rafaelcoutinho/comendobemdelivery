
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryCost"%>
<%@page import="br.com.copacabana.cb.entities.OrderedPlate"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%
	
	Datastore.getPersistanceManager().getTransaction().begin();
	Query q = Datastore.getPersistanceManager().createNamedQuery("getMealOrder");
	
	for(Iterator<MealOrder> iter = q.getResultList().iterator();iter.hasNext();){
		MealOrder p = iter.next();
		
		Integer convenienceTaxInCents = 0;
		if(p.getConvenienceTax()!=null){
			convenienceTaxInCents=Double.valueOf(p.getConvenienceTax()*100).intValue();				
		}
		p.setConvenienceTaxInCents(convenienceTaxInCents);
		
		Integer delCostInCents = Double.valueOf(p.getDeliveryCost()*100).intValue();				
		p.setDeliveryCostInCents(delCostInCents);
		Integer totalAmount = 0;
		for(Iterator<OrderedPlate> iterp = p.getPlates().iterator();iterp.hasNext();){
			OrderedPlate op= iterp.next();
			totalAmount+=op.getPriceInCents();
		}
		totalAmount+=delCostInCents;
		totalAmount+=convenienceTaxInCents;
		p.setTotalAmountInCents(totalAmount);
						
		
	}
	
	Datastore.getPersistanceManager().getTransaction().commit();
%>