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
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
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
function sendDeleteOldLogRequest(userId){
	var answer = confirm("Tem certeza? Esta ação irá apagar todos os arquivos de log que estão no cliente do "+userId);
	if(answer){
		var text=dijit.byId('msgText').attr('value');
		var url = "sendXMPPMsg.do?to="+userId+"&msg={type:96}";
		dojo.byId('resultsFrame').src=url;
	}
	return false;
}
		
function sendLogRequest(userId){
	var text=dijit.byId('msgText').attr('value');
	var url = "sendXMPPMsg.do?to="+userId+"&msg={type:97}";
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
<h2>Monitorar XMPP</h2>
<a href="createXMPPUser.jsp">Criar usuários xmpp</a>
<hr></hr>
<br />
Mensagem: <input type="text" name="msgText" id="msgText" dojoType="dijit.form.TextBox" trim="true" value="Servidor online"><br/>
<style>
th {
background-color: #d9d9ff;
}
.odd{
background-color: #f9f9f9;
}
</style>
<table cellpadding="2" cellspacing="0">
	<tr>
		<th>Estabelecimeto</th>
		<th>Último contato</th>
		<th>Xmpp Username</th>		
		<th>IP</th>
		<th>ClientVersion</th>		
		<th>Ping</th>		
		<th>SendMsg</th>
		<th>Simula Pedido</th>
		<th>Remove Pedidos </th>
		
		
	</tr>

	<%
		List<XMPPUser> l = man.list("getXmppUserByLastUse");
	int counter = 0;
		for (Iterator<XMPPUser> iter = l.iterator(); iter.hasNext();) {
			XMPPUser user = iter.next();
			String className = "";
			if(counter++%2!=0){
				className="class='odd'";
			}
	%><tr><%@page
	import="com.google.appengine.api.datastore.KeyFactory"%>
	<td <%=className %>>
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
		<td <%=className %>><%=sdf.format(user.getLastUse())%></td>
		<td <%=className %>><%=user.getUserId()%></td>		
		<td <%=className %>><%=user.getIp()%></td>
		<td <%=className %>><%=user.getClientVersion()%></td>		
		<td <%=className %>><a onclick="sendPingMsg('<%=user.getUserId()%>')" href="#">Ping</a></td>
		<td <%=className %>><a  onclick="sendMsg('<%=user.getUserId()%>')" href="#">sendMsg</a></td>
		<td <%=className %>><a  onclick="sendFakeNewRequestMsg('<%=user.getUserId()%>')" href="#">sendFakeNewRequest</a></td>
		<td <%=className %>><a  onclick="sendFakeNoNewRequestMsg('<%=user.getUserId()%>')" href="#">sendFake No Request</a></td>
		<td <%=className %>><a  onclick="sendLogRequest('<%=user.getUserId()%>')" href="#">request LOGS</a></td>
		<td <%=className %>><a  onclick="sendDeleteOldLogRequest('<%=user.getUserId()%>')" href="#">send to delete old Logs</a></td>
		

		
	</tr>
	<%
		}
	%>
</table>
<br/>Resultados:
<div id="response">
<iframe name="resultsFrame" id="resultsFrame" heigth=100 width=300 src=""/></div>
</body>