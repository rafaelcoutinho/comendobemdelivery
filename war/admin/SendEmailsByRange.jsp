<%@page import="br.copacabana.spring.DeliveryManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
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
	<a href="ManageClients.jsp">formato antigo</a>
	<hr>
<%
String restId = request.getParameter("restSelection");
Set<Key> delRanges = new HashSet<Key>();
if(restId!=null && !restId.equals("-1")){
	Restaurant r = new RestaurantManager().get(KeyFactory.stringToKey(restId));
	r.getDeliveryRanges();
	for(Iterator<DeliveryRange> iter = r.getDeliveryRanges().iterator();iter.hasNext();){
		delRanges.add(iter.next().getNeighborhood());
	}
}

StringBuilder forVisualization =new StringBuilder();
	StringBuilder sb = new StringBuilder();

	ClientManager cman = new ClientManager();
	AddressManager aman = new AddressManager();
	NeighborhoodManager nman = new NeighborhoodManager();
	int counter = 1;
	
		List<Client> clist = cman.list("getClient");
		Map<Key, Set<Client>> clientPerNeig = new HashMap<Key, Set<Client>>();
		Set<Neighborhood> neigSet = new HashSet<Neighborhood>();
		Set<Client> noAddress = new HashSet<Client>();
		StringBuilder noAddressEmail = new StringBuilder();
		Set<Client> totalClients = new HashSet<Client>();
		Map<Key, StringBuilder> emailsPerNeig = new HashMap<Key, StringBuilder>();
		for (Iterator<Client> iter = clist.iterator(); iter.hasNext();) {
			Client c = iter.next();			
			if (c.getAddresses() == null || c.getAddresses().size() == 0) {
				noAddress.add(c);
				noAddressEmail.append(c.getEmail()).append(",");
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
							StringBuilder emails = emailsPerNeig.get(address.getNeighborhood().getId());
							
							if (addList == null) {
								emails=new StringBuilder();
							
								addList = new HashSet<Client>();
							}
							if(!emails.toString().contains(c.getEmail())){
								emails.append(c.getEmail()).append(",");
							}
							emailsPerNeig.put(address.getNeighborhood().getId(),emails);
							addList.add(c);
							totalClients.addAll(addList);
							clientPerNeig.put(address.getNeighborhood().getId(), addList);
						}						
					}
				}
			}
		}
%>

<form method="get" action="SendEmailsByRange.jsp">
<select name="restSelection">
<option value="-1">---</option>
<%
for(Iterator<Restaurant> iter = new RestaurantManager().list().iterator();iter.hasNext();){
	Restaurant r= iter.next();
	%><option value="<%=r.getIdStr() %>"><%=r.getName() %></option><%

 }
%>
</select><input type="submit" value="Selecionar area de restaurante">
</form>

<form action="sendSpam1stStep.jsp" method="post">
<ul><%
		int total = 0;
		for (Iterator<Neighborhood> iter = neigSet.iterator(); iter.hasNext();) {
			Neighborhood n = iter.next();
%><li><input type="checkbox" name="email" value="<%=emailsPerNeig.get(n.getId()).toString() %>" <%if(delRanges.contains(n.getId())){ %>checked="checked"<%} %> > <%=n.getName()%> (<%=clientPerNeig.get(n.getId()).size() %>)</li><%
		total+=clientPerNeig.get(n.getId()).size();
	}
%>
<li><input type="checkbox" name="email" value="<%=noAddressEmail.toString() %>"> Sem endereços (<%=noAddress.size() %>)</li>
</ul>
<div> Total enderecos: <%=total+noAddress.size() %> - Total usuários: <%=totalClients.size() %>/<%=clist.size() %></div>
<br>
<input type="submit" value="enviar para estes bairros">
</form>
<hr>
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