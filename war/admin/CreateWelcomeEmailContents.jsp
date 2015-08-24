<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="br.com.copacabana.cb.app.Configuration"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.EntityManagerBean"%>

<%@page import="br.com.copacabana.cb.entities.WarnMessage"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<%
	String msg = "";
	
	ConfigurationManager cman = new ConfigurationManager();
	
	if (request.getParameter("id") != null) {		
		String id = request.getParameter("id");
		String msgTxt = request.getParameter("msg");
		cman.persist(new Configuration(id,msgTxt));
		out.println("Msg Id "+id+" was persisted");
	}
	
	String emailMsg = br.copacabana.usecase.OnNewClientRegistered.CLIENT_MSG;
	if(((Configuration)cman.find("welcome.client.email.msg", Configuration.class))!=null){	
		emailMsg = ((Configuration)cman.find("welcome.client.email.msg", Configuration.class)).getValue();
	}
	
	String emailSubject = br.copacabana.usecase.OnNewClientRegistered.CLIENT_SUBJECT;
	if(((Configuration)cman.find("welcome.client.email.subject", Configuration.class))!=null){	
		emailSubject = ((Configuration)cman.find("welcome.client.email.subject", Configuration.class)).getValue();
	}
	
	
	
	
%>
<%@include file="/static/commonScript.html" %>


<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.TimeZone"%><body class="tundra">
<script>
var count=0;
function submitForm(id){
	        	 var formDom=dojo.byId(id);
	        	 
	        	var xhrArgs = {
	                    form: formDom,
	                    handleAs: "text",
	                    load: function(data) {
	                    	//console.log(data);
	                    	count++;
	                    	console.log('salvou!',formDom);
	                    	
	                    	dijit.showTooltip("salvou!", formDom.children[1],['above']);
	                    	
	                    },
	                    error: function(error) {
	                   	 	console.error('error');
	                   	 count++;
	                   	 dijit.showTooltip("falhou salvar!", formDom.children[1]);
	                   	dojo.byId('log'+id).innerHTML=dojo.byId('log'+id).innerHTML+count+" erro!."+error+"<br>";
	                    }
	                }
	    		var deferred = dojo.xhrPost(xhrArgs);
	    		
	        	return false;
	        }			
</script>
<a href="CreateWelcomeEmailContents.jsp">Email boas vindas</a> - <a href="CreateExpiredEmailContents.jsp">Email pedido vencido Cliente</a> -  <a href="ManageRestExpiredEmailContents.jsp">Email pedido vencido Restaurante</a> - <a href="CreateCancelledEmailContents.jsp">Email de pedido cancelados</a> - <a href="CreateFeedbackEmail.jsp">Email de pesquisa de satisfacao</a> - <br>
<h2>Edicao do conteudo do email de boas vindas para cliente.</h2><br>
Os parametros substituem o %s e tem a seguinte ordem de valores:<br>
<ol>
<li>Nome do usuario</li>
</ol>
<form action="/admin/createConf.do" method="post" id="subjectForm" class="ppform" target="_Blank">
Assunto:<input type="hidden" name="key" value="welcome.client.email.subject" readonly="readonly" dojoType="dijit.form.TextBox"/> = 
<input type="text" name="value" value="<%=emailSubject%>" dojoType="dijit.form.TextBox"/> 
<input type="button" value="Salvar" onclick="submitForm('subjectForm')">
<div id="logsubjectForm"></div>
</form>
<form
	action="CreateWelcomeEmailContents.jsp" onsubmit="moveValues();return false;" id="msgForm">
	<input type="hidden" name="id" value="welcome.client.email.msg" />
	Mensagem:<br />
	<div style="display: none;"><textarea id="msg" name="msg"><%=emailMsg%></textarea></div>


<div id="programmatic2"></div>
<div onclick="testMsg()" style="width: 120px; margin: 3px; border: 3px inset grey; background-color: gray;">Test msg</div>
<input type="submit" value="Atualizar Msg"/>
</form>



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