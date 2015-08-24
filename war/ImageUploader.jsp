<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>

<%
UserService userService = UserServiceFactory.getUserService();
if (request.getUserPrincipal() != null) {
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	request.getSession().setAttribute("isAdmin","fornow");
%>



<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%><html>
<head>
<title>Upload Test</title>
</head>
<body><jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<form action="<%=blobstoreService.createUploadUrl("/upload")%>"
	method="post" enctype="multipart/form-data">
	
	Arquivo:<input type="file" name="myFile"> 
	<input type="submit" value="enviar">
</form>
</body>
</html>
<%}else{
	response.getWriter().println("<p>Please <a href=\"" + userService.createLoginURL(request.getRequestURI()) + "\">sign in</a>.</p>");
}%>
