<%@page import="java.util.Date"%>
<%@page import="br.copacabana.util.TimeController"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.com.copacabana.cb.entities.InvitationState"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.usecase.invitation.InvitationManager"%>
<%@page import="br.com.copacabana.cb.entities.Invitation"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br/>
<%
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm:ss");
sdf.setTimeZone(TimeController.getDefaultTimeZone());
String sStr="10/03/2011 00:00:00";
if(request.getParameter("start")!=null){
	sStr=request.getParameter("start");
}
ClientManager cm = new ClientManager();
	Date start = sdf.parse(sStr);
	int perInvitation = 1;
	int perOrder = 5;
	int perFriendsOrder = 2;
	if (request.getParameter("perOrder") != null) {
		perOrder = Integer.parseInt(request.getParameter("perOrder"));
	}
	if (request.getParameter("perInvitation") != null) {
		perInvitation = Integer.parseInt(request.getParameter("perInvitation"));
	}
	if (request.getParameter("perFriendsOrder") != null) {
		perFriendsOrder = Integer.parseInt(request.getParameter("perFriendsOrder"));
	}

	int totalPerInvitation = 0;
	int totalPerFriendsOrders = 0;
	int totalPerOrders = 0;
	String email = request.getParameter("email");
	if (email != null) {
		
		Client c = cm.getByLogin(email);
%>Cliente:
<%=c.getName()%><br>
<%
	InvitationManager im = new InvitationManager();
		List<Invitation> invs = im.listConfirmedInvitationsFromDate(c.getId(),start);
		totalPerInvitation=invs.size();
		List<String> inviteeEmails = new ArrayList<String>();
		for (Iterator<Invitation> iter = invs.iterator(); iter.hasNext();) {
			Invitation inv = iter.next();
			if (InvitationState.CONFIRMED.equals(inv.getStatus())) {				
				inviteeEmails.add(inv.getEmail());
			}
		}
		OrderManager om = new OrderManager();

		for (Iterator<String> iter = inviteeEmails.iterator(); iter.hasNext();) {
			String email2 = iter.next();
			try {

				Client cc = cm.getByLogin(email2);
				totalPerFriendsOrders+=om.listClientOrdersSince(cc,start).size();
				
			} catch (Exception e) {
				out.println("cannot find user " + email2);
			}
		}
		totalPerOrders+=om.listClientOrdersSince(c,start).size();
		

	}
%>

<table>
	<tr>
		<td>Convites confirmados</td>
		<td><%=totalPerInvitation%> x <%=perInvitation %></td>
		<td><%=totalPerInvitation*perInvitation %></td>
	</tr>
	<tr>
		<td>Pedidos de amigos</td>
		<td><%=totalPerFriendsOrders%> x <%=perFriendsOrder %></td>
		<td><%=totalPerFriendsOrders*perFriendsOrder %></td>
	</tr>
	<tr>
		<td>Pedidos próprios</td>
		<td><%=totalPerOrders%> x <%=perOrder %></td>
		<td><%=totalPerOrders*perOrder %></td>
	</tr>
	<tr>
		<td>Totals</td>
		<td></td>
		<td><%=(totalPerOrders*perOrder + totalPerFriendsOrders*perFriendsOrder + totalPerInvitation*perInvitation)%></td>
	</tr>
</table>
<br>
<form action="calculatePoints.jsp"><br>
Desde:<input type="text"
	name="start" value="<%=sdf.format(start)%>"></br>
Por convite:<input type="text"
	name="perInvitation" value="<%=perInvitation%>"></br>
Por pedido proprio:<input type="text" name="perOrder"
	value="<%=perOrder%>"></br>
Por pedido amigo:<input type="text" name="perFriendsOrder"
	value="<%=perFriendsOrder%>"></br>
E-mail para cálculo:<select name="email" >
<%for(Iterator<Client> clist = cm.list().iterator();clist.hasNext();){
	Client ccc=clist.next();	
	String selected ="";
	if(ccc.getUser().getLogin().equals(email)){
		selected="selected='selected'";
	}
	%><option value="<%=ccc.getUser().getLogin() %>" <%=selected %>><%=ccc.getName()%> - <%=ccc.getUser().getLogin()%></option><%
}
%></select>
<input type="submit"></form>

