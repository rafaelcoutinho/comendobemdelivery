<%@page import="br.com.copacabana.web.Constants"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	<fmt:setLocale value='pt'/>
<fmt:setBundle basename='messages'/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Meus convites</title>

<cb:header />

<link href="/styles/user/profile.css" type="text/css"
	rel="stylesheet" />
<link
	href="/styles/user/manageOrders.css"
	type="text/css" rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/user/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html" %>
<style>
label{
 display: inline-block;
    text-align: right;
    width: 150px;
}
th{
background-color: #D9261C;
    color: white;
    font-weight: bold;
    }
</style>
<div id="fb-root"></div>
<cb:body closedMenu="true">

	<jsp:include page="clientheader.jsp"><jsp:param
			name="isMyInvitations" value="true"></jsp:param></jsp:include>
			
			<div><c:if test="${not empty msgs }"><div style="color: red;width:100%;margin:10px;">${msgs }</div></c:if>
			<div style="float:right;">
	
    <span style="font-size: small;font-style: italic;">
    <c:if test="${fn:length(invitations)==0}">
        Convide amigos e ganhe pontos no ComendoBem
        </c:if>
    <c:if test="${fn:length(invitations)>0}">Convide mais amigos e ganhe pontos no ComendoBem</c:if>
    </span><br>
    <div dojoType="dijit.form.DropDownButton"  baseClass="orangeButton" style="margin-top: 5px;float: right;font-weight: bold;">
    <span>Convidar com e-mail</span>
    <div dojoType="dijit.TooltipDialog" id="lembrete" dojoAttachEvent="onExecute:executeReminder,onexecute:executeReminder">
    <div style="margin: 15px">

    	<p>Insira os nomes e e-mails de seus convidados. Assim que eles se cadastrarem no ComendoBem voc&ecirc; ganha pontos.</p>
       <form action="/convidar.do" method="post"  dojoType="dijit.form.Form" id="invitations">
			<table>
			<tr><th>#</th><th>Nome</th><th>E-mail</th></tr>
			<tr>
			<td>1:</td><td><input name="toName" width="270" cssClass="required requiredBig" 
			class="mandatory" required="true" properCase="true" trim="true"
			dojoType="dijit.form.ValidationTextBox" /></td>
			<td><input width="270"
			cssClass="required requiredBig"   name="toEmail"
			class="mandatory" required="true" regExpGen="com.copacabana.util.emailFormat" trim="true"
			dojoType="dijit.form.ValidationTextBox"  /></td>
			</tr>
			
			<tr>
			<td>2:</td><td><input name="toName" width="270" cssClass="required requiredBig" 
			required="true" properCase="true" trim="true"
			dojoType="dijit.form.ValidationTextBox" /></td>
			<td><input width="270"
			cssClass="required requiredBig"   name="toEmail"
			required="true" regExpGen="com.copacabana.util.emailFormat" trim="true"
			dojoType="dijit.form.ValidationTextBox"  /></td>
			</tr>
			
			<tr>
			<td>3:</td><td><input name="toName" width="270" cssClass="required requiredBig" 
			 required="true" properCase="true" trim="true"
			dojoType="dijit.form.ValidationTextBox" /></td>
			<td><input width="270"
			cssClass="required requiredBig"   name="toEmail"
			 required="true" regExpGen="com.copacabana.util.emailFormat" trim="true"
			dojoType="dijit.form.ValidationTextBox"  /></td>
			</tr>
			
			</table>
			
			</form>
			<button baseClass="orangeButton" dojoType="dijit.form.Button" onClick="submit" >Enviar convites</button>
			</div>
    </div>
</div>



		<div style="float:right;clear: both;margin:2px;">
			<c:if test="${sessionScope.isFBUser==true}">
				<a class="fb_button fb_button_medium" href="#" onclick="showFBInvitation()"  ><span class="fb_button_text">Convidar com Facebook</span></a><br>
			</c:if>
			<c:if test="${sessionScope.isFBUser==false}">
				<a class="fb_button fb_button_medium" target="_fbauth" href="/fbresponse.jsp" id="connectFBLink" ><span class="fb_button_text">Convidar com Facebook</span></a><br>
			</c:if>
		</div> 
</div>
			<h2>Meus convidados</h2>
			<br style="clear: both;"/>
<div>
		
			<c:if test="${fn:length(invitations)==0}">
			<h3>Voc&ecirc; ainda n&atilde;o convidou nenhum amigo. Ao convidar amigos voc&ecirc; ganha pontos no ComendoBem que podem te dar pr&ecirc;mios!</h3><br> 
			</c:if>
			<c:if test="${fn:length(invitations)>0}">
			<table><th></th><th>Nome</th><th>E-mail</th><th>Status</th><th>Enviado em</th></tr>
			<c:forEach var="invitation" items="${invitations }" varStatus="status">
			<tr><td>${status.count }</td>
				<td>${invitation.name}</td>
				<td>${invitation.email}</td>
				<td><fmt:message key='invitationStatus.${invitation.status}'/></td>

				<td><fmt:formatDate value="${invitation.date}" type="date"	timeStyle="long" dateStyle="short" timeZone="America/Sao_Paulo" /> </td>
			</tr>
			
			</c:forEach>
			</table>
			</c:if>
			
			</div>
			</div>
</cb:body>

<script src="http://connect.facebook.net/pt_BR/all.js"></script>

<script>

	FB.init({
		appId:'<%=Constants.FBID%>', cookie:true, 
			status:true, xfbml:true 
		});
		var alreadySyncedWithFB=false;
		function executeLogin(fb,user){
			var updateChoice=false;
			if(user.email!=loggedUser.entity.login){
				updateChoice=confirm("Seu e-mail no ComendoBem:\n "+loggedUser.entity.login+"\né diferente de seu e-mail do Facebook\n "+user.email+"\n\nDeseja alterar o do ComendoBem?");
			}
			try{
					var xhrArgs = {
							content: {email:user.email,user:dojo.toJson(user),update:updateChoice},
							url:'/updateMyLogin.do',
							handleAs: "json",
							load : function(response) {	
								console.log("response ok ",response);
								showFBInvitation();
								alreadySyncedWithFB=true;
								dojo.byId('connectFBLink').href="#";
								dojo.byId('connectFBLink').target="_self";
								dojo.byId('connectFBLink').onclick=function(){showFBInvitation();return false;};
							},
							error: function(response) {
								console.log("response fail ",response);
								showFBInvitation();			
							}
					};
					//
					var deferred = dojo.xhrGet(xhrArgs);
					}catch(e){
						console.error(e);
					}
				
			
						
		}
		function showFBInvitation(){
		FB.ui({ 
			method: 'apprequests', 
			data:'{"inviter":"'+id+'"}',
			title:'Convide seus amigos para participar do ComendoBem',
			message: 'Peça pizzas, almoços e etc online pelo ComendoBem, o site mais gostoso da Internet'
		}
		);
		}


dojo.require("com.copacabana.RoundedButton");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.TitlePane");
dojo.require("com.copacabana.util");
function submit(event){
if (!com.copacabana.util.checkValidForm()) {
	return;
} else {
	if (event) {
		// Stop the submit event since we want to control form submission.
		event.preventDefault();
		event.stopPropagation();
	}
	com.copacabana.util.showLoading();
	dojo.byId('invitations').submit();
}
}
</script>
</html>