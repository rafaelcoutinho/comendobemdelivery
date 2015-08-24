<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="br.com.copacabana.cb.entities.ClientLevel"%>
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
	String login = request.getParameter("login");
	Client c = null;
	ClientManager cman = new ClientManager();
	UserBeanManager uman = new UserBeanManager();
	if (login != null) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", login);
		java.util.List<UserBean> l = uman.list(UserBean.Queries.getUserByLogin.name(), m);
		if (l.isEmpty()) {
			out.print("Can't find user " + login);
		} else {
			UserBean ub = l.get(0);
			Authentication auth = new Authentication();
			c = cman.getByLogin(login);
		}
	}
	if ("updateLevel".equals(request.getParameter("action"))) {
		Datastore.getPersistanceManager().getTransaction().begin();
		ClientLevel newLevel = ClientLevel.valueOf(request.getParameter("newLevel"));
		c.setLevel(newLevel);
		cman.persist(c);
		Datastore.getPersistanceManager().getTransaction().commit();
		out.print(c.getEmail()+" -> "+newLevel.name()+" "+c.getLevel().ordinal()+"<br>");
	}
	if ("resetEveryBody".equals(request.getParameter("action"))) {
		
		List<Client> l = cman.list();
		for (Iterator<Client> iter = l.iterator(); iter.hasNext();) {
			Datastore.getPersistanceManager().getTransaction().begin();
			Client cc = iter.next();
			cc.setLevel(ClientLevel.NewBie);
			out.print(cc.getEmail()+" -> NEWBIE<br>");
			cman.persist(cc);
			Datastore.getPersistanceManager().getTransaction().commit();
		}
		
		out.print(l.size()+" clientes atualizados para NEWBIE<br>");
	}
%>


<%@page import="br.com.copacabana.cb.entities.Client"%><br />

<%
	if (c != null) {
%>
<form action="manageClientLevel.jsp"><input type="hidden"
	name="action" value="updateLevel"> <input type="hidden"
	name="login" value="<%=login%>"> <br>
Name: <%=c.getName()%><br>
Phone: <%=c.getMainPhone()%><br>
Total Online 30 dias: <%=cman.getOnlineOrdersLast30Days(c)%><br>
<%
String level = "";
if(c.getLevel()==null){
	c.setLevel(ClientLevel.NewBie);
}else{
	level= c.getLevel().name();	
}

%>
Level:
<select name="newLevel">
<option value="null">---- Selecione ---</option>
<option value="NewBie" <%if(level.equals("NewBie")){ %>selected="selected"<%} %>>NewBie - novato</option>
<option value="ConfirmedPaymentData" <%if(level.equals("ConfirmedPaymentData")){ %>selected="selected"<%} %>>ConfirmedPaymentData - verificado</option>
<option value="LoyalBuyer" <%if(level.equals("LoyalBuyer")){ %>selected="selected"<%} %>>LoyalBuyer - cliente bom</option>
<option value="Bad" <%if(level.equals("Bad")){ %>selected="selected"<%} %>>Bad - cliente ruim!!</option>
</select>

<input type="submit" value="salvar">
</form>
<hr>
<a href="manageClientLevel.jsp" >Carregar todo mundo</a><br>
<%
	}else{
%> <br />
Carregar:
<form action="manageClientLevel.jsp"><input type="hidden"
	name="action" value="load"> <select name="login">

	<%
		List<Client> clientlist = cman.list("getClient");
		for (Iterator<Client> iter = clientlist.iterator(); iter.hasNext();) {
			Client cli = iter.next();
	%>
	<option value="<%=cli.getUser().getLogin()%>"><%=cli.getName()%>
	- <%=cli.getUser().getLogin()%> : <%=cli.getLevel() %></option>
	<%
		}
	%>

</select><input type="submit"></form>
<br />

<form action="manageClientLevel.jsp">Ou via email: <input
	type="text" name="login"> <input type="hidden" name="action"
	value="load"><input type="submit"></form>
<br />
<br>
<hr>
<a href="manageClientLevel.jsp?action=resetEveryBody" onclick="return confirm('tem certeza?');">Resetar todo mundo</a><br>
<%}%><br>
