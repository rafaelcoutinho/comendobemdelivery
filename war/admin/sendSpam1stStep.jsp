<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include>
<%@include file="/static/commonScript.html" %>
<body class="tundra">
<form action="sendSpam.jsp" method="post"   onsubmit="moveVals();">
<%
String[] emails = request.getParameterValues("email");

StringBuilder sb = new StringBuilder();
if(emails!=null){
for(int i = 0;i<emails.length;i++){
	if(!sb.toString().contains(emails[i])){
		sb.append(emails[i]).append(",");
	}
}
}
String[] emailsToFix= sb.toString().split(",");
String emailsStr="";
for(int i = 0;i<emailsToFix.length;i++){
	String item = emailsToFix[i];
	if(!emailsStr.contains(item)){
		emailsStr+=item+",";
	}
}


%>
To:<input type="text"  value="<%=emailsStr %>" name="email" style="width: 700px"/><br>

From:<input type="text" name="from" value="contato@comendobem.com.br"><br>
FromName:<input type="text" name="fromName" value="ComendoBem"><br>
<i>tips: {0} é substituido pelo nome cadastrado na newsletter</i><br> 
Subject:<input type="text" name="subject" style="width: 500px"><br>
Texto: <br>

<div id="programmatic2"></div>

<textarea name="text" id="text" style="display: none;"></textarea>
<br>
<input type="submit" value="agendar emails">



<div>

Templates:
<br><br>
<input type="checkbox" name="addBlogUrl"> <span style="font-size: x-small;">Caso não visualize esse e-mail, clique aqui.</span> (Url=<input type="text" name="blogUrl">)<br><br>

<input type="checkbox" name="addRemoveUrl"> <span style="font-size: xx-small;">Se não deseja mais receber estas mensagens <a href="http://www.comendobem.com.br/removerEmail.do">clique aqui.</a></span><br>




</div>
</form>
</body>
<script>
function moveVals(){
	dojo.byId('text').value=editor.attr('value');
}
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
	
	
});
</script>