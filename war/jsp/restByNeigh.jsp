<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="br.copacabana.spring.search.bean.RestaurantBean"%>
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
	CityManager cityman = new CityManager();
	String neighborStr = request.getParameter("key");
	Key neighKey = KeyFactory.stringToKey(neighborStr);
	Neighborhood n = nman.find(neighKey, Neighborhood.class);
	RestaurantManager reman = new RestaurantManager();

	Map<String, Object> m = new HashMap<String, Object>();
	m.put("neighborhood", neighKey);
	List<Restaurant> restList = reman.list("getRestaurantInNeighborhood", m);
	String nname = n.getName().replace(' ', '-');
	nname = nname.toLowerCase();
	String cname = n.getCity().getName().toLowerCase();
	cname = cname.replace(' ', '-');
%>
<style>
.fundoTelaEstatica a {
	font-size: 1.4em;
}
</style>
<%@page import="br.com.copacabana.web.Constants"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%><div
	class="fundoTelaEstatica"><a
	title="Cidades com delivery de pizza, lanches, churrasco, massas do www.comendobem.com.br"
	href="/cidadescomdelivery.do">Voltar para cidades com delivery</a>
<h2>Em <a title="Delivery em <%=n.getCity().getName()%>"
	href="/<%=cname%>"><%=n.getCity().getName()%></a> no <a
	title="Delivery em <%=n.getCity().getName()%> no <%=n.getName()%>"
	href="/<%=cname%>/<%=nname%>">bairro <%=n.getName()%></a> o
tamb&eacute;m oferece <a title="Delivery de pizza massas lanches sushi"
	href="/<%=cname%>/<%=nname%>">delivery online de pizzas, massas,
lanches, sandu&iacute;ches</a>.</h2>
<br />
<br />
Os seguintes restaurantes oferecem delivery de pedidos online neste
bairro de <%=n.getCity().getName()%>: <br />
<ul>
	<%
		for (Iterator<Restaurant> iter = restList.iterator(); iter.hasNext();) {
			Restaurant r = iter.next();
			RestaurantBean rbean = new RestaurantBean(r);
	%><li>

	<div typeof="vcard:VCard commerce:Business"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
		xmlns:commerce="http://search.yahoo.com/searchmonkey/commerce/"
		xmlns:review="http://purl.org/stuff/rev#"
		xmlns:xsd="http://www.w3.org/2001/XMLSchema#"><span
		property="rdfs:label vcard:fn"> <a title="<%=r.getName()%>"
		href="<%=rbean.getDirectAccessUrl()%>"> <%=r.getName()%></a> - <a
		title="Peça seu delivery de pizza, lanche, massas, churrasco, sanduiches no <%=r.getName()%>"
		href="<%=rbean.getDirectAccessUrl()%>"> Pe&ccedil;a seu delivery
	j&aacute;</a> <br />
	</span> Funcionamento hoje das <span property="commerce:hoursOfOperation">
	<%=r.getTodaysWO().getStartingHour()%>:<%=r.getTodaysWO().getStartingMinute()%>
	&agrave;s <%=r.getTodaysWO().getClosingHour()%>:<%=r.getTodaysWO().getClosingMinute()%>.
	</span>
	<div style="cursor: pointer; font-size: xx-small;"
		onclick="if(document.getElementById('t<%=r.getId().getId()%>').style.display=='block') {document.getElementById('t<%=r.getId().getId()%>').style.display='none';} else {document.getElementById('t<%=r.getId().getId()%>').style.display='block';}">Veja
	o card&aacute;pio para delivery do <%=r.getName()%></div>
	<div id="t<%=r.getId().getId()%>" style="display: none;">
	<%
		FoodCategoryManager fman = new FoodCategoryManager();
			for (Iterator<Plate> iterP = r.getPlates().iterator(); iterP.hasNext();) {
				Plate pp = iterP.next();
				FoodCategory fc = fman.find(pp.getFoodCategory(), FoodCategory.class);
	%><%=pp.getName()%> - <span property="commerce:cuisine"><a
		href="/home.do"><%=fc.getName()%></a></span><br />
	<%
		}
	%>
	</div>
	<div style="cursor: pointer; font-size: xx-small;"
		onclick="if(document.getElementById('n<%=r.getId().getId()%>').style.display=='block') {document.getElementById('n<%=r.getId().getId()%>').style.display='none';} else {document.getElementById('n<%=r.getId().getId()%>').style.display='block';}">
	Veja onde mais o <%=r.getName()%> faz entregas (delivery) al&eacute;m
	do <%=n.getName()%> em
	<div rel="vcard:adr">
	<div typeof="vcard:Address"><span property="vcard:locality"><%=n.getCity().getName()%></span>
	<span property="vcard:region"><%=n.getCity().getState().getName()%></span>
	</div>
	</div>
	</div>
	<div id="n<%=r.getId().getId()%>" style="display: none;">
	<%
		for (Iterator<DeliveryRange> iterP = r.getDeliveryRanges().iterator(); iterP.hasNext();) {
				DeliveryRange pp = iterP.next();
				if (pp.getNeighborhood() != null) {
					Neighborhood othern = (Neighborhood) nman.find(pp.getNeighborhood(), Neighborhood.class);
	%>
	<div rel="vcard:adr">
	<div typeof="vcard:Address"><span property="vcard:locality"><%=othern.getName()%>,
	<%=othern.getCity().getName()%></span> <span property="vcard:region"><%=othern.getCity().getState().getName()%></span>
	</div>
	</div>

	<%
		out.print(othern.getName() + " - " + othern.getCity().getName());
				} else {
					String name = ((City) cityman.find(pp.getCity(), City.class)).getName();
	%>
	<div rel="vcard:adr">
	<div typeof="vcard:Address"><span property="rdfs:label">Toda
	<%=name%></span></div>
	</div>

	<%
		}
	%><br />
	<%
		}
	%> <a
		href="areaDeDeliveryDeRestaurante.do?r=<%=KeyFactory.keyToString(r.getId())%>"
		onclick="window.open(this.href,'delRange','location=1,status=1,scrollbars=1,width=440,height=300');return false;">Ver
	em pop-up</a><br />
	</div>

	</div>
	</li>
	<%
		}
	%>
</ul>

<br />
<h2>Escolha seu restaurante em <a
	title="Delivery em <%=n.getCity().getName()%>" href="/<%=cname%>"><%=n.getCity().getName()%></a>
no <a title="Delivery em <%=n.getCity().getName()%> no <%=n.getName()%>"
	href="/<%=cname%>/<%=nname%>">bairro <%=n.getName()%></a> e fa&ccedil;a
seu pedido de delivery online de pizzas, massas, lanches,
sandu&iacute;ches.<br />
</h2>



</div>