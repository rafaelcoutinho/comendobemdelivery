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
<%
	ConfigurationManager cman = new ConfigurationManager();
	CentralManager cm = new CentralManager();

	if ("save".equals(request.getParameter("action"))) {
		String[] larger = request.getParameterValues("restIdsLarger");
		String[] notepad = request.getParameterValues("restIdsNotepad");
		String[] extendednotepad = request.getParameterValues("restIdsExtendedNotepad");
		StringBuilder largerStr = new StringBuilder();
		if (larger != null) {
			for (int i = 0; i < larger.length; i++) {
				largerStr.append(larger[i]).append(",");
			}
		}
		StringBuilder notepadStr = new StringBuilder();
		if (notepad != null) {
			
			for (int i = 0; i < notepad.length; i++) {
				notepadStr.append(notepad[i]).append(",");
			}
		}
		StringBuilder extendednotepadStr = new StringBuilder();
		if (extendednotepad != null) {
			
			for (int i = 0; i < extendednotepad.length; i++) {
				extendednotepadStr.append(extendednotepad[i]).append(",");
			}
		}
		cman.createOrUpdateExtended("largerPrintKeys", largerStr.toString());
		cman.createOrUpdateExtended("notepadPrintKeys", notepadStr.toString());
		cman.createOrUpdateExtended("extendednotepadPrintKeys", extendednotepadStr.toString());

	}
	if ("delete".equals(request.getParameter("action"))) {
	}

	String largerConf = cman.getConfigurationExtendedValue("largerPrintKeys");
	String notepadConf = cman.getConfigurationExtendedValue("notepadPrintKeys");
	String extendednotepadConf = cman.getConfigurationExtendedValue("extendednotepadPrintKeys");
	
%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br>
<form action="managePrintTypes.jsp"><input type="hidden"
	name="action" value="save"> NotePad<br>
Restaurante:<select name="restIdsNotepad" multiple="multiple">
	<%
		RestaurantManager rm = new RestaurantManager();
	
		for (Iterator iter = cm.list().iterator(); iter.hasNext();) {
			Central c = (Central)iter.next();
			String centralKey = KeyFactory.keyToString(c.getId());
			String selected = "";
			if (notepadConf.contains(centralKey)) {
				selected = "selected='selected'";
			}
	%><option value="<%=centralKey%>" <%=selected%>><%=c.getName()%></option>
	<%
		}
	
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (notepadConf.contains(restKey)) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
<hr>
Larger<br>
Restaurante:<select name="restIdsLarger" multiple="multiple">


	<%
	for (Iterator iter = cm.list().iterator(); iter.hasNext();) {
		Central c = (Central)iter.next();
		String centralKey = KeyFactory.keyToString(c.getId());
		String selected = "";
		if (largerConf.contains(centralKey)) {
			selected = "selected='selected'";
		}
%><option value="<%=centralKey%>" <%=selected%>><%=c.getName()%></option>
<%
	}
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (largerConf.contains(restKey)) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
<hr>
Extended Notepad<br>
Restaurante:<select name="restIdsExtendedNotepad" multiple="multiple">


	<%
	for (Iterator iter = cm.list().iterator(); iter.hasNext();) {
		Central c = (Central)iter.next();
		String centralKey = KeyFactory.keyToString(c.getId());
		String selected = "";
		if (extendednotepadConf.contains(centralKey)) {
			selected = "selected='selected'";
		}
%><option value="<%=centralKey%>" <%=selected%>><%=c.getName()%></option>
<%
	}
		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			String selected = "";
			if (extendednotepadConf.contains(restKey)) {
				selected = "selected='selected'";
			}
	%><option value="<%=restKey%>" <%=selected%>><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
<input type="submit" value="Salvar"></form>
<br>
