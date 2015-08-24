<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="com.ibm.icu.util.StringTokenizer"%>
<%@page import="com.google.gson.JsonPrimitive"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%
	ConfigurationManager cman = new ConfigurationManager();

	String str = cman.getConfigurationValue("pizzadoro.id");
	String foodCatIdStr = cman.getConfigurationValue("pizzadoro.foodcats");
	String pct = cman.getConfigurationValue("pizzadoro.pct");
	JsonObject json = new JsonObject();
	if (str != null) {
		json.add("pct",new JsonPrimitive(pct));
		json.add("id",new JsonPrimitive(str));
		json.add("foodCatIdStr",new JsonPrimitive(pct));
		Key k = KeyFactory.stringToKey(str);
		RestaurantManager rm = new RestaurantManager();
		Restaurant r = rm.get(k);
		List<Plate> ps = new ArrayList<Plate>();
		JsonObject pjson = new JsonObject();
		for (Iterator<Plate> iter = r.getPlates().iterator(); iter.hasNext();) {
			Plate p = iter.next();
			if (foodCatIdStr.contains(KeyFactory.keyToString(p.getFoodCategory()))) {
				pjson.add(KeyFactory.keyToString(p.getId()), new JsonPrimitive(true));
			}
		}
		json.add("plates", pjson);
	}
%><%=json.toString() %>
