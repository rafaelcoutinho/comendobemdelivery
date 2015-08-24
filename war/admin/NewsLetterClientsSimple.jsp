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
	import="br.com.copacabana.cb.entities.DeliveryRange"%><%@page
	import="br.com.copacabana.cb.entities.Address"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br />
<%
	StringBuilder sb = new StringBuilder();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", new Locale("pt", "br"));
	sdf.setTimeZone(TimeController.getDefaultTimeZone());

	ClientManager cman = new ClientManager();
	int totalClients = cman.list("getClient").size();
	AddressManager aman = new AddressManager();
	int counter = 1;
	try {
		OrderManager om = new OrderManager();
		ClientManager ccm = new ClientManager();

		List<Client> clist = cman.list("getNewsLetterClients");
		boolean filterCity = false;
		boolean excludeNull = false;
		if (request.getParameter("excludeNull") != null) {
			excludeNull = true;
		}
		String cityKey = "";
		if (request.getParameter("city") != null) {
			filterCity = true;
			cityKey = request.getParameter("city");
		}
%>
<link rel="stylesheet" href="/styles/tableSortable.css" type="text/css"/>
<style>
/* tables overwrite */
table.tablesorter {
	width: 55%;
}
</style>
<script type="text/javascript" src="/scripts/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.tablesorter.min.js"></script>


<script>
$(document).ready(function(){
	console.log($("#dealsTable"));
$("#dealsTable").tablesorter({sortList:[[0,0]], widgets: ['zebra'], headers:{}});
$("#dealsTable2").tablesorter({sortList:[[0,0]], widgets: ['zebra'], headers:{}});
} 
);
function toggle(divId) {
		var div = document.getElementById(divId);
		if (div.style.display == 'block') {
			div.style.display = 'none';
		} else {
			div.style.display = 'block';
		}
	}
</script>
</head>
<body>
<span>Resumo</span><br>
Total Clientes : <%=totalClients %><br>
<%=clist.size() %> recebem newsletter<br/>
<hr>  
<a href="NewsLetterClients.jsp">Ver antigo formato (pesado!)</a>
<br>
Filtrando por cidade:
<%=filterCity%><br>
Excluindo null:
<%=excludeNull%><br>
<form action="NewsLetterClientsSimple.jsp">Filtrar por cidade:<br />
Cidade:<select name="city">
	<%
		CityManager cm = new CityManager();

			String checked = "";
			if (request.getParameter("excludeNull") != null) {
				checked = "checked='checked'";
			}

			for (Iterator<City> iter = cm.list().iterator(); iter.hasNext();) {
				City c = iter.next();
				String selected = "";
				if (c.getIdStr().equals(request.getParameter("city"))) {
					selected = "selected='selected'";
				}
	%><option value="<%=c.getIdStr()%>"><%=c.getName()%></option>
	<%
		}
	%>
</select> <input type="checkbox" name="excludeNull" <%=checked%>>Excluir
sem endereços <br>
<input type="submit"></form>
<script>
function toggleCheckbox(){
	var cs = dojo.query("[type=checkbox]");
	for(var i=0;i<cs.length;i++){
		var item = cs[i];			
		if(item.checked==false){
			item.checked=true;
		}else{
			item.checked=false;	
		}
	}
}
</script><br>
<a href="javascript:toggleCheckbox()">Toggle</a><br>
<h2 onclick="toggle('subscribeon')" style="cursor: pointer">Clientes
que assinam a news letter:</h2>
<div id="subscribeon" style="display: block">
<table border="0" id="dealsTable" class="tablesorter">
<thead>
	<tr>
		<th>#</th>
		<th>Nome</th>
		<th>Email</th>
		<th>Pedidos no site</th>
		<th>Data de registro</th>
		<th>Data em secs (ord)</th>
		<th>Facebook?</th>
		<th>Endere&ccedil;os</th>
	</tr>
	</thead><tbody>
	<%
		for (Iterator<Client> iter = clist.iterator(); iter.hasNext();) {
				Client c = iter.next();

				sb.append(c.getUser().getLogin());
				sb.append(", ");
	%><tr>
		<td valign="top"><input checked="checked" type="checkbox" name="email" value="<%=c.getEmail() %>" ><%=counter++%></td>
		<td valign="top"><%=c.getName()%></td>
		<td valign="top"><%=c.getUser().getLogin()%></td>
		<td valign="top"><%=c.getMealOrders().size()%></td>
		<td valign="top"><%=sdf.format(c.getRegisteredOn())%></td>
		<td valign="top"><%=c.getRegisteredOn().getTime()%></td>
		<td valign="top"><%=c.getUser().getIsFacebook()%></td>
		<td valign="top"><%=c.getAddresses().size()%></td>

	</tr>
	<%
		}
	%></tbody>
</table><%=(counter - 1)%> de <%=totalClients%>
<%
	} catch (Exception e) {
		e.printStackTrace();
		out.print("Error:" + e.getMessage());
	}
%> <br />
Emails para copy/paste: <br />
<%=sb.toString()%> <br />
</div>
<br />
<h2 onclick="toggle('subscribeoff')" style="cursor: pointer">Clientes
que <b>N&Atilde;O</b> assinam a newsletter:</h2>
<div id="subscribeoff" style="display: none">
<table border="1" id="dealsTable2" class="tablesorter">
<thead><tr>
	<th>#</th>
	<th>Nome</th>
	<th>Email</th>
	<th>Pedidos no site</th>
	<th>Data de registro</th>
	<th>Data em secs</th>
	<th>Facebook?</th>
	<th>Endere&ccedil;os</th>
	</tr>
	</thead><tbody>
	<%
		try {
			List<Client> cnolist = cman.list("getNoNewsLetterClients");
			counter = 1;
			for (Iterator<Client> iter = cnolist.iterator(); iter.hasNext();) {
				Client c = iter.next();
	%><tr>
		<td valign="top"><%=counter++%></td>
		<td valign="top"><%=c.getName()%></td>
		<td valign="top"><%=c.getUser().getLogin()%></td>
		<td valign="top"><%=c.getMealOrders().size()%></td>		
		<td valign="top"><%=sdf.format(c.getRegisteredOn())%></td>
		<td valign="top"><%=c.getRegisteredOn().getTime()%></td>
		<td valign="top"><%=c.getUser().getIsFacebook()%></td>
		<td><%=c.getAddresses().size()%></td>

	</tr>
	<%
		}
	%></tbody>
</table><%=(counter - 1)%> de <%=totalClients%>
<%
	} catch (Exception e) {
		e.printStackTrace();
		out.print("Error:" + e.getMessage());
	}
%>
</div>
</body>