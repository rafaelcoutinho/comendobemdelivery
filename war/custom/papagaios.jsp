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

	String str = cman.getConfigurationValue("papagaios.id");
	String foodCatIdStr = cman.getConfigurationValue("papagaios.foodCats");
	JsonObject json = new JsonObject();
	if (str != null) {
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
		JsonObject taxesjson = new JsonObject();
		String delCostMatrix = cman.getConfigurationExtendedValue("papagaios.delCostMatrix");
		if(delCostMatrix!=null){
			String[] matrix =delCostMatrix.split("\\n");
			int i = 0; 
			
			for(i=0;i<matrix.length;i++){
				StringTokenizer stokenPlate = new StringTokenizer(matrix[i],"|");
				
				
				JsonObject dataJson = new JsonObject();
				dataJson.add("name",new JsonPrimitive(stokenPlate.nextToken()));
				dataJson.add("1",new JsonPrimitive(Integer.parseInt(stokenPlate.nextToken())));
				dataJson.add("2",new JsonPrimitive(Integer.parseInt(stokenPlate.nextToken())));
				dataJson.add("3",new JsonPrimitive(Integer.parseInt(stokenPlate.nextToken())));
				dataJson.add("4",new JsonPrimitive(Integer.parseInt(stokenPlate.nextToken())));
				String id = stokenPlate.nextToken();
				id=id.replace('\n',' ');
				id=id.trim();
				taxesjson.add(id,dataJson);
				
			}
			
		}
		json.add("delivery", taxesjson);
		
	}
%><%=json.toString() %>
