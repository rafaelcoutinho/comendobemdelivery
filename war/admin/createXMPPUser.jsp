<%@page import="br.copacabana.xmpp.XmppController"%>
<%@page import="java.util.Calendar"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>

<%@page import="br.com.copacabana.cb.entities.XMPPUser"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.xmpp.JID"%>
<%@page import="com.google.appengine.api.xmpp.XMPPServiceFactory"%>
<%@page import="com.google.appengine.api.xmpp.XMPPService"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="br.copacabana.spring.UserBeanManager"%><html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>Comendo Bem!</title>
<%@include file="/static/commonScript.html"%>

<body class="tundra">
<%
	
	RestaurantManager rman = new RestaurantManager();

	UserBeanManager ubman = new UserBeanManager();
	SimpleDateFormat sdf = new SimpleDateFormat("kk:mm dd MMM", new Locale("pt", "BR"));
	sdf.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
	XmppController man = new XmppController();
	boolean created = false;
	boolean updated = false;
	boolean invitationsent = false;
	String uname = "";
	if (request.getParameter("createUser") != null) {
		uname = request.getParameter("username");
		String pwd = request.getParameter("password");
		XMPPUser xmppUser = new XMPPUser(uname, pwd);

		Map<String, Object> m = new HashMap<String, Object>();
		m.put("userId", uname);
		List<XMPPUser> list = man.list("getXmppUserByUserId", m);
		if (list.size() > 0) {

			xmppUser = list.get(0);
			xmppUser.setUserPassword(pwd);
			out.println("updating " + uname + " .<Br/>");
			updated = true;
		}

		man.persist(xmppUser);
		created = true;
		try {
			JID jid = new JID(uname);
			JID jidfrom = new JID("rafael.coutinho@gmail.com");
			XMPPService xmpp = XMPPServiceFactory.getXMPPService();
			xmpp.sendInvitation(jid);
			xmpp.sendInvitation(jid, jidfrom);
			invitationsent = true;
		} catch (Exception e) {
			out.print(e.getMessage());
		}
	} else {
		if (request.getParameter("deleteUser") != null) {
			uname = request.getParameter("username");
			Map<String, Object> m = new HashMap<String, Object>();
			m.put("userId", uname);
			List<XMPPUser> list = man.list("getXmppUserByUserId", m);
			if (list.size() > 0) {
				XMPPUser xmppUser = list.get(0);
				man.delete(xmppUser);
				out.println("deleted " + uname + " .<Br/>");
			}

		}
	}
%>

<%
	if (created == true && updated == false) {
%><b>Criado com sucesso <%=uname%></b>
and invitation was
<%=invitationsent%><br />
<%
	}
%>
<%
	if (created == true && updated == true) {
%><b>Atualizado com sucesso <%=uname%></b>
and invitation was
<%=invitationsent%><br />
<%
	}
%>
<script>
dojo.require('dijit.form.TextBox');
dojo.require('dijit.form.Button');
function updateUser(userid,pwd,id){
dijit.byId('username').attr('value',userid);
dijit.byId('password').attr('value',pwd);
dijit.byId('submitStateButton').attr('label','Atualizar usuário');
}
function sendMsg(userId){
	var text=dijit.byId('msgText').attr('value');
	var url = "sendXMPPMsg.do?to="+userId+"&msg={type:2,data:{msg:'"+text+"'}}";
	dojo.byId('resultsFrame').src=url;
	return false;
}
function sendFakeNewRequestMsg(userId){
	var text=dijit.byId('msgText').attr('value');
	var url = "sendXMPPMsg.do?to="+userId+"&msg={type:0,data:{id:'-1'}}";
	dojo.byId('resultsFrame').src=url;
	return false;
}
function sendPingMsg(userId){
	var text=dijit.byId('msgText').attr('value');
	var url = "sendXMPPMsg.do?to="+userId+"&msg={type:99}";
	dojo.byId('resultsFrame').src=url;
	return false;
}
function sendFakeNoNewRequestMsg(userId){
	var text=dijit.byId('msgText').attr('value');
	var url = "sendXMPPMsg.do?to="+userId+"&msg={type:1,data:{id:'-1'}}";
	dojo.byId('resultsFrame').src=url;
	return false;
}
function checkDelete(username){
var url = 'createXMPPUser.jsp?username='+username+'&deleteUser=true';
	var answer = confirm("Confirma apagar "+username)
	if (answer){
		
		window.location = 'createXMPPUser.jsp?username='+username+'&deleteUser=true';
	}
	else{
		
	}
	return false;

}
</script>
<h2>Cria XMPP</h2>
<form action="createXMPPUser.jsp">
 
