<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Acesso direto</title>
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
dojo.require("dojo.string");
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
			dojo.byId('uniqueUrlNameId').value=data.uniqueUrlName;
		},
		error : function(error) {
			console.log('error');
		}
	}
	
	var deferred = dojo.xhrPost(xhrArgs);
}

var submitForm = function(){
	com.copacabana.util.showLoading();
	var unique = dijit.byId('uniqueUrlNameId').attr('value');
	unique=dojo.string.trim(unique);
	if(unique.length==0){
		var msg = new com.copacabana.MessageWidget();
		msg.showMsg("Por favor preencha o campo com o nome para acesso direto.",msg.errorType);
	}else{
		if(unique.indexOf(' ')>0 && unique.indexOf('/')>0 && unique.indexOf('\\')>0){
			msg.showMsg("O nome para acesso direto n&atilde;o pode conter espa&ccedil; e os seguintes caracteres: / \\",msg.errorType);	
		}else{
			var xhrArgs = {
					form : dojo.byId("singleUrlForm"),
					handleAs : "text",
					load : function(data) {						
						var entity = dojo.fromJson(data);
						com.copacabana.util.hideLoading();
						var msg = new com.copacabana.MessageWidget();
						msg.showMsg("Acesso direto salvo. <br/>Teste o <a href='/"+dijit.byId('uniqueUrlNameId').attr('value')+"' target='_blank'>aqui</a>" );
					},
					error : function(error) {
						var errJson = dojo.fromJson(error.responseText);
						
						console.log("failed to post data.",error);
						com.copacabana.util.hideLoading();
						var msg = new com.copacabana.MessageWidget();
						if(errJson.errorCode=='UNIQUEURLNAMEALREADYEXISTS'){
							msg.showMsg("O nome "+errJson.errorMsg+" j&aacute; est&aacute; sendo usado por outro restaurante.<br/>Por favor utilize outro nome para o acesso direto." );
						}else{
							msg.showMsg("Erro ao salvar dados: " + error.responseText);
						}
					}
				}
				// Call the asynchronous xhrPost
				
				var deferred = dojo.xhrPost(xhrArgs);
			
		}
	}
	
}


</script>
<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp"><jsp:param
			name="isFunctions" value="true"></jsp:param></jsp:include>

	<div id="dadosFuncionalidades">
	<div id="funcionalidade">
	<table>
		<tr>
			<td><h2>Configurar acesso direto.</h2> O acesso direto permite acessar a p&aacute;gina do seu estabelecimento no ComendoBem diretamente. Somente colocar o endere&ccedil;o www.comendobem.com.br/NOMEUNICO, onde o NOMEUNICO voc&ecirc; configura usando o formul&aacute;rio abaixo:<br /><br />
			<form action="updateUniqueUrl.do" method="post" id="singleUrlForm" onsubmit="return false;">
			www.comendobem.com.br/<input
				type="text" name=newUrlName title="Nome sem espaco" trim="true" 
				dojoType="dijit.form.TextBox" id="uniqueUrlNameId"><br/>
				O nome &uacute;nico n&atilde;o pode conter os seguintes caracteres: <b>',./\</b>
			
				
				</form>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><img
				src="/resources/img/btOk.png" alt="salvar"
				onclick="javascript:submitForm()" /></td>
		</tr>
	</table>


	</div>
	</div>


<jsp:include page="profileSide.jsp" ><jsp:param name="isDirectAccess" value="true"></jsp:param></jsp:include>

</cb:body>
</html>