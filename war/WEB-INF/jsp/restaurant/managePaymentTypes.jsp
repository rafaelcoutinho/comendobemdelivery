<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.UserBeanManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
RestaurantManager rman = new RestaurantManager();
UserBeanManager ubean = new UserBeanManager();
Restaurant r = rman.getRestaurant(Authentication.getLoggedUserKey(session));
for(Iterator<String> iter = r.getAcceptablePayments().iterator();iter.hasNext();){
	request.setAttribute(iter.next(),Boolean.TRUE);
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - Tipos de pagamento</title>
	
	<cb:header />
	<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dijit/themes/tundra/tundra.css">
	<link href="/styles/restaurant/profile.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/restaurant/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
		<link href="/styles/restaurant/profile_ie_8.css" type="text/css" rel="stylesheet" />
	</c:if>
	
	<link href="/styles/restaurant/areaTaxa.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/restaurant/areaTaxa_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	
<%@include file="/static/commonScript.html" %>

<script>
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");

dojo.addOnLoad(function() {
	//updateForm();
});
var updateForm = function(){
	var xhrArgs = {
		url : "/getRestaurant.do?id=" + loggedRestaurant.id,		
		handleAs : "json",
		load : function(data) {			
			console.log(data.acceptablePayments);
			var i=0;
			for(i=0;i<data.acceptablePayments.length;i++){
				var ptype = data.acceptablePayments[i];
				var pWidget=dijit.byId(ptype);
				pWidget.attr('checked',true);
			}
		},
		error : function(error) {
			console.log('error');
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
}
function save(){
	com.copacabana.util.showLoading();
	dijit.byId('PAYPAL').attr('checked');
	dojo.byId('PAYPAL').checked='checked';
	var xhrArgs = {
	        form: dijit.byId('paymentForm').domNode,
	        handleAs: "json",
	        load: function(data) {
	        	console.log(data);
	        	com.copacabana.util.hideLoading();
	        	//var msg = new com.copacabana.MessageWidget();
	            //msg.showMsg("Dados salvos.");
	        	com.copacabana.util.showSuccessAction();
	            
	            
	        },
	        error: function(error) {
	        	com.copacabana.util.hideLoading();
	            //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
	            //docs server.
	            console.log("failed to post data.",error);
	            var msg = new com.copacabana.MessageWidget();
	            msg.showMsg("Erro ao salvar dados: "+error.message);
	        }
	    }
	    //Call the asynchronous xhrPost
	    console.log("Form being sent...");
	    var deferred = dojo.xhrPost(xhrArgs);

}

function save2(){
	
var formWidget = dijit.byId('form');
var form = dijit.byId('myform');
com.copacabana.util.cleanNode(form.domNode);
var cash=dijit.byId('INCASH');
var i=0;
console.log('form',form);
if(cash.attr('checked')==true){
	var cashInput = document.createElement('input');	
	cashInput.setAttribute('type','hidden');
	
	cashInput.setAttribute('name','acceptablePayments');
	
	cashInput.setAttribute('value','INCASH');	
	form.domNode.appendChild(cashInput);
	
	i++;
}
var cheque=dijit.byId('CHEQUE');
if(cheque.attr('checked')==true){
	var chequeInput = document.createElement('input');
	chequeInput.setAttribute('type','hidden');
	chequeInput.setAttribute('name','acceptablePayments');
	chequeInput.setAttribute('value','CHEQUE');
	form.domNode.appendChild(chequeInput);
	i++;
}
var paypal=dijit.byId('PAYPAL');
if(paypal.attr('checked')==true){
	var chequeInput = document.createElement('input');
	chequeInput.setAttribute('type','hidden');
	chequeInput.setAttribute('name','acceptablePayments');
	chequeInput.setAttribute('value','PAYPAL');
	form.domNode.appendChild(chequeInput);
	i++;
}
console.log('c');
var rest=dijit.byId('restId');
rest.attr('value',loggedRestaurant.id);
if(i==0){
	var msgAtLeastOne = new com.copacabana.MessageWidget();
	msgAtLeastOne.showMsg("Por favor selecione pelo menos uma forma de pagamento.");
	
	return;
}
var xhrArgs = {
        form: form.domNode,
        handleAs: "json",
        load: function(data) {
        	console.log(data);
        	
        	com.copacabana.util.showSuccessAction();
        },
        error: function(error) {
            //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
            //docs server.
            console.log("failed to post data.",error);
            var msg = new com.copacabana.MessageWidget();
            msg.showMsg("Erro ao salvar dados: "+error.message);
        }
    }
    //Call the asynchronous xhrPost
    console.log("Form being sent...");
    var deferred = dojo.xhrPost(xhrArgs);

//form.submit();

	
}
</script>

<form action="/updatePaymentTypes.do" dojoType="dijit.form.Form" id="myform" method="post">
<input type="hidden" name="id" id="restId" dojoType="dijit.form.TextBox"/>

</form>
<cb:body closedMenu="true">
	
	<jsp:include page="restheader.jsp" ><jsp:param name="isFunctions" value="true"></jsp:param></jsp:include>
<form action="/updatePaymentTypes.do" dojoType="dijit.form.Form" id="paymentForm" method="post">	
	<div id="dadosFuncionalidades">
		<div id="funcionalidade">
			<h2>Formas de pagamento</h2>
			
			<p>
				Selecione as suas formas de pgto:<br />
				<input dojoType="dijit.form.CheckBox" value="INCASH" type="checkbox" name="acceptablePayments" id="INCASH" <c:if test="${INCASH==true}">checked="checked"</c:if>/><label for="INCASH">Dinheiro</label><br/>
				<input dojoType="dijit.form.CheckBox" value="CHEQUE" type="checkbox" name="acceptablePayments" id="CHEQUE" <c:if test="${CHEQUE==true}">checked="checked"</c:if>></input><label for="CHEQUE">Cheque</label><br/>
				<input dojoType="dijit.form.CheckBox" value="PAYPAL" type="checkbox" name="acceptablePayments" id="PAYPAL" checked="checked" readonly="readonly"></input><label for="PAYPAL">Online via PayPal (Visa, Master, AMEX)</label><br/>
				<input dojoType="dijit.form.CheckBox" value="VISAMACHINE" type="checkbox" name="acceptablePayments" id="VISAMACHINE" <c:if test="${VISAMACHINE==true}">checked="checked"</c:if>></input><label for="VISAMACHINE">Visa</label><br/>
				<input dojoType="dijit.form.CheckBox" value="VISADEBITMACHINE" type="checkbox" name="acceptablePayments" id="VISADEBITMACHINE" <c:if test="${VISADEBITMACHINE==true}">checked="checked"</c:if>></input><label for="VISADEBITMACHINE">Visa Electron</label><br/>
				<input dojoType="dijit.form.CheckBox" value="VISAVOUCHERMACHINE" type="checkbox" name="acceptablePayments" id="VISAVOUCHERMACHINE" <c:if test="${VISAVOUCHERMACHINE==true}">checked="checked"</c:if>></input><label for="VISAVOUCHERMACHINE">Visa Vale</label><br/>
				<input dojoType="dijit.form.CheckBox" value="MASTERMACHINE" type="checkbox" name="acceptablePayments" id="MASTERMACHINE" <c:if test="${MASTERMACHINE==true}">checked="checked"</c:if>></input><label for="MASTERMACHINE">MasterCard</label><br/>
				<input dojoType="dijit.form.CheckBox" value="MASTERDEBITMACHINE" type="checkbox" name="acceptablePayments" id="MASTERDEBITMACHINE" <c:if test="${MASTERDEBITMACHINE==true}">checked="checked"</c:if>></input><label for="MASTERDEBITMACHINE">Redeshop/Maestro</label><br/>
				<input dojoType="dijit.form.CheckBox" value="AMEXMACHINE" type="checkbox" name="acceptablePayments" id="AMEXMACHINE" <c:if test="${AMEXMACHINE==true}">checked="checked"</c:if>></input><label for="AMEXMACHINE">Máquina American Express</label><br/>
				<input dojoType="dijit.form.CheckBox" value="TRMACHINE" type="checkbox" name="acceptablePayments" id="TRMACHINE" <c:if test="${TRMACHINE==true}">checked="checked"</c:if>></input><label for="TRMACHINE">Máquina TR (Ticket Restaurante)</label><br/>
				<input dojoType="dijit.form.CheckBox" value="VRSMART" type="checkbox" name="acceptablePayments"  id="VRSMART" <c:if test="${VRSMART==true}">checked="checked"</c:if>></input><label for="VRSMART">VR Smart</label><br/>
				<input dojoType="dijit.form.CheckBox" value="TRSODEXHO" type="checkbox" name="acceptablePayments"  id=TRSODEXHO <c:if test="${TRSODEXHO==true}">checked="checked"</c:if>></input><label for="TRSODEXHO">Sodexho</label><br/>
			<div id="barraSalvar" class="fundoCinza barraSalvar" >				
					<img src="/resources/img/btSalvar.png" alt="salvar" onclick="save()"/>				
			</div>
			</div>
		</div>
</form>		
		<jsp:include page="profileSide.jsp" ><jsp:param name="isPaymentType" value="true"></jsp:param></jsp:include>
	
	
</cb:body>
</html>