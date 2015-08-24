<%@page import="br.copacabana.util.TimeController"%>
<%@page import="br.copacabana.spring.UserBeanManager"%>
<%@page import="br.com.copacabana.cb.entities.mgr.WarnMessageManager"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.EntityManagerBean"%>

<%@page import="br.com.copacabana.cb.entities.WarnMessage"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.com.copacabana.cb.entities.WarnMessage.MessageType"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<%
	String msg = "";
	String msgType = "";
	String userBean = "";
	String id = "";
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy kk:mm");
	sdf.setTimeZone(TimeController.getDefaultTimeZone());
	String lastChange="";
	String wasRead="";
	EntityManagerBean em = CityIdentifier.getEntityManager(getServletContext());
	if (request.getParameter("loadMsg") != null) {
		
		WarnMessageManager cman = new WarnMessageManager();
		Long l = Long.valueOf(request.getParameter("loadMsg"));
		WarnMessage warn = cman.find(l, WarnMessage.class);
		msg = warn.getMsg();
		msgType = warn.getMsgType().name();
		id = warn.getId().toString();
		userBean = KeyFactory.keyToString(warn.getUserBean());
		String data="sem info de data";
		if(warn.getLastChange()!=null){
			
			data=sdf.format(warn.getLastChange());
		}
		if(warn.getRead()){			
			wasRead="* Foi lido no dia "+data;
		}else{
			wasRead="* Nao lida desde "+data;
		}

	} else {
		if (request.getParameter("msg") != null) {
			
			WarnMessageManager cman = new WarnMessageManager();
			msg = request.getParameter("msg");
			msgType = request.getParameter("msgType");
			userBean = request.getParameter("userBean");
			id = request.getParameter("id");
			WarnMessage warn;
			if (id != null && id.length() > 0) {
				Long l = Long.valueOf(id);
				warn = cman.find(l, WarnMessage.class);
				warn.setMsg(msg);
				warn.setMsgType(WarnMessage.MessageType.valueOf(msgType));
			} else {
				warn = new WarnMessage(msg, WarnMessage.MessageType.valueOf(msgType), KeyFactory.stringToKey(userBean));
			}
			if(warn.getRead()==false){
				warn.setLastChange(new Date());
			}
			warn = cman.persist(warn);
			out.print("Saved: " + warn.getId());
			id= warn.getId().toString();
		}
	}
	
%>
<%@include file="/static/commonScript.html" %>


<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.TimeZone"%><body class="tundra">
<%=wasRead %>
<form
	action="CreateMsgForUser.jsp" onsubmit="moveValues();return false;" id="msgForm">id:<input type="text" name="id" 
	value="<%=id%>" /><br />

User:<select name="userBean" >
<%
UserBeanManager uBean = new UserBeanManager();
List<UserBean> list = uBean.list("getUser");
for(Iterator<UserBean> iter = list.iterator();iter.hasNext();){
	UserBean ub = iter.next();
	%>
	<option value="<%=
		KeyFactory.keyToString(ub.getId())%>" <%
		if(KeyFactory.keyToString(ub.getId()).equals(userBean)){
		%>selected="selected"<%} %> >
		<%=ub.getLogin()%>
	</option>	
	<%
}

%>

</select><br />

Type: <select name="msgType">
	<option value="NORMAL" <%if("NORMAL".equals(msgType)) {%>selected="selected"<%} %>>NORMAL</option>
	<option value="WARN" <%if("WARN".equals(msgType)) {%>selected="selected"<%} %>>WARN</option>
	<option value="CONFIRM" <%if("CONFIRM".equals(msgType)) {%>selected="selected"<%} %>>CONFIRM</option>
	<option value="ACCEPT_TERMS" <%if("ACCEPT_TERMS".equals(msgType)) {%>selected="selected"<%} %>>ACCEPT_TERMS</option>
</select> Txt:<br />
<div style="display: none;"><textarea id="msg" name="msg"><%=msg%></textarea></div>


<div id="programmatic2"></div>
<div onclick="testMsg()" style="width: 120px; margin: 3px; border: 3px inset grey; background-color: gray;">Test msg</div>
<input type="submit"/>
</form>

<hr></hr>
<div style="width: 100%;height: 200px;overflow: scroll;">
<%
WarnMessageManager wmann = new WarnMessageManager();
List<WarnMessage> wlist = wmann.list("getWarnMessage");
for(Iterator<WarnMessage> iter = wlist.iterator();iter.hasNext();){
	WarnMessage ww = iter.next();
	%>
	<a href="CreateMsgForUser.jsp?loadMsg=<%=ww.getId() %>"><%=ww.getId()%></a> - <%=ww.getMsgType().name()%> - <%=ww.getUserBean()%><br/>
	<%
}

%>
</div>

</body>

<script>
dojo.require ("dijit.Editor");
dojo.require ("dijit._editor.plugins.ViewSource");
dojo.require ("dijit._editor.plugins.AlwaysShowToolbar");
dojo.require ("dijit._editor.plugins.FullScreen");
dojo.require ("dijit._editor.plugins.LinkDialog");
dojo.require ("dojox.editor.plugins.Preview");
dojo.require ("com.copacabana.util");
var editor;
dojo.addOnLoad(function() {

	var ltextplugins = ['dijit._editor.plugins.AlwaysShowToolbar','dijit._editor.plugins.LinkDialog','dojox.editor.plugins.Preview','dijit._editor.plugins.ViewSource','dijit._editor.plugins.FullScreen'];
	editor=new dijit.Editor({height: '200px', name:'msg',extraPlugins: ltextplugins}, dojo.byId('programmatic2'));
	editor.attr('value',dojo.byId('msg').value);
	
});

function testMsg(){
	editor.attr('value');
	dijit.hideTooltip(dojo.byId('msgHandler'));
	com.copacabana.util.warning('-1',editor.attr('value'),'NORMAL');
	
}
function moveValues(){
	dojo.byId('msg').value=editor.attr('value');
	dojo.xhrPost({
	      form:dojo.byId('msgForm'),
	      load:function(data){window.location=window.location}
	      
	  });
		
	return false;

}
</script>