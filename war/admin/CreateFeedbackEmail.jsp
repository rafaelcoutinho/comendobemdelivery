<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="com.google.appengine.api.datastore.Text"%>
<%@page import="br.com.copacabana.cb.entities.EmailContent"%>
<%@page import="java.util.ResourceBundle"%>
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
	
	EntityManagerBean em = CityIdentifier.getEntityManager(getServletContext());
	
	String id = "FeedBackEmail";
	if (request.getParameter("msg") != null) {
		String msgTxt = request.getParameter("msg");
		String subject = request.getParameter("subject");
		EmailContent email = Datastore.getPersistanceManager().find(EmailContent.class,id);
		Datastore.getPersistanceManager().getTransaction().begin();
		if(email==null){
			email = new EmailContent(id,msgTxt);
			email.setSubject(subject);
			
			Datastore.getPersistanceManager().persist(email);
		}else{
			email.setSubject(subject);
			email.setMsg(new Text(msgTxt)); 
			Datastore.getPersistanceManager().merge(email);			
			
		}
		Datastore.getPersistanceManager().getTransaction().commit();
		out.println("Msg Id "+id+" was persisted");
	}
	
	EmailContent email = Datastore.getPersistanceManager().find(EmailContent.class,id);
	String subject=null;
	String msg=null;
	if(email!=null){
		 subject = email.getSubject();
		 msg = email.getMsg().getValue();
	}
	
	
	if(subject==null || subject.length()==0){
		subject=ResourceBundle.getBundle("messages").getString("order.complete.subject");
	}
	
	if(msg==null || msg.length()==0){
		msg=ResourceBundle.getBundle("messages").getString("order.complete.msg");
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
<h2>Edicao do conteudo do email para pesquisa de satisfacao quando o pedido completa.</h2><br>
Os parametros substituem e {N} tem a seguinte ordem de valores:<br>
<ol>
<li>Nome do cliente</li>
<li>ID traduzido</li>
<li>Data do pedido</li>
<li>Nome Restaurante</li>
<li>Valor do pedido</li>
<li>Página resultado bom</li>
<li>Página resultado medio</li>
<li>Página resultado ruim</li>
</ol>


<form
	action="CreateFeedbackEmail.jsp" onsubmit="moveValues();return false;" id="msgForm">
	Assunto: <input type="text" name="subject" value="<%=subject%>" dojoType="dijit.form.TextBox"/> 


	
	Mensagem:<br />
	<div style="display: none;"><textarea id="msg" name="msg"><%=msg%></textarea></div>


<div id="programmatic2"></div>
<div onclick="testMsg()" style="width: 120px; margin: 3px; border: 3px inset grey; background-color: gray;">Test msg</div>
<input type="submit" value="Atualizar Msg"/>
</form>



<hr></hr>

<hr>
<br>

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
	      load:function(data){window.location=window.location},
	      error:function(error){console.error()}
	      
	  });
		
	return false;

}
</script>