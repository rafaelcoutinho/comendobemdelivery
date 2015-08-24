<%@page import="br.com.copacabana.cb.entities.OrderType"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="br.com.copacabana.cb.entities.Picture"%>
<%@page import="java.util.List"%>
<%@page import="br.com.copacabana.cb.entities.mgr.PictureManager"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.google.appengine.api.blobstore.BlobInfoFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobInfo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>

<%
	for (Iterator<MealOrder> iter = new OrderManager().list().iterator(); iter.hasNext();) {
		MealOrder c = iter.next();
		if (c.getOrderType() == null) {
			if (c.getClient().getId().getKind().equals("CLIENT")) {
				c.setOrderType(OrderType.ONLINE);
			} else {
				c.setOrderType(OrderType.ERP);
			}
			new OrderManager().persist(c);
		}
	}
%>