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
	FoodCategoryManager fm = new FoodCategoryManager();
	ConfigurationManager cman = new ConfigurationManager();
	if ("schedule".equals(request.getParameter("action"))) {
		Key restId = KeyFactory.stringToKey(request.getParameter("restId"));

		String[] wdays = request.getParameterValues("weekDay");
	
		String[] catIds = request.getParameterValues("catId");
		//DayOfWeek weekDay = DayOfWeek.valueOf(request.getParameter("weekDay"));
		PlateStatus status = PlateStatus.valueOf(request.getParameter("toStatus"));
		/* try {
			SwitcherConf conf = SwitcherConf.listRestConfsByDate(restId, weekDay, catId);
			Datastore.getPersistanceManager().getTransaction().begin();
			Datastore.getPersistanceManager().remove(conf);
			
		} catch (NoResultException ne) {

		}*/
		for (int i = 0; i < wdays.length; i++) {
			DayOfWeek weekDay = DayOfWeek.valueOf(wdays[i]);
			for (int j = 0; j < catIds.length; j++) {
				Key catId = KeyFactory.stringToKey(catIds[j]);
				Datastore.getPersistanceManager().getTransaction().begin();
				SwitcherConf conf = new SwitcherConf(restId, catId, status, weekDay);
				Datastore.getPersistanceManager().persist(conf);
				Datastore.getPersistanceManager().getTransaction().commit();
			}
		}
		response.sendRedirect("switcher.jsp");
	}
	if ("delete".equals(request.getParameter("action"))) {
		Long id = Long.parseLong(request.getParameter("id"));
		SwitcherConf conf = SwitcherConf.getConf(id);
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().remove(conf);
		Datastore.getPersistanceManager().getTransaction().commit();
		response.sendRedirect("switcher.jsp");
	}
	List<SwitcherConf> list = SwitcherConf.list();
%>
<link rel="stylesheet" href="/styles/tableSortable.css" type="text/css"/>
<style>
/* tables overwrite */
table.tablesorter {
	width: 55%;
}
</style>
<script type="text/javascript" src="/scripts/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.tablesorter.min.js"></script>
<script>
$(document).ready(function(){
	console.log($("#dealsTable"));
	$("#dealsTable").tablesorter({sortList:[[0,0]], widgets: ['zebra'], headers:{}});

} 
);

</script>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br>
<form action="switcher.jsp" method="post">
<input type="hidden" name="action" value="schedule">
Categoria:<select
	id="foodCats" name="catId" multiple="multiple">
	<%
		for (Iterator iter = fm.list().iterator(); iter.hasNext();) {
			FoodCategory r = (FoodCategory) iter.next();
			String key = KeyFactory.keyToString(r.getId());
	%><option value="<%=key%>"><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
Restaurante:<select name="restId">
	<%
		RestaurantManager rm = new RestaurantManager();

		for (Iterator iter = rm.list().iterator(); iter.hasNext();) {
			Restaurant r = (Restaurant) iter.next();
			String restKey = KeyFactory.keyToString(r.getId());
	%><option value="<%=restKey%>"><%=r.getName()%></option>
	<%
		}
	%>
</select> <br>
Status:<select name="toStatus">
	<option value="<%=PlateStatus.AVAILABLE.name()%>">Disponivel</option>
	<option value="<%=PlateStatus.UNAVAILABLE.name()%>">NÃO
	Disponivel</option>
	<option value="<%=PlateStatus.HIDDEN.name()%>">Oculto</option>
</select><br>
Dia da semana (a executar na madrugada):<select name="weekDay" multiple="multiple">
	<option value="<%=DayOfWeek.MONDAY.name()%>"><%=DayOfWeek.MONDAY.name()%></option>
	<option value="<%=DayOfWeek.TUESDAY.name()%>"><%=DayOfWeek.TUESDAY.name()%></option>
	<option value="<%=DayOfWeek.WEDNESDAY.name()%>"><%=DayOfWeek.WEDNESDAY.name()%></option>
	<option value="<%=DayOfWeek.THURSDAY.name()%>"><%=DayOfWeek.THURSDAY.name()%></option>
	<option value="<%=DayOfWeek.FRIDAY.name()%>"><%=DayOfWeek.FRIDAY.name()%></option>
	<option value="<%=DayOfWeek.SATURDAY.name()%>"><%=DayOfWeek.SATURDAY.name()%></option>
	<option value="<%=DayOfWeek.SUNDAY.name()%>"><%=DayOfWeek.SUNDAY.name()%></option>

</select> <br>
<input type="submit" value="Trocar"></form>
<br>
<table border="0" id="dealsTable" class="tablesorter">
<thead>
	<tr><th>Dia</th><th>Rest</th><th>Cate</th><th>Status</th><th>Ultima exec</th><th></th></tr>
	</thead><tbody>

	<%
		RestaurantManager rman = new RestaurantManager();
		FoodCategoryManager fman = new FoodCategoryManager();
		for (Iterator<SwitcherConf> iter = list.iterator(); iter.hasNext();) {
			SwitcherConf conf = iter.next();
	%><tr>
		<td><%=conf.getDayOfWeek().name()%></td>
		<td><%=rman.get(conf.getRestId()).getName()%></td>
		<td><%=fman.get(conf.getFoodCat()).getName()%></td>
		<td><%=conf.getToStatus().name()%></td>
		<td><%=conf.getLastRun()%></td>
		<td><a href="switcher.jsp?action=delete&id=<%=conf.getId().toString()%>">apagar</a></td>
	</tr>
	<%
		}
	%></tbody>
</table>
<br>
<a href="/cron/runCategoriesSwitcher" target="_blank">Executar as de hoje na mão</a>