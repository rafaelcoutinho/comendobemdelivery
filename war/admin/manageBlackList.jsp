<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.spring.UserBeanManager"%>
<%@page import="br.com.copacabana.cb.entities.Central"%>
<%@page import="br.com.copacabana.cb.entities.mgr.CentralManager"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.AuthenticationController"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="java.util.Iterator"%><jsp:include
	page="/admin/adminHeader.jsp"></jsp:include>
<%


ConfigurationManager confman = new ConfigurationManager();
ClientManager cman = new ClientManager();


if ("save".equals(request.getParameter("action"))) {
	String[] larger = request.getParameterValues("blacklist");
	StringBuilder largerStr = new StringBuilder();
	if (larger != null) {
		for (int i = 0; i < larger.length; i++) {
			largerStr.append("|").append(larger[i]).append("|,");
		}
	}	
	confman.createOrUpdateExtended("blacklist", largerStr.toString());	
}
String largerConf = confman.getConfigurationExtendedValue("blacklist");
if ("bymail".equals(request.getParameter("action"))) {
	String email = request.getParameter("mail");
	Client c = cman.getByLogin(email);
	if(c==null){
		%><b>Can't find user with email '<%=email %>'</b><%
	}else{
		if(!largerConf.contains("|"+c.getUser().getIdStr()+"|,")){
			largerConf=largerConf+"|"+c.getUser().getIdStr()+"|,";
			confman.createOrUpdateExtended("blacklist", largerConf);
		}
	}
	
	
}

	
%><!--  current list: <%=largerConf%> -->


<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.Client"%><br />
<br />
Usuários suspeitos<br/>
<form action="manageBlackList.jsp">
<input type="hidden" name="action" value="save">
<select name="blacklist" multiple="multiple">	
	<%

			List<Client> clientlist = cman.list("getClient");
			for (Iterator<Client> iter = clientlist.iterator(); iter.hasNext();) {
				Client cli = iter.next();
				String selected="";
				if(largerConf.contains("|"+cli.getUser().getIdStr()+"|")){
					selected="selected='selected'";
				}
	%>
	<option value="<%=cli.getUser().getId().getId()%>" <%=selected %> 
	><%=cli.getName()%>
	- <%=cli.getUser().getLogin()%></option>
	<%
		}
		
	%>

</select>
<input type="submit"></form>
<br />

<form action="manageBlackList.jsp"><input type="hidden" name="action" value="bymail">Ou via email: <input type="text"
	name="mail"> <input type="submit"></form>
<br />
<br>
<a href="LoginAs.jsp?loadClients=true">Carregar clientes</a>