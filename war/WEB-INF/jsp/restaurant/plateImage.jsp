<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%><html>
<head>

		<%@ page
		import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
	<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>

	<%BlobstoreService blobstoreService = BlobstoreServiceFactory
						.getBlobstoreService();%>
						
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Alterar Foto</title>

<cb:header />
<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dijit/themes/tundra/tundra.css">
<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
	<link href="/styles/restaurant/profile_ie_8.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="/styles/restaurant/areaTaxa.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/areaTaxa_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>

<%@include file="/static/commonScript.html"%>

<script>
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.util");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");

dojo.addOnLoad(function() {
	updateForm();
});
var updateForm = function(){
	var xhrArgs = {
		url : "/getRestaurant.do?id=" + loggedRestaurant.id,		
		handleAs : "json",
		load : function(data) {			
			console.log(data.imgKeyString);
			if(data.imgKeyString!=null){
				dojo.byId("imgPlace").src="/img?blob-key="+data.imgKeyString;
				
			}
			
		},
		error : function(error) {
			console.log('error');
		}
	}
	dojo.byId("photoForm").action=formAction;
	var deferred = dojo.xhrPost(xhrArgs);
}

var submitForm = function(){
	com.copacabana.util.showLoading();
	dojo.byId("photoForm").submit();
}

var formAction = '<%=blobstoreService.createUploadUrl("/uploadPlateImage")%>';

</script>
<style type="text/css">		
.dijitCheckBoxInput{
opacity:1;
}</style>

<cb:body closedMenu="true">
	
	<jsp:include page="restheader.jsp" ><jsp:param name="isFunctions" value="true"></jsp:param></jsp:include>
	
	<div id="dadosFuncionalidades">
		<div id="funcionalidade">
		<table><tr><td ><div style="width: 70px;height: 70px;border: thin red solid;"><img src="" id="imgPlace" style="width: 70px"></div></td></tr><tr><td>
		 Alterar foto:<br/>
		<form action=""
		method="post" enctype="multipart/form-data" id="photoForm" >		
		<input type="file" name="myFile" title="Selecionar foto" dojoType="dijit.form.TextBox">
		<input type="text" name="pid" value="ag5jb21lbmRvYmVtYmV0YXIdCxIKUkVTVEFVUkFOVBjmCAwLEgVQTEFURRjxCAw"> 
	</form>
	</td></tr>
	<tr>
			<td colspan="2" align="center"><img
				src="../../resources/img/btOk.png" alt="salvar"
				onclick="javascript:submitForm()" /></td>
		</tr>
	</table>
	
	</table>
			</div>
	</div>
		
		<jsp:include page="profileSide.jsp" ><jsp:param name="isPicture" value="true"></jsp:param></jsp:include>
	
	
</cb:body>
</html>