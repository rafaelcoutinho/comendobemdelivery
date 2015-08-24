<%@page import="br.com.copacabana.cb.entities.PlateSize"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.com.copacabana.cb.entities.TurnType"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%
	PlateManager pm = new PlateManager();

	List<Plate> list = pm.list();
	//List<Plate> list = pm.listAllNonUpdatePlate();

	for (Iterator<Plate> iter = list.iterator(); iter.hasNext();) {
		Plate p = iter.next();
		if (!PlateSize.NONE.equals(p.getPlateSize())) {
			p.setPlateSize(PlateSize.NONE);
			pm.persist(p);
		}
	}
%><%=list.size()%>