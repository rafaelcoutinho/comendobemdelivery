
<form action="/admin/test">Query:<br/>
<textarea rows="10" cols="80" name="query"><%=request.getAttribute("query")%></textarea><input
	type="submit"></form>
<hr></hr>
<form action="/admin/test">QueryName:<br/>
<input type="text"  name="queryName" value="<%=request.getAttribute("queryName")%>"><input
	type="submit">
	<br/>
	Attributos:<br/>
	<%
	
	String attrA="";
	String attrB="";
	String attrAValue="";
	String attrBValue="";
	if(request.getParameterValues("attr")!=null){
	try{
		attrA=request.getParameterValues("attr")[0];
		attrB=request.getParameterValues("attr")[1];
		attrAValue=request.getParameterValues("attrValue")[0];
		attrBValue=request.getParameterValues("attrValue")[1];
		
	}catch(Exception e){}
		
		}%>
	
<input type="text"  name="attr" value="<%=attrA%>">:
<input type="text"  name="attrValue" value="<%=attrAValue%>"><br/>
<input type="text"  name="attr" value="<%=attrB%>">:
<input type="text"  name="attrValue" value="<%=attrBValue%>"><br/>	
	
	
	</form>


Results: '<%=request.getAttribute("results")%>'