<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<html><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<head>

</head>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
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
	<html>
	<%@include file="/static/commonScript.html" %>
	<head><style>
.tbsection {
	border: 2px inset blue;
	padding: 10px;
}

.odd{
background-color: rgb(233,233,233);
}
table {
	-moz-border-radius: 3px 3px 3px 3px;
	border: 1px solid blue;
	padding: 2px;
}
</style></head>
	<body class="tundra">
	<jsp:include page="/admin/adminHeader.jsp"></jsp:include> <br/>
<%
StringBuilder forVisualization =new StringBuilder();
	StringBuilder sb = new StringBuilder();

	ClientManager cman = new ClientManager();
	AddressManager aman = new AddressManager();
	NeighborhoodManager nman = new NeighborhoodManager();
	int counter = 1;
	try {
		List<Client> clist = cman.list("getClient");
		Map<Key, Set<Client>> clientPerNeig = new HashMap<Key, Set<Client>>();
		Set<Neighborhood> neigSet = new HashSet<Neighborhood>();
		Set<Client> noAddress = new HashSet<Client>();
		Set<Client> totalClients = new HashSet<Client>();
		
		for (Iterator<Client> iter = clist.iterator(); iter.hasNext();) {
			Client c = iter.next();			
			if (c.getAddresses() == null || c.getAddresses().size() == 0) {
				noAddress.add(c);
				totalClients.add(c);
			} else {
				for (Iterator<Key> iterAddr = c.getAddresses().iterator(); iterAddr.hasNext();) {
					Key addKey = iterAddr.next();
					Address address = aman.getAddress(addKey);
					if (address == null) {
						System.err.println("Ta errado address null: " + address);
						//c.getAddresses().remove(addKey);
						//cman.persist(c);
					} else {
						if (address.getNeighborhood() == null) {
							System.err.println("Ta errado: " + address.getId());
						} else {

							Set<Client> addList = clientPerNeig.get(address.getNeighborhood().getId());
							neigSet.add(address.getNeighborhood());
							if (addList == null) {
								addList = new HashSet<Client>();
							}
							addList.add(c);
							totalClients.addAll(addList);
							clientPerNeig.put(address.getNeighborhood().getId(), addList);
						}						
					}

				}
			}
		}
%>
<a href="SendEmailsByRange.jsp">Ferramenta de emails por bairro</a><br>

<ul><%
		int total = 0;
		for (Iterator<Neighborhood> iter = neigSet.iterator(); iter.hasNext();) {
			Neighborhood n = iter.next();
%><li><a href="#<%=n.getId().getId() %>"><%=n.getName()%> (<%=clientPerNeig.get(n.getId()).size() %>)</a></li><%
		total+=clientPerNeig.get(n.getId()).size();
	}
%>
<li><a href="#null">Sem endereços (<%=noAddress.size() %>)</a></li>
</ul>
<div> Total enderecos: <%=total+noAddress.size() %> - Total usuários: <%=totalClients.size() %>/<%=clist.size() %></div>
<br>

<form action="sendSpam1stStep.jsp">
<input type="submit" value="enviar email para selecionados">
<hr/>
<%
    
	for (Iterator<Key> iter = clientPerNeig.keySet().iterator(); iter.hasNext();) {
			Key k = iter.next();
			Set<Client> lc = clientPerNeig.get(k);
			Neighborhood n = nman.get(k);
			forVisualization.append(n.getName()).append("|").append(lc.size()).append("\n");
			
%>

<div><A name="<%=k.getId()%>"><%=n.getName()%> (<%=lc.size()%>)</A> <div onclick="toggle('table_<%=k.getId()%>')">mostrar</div><br>
	<div id="table_<%=k.getId()%>" style="display: none;" class="tbsection" >
	<table border="0" cellspacing="0">
	<tr>
	<th>#</th>
	<th>Nome</th>
	<th>Email</th>
	<th>Data de registro</th>
	<th>Recebe newsletter</th>
	</tr>
	<tbody>
	<%
		counter = 1;
	 
				StringBuilder sbmails = new StringBuilder();				
				for (Iterator<Client> iterClients = lc.iterator(); iterClients.hasNext();) {
					Client c = iterClients.next();
					sbmails.append(c.getUser().getLogin()).append(",");
					String cssClass="";
					if(counter%2!=0){
						cssClass="class='odd'";
					}
	%><tr <%=cssClass %>>
			<td valign="top"><input type="checkbox" name="email" value="<%=c.getEmail() %>" > <%=counter++%></td>
			<td valign="top"><%=c.getName()%></td>			
			<td valign="top"><%=c.getUser().getLogin()%></td>
			<td valign="top"><%=c.getRegisteredOn()%></td>
			<td valign="top"><%=c.getReceiveNewsletter()%></td>
		</tr>	
		<%
				}
			%>
	</tbody>
	</table><br>	
	Emails para copy/paste: <br/> <%=sbmails.toString()%>
	</div>
	</div>

	<%
		}

//para os nulos




%><div><A name="null">Nulos (<%=noAddress.size()%>)</A> <div onclick="toggle('table_null')">mostrar</div><br>
<div id="table_null" style="display: none;" class="tbsection" >
<table border="0" cellspacing="0">
<tr>
<th>#</th>
<th>Nome</th>
<th>Email</th>
<th>Data de registro</th>
<th>Recebe newsletter</th>
</tr>
<tbody>
<%
	counter = 1;
	StringBuilder sbmails = new StringBuilder();				
	for (Iterator<Client> iterClients = noAddress.iterator(); iterClients.hasNext();) {
		Client c = iterClients.next();
		sbmails.append(c.getUser().getLogin()).append(",");
		String cssClass="";
		if(counter%2!=0){
			cssClass="class='odd'";
		}
		
%><tr <%=cssClass %>>
<td valign="top"><input type="checkbox" name="email" value="<%=c.getEmail() %>" > <%=counter++%></td>
<td valign="top"><%=c.getName()%></td>			
<td valign="top"><%=c.getUser().getLogin()%></td>
<td valign="top"><%=c.getRegisteredOn()%></td>
<td valign="top"><%=c.getReceiveNewsletter()%></td>
</tr>	
<%
	}
%>
</tbody>
</table><br>
<input type="submit" value="enviar email para selecionados">	
</form>
Emails para copy/paste: <br/> <%=sbmails.toString()%>
</div>
</div>

<%

		} catch (Exception e) {
			e.printStackTrace();
		}
	%><br />
	<hr>
	<form action="VisualizaBairrosNoMapa.jsp" method="post" target="_blank" enctype="application/x-www-form-urlencoded" >
	<input type="hidden" name="ranges" value="0">
	<input type="hidden" name="ranges" value="10">
	<input type="hidden" name="ranges" value="20">
	<input type="hidden" name="ranges" value="50">	
	
	<textarea name="list"><%=forVisualization.toString() %></textarea><input type="submit" value="Ver no mapa">
	</form>
</body>
</html>
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