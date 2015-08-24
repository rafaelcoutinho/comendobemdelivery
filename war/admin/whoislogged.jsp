<%@page import="br.com.copacabana.cb.entities.LoginSession"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.Map"%>
<%@page import="br.copacabana.usecase.SessionMonitor"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.TimeZone"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<%
String patternDay = "kk:mm dd";
SimpleDateFormat day = new SimpleDateFormat(patternDay, new Locale("pt", "br"));
day.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
Map<Key, LoginSession> mls = (Map<Key, LoginSession>) request.getSession().getServletContext().getAttribute("activeSessions");
if (mls == null) {
	%>Ninguem logado<%
}else{

%>
Usuarios logados<br/>
<table>
	<tr>
		<th>Dados</th>
		<th>Tipo</th>
		<th>Desde</th>
	</tr>
	<%
for(Iterator<LoginSession> iter = mls.values().iterator();iter.hasNext();){
	LoginSession ls = iter.next();
	%><tr>
		<td><%=ls.getBasicInfo() %></td>
		<td><%=ls.getType() %></td>
		<td><%=day.format(ls.getLoggedIn())%></td>
	</tr>
	<% }
	}%>
</table>

