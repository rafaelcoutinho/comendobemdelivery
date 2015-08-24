
<%@page import="br.copacabana.spring.CityManager"%>
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
<%
	CityManager cman = new CityManager();
	NeighborhoodManager nman = new NeighborhoodManager();
	List<City> cities = cman.list("getCities");
%>

<div class="fundoTelaEstatica">
<h2>O ComendoBem possui delivery e pedidos de entrega nas seguintes
cidades:</h2>
<br />
<%
	for (Iterator<City> iter = cities.iterator(); iter.hasNext();) {
		City c = iter.next();
%><p>Delivery na cidade de <%=c.getName()%> e faz delivery nos
bairros</p>
<ul>
	<%
		Map<String, Object> m = new HashMap<String, Object>();
			m.put("city", c);
			List<Neighborhood> ln = nman.list("searchNeighborhoodByCity", m);
			if (ln.size() == 0) {
	%><li>Breve! Aguarde.</li>
	<%
		}
			String cname = c.getName().toLowerCase();
			cname = cname.replace(' ', '-');
			for (Iterator<Neighborhood> iter2 = ln.iterator(); iter2.hasNext();) {
				Neighborhood n = iter2.next();
				String nname = n.getName().replace(' ', '-');
				nname = nname.toLowerCase();
	%><li><a
		title="Peça delivery de seu delivery de pizza, lanche, massas, churrasco, sanduiches no bairro <%=n.getName()%> de <%=n.getCity().getName()%> pelo www.comendobem.com.br"
		href="restaurantesPorBairros.do?key=<%=KeyFactory.keyToString(n.getId())%>">Delivery
	no bairro <%=n.getName()%></a><br>
	Ou peça já <a href="/<%=cname%>/<%=nname%>">Delivery no <%=n.getName()%>
	em <%=n.getCity().getName()%></a></li>
	<%
		}
	%>
</ul>
<%
	}
%>
</div>
