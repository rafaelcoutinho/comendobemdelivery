
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
<%@page import="java.util.Iterator"%><jsp:include page="/admin/adminHeader.jsp"></jsp:include> <%

	String login= request.getParameter("login");
	
	UserBeanManager uman = new UserBeanManager();
	if(login!=null){
		
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", login);
		java.util.List<UserBean> l = uman.list(UserBean.Queries.getUserByLogin.name(), m);
		if(l.isEmpty()){
			out.print("Can't find user "+login);
		}else{
			UserBean ub = l.get(0);
			Authentication auth = new Authentication();
			if(ub.getIsFacebook()){
				
				auth.setUserType("client");
				auth.setSession(session);				
				auth.innnerHandleFBUserData(login);												
			}else{
				auth.authenticate(ub.getLogin(),ub.getPassword(),false,false);
			}
			AuthenticationController.setSessionValues(auth,request.getSession());
			out.print("Authenticado como: "+login+"<br><a href=\"/home.do\" target=\"_blank\">Ir para home</a>");
			if(request.getParameter("avoidTerms")!=null && request.getParameter("avoidTerms").equals("on")){
				session.removeAttribute("restaurantNotActive");
				out.print("Terms acceptance removed<Br>");
			}else{
				if(session.getAttribute("restaurantNotActive")!=null){
					out.print("Terms acceptance:"+session.getAttribute("restaurantNotActive")+"<Br>");
				}
			}
			
		}		
	}
	RestaurantManager rman = new RestaurantManager();
	List<Restaurant> rlist =  rman.list("getRestaurant");	
%>


<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.Client"%><br/>
<br/>
Autenticar como 
<form action="LoginAs.jsp">
<select name="login">
<option value="---">----RESTAURANTS----</option>
<%
for(Iterator<Restaurant> iter = rlist.iterator();iter.hasNext();){
	Restaurant rest = iter.next();
%><option value="<%=rest.getUser().getLogin() %>"><%=rest.getName() %> - <%=rest.getUser().getLogin() %></option>

<%}
if("true".equals(request.getParameter("loadClients"))){
%><option value="---">----CLIENTS----</option><%
ClientManager cman = new ClientManager();

List<Client> clientlist =  cman.list("getClient");
for(Iterator<Client> iter = clientlist.iterator();iter.hasNext();){
	Client cli = iter.next();
%>
<option value="<%=cli.getUser().getLogin() %>"><%=cli.getName() %> - <%=cli.getUser().getLogin() %></option>
<%} 
}%>
<option value="---">----CENTRAIS----</option>
<%
CentralManager centman = new CentralManager();

List<Central> centrais =  centman.list();
for(Iterator<Central> iter = centrais.iterator();iter.hasNext();){
	Central cli = iter.next();
%>
<option value="<%=cli.getUser().getLogin() %>"><%=cli.getName() %> - <%=cli.getUser().getLogin() %></option>
<%} %>
</select><input type="checkbox" name="avoidTerms" checked="false"></input>Avoid Terms?
<input type="submit">
</form><br/>

<form action="LoginAs.jsp">
Ou via email: <input type="text" name="login">
<input type="submit">
</form><br/>
<br><a href="LoginAs.jsp?loadClients=true">Carregar clientes</a>