<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
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

 	OrderManager om = new OrderManager();
 	AddressManager aman = new AddressManager();
 	int counter = 1; 	
 	List<MealOrder> orderList = om.query("getCompleteOnlineOrders");
 		
 	
 %>

<h2 onclick="toggle('subscribeon')" style="cursor:pointer">Clientes do site que fizeram pedidos por telefone:</h2>
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
			
	for (Iterator<MealOrder> iter = orderList.iterator(); iter.hasNext();) {
		MealOrder order = iter.next();
		if(!order.getClient().getId().getKind().equals("CLIENT")){
			continue;
		}
		Client c = order.getClient();
		%><tr>
			<td valign="top"><%=counter++%></td>
			<td valign="top"><%=order.getClientName()%></td>			
			<td valign="top"><%=order.getClient().getUser().getLogin()%></td>
			<td valign="top"><%=c.getMealOrders().size()%></td>
			<td valign="top"><%=sdf.format(c.getRegisteredOn())%></td>
			<td><ul>
			
				
			</ul>
			
			</td>

		</tr>
		<%
			}
		%></table>
<br />
Emails para copy/paste: <br/> <%=sb.toString()%>