<input type="hidden"
	name="createUser" value="true" /> Nome: <input type="text" id="username"
	name="username" dojoType="dijit.form.TextBox" trim="true" value="@jabber.org"><br />
Password: <input type="text" name="password" id="password"
	dojoType="dijit.form.TextBox" trim="true"> <br />
<button type="submit" dojoType="dijit.form.Button"
	id="submitStateButton">Cria XMPP User</button>
</form>
<hr></hr>
<br />
Mensagem: <input type="text" name="msgText" id="msgText" dojoType="dijit.form.TextBox" trim="true" value="Servidor online"><br/>
<table>
	<tr>
		<th>Username</th>
		<th>Pwd</th>
		<th>IP</th>
		<th>ClientVersion</th>
		<th>lastUse</th>
		
		<th>Delete</th>
		<th>Invite</th>
		<th>IsOnline</th>
		<th>SendMsg</th>
		<th>Simula Pedido</th>
		<th>Remove Pedidos </th>
		<th>user id</th>
		
	</tr>

	<%
		List<XMPPUser> l = man.list("getXmppUserByLastUse");
		for (Iterator<XMPPUser> iter = l.iterator(); iter.hasNext();) {
			XMPPUser user = iter.next();
	%><tr><%@page
	import="com.google.appengine.api.datastore.KeyFactory"%>
		<td><a href="#" onclick="updateUser('<%=user.getUserId()%>','<%=user.getUserPassword()%>','<%=KeyFactory.keyToString(user.getId())%>')"><%=user.getUserId()%></a></td>
		<td><%=user.getUserPassword()%></td>
		<td><%=user.getIp()%></td>
		<td><%=user.getClientVersion()%></td>
		<td><%=sdf.format(user.getLastUse())%></td>
		
		<td><a href="#" onclick="checkDelete('<%=user.getUserId()%>')">Delete</a></td>
		<td><a target="resultsFrame" href="sendInvitation.do?to=<%=user.getUserId()%>">Invite</a></td>
		<td><a onclick="sendPingMsg('<%=user.getUserId()%>')" href="#">Ping</a></td>
		<td><a  onclick="sendMsg('<%=user.getUserId()%>')" href="#">sendMsg</a></td>
		<td><a  onclick="sendFakeNewRequestMsg('<%=user.getUserId()%>')" href="#">sendFakeNewRequest</a></td>
		<td><a  onclick="sendFakeNoNewRequestMsg('<%=user.getUserId()%>')" href="#">sendFake No Request</a></td>

		<td>
		<%
			if (user.getAssociatedUserBeanId() != null) {
					try {
						UserBean ub = ubman.getUserBean(user.getAssociatedUserBeanId());
						Restaurant r = rman.getRestaurantByUserBean(ub);
						out.print(r.getName());
						if (r.isOpen()) {
							Calendar c = Calendar.getInstance();
							int today = Calendar.getInstance().get(Calendar.DAY_OF_YEAR);
							c.setTime(user.getLastUse());
							out.print("<!-- "+c.get(Calendar.DAY_OF_YEAR)+"="+today+" -->");
							out.print("<!-- in range "+r.getTodaysWO().isInRange(c)+" -->");
							if (c.get(Calendar.DAY_OF_YEAR)!=today || !r.getTodaysWO().isInRange(c)) {
								out.println(" <span style='background-color:red;width:5px;height:5px;' title='Não pingou desde abertura'>!</span>");
							}
						}
					} catch (Exception e) {
						UserBean ub = ubman.getUserBean(user.getAssociatedUserBeanId());

						out.print(ub.getLogin());
					}
				} else {
					out.print("N/A");
				}
		%>
		</td>
	</tr>
	<%
		}
	%>
</table>
<br/>Resultados:
<div id="response">
<iframe name="resultsFrame" id="resultsFrame" heigth=100 width=300 src=""/></div>
</body>