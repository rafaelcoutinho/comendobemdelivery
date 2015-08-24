<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.ConfigurationExtended"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include>
Buscando logs:<br>
<%
ConfigurationManager cm = new ConfigurationManager();
if(request.getParameter("delete")!=null){
	ConfigurationExtended c= cm.getConfigurationExtended(request.getParameter("delete"));
	Datastore.getPersistanceManager().getTransaction().begin();
	Datastore.getPersistanceManager().remove(c);
	Datastore.getPersistanceManager().getTransaction().commit();
	response.sendRedirect("checkClientMonitorLogs.jsp");
	
}
List<ConfigurationExtended> l = cm.listExtends();
for(Iterator<ConfigurationExtended> iter= l.iterator();iter.hasNext();){
	ConfigurationExtended conf = iter.next();
	if(conf.getKey().startsWith("logs_")){		
		%><h2><%=conf.getKey() %></h2> 
		<pre><%=conf.getValue() %>
		</pre>
		<a href="checkClientMonitorLogs.jsp?delete=<%=conf.getKey() %>">apagar</a>
		<hr>	
		<%
	}
}
%>