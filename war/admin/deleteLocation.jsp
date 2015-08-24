
<%@page import="br.com.copacabana.cb.entities.mgr.LocationsManager"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Locations"%>

<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%><%
EntityManagerBean em = CityIdentifier.getEntityManager(getServletContext());
LocationsManager cman = new LocationsManager();
String key = request.getParameter("key");
if(key!=null && !key.equals("")){
	Locations loc = cman.find(KeyFactory.stringToKey(key),Locations.class);
	cman.delete(loc);
	
}
response.sendRedirect("listUnassignedLocations.jsp");
%>