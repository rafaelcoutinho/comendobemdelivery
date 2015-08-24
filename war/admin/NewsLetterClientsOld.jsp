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
StringBuilder sb= new StringBuilder();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", new Locale("pt","br"));
sdf.setTimeZone(TimeController.getDefaultTimeZone());

ClientManager cman = new ClientManager();
AddressManager aman = new AddressManager();
int counter = 1;
try{
	OrderManager om = new OrderManager();
	ClientManager ccm = new ClientManager();
	
List<Client> clist = cman.list("getNewsLetterClients");




%>
<script>
function toggle(divId){
var div = document.getElementById(divId);
if(div.style.display=='block'){
div.style.display='none';
}else{
div.style.display='block';
}
}

</script>
<h2 onclick="toggle('subscribeon')" style="cursor:pointer">Clientes
que assinam a news letter:</h2>
<div id="subscribeon" style="display:block">
<table border="1">
<tr>
<th>#</th>
	<th>Nome</th>
	<th>Email</th>	
	<th>Pedidos no site</th>
	<th>Data de registro</th>
	<th>Endere&ccedil;os</th>
</tr>	
	<% 
	
for(Iterator<Client> iter = clist.iterator();iter.hasNext();){
	Client c = iter.next();
	sb.append(c.getUser().getLogin());
	sb.append(", ");

	%><tr>
			<td valign="top"><%=counter++ %></td>
			<td valign="top"><%=c.getName() %></td>			
			<td valign="top"><%=c.getUser().getLogin() %></td>
			<td valign="top"><%=c.getMealOrders().size()%></td>
			<td valign="top"><%=sdf.format(c.getRegisteredOn())%></td>			
			
			<td>
			<div
				onclick="var v = document.getElementById('c_<%=c.getId().getId() %>');if(v.style.display=='block'){v.style.display='none';}else{v.style.display='block'};">ver</div>
			<div style="display: none;" id="c_<%=c.getId().getId() %>">
			Total: <%=c.getAddresses().size()%><br />
			<ul>
				<%
	for(Iterator<Key> iter2 = c.getAddresses().iterator();iter2.hasNext();){
		Address add = (Address)aman.find(iter2.next(),Address.class);
		%><li><%=add.getNeighborhood().getName()%>,<%=add.getNeighborhood().getCity().getName() %></li>
				<%
	} 

	%>
			</ul>
			</div>
			</td>

		</tr>
		<%
}
%></table><%=(counter-1) %> de <%=cman.list("getClient").size() %><%
}catch(Exception e){
e.printStackTrace();
out.print("Error:"+e.getMessage());
}
%>
<br />
Emails para copy/paste: <br/> <%=sb.toString()%>

<br/></div><br/>
<h2 onclick="toggle('subscribeoff')" style="cursor:pointer">Clientes que <b>N&Atilde;O</b> assinam a newsletter:</h2>
<div id="subscribeoff" style="display:none">
<table border="1">
<th>#</th>
	<th>Nome</th>
	<th>Email</th>	
	<th>Pedidos no site</th>
	<th>Data de registro</th>
	<th>Endere&ccedil;os</th></tr>
	<% 
	try{
	List<Client> cnolist = cman.list("getNoNewsLetterClients");
	counter = 1;
for(Iterator<Client> iter = cnolist.iterator();iter.hasNext();){
	Client c = iter.next();
	
	%><tr>
			<td valign="top"><%=counter++ %></td>
			<td valign="top"><%=c.getName() %></td>			
			<td valign="top"><%=c.getUser().getLogin() %></td>
			<td valign="top"><%=c.getMealOrders().size()%></td>
			<td valign="top"><%=sdf.format(c.getRegisteredOn())%></td>
			
			<td>
			<div
				onclick="var v = document.getElementById('c_<%=c.getId().getId() %>');if(v.style.display=='block'){v.style.display='none';}else{v.style.display='block'};">ver</div>
			<div style="display: none;" id="c_<%=c.getId().getId() %>">
			Total: <%=c.getAddresses().size()%><br />
			<ul>
				<%
	for(Iterator<Key> iter2 = c.getAddresses().iterator();iter2.hasNext();){
		Address add = (Address)aman.find(iter2.next(),Address.class);
		%><li><%=add.getNeighborhood().getName()%>,<%=add.getNeighborhood().getCity().getName() %></li>
				<%
	} 

	%>
			</ul>
			</div>
			</td>

		</tr>
		<%
}
%></table><%=(counter-1) %> de <%=cman.list("getClient").size() %><%
}catch(Exception e){
e.printStackTrace();
out.print("Error:"+e.getMessage());
}
%>
</div>