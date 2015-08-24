<%@page import="br.copacabana.usecase.control.FromSource"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.app.Configuration"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%

ConfigurationManager cman = new ConfigurationManager();
if(request.getParameter("create")!=null){
	String key = request.getParameter("key");
	String value = request.getParameter("value");
	cman.createOrUpdate(FromSource.PREFIX_DEST+key,value);
	response.sendRedirect("manageSrcDestination.jsp");
}

List<Configuration>  l = cman.list("listAllConf");
List<Configuration> destinations = new ArrayList<Configuration>();
for(Iterator<Configuration> iter = l.iterator();iter.hasNext();){
	Configuration c = iter.next();
	if(c.getKey().startsWith(FromSource.PREFIX_DEST)){
		destinations.add(c);
	}
}
%>

<jsp:include page="/admin/adminHeader.jsp"></jsp:include>
Criar destino para usuários oriundos de determinados fontes.<Br>
<form action="manageSrcDestination.jsp">
ID fonte: <input  type="text" name="key" value=""> (ex. 1 ou newsletter ou newsletter2)<br>
Url destino: <input  type="text" name="value" value=""> <br>
<input type="submit">
<input type="hidden" name="create" value="true">
</form>
<hr><table><thead><tr><th>ID</th><th>Destino</th><th>Total</th></tr></thead><tbody>
<%for(Iterator<Configuration> iter = destinations.iterator();iter.hasNext();){
	Configuration c=iter.next();
	String key = c.getKey().substring(FromSource.PREFIX_DEST.length());
	Configuration total = cman.get(FromSource.PREFIX_COUNTER+key);
	int counter=0;
	if(total!=null){
		counter=Integer.parseInt(total.getValue());
	}
	%><tr>
	<td><%=key %></td>
	<td><%=c.getValue() %></td>
	<td><%=counter%></td></tr><%
	
}%>
</tbody>
</table>
</form>