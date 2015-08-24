<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="java.util.Locale"%>
<%@page import="br.copacabana.util.TimeController"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Client"%><%@page
	import="br.copacabana.usecase.CityIdentifier"%><%@page
	import="br.copacabana.EntityManagerBean"%><%@page
	import="br.com.copacabana.cb.entities.mgr.JPAManager"%>
<%@page import="br.com.copacabana.cb.entities.City"%><%@page
	import="java.util.List"%><%@page
	import="br.copacabana.spring.NeighborhoodManager"%><%@page
	import="br.com.copacabana.cb.entities.Neighborhood"%><%@page
	import="java.util.Iterator"%><%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%><%@page
	import="com.google.appengine.api.datastore.KeyFactory"%><%@page
	import="com.google.appengine.api.datastore.Key"%><%@page
	import="br.com.copacabana.cb.entities.Restaurant"%><%@page
	import="br.com.copacabana.cb.entities.DeliveryRange"%><%@page import="br.com.copacabana.cb.entities.Address"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br/> 
<%
 	StringBuilder sb = new StringBuilder();
 	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", new Locale("pt", "br"));
 	sdf.setTimeZone(TimeController.getDefaultTimeZone());

 	RestaurantClientManager restCliman = new RestaurantClientManager();
 	AddressManager aman = new AddressManager();
 	int counter = 1; 	
 		List<RestaurantClient> clist = restCliman.list("allRestaurantClients");
 		
 %>

<h2 onclick="toggle('subscribeon')" style="cursor:pointer">Clientes cadastrados pelo ERP:</h2>
<div id="subscribeon" style="display:block">
<table border="1">
<tr>
<th>#</th>
	<th>Nome</th>
	<th>Email</th>	
	<th>Pedidos no site</th>
	<th>Data de registro</th>
	<th>Restaurante</th>
</tr>	
	<%
			
				for (Iterator<RestaurantClient> iter = clist.iterator(); iter.hasNext();) {
					RestaurantClient c = iter.next();
					if(c.getTempEmail()!=null && c.getTempEmail().length()>0){
					sb.append(c.getTempEmail());
					sb.append(", ");
					}
		%><tr>
			<td valign="top"><%=counter++%></td>
			<td valign="top"><%=c.getName()%></td>			
			<td valign="top"><%=c.getTempEmail()%></td>
			<td valign="top"><%=c.getMealOrders().size()%></td>
			<td valign="top"><%=sdf.format(c.getRegisteredOn())%></td>
			<td><ul>
			
				<%
					RestaurantManager rman= new  RestaurantManager();
					for (Iterator<Key> iter2 = c.getFromRests().iterator(); iter2.hasNext();) {
								Restaurant r=rman.get(iter2.next());
				%><li><%=r.getName()%></li>
				<%
					}
				%>
			</ul>
			</div>
			</td>

		</tr>
		<%
			}
		%></table>
<br />
Emails para copy/paste: <br/> <%=sb.toString()%>
