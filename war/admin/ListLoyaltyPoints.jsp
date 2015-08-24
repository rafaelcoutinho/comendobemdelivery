<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="br.com.copacabana.cb.entities.LoyaltyPoints"%>
<%@page import="javax.persistence.NoResultException"%>
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
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br />
Pontuação no mês</br>
<%
ClientManager cm = new ClientManager();
List<LoyaltyPoints> clist =  cm.listCurrentMonthLoyaltyPoints();
%><table><tr><th>Posição</th><th>Mes</th><th>nome</th><th>convites</th><th>pedidos de amigos</th><th>pedidos</th><th>total</th></tr><%
int pos = 0;
int last = -1;
for (Iterator<LoyaltyPoints> iter = clist.iterator(); iter.hasNext();) {
	LoyaltyPoints l = iter.next();
	
	Client c = cm.get(l.getClient());
	if(last!=l.getTotal()){
		last=l.getTotal();
		pos++;
	}
	%><tr><td><%=pos %></td><td><%=(l.getMonth()+1) %>/<%=(l.getYear()) %></td><td><%=c.getName() %> (<%=c.getUser().getLogin() %>)</td><td><%=l.getConfirmedInvitations() %></td><td><%=l.getFriendsOrders() %></td><td><%=l.getMyOrders() %></td><td><%=l.getTotal() %></td></tr><% 
	
	
}
%></table>
<hr>
Meses anteriores:<br>
<%
Calendar c = Calendar.getInstance();
c.add(Calendar.MONTH,-1);
SimpleDateFormat sdf2 = new SimpleDateFormat("MMMMM yyyy",new Locale("pt","br"));

List<LoyaltyPoints> clist2 =  cm.listMonthLoyaltyPoints(c.get(Calendar.MONTH),c.get(Calendar.YEAR));
%><Br>
<div style="font-weight: bold;"><%=sdf2.format(c.getTime()) %></div>
<div>
<table><tr><th>Posição</th><th>Mes</th><th>nome</th><th>convites</th><th>pedidos de amigos</th><th>pedidos</th><th>total</th></tr><%
 pos = 0;
 last = -1;
for (Iterator<LoyaltyPoints> iter = clist2.iterator(); iter.hasNext();) {
	LoyaltyPoints l = iter.next();
	 
	Client c2 = cm.get(l.getClient());
	if(last!=l.getTotal()){
		last=l.getTotal();
		pos++;
	}
	%><tr><td><%=pos %></td><td><%=(l.getMonth()+1) %>/<%=(l.getYear()) %></td><td><%=c2.getName() %> (<%=c2.getUser().getLogin() %>)</td><td><%=l.getConfirmedInvitations() %></td><td><%=l.getFriendsOrders() %></td><td><%=l.getMyOrders() %></td><td><%=l.getTotal() %></td></tr><% 
	
	
}
%></table>
</div>