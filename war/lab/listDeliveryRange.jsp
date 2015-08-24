<%@page import="java.util.Iterator"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.Authentication"%><%@page import="br.copacabana.spring.RestaurantManager"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@page import="br.copacabana.spring.DeliveryManager"%><%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
{"delRanges":[<%
Restaurant r = new RestaurantManager().get(Authentication.getLoggedUserKey(session));
for(Iterator<DeliveryRange> iter = r.getDeliveryRanges().iterator();iter.hasNext();){
	DeliveryRange del = iter.next();	
	String idN = KeyFactory.keyToString(del.getNeighborhood());
	%>
	{"id":"<%=del.getIdStr()%>","neighborhoodId":"<%=idN %>","costInCents":<%=del.getCostInCents()%>,"minimumCost":<%=del.getMinimumOrderValueInCents()%>}<%
	if(iter.hasNext()){%>,<%}
	
}
%>],"status":"online"}