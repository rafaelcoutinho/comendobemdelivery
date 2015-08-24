<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.usecase.invitation.InvitationManager"%>
<%@page import="br.com.copacabana.cb.entities.Invitation"%>
<%@page import="br.copacabana.util.TimeController"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.NewsLetterUser"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.usecase.invitation.NewsletterManager"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include><br />
<%@include file="/static/commonScript.html" %>
<%!List<Invitation> getInvitation(String inviteeEmail){
	InvitationManager inv = new InvitationManager();
	return inv.getInvitationsByInviteeEmail(inviteeEmail);
}%><%
	NewsletterManager nman = new NewsletterManager();
	if("save".equals(request.getParameter("action"))){
		String name= request.getParameter("name");
		String email= request.getParameter("email");
		nman.createNewsletterUser(email,name);
	}
	if("remove".equals(request.getParameter("action"))){
		String email= request.getParameter("email");
		nman.removeEntry(email);		
	}
	if("movetonotreceivers".equals(request.getParameter("action"))){
		String email= request.getParameter("email");		
		nman.stopNewsletter(email,"ação do admin");		
	}
	List<NewsLetterUser> receivers = nman.listNotRegisteredUsers(true);
	List<NewsLetterUser> notReceivers = nman.listNotRegisteredUsers(false);
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", new Locale("pt", "br"));
	sdf.setTimeZone(TimeController.getDefaultTimeZone());
	StringBuilder sb = new StringBuilder();
%>
Pessoas que recebem newsletter mas não estão cadastradas no ComendoBem:
<br />
<script>
function showSection(idSec){
	document.getElementById(idSec).style.display='block';
}
</script>

<form action="NotRegisteredNewsletterUsers.jsp">
Inserir email:<br>
Nome:<input type="text" name="name"><br>
Email:<input type="text" name="email"><br>
<input type="hidden" name="action" value="save">
<input type="submit" value="Salvar"/>
</form>
<script>
function toggleCheckbox(){
	var cs = dojo.query("[type=checkbox]");
	for(var i=0;i<cs.length;i++){
		var item = cs[i];			
		if(item.checked==false){
			item.checked=true;
		}else{
			item.checked=false;	
		}
	}
}
</script><br>
<a href="javascript:toggleCheckbox()">Toggle</a><br>
<form action="sendSpam1stStep.jsp" method="post">
<table>
	<tr>
		<th>#</th>		
		<th>Nome</th>
		<th>Email</th>
		<th>Data criação</th>
		<th>Ultima mudança</th>
	</tr>
	<%int counter=0;ClientManager cm = new ClientManager();
		for (Iterator<NewsLetterUser> iter = receivers.iterator(); iter.hasNext();) {
			NewsLetterUser ns = iter.next();
			sb.append(ns.getEmail());
			sb.append(", ");
			List<Invitation> invitations= getInvitation(ns.getEmail());

	%>
	<tr>
		<td valign="top"><input type="checkbox" name="email" value="<%=ns.getEmail()%>"><%=counter++%></td>
		<td valign="top"><%=ns.getName()%></td>
		<td valign="top"><%=ns.getEmail()%></td>
		<td valign="top"><%=sdf.format(ns.getDate())%></td>
		<td valign="top"><%=sdf.format(ns.getLastStatusChange())%></td>
		<td valign="top"><%if(invitations!=null && invitations.size()>0){
			
%><div onclick="showSection('<%=counter %>Sec')">Ver quem convidou</div><div id="<%=counter %>Sec" style="display: none;">Foi convidado por :<br><ul><%

			for(Iterator<Invitation> iterInv = invitations.iterator();iterInv.hasNext(); ){
				Invitation inv = iterInv.next();
				Client c = cm.get(inv.getFrom());
				%><li><%=c.getName()%> (<%=c.getUser().getLogin()%>)</li><%
			}
		
		%></ul></div><%} %></td>
		<td><a href="NotRegisteredNewsletterUsers.jsp?action=remove&email=<%=ns.getEmail() %>">remover</a> <a href="NotRegisteredNewsletterUsers.jsp?action=movetonotreceivers&email=<%=ns.getEmail() %>">parar emails</a></td>		
	</tr>
	<%
		
	}
	%>
</table><br>
<input type="submit" value="Enviar Email para selecionados">
</form>
Total: <%=(counter) %> 
<br>
Emails para copy/paste: <br/> <%=sb.toString()%><br>
<hr>
Pessoas que NÃO recebem newsletter e ainda não estão cadastradas no
ComendoBem:
<br />
<table>
	<tr>
	<th>#</th>
		<th>Nome</th>
		<th>Email</th>
		<th>Data criação</th>
		<th>Ultima mudança</th>
		<th>Comentário</th>
	</tr>

	<%counter=0;
		for (Iterator<NewsLetterUser> iter = notReceivers.iterator(); iter.hasNext();) {
			NewsLetterUser ns = iter.next();
			List<Invitation> invitations= getInvitation(ns.getEmail());
	%>
	<tr>
		<td valign="top"><%=counter++%></td>
		<td valign="top"><%=ns.getName()%></td>
		<td valign="top"><%=ns.getEmail()%></td>
		<td valign="top"><%=sdf.format(ns.getDate())%></td>
		<td valign="top"><%=sdf.format(ns.getLastStatusChange())%></td>
		<td valign="top"><%=ns.getComment()%></td>
		<td valign="top"><%if(invitations!=null && invitations.size()>0){
%>Foi convidado por :<br><ul><%

			for(Iterator<Invitation> iterInv = invitations.iterator();iterInv.hasNext(); ){
				Invitation inv = iterInv.next();
				Client c = cm.get(inv.getFrom());
				%><li><%=c.getName()%> (<%=c.getUser().getLogin()%>)</li><%
			}
		
		%></ul></td><%} %>
	</tr>
	<%
		}
	%>

</table>