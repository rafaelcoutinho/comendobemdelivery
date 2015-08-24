<SCRIPT TYPE="text/javascript" SRC="/scripts/base64.js"></SCRIPT>
<%
String params = request.getParameter("params");
if(params!=null){	
	String java = com.google.appengine.repackaged.com.google.common.util.Base64.encode(params.getBytes());
	%>'<%=params%>' - '<%=java %>'=<script>document.write('\''+Base64.encode('<%=params%>')+'\'');
	if('<%=java %>'==Base64.encode('<%=params%>')){
		document.write(' <b>iguais</b>');
	}	
	</script><br/><%
}
%>
<form action="TesteBase64.jsp" >
<input type="text" name="params" value="<%= params%>">
</form>
