<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%
ClientManager cm = new ClientManager();
List<Client> cs =  cm.list();
SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
Date since= sdf.parse("01-01-2011");
int counter=0;
for(Iterator<Client> iter = cs.iterator();iter.hasNext();){
	Client c = iter.next();
	if(c.getRegisteredOn()==null){
		c.setRegisteredOn(since);
		cm.update(c);
		counter++;
	}
}

%>Foram atualizados: <%=counter%> clientes