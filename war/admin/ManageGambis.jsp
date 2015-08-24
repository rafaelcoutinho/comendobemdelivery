<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb"
	tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
try{
	ConfigurationManager cman = new ConfigurationManager();
	String action = request.getParameter("action");
	if (action != null && action.equals("pizzadoro")) {
		String pid = request.getParameter("pizzadoro.id");
		String pct = request.getParameter("pizzadoro.pct");
		String[] foodCats = request
				.getParameterValues("pizzadoro.foodcats");
		StringBuilder sb = new StringBuilder();
		if (foodCats != null) {
			for (int i = 0; i < foodCats.length; i++) {
				sb.append(foodCats[i]).append("|");
			}
			sb.setLength(sb.length() - 1);
		}
		String hasSpecificLogic = request
				.getParameter("hasSpecificLogic");
		String steakHousemsg = request.getParameter("steakHouse.msg");
		cman.createOrUpdate("pizzadoro.id", pid);
		cman.createOrUpdate("pizzadoro.pct", pct);
		cman.createOrUpdate("pizzadoro.foodcats", sb.toString());
		cman.createOrUpdate("hasSpecificLogic", "true");		
		
		
	}
	if (action != null && action.equals("steak")) {
		String steakHouseId = request.getParameter("steakHouse.Id");
		String[] steakHouseFoodCats = request
				.getParameterValues("steakHouse.FoodCats");

		StringBuilder sb = new StringBuilder();
		if (steakHouseFoodCats != null) {
			for (int i = 0; i < steakHouseFoodCats.length; i++) {
				sb.append(steakHouseFoodCats[i]).append("|");
			}
			sb.setLength(sb.length() - 1);
		}
		String hasSpecificLogic = request
				.getParameter("hasSpecificLogic");
		String steakHousemsg = request.getParameter("steakHouse.msg");
		cman.createOrUpdate("steakHouse.Id", steakHouseId);
		cman.createOrUpdate("hasSpecificLogic", hasSpecificLogic);
		cman.createOrUpdate("steakHouse.msg", steakHousemsg);
		cman.createOrUpdate("steakHouse.Id", steakHouseId);
		cman.createOrUpdate("steakHouse.FoodCats", sb.toString());
	}
	if (action != null && action.equals("makis")) {
		String makisId = request.getParameter("makis.Id");
		String hasSpecificLogic = request.getParameter("hasSpecificLogic");
		String makisMsg = request.getParameter("makis.msg");
		String makisPackageId = request.getParameter("makis.package.id");
		cman.createOrUpdate("makis.msg", makisMsg);
		cman.createOrUpdate("makis.Id", makisId);
		cman.createOrUpdate("makis.package.id", makisPackageId);
		cman.createOrUpdate("hasSpecificLogic", hasSpecificLogic);
		
	}
	if (action != null && action.equals("papagaios")) {
		String id = request.getParameter("papagaios.id");
		String[] foodCats = request.getParameterValues("papagaios.foodCats");
		
		StringBuilder sb = new StringBuilder();
		if (foodCats != null) {
			for (int i = 0; i < foodCats.length; i++) {
				sb.append(foodCats[i]).append("|");
			}
			sb.setLength(sb.length() - 1);
		}
		
		String delCostMatrix = request.getParameter("papagaios.delCostMatrix");
		String hasSpecificLogic = request.getParameter("hasSpecificLogic");
		cman.createOrUpdate("papagaios.id", id);
		cman.createOrUpdate("hasSpecificLogic", hasSpecificLogic);
		cman.createOrUpdate("papagaios.foodCats", sb.toString());
		cman.createOrUpdateExtended("papagaios.delCostMatrix",delCostMatrix);
		
	}
	if(action != null && action.equals("canRetrieveAtRestaurant")) {
		String[] ids = request.getParameterValues("restIds");
		StringBuilder sb = new StringBuilder();
		if (ids != null) {
			for (int i = 0; i < ids.length; i++) {
				sb.append(ids[i]).append("|");
			}
			sb.setLength(sb.length() - 1);
		}
		String hasSpecificLogic = request.getParameter("hasSpecificLogic");
		cman.createOrUpdate("no.takeaway.ids", sb.toString());
		cman.createOrUpdate("hasSpecificLogic", hasSpecificLogic);
		
	}
	
%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<h3>Gambis</h3>
<br />
<a href="orphanAddresses.jsp">end. orfaos</a> | <a href="switcher.jsp">Mudar estado de pratos</a>
<hr>
Pro SteakHouse:
<form action="ManageGambis.jsp"><input type="hidden"
	name="action" value="steak" /> <select name="steakHouse.Id"
	value="<%=cman.getConfigurationValue("steakHouse.Id")%>">
	<%
		RestaurantManager rm = new RestaurantManager();
	
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (restKey.equals(cman.getConfigurationValue("steakHouse.Id"))) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
Foodcats: 
<%FoodCategoryManager fm = new FoodCategoryManager();
String stra= cman.getConfigurationValue("steakHouse.FoodCats");

%>

<select id="foodCats" name="steakHouse.FoodCats" multiple="multiple">
	<%
		
		for (Iterator iter = fm.list().iterator(); iter.hasNext();) {
			FoodCategory r = (FoodCategory) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected= "";
			if(stra.contains(restKey)){
				selected="selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected %>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br />
<%String val = cman.getConfigurationValue("hasSpecificLogic");%>
hasSpecificLogic:<select name="hasSpecificLogic"><option value="false">False</option><option value="true" <%if(val!=null &&val.equals("true")){ %>selected="selected"<%} %>>True</option></select>
	<br>
steakHouse.msg:<input type="text" name="steakHouse.msg"
	value="<%=cman.getConfigurationValue("steakHouse.msg")%>" size="100"> <br />
<input type="submit"></form>
<hr>
<br/>
Cuidado<br/>
<a href="oneTimePlateUpdater.jsp">One Time plate updater</a>
<hr>
<br>
Pro Makis:
<form action="ManageGambis.jsp"><input type="hidden"
	name="action" value="makis" /> <select name="makis.Id"
	value="<%=cman.getConfigurationValue("makis.Id")%>">
	<%
	
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (restKey.equals(cman.getConfigurationValue("makis.Id"))) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
<%if(cman.getConfigurationValue("makis.Id")!=null && cman.getConfigurationValue("makis.Id").length()>0){ 
	Restaurant makis = rm.getRestaurant(KeyFactory.stringToKey(cman.getConfigurationValue("makis.Id")));
	Set<Plate> plates = makis.getPlates();
	String currentMakisPackageId=cman.getConfigurationValue("makis.package.id");
	%>Embalagem: <select name="makis.package.id" ><%
	for(Iterator<Plate> iter = plates.iterator();iter.hasNext();){
		Plate p = iter.next();
		String k = KeyFactory.keyToString(p.getId());
		String selected="";
		if(k.equals(currentMakisPackageId)){
			selected=" selected='selected' ";
		}
%><option value="<%=k%>" <%=selected%>><%=p.getName()%></option>
<%} %>
</select>
<%}else{ %>
Embalagem Id:<input type="text" name="makis.package.id"/>
 
<%}%>
<br />
hasSpecificLogic:<select name="hasSpecificLogic"><option value="false">False</option><option value="true" <%if(val!=null &&val.equals("true")){ %>selected="selected"<%} %>>True</option></select>
	<br>
makis.msg:<input type="text" name="makis.msg"
	value="<%=cman.getConfigurationValue("makis.msg")%>" size="100"> <br />
<input type="submit"></form>
<br>
<hr>
<form action="ManageGambis.jsp">Restaurantes que nao permitem buscar. <br><input type="hidden"
	name="action" value="canRetrieveAtRestaurant" /> 
	<select name="restIds" multiple="multiple"	>
	<%
		String listNotAllowed = cman.getConfigurationValue("no.takeaway.ids");
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if(listNotAllowed!=null && listNotAllowed.length()>0 && listNotAllowed.contains(restKey)){
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select><Br> 
hasSpecificLogic:<select name="hasSpecificLogic"><option value="false">False</option><option value="true" <%if(val!=null &&val.equals("true")){ %>selected="selected"<%} %>>True</option></select>
	<br>
<input type="submit"></form>
<hr>
<hr>
<br>
Pro Papagaios:
<form action="ManageGambis.jsp" method="post"><input type="hidden"
	name="action" value="papagaios" /> <select name="papagaios.id"
	value="<%=cman.getConfigurationValue("papagaios.id")%>">
	<%		
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (restKey.equals(cman.getConfigurationValue("papagaios.id"))) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
<%
String ppfoodcats= cman.getConfigurationValue("papagaios.foodCats");

%>
Tipo de prato
<select id="foodCats" name="papagaios.foodCats" multiple="multiple">
	<%
		
		for (Iterator iter = fm.list().iterator(); iter.hasNext();) {
			FoodCategory r = (FoodCategory) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected= "";
			if(ppfoodcats.contains(restKey)){
				selected="selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected %>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br />
<%
		NeighborhoodManager nm = new NeighborhoodManager();
		StringBuffer delRangeData = new StringBuffer();
		
		if(cman.getConfigurationValue("papagaios.id")!=null && cman.getConfigurationValue("papagaios.id").length()>0){
			if(cman.getConfigurationExtendedValue("papagaios.delCostMatrix")==null || cman.getConfigurationExtendedValue("papagaios.delCostMatrix").equals("")){			
				Restaurant r = new RestaurantManager().get(KeyFactory.stringToKey(cman.getConfigurationValue("papagaios.id")));
				Set<DeliveryRange> rds = r.getDeliveryRanges();
				for (Iterator<DeliveryRange> iter = rds.iterator(); iter.hasNext();) {
					DeliveryRange dr = iter.next();
					delRangeData.append(nm.get(dr.getNeighborhood()).getName());
					delRangeData.append("|");
					delRangeData.append(dr.getCostInCents());
					delRangeData.append("|");
					delRangeData.append("000");
					delRangeData.append("|");
					delRangeData.append("000");
					delRangeData.append("|");
					delRangeData.append("000");
					delRangeData.append("|");
					delRangeData.append(KeyFactory.keyToString(dr.getNeighborhood()));
					delRangeData.append("\n");
				}
			}else{
				delRangeData.append(cman.getConfigurationExtendedValue("papagaios.delCostMatrix"));
			}
		
		}
		
	%>
</select> 
DelCostMatrix: Nome|custo p/1|p/2|p/3|p/4 ou +|Id do bairro#<br>
<textarea rows="5" cols="200" name="papagaios.delCostMatrix"><%=delRangeData.toString() %></textarea>



<br />
hasSpecificLogic:<select name="hasSpecificLogic"><option value="false">False</option><option value="true" <%if(val!=null &&val.equals("true")){ %>selected="selected"<%} %>>True</option></select>
	<br>
<input type="submit"></form>

<br>
<hr>
<br>
Pro Pizzzadoro:<br>
<form action="ManageGambis.jsp" method="post"><input type="hidden"
	name="action" value="pizzadoro" /> <select name="pizzadoro.id"
	value="<%=cman.getConfigurationValue("pizzadoro.id")%>">
	<%		
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (restKey.equals(cman.getConfigurationValue("pizzadoro.id"))) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
<select name="pizzadoro.foodcats" multiple="multiple">
	<%
	String pizzadoroFoodCats= cman.getConfigurationValue("pizzadoro.foodcats");
		for (Iterator iter = fm.list().iterator(); iter.hasNext();) {
			FoodCategory r = (FoodCategory) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected= "";
			if(pizzadoroFoodCats.contains(restKey)){
				selected="selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected %>><%=r.getName()%></option>
	<%
		}
	%>
</select><br/>
<input type="text" name="pizzadoro.pct" value="<%=cman.getConfigurationValue("pizzadoro.pct") %>"/>%<br/>
<input type="submit"> 
</form>

<%}catch(Exception e){
	e.printStackTrace();
out.println("<span style='color:red'>"+e.getMessage()+"</span>");
}%>