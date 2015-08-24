<%@page import="br.copacabana.spring.DeliveryManager"%>
<%@page import="com.google.appengine.api.datastore.Key"%>

<%@page import="java.util.HashSet"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.City"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="java.util.List"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.StringTokenizer"%>
<%!String normalizeName(String name) {
		return name.toLowerCase().replace('í', 'i').replace('ã', 'a').replace('ç', 'c').replace('õ', 'o').replace('ú', 'u');

	}%>
<%
	String restId = request.getParameter("restSelection");
	String action = request.getParameter("action");
	String cityId = request.getParameter("citySelection");
	String pasteNeeded = "";
	String currentDeliveryRange = null;
	if ("loadCurrentDeliveryRange".equals(action)) {
		
		RestaurantManager rman = new RestaurantManager();
		Restaurant r = rman.getRestaurant(KeyFactory.stringToKey(restId));
		StringBuilder sb = new StringBuilder();
		NeighborhoodManager nman = new NeighborhoodManager();
		for (Iterator<DeliveryRange> iter = r.getDeliveryRanges().iterator(); iter.hasNext();) {
			DeliveryRange dr = iter.next();
			if (dr.getNeighborhood() != null) {
				int mincost = dr.getMinimumOrderValueInCents();
				if (mincost == 0) {
					mincost = new Double(100 * dr.getMinimumOrderValue()).intValue();
				}
				int cost = dr.getCostInCents();
				if (cost == 0) {
					cost = new Double(100 * dr.getCost()).intValue();
				}
				sb.append(nman.get(dr.getNeighborhood()).getName()).append("|").append(cost).append("|").append(mincost).append("#");
				if (cityId == null && dr.getCity() != null) {
					cityId = KeyFactory.keyToString(dr.getCity());
				}
			} else {
				out.println("Há referencias a cidade toda");
			}
		}
		currentDeliveryRange = sb.toString();

	}

	if ("createDeliveryRange".equals(action)) {
		out.print("Criando:<Br>");
		EntityManagerBean em = CityIdentifier.getEntityManager(getServletContext());
		String[] nids = request.getParameterValues("nid");
		String[] minimum = request.getParameterValues("minimum");
		String[] cost = request.getParameterValues("cost");
		RestaurantManager rman = new RestaurantManager();
		NeighborhoodManager nman = new NeighborhoodManager();
		Restaurant r = rman.getRestaurant(KeyFactory.stringToKey(restId));
		if ("true".equals(request.getParameter("replaceAll"))) {
			r.setDeliveryRanges(new HashSet());
		}
		DeliveryManager delMan = new DeliveryManager();
		if (nids != null) {

			for (int i = 0; i < nids.length; i++) {
				DeliveryRange dr = new DeliveryRange();
				Key nk = KeyFactory.stringToKey(nids[i]);
				Neighborhood n = nman.find(nk, Neighborhood.class);
				dr.setNeighborhood(nk);
				dr.setRestaurant(r);
				dr.setMinimumOrderValueInCents(Integer.parseInt(minimum[i]));
				dr.setCostInCents(Integer.parseInt(cost[i]));
				Double cem = 100.0;
				Double costDouble = Double.parseDouble(cost[i]);
				costDouble/=cem;
				Double minDouble = Double.parseDouble(minimum[i]);
				minDouble/=cem;
				dr.setMinimumOrderValue(minDouble);
				dr.setCost(costDouble);
				
				r.addDeliveryRange(dr);
%><%=i%>: <%=n.getName() %> R$ <%=cost[i]%> mínimo: <%=minimum[i]%>|<span style="font-size: xx-small;font-style: italic;"><%=nids[i]%></span><br />
<%
	}

		}
		rman.persist(r);
		r = rman.getRestaurant(KeyFactory.stringToKey(restId));

	}
	if ("confirm".equals(action) || "paste".equals(action)) {
		EntityManagerBean em = CityIdentifier.getEntityManager(getServletContext());

		String newPlates = request.getParameter("newDeliveryRanges");
		StringTokenizer stoken = new StringTokenizer(newPlates, "#");
		RestaurantManager rman = new RestaurantManager();
		NeighborhoodManager nman = new NeighborhoodManager();
		Restaurant r = rman.getRestaurant(KeyFactory.stringToKey(restId));
		City c = new CityManager().getCity(KeyFactory.stringToKey(cityId));
		Set<Neighborhood> set = c.getNeighborhoods();
		Map<String, Neighborhood> map = new HashMap<String, Neighborhood>(set.size());
		for (Iterator<Neighborhood> iter = set.iterator(); iter.hasNext();) {
			Neighborhood n = iter.next();
			map.put(normalizeName(n.getName()), n);
		}
		StringBuilder onlyNotIdenfied = new StringBuilder();
		out.println("Há " + stoken.countTokens() + " para " + r.getName() + " em " + c.getName() + " "

		+ "<br><form action='deliveryRangeBulkupdate.jsp' method='post'><input type='hidden' name='restSelection' value='" + restId + "'><input type='hidden' name='action' value='createDeliveryRange'><table><tr><th></th><th>Nome</th><th>Custo</th><th>Valor mínimo</th><tr>");
		try {
			while (stoken.hasMoreElements()) {
				String plate = (String) stoken.nextElement();
				StringTokenizer stokenPlate = new StringTokenizer(plate, "|");
				String name = (String) stokenPlate.nextElement();
				String cost = (String) stokenPlate.nextElement();
				String minimum = "0";
				if (stokenPlate.hasMoreElements()) {
					minimum = (String) stokenPlate.nextElement();
				}
				Neighborhood n = map.get(normalizeName(name.trim()));
				if (n != null) {
%><tr>
	<td><input type="checkbox" checked="checked" name="nid"
		value="<%=KeyFactory.keyToString(n.getId())%>"></td>
	<td><%=n.getName()%></td>
	<td><input type='hidden' name='cost' value='<%=cost%>'><%=cost%></td>
	<td><input type='hidden' name='minimum' value='<%=minimum%>'><%=minimum%></td>
<tr>
	<%
		} else {
						onlyNotIdenfied.append("<tr><td><a href='http://gmaps-samples-v3.googlecode.com/svn/trunk/geocoder/v3-geocoder-tool.html#q%3D").append(name).append("%2C%20Campinas'>N/I</td><td>").append(name).append("</td><td>").append(cost).append("</td><td>").append(minimum).append("</td><tr>");
					}
				}
				out.print("<tr><td colspan=\"4\">-----------</td></tr>");
				out.print(onlyNotIdenfied.toString());
				out.print("</table><br/>");
	%>
	<input type="checkbox" checked="checked" name="replaceAll" value="true">
	<input type="submit" value="Criar selecionados">
	</form>
	<hr>
	<%
		} catch (Exception e) {
				out.print("<b style='color:red'>" + e.getMessage() + "</b>");

			}
		}
	%>


	<%@include file="/static/commonScript.html"%>
	<script>
	dojo.addOnLoad(function() {
		initRests();
	});
	function loadFoodCat(){
    	var stateStore = new dojo.data.ItemFileReadStore({
            url: "/listCitiesItemFileReadStore.do"
        });
        dijit.byId("citySelection").store = stateStore;
        dijit.byId('citySelection').attr('value','<%=cityId%>');
        
    }
	function initRests() {
		loadOtherRestaurants();
		dijit.byId('restSelection').onChange = loadRestData;		
		dijit.byId('restSelection').attr('value','<%=restId%>');
		loadFoodCat();
	}
	function loadRestData() {
	}
	function loadOtherRestaurants() {
		var stateStore = new dojo.data.ItemFileReadStore({
			url : "/admin/listRestaurants.do"
		});
		dijit.byId("restSelection").store = stateStore;
		
	}
	function loadIt(){
		window.location='deliveryRangeBulkupdate.jsp?action=loadCurrentDeliveryRange&restSelection='+dijit.byId("restSelection").attr('value')
	}
	
</script>
	<body class="tundra">

	<br />
	<form action="deliveryRangeBulkupdate.jsp" method="post">Selecione
	um restaurante: <input type="hidden" name="action" value="paste">
	<select dojoType="dijit.form.FilteringSelect" id="restSelection"
		name="restSelection" autoComplete="true"></select> <a
		href="javascript:loadIt()">carregar</a><br />
	Selecione uma cidade: <select dojoType="dijit.form.FilteringSelect"
		id="citySelection" name="citySelection" autoComplete="true"></select>
	<br />
	ToPaste: <textarea id="toPaste" name="newDeliveryRanges" cols="100"
		rows="20"><%
		if (currentDeliveryRange != null) {
			out.print(currentDeliveryRange);
		}
	%></textarea> <input type="submit" value="PasteRanges"></form>
	</body>