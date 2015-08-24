<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.spring.DeliveryManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>

<%@page import="br.com.copacabana.cb.entities.City"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%
	NeighborhoodManager nman = new NeighborhoodManager();
	String neighborStr = request.getParameter("key");
	Key neighKey = KeyFactory.stringToKey(neighborStr);
	Neighborhood n = nman.find(neighKey, Neighborhood.class);
	DeliveryManager deliveryRangeMan = new DeliveryManager();
	RestaurantManager reman = new RestaurantManager();

	Map<String, Object> m = new HashMap<String, Object>();
	m.put("neighborhood", neighKey);
	List<Restaurant> restList = reman.list("getRestaurantInNeighborhood", m);
%>

<%@page import="br.com.copacabana.web.Constants"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%><div
	class="fundoTelaEstatica"><a
	title="Cidades com delivery de pizza, lanches, churrasco, massas do www.comendobem.com.br"
	href="/cidadescomdelivery.do">Voltar para cidades com delivery</a>
<h2>Em <%=n.getCity().getName()%> no bairro <%=n.getName()%> o
tamb&eacute;m oferece delivery online de pizzas, massas, lanches,
sandu&iacute;ches.</h2>
<br />
<br />
Os seguintes restaurantes oferecem delivery de pedidos online neste
bairro de <%=n.getCity().getName()%>: <br />
<ul>
	<%
		for (Iterator<Restaurant> iter = restList.iterator(); iter.hasNext();) {
			Restaurant r = iter.next();
	%><li>
	<%
		if (r.getUniqueUrlName() != null && !r.getUniqueUrlName().equals("")) {
	%> <a title="<%=r.getName()%>"
		href="/<%=r.getUniqueUrlName()%>.restaurante"> <%
 	} else {
 %><a title="<%=r.getName()%>"
		href="/home.do?showRestaurant=true&restaurantId=<%=KeyFactory.keyToString(r.getId())%>&rName=<%=r.getName()%>">
	<%
		}
	%> <%=r.getName()%></a> - <%
 	if (r.getUniqueUrlName() != null && !r.getUniqueUrlName().equals("")) {
 %> <a
		title="Peça seu delivery de pizza, lanche, massas, churrasco, sanduiches no <%=r.getName()%>"
		href="/<%=r.getUniqueUrlName()%>.restaurante"> <%
 	} else {
 %><a
		title="Peça seu delivery de pizza, lanche, massas, churrasco, sanduiches no <%=r.getName()%>"
		href="/home.do?showRestaurant=true&restaurantId=<%=KeyFactory.keyToString(r.getId())%>&rName=<%=r.getName()%>">
	<%
		}
	%> Pe&ccedil;a seu delivery j&aacute;</a> <br />
	<div style="cursor: pointer; font-size: xx-small;"
		onclick="if(document.getElementById('t<%=r.getId().getId()%>').style.display=='block') {document.getElementById('t<%=r.getId().getId()%>').style.display='none';} else {document.getElementById('t<%=r.getId().getId()%>').style.display='block';}">Veja
	o card&aacute;pio para delivery do <%=r.getName()%></div>
	<div id="t<%=r.getId().getId()%>" style="display: none;">
	<%
		FoodCategoryManager fman = new FoodCategoryManager();
			for (Iterator<Plate> iterP = r.getPlates().iterator(); iterP.hasNext();) {
				Plate pp = iterP.next();
				FoodCategory fc = fman.find(pp.getFoodCategory(), FoodCategory.class);
	%><%=pp.getName()%> - <a href="/home.do"><%=fc.getName()%></a><br />
	<%
		}
	%>
	</div>
	<div style="cursor: pointer; font-size: xx-small;"
		onclick="if(document.getElementById('n<%=r.getId().getId()%>').style.display=='block') {document.getElementById('n<%=r.getId().getId()%>').style.display='none';} else {document.getElementById('n<%=r.getId().getId()%>').style.display='block';}">
	Veja onde mais o <%=r.getName()%> faz entregas (delivery) al&eacute;m
	do <%=n.getName()%> em <%=n.getCity().getName()%></div>
	<div id="n<%=r.getId().getId()%>" style="display: none;">
	<%
		for (Iterator<DeliveryRange> iterP = r.getDeliveryRanges().iterator(); iterP.hasNext();) {
				DeliveryRange pp = iterP.next();
				Neighborhood othern = (Neighborhood) nman.find(pp.getNeighborhood(), Neighborhood.class);
	%><%=othern.getName()%> - <%=othern.getCity().getName()%><br />
	<%
		}
	%> <a
		href="areaDeDeliveryDeRestaurante.do?r=<%=KeyFactory.keyToString(r.getId())%>"
		onclick="window.open(this.href,'delRange','location=1,status=1,scrollbars=1,width=440,height=300');return false;">Ver
	em pop-up</a><br />
	</div></li>
	<%
		}
	%>
</ul>

<br />
<h2>Escolha seu restaurante em <%=n.getCity().getName()%> no bairro
<%=n.getName()%> e fa&ccedil;a seu pedido de delivery online de pizzas,
massas, lanches, sandu&iacute;ches.<br />
</h2>

</div>