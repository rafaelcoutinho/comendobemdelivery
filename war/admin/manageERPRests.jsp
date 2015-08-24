Foodcats:
<%@page import="br.com.copacabana.cb.entities.Central"%>
<%@page import="br.com.copacabana.cb.entities.mgr.CentralManager"%>
<%@page import="br.com.copacabana.cb.app.Configuration"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="javax.persistence.NoResultException"%>
<%@page import="br.com.copacabana.cb.entities.SwitcherConf"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="br.com.copacabana.cb.entities.WorkingHours.DayOfWeek"%>
<%@page import="br.com.copacabana.cb.entities.PlateStatus"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br>
<%
	ConfigurationManager cman = new ConfigurationManager();
	

	if ("save".equals(request.getParameter("action"))) {
		String[] larger = request.getParameterValues("erpClients");
		if(larger==null){
			larger=new String[0];
		}
		StringBuilder largerStr = new StringBuilder();
		if (larger != null) {
			for (int i = 0; i < larger.length; i++) {
				largerStr.append(larger[i]).append(",");
			}
		}		
		cman.createOrUpdateExtended("erpClients", largerStr.toString());
	%><b>Acesso atualizado!</b><br><%
	}

	String erpClients = cman.getConfigurationExtendedValue("erpClients");	
%>

<form action="manageERPRests.jsp" method="post"><input type="hidden"
	name="action" value="save"> Restaurantes com acesso ao ERP:<br>




	<%
		RestaurantManager rm = new RestaurantManager();
	
			for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (erpClients.contains(restKey)) {
				selected = "checked=\"checked\"";
			}
	%><input type="checkbox" name="erpClients" value="<%=restKey%>"  <%=selected%>><label for="<%=restKey%>"><%=r.getName()%></label><br> 
	<%
		}
	%>
<input type="submit" value="Salvar"></form>
<br>
