<%@page import="br.copacabana.usecase.MonitorCriticalPendingRequestsCommand"%>
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
		String rest = request.getParameter("rest");
		String delay = request.getParameter("delay");				
		cman.createOrUpdate("delay_"+rest, delay);
	%><b>Alerta atualizado!</b><br><%
	}
		
%>
Configurar temporizador de alerta por restaurante em segundos (-1 ou vazio é imediato):<br/>





	<%
		RestaurantManager rm = new RestaurantManager();
	
			for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
			
			
	%><form action="manageDelayNotification.jsp" method="post"><input type="hidden"
	name="action" value="save"> <input type="hidden"
	name="rest" value="<%=restKey %>"> <%=r.getName() %> <input type="text" name="delay" value="<%=MonitorCriticalPendingRequestsCommand.getRestaurantAlertDelay(r.getId())%>"  > <input type="submit" value="atualizar"><br/></form> 
	<%
		}
	%>

<br>
