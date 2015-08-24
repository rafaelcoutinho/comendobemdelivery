<%@page import="com.google.gson.JsonPrimitive"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="br.com.copacabana.cb.entities.mgr.OrdinarySellManager"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.com.copacabana.cb.entities.Payment"%>
<%@page import="br.com.copacabana.cb.entities.ItemSold"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.copacabana.SubmitOrderController"%>
<%@page import="br.com.copacabana.cb.entities.OrdinarySell"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.Authentication"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>


<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta property="og:title" content="Vila Ré Apresenta - Noite Italiana" />
<meta property="og:type" content="website" />
<meta property="og:url" content="http://www.comendobem.com.br/noiteItaliana.do" />
<meta property="og:image" content="http://www.comendobem.com.br/resources/NoiteItalianaVilaRe7.JPG" />
<meta property="og:site_name" content="ComendoBem.com.br" />
<meta property="fb:admins" content="832414726" />
<meta property="fb:app_id" content="188850524473998">

<meta property="og:description"
	content="Foneria Vila Ré apresenta Noite Italiana no Tenis Clube Campinas." />

<meta property="og:locality" content="Campinas"/>
<meta property="og:region" content="SP"/>
<meta property="og:postal-code" content="13023"/>
<meta property="og:country-name" content="BRASIL"/>
<meta property="fb:app_id" content="188850524473998"/>
<meta name="description" content="ComendoBem.com.br - Noite Italiana." />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Comendo Bem - Noite Italiana</title>
<%@include file="/static/commonScript.html"%>
<link href="../../styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/user/login.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<Style>
tbody td, tbody td input {
    text-align: left;
    }
</Style>
<script>
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dojox.validate.regexp");
dojo.require("dojo.parser");
dojo.require("com.copacabana.order.ChangeDeliveryAddressWidget");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.order.OrderManagerWidget");
dojo.require("com.copacabana.order.OrderEntryWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.util");

	dojo.require("dijit.form.Form");
	dojo.require("dijit.form.ValidationTextBox");
	dojo.require("dijit.form.FilteringSelect");
	dojo.require("dojo.parser");
	dojo.require("dojo.data.ItemFileReadStore");
	
	dojo.require("dijit.form.TextBox");
	dojo.require("dijit.form.SimpleTextarea");
	dojo.require("dijit.InlineEditBox");
	dojo.require("dojo.parser");
	dojo.require("com.copacabana.util");
	dojo.require("com.copacabana.MessageWidget");

	var dlg;
	var restaurantAddressKey='1';
	var restaurantAddress={
			street:"Rua Osvaldo Dalben",
			number:"14",
			phone:"(19) 3289-0321"
	};
	
	var submitForm = function(event) {
	
		
	}
</script>
<cb:header />
</head>
<%
	Client client = null;
	try {
		Key userK = Authentication.getLoggedUserKey(request.getSession());

		client = Datastore.getPersistanceManager().find(Client.class, userK);
	} catch (Exception e) {

	}
	request.setAttribute("client",client);
%>
<c:if test="${not empty client }">
<script>
dojo.require("com.copacabana.order.ChangeDeliveryAddressWidget");

var loggedUser = ${sessionScope.loggedUser};
var loggedClient = loggedUser.entity;
var id=loggedClient.id;

var retrieveInRestaurant = function() {
	dijit.hideTooltip(dojo.byId('totalWrapper'));
	dojo.publish("onRetrieveInRestaurant",[restaurantAddress]); 
}
dojo.addOnLoad(function() {
	<c:if test="${param.submitting!='true' }">
var deliveryRange = new com.copacabana.order.ChangeDeliveryAddressWidget(
		{
			clientId : loggedUser.entity.id,
			restId : '',
			selectedAddress : {},
			clientAddress : {},
			onlyForRetrieval:false,
			deliveryRange:[{"neighborhood":null,"deliveryRange":{"id":"","neighborhood":null,"city":"ag1jb21lbmRvYmVtYXBwchcLEgVTVEFURRjRDwwLEgRDSVRZGOkHDA","cost":2.12,"costInCents":212,"minimumOrderValueInCents":200,"isPercentage":false,"minimumOrderValue":0.0},"city":{"id":"ag1jb21lbmRvYmVtYXBwchcLEgVTVEFURRjRDwwLEgRDSVRZGOkHDA","name":"Campinas","state":{"id":2001,"name":null}}}],
			restaurantAddress : restaurantAddress
		});
		dojo.subscribe("onDeliveryCostChange",updateTotalCost);
deliveryRange.startup();
dojo.byId("deliveryAddress").appendChild(deliveryRange.domNode);
</c:if>
console.log("ok")
});
var totalCost=0.0;
var currDelCost=0.0;

var deliveryset=false;
function updateTotalCost(delCost){
	if(delCost!=null){
		deliveryset=true;
		console.log("deliveryset",deliveryset)
		currDelCost=0.0;
	}
	var numIngressosOpts=dojo.byId("totalIngressos").options;
	console.log(dojo.byId("totalIngressos").options)
	var numIngressos=0;
	for(var i = 0;i< numIngressosOpts.length;i++){
		console.log(numIngressosOpts[i].selected,numIngressosOpts[i].text)
		if(numIngressosOpts[i].selected==true){
			numIngressos=numIngressosOpts[i].text;
		}
	}
	console.log("numIngressos",numIngressos);
	totalCost=(numIngressos*60.0)+currDelCost;
	dojo.byId("totalCost").innerHTML=totalCost;
	
}
var publishAddressChangeRequest = function() {
	dojo.publish("onChangeAddressRequest");
}

function submitForm(){
	console.log("deliveryset",deliveryset)
	if(deliveryset!=true){
		alert("Por favor selecione uma forma de entrega.");
		return false;
	}
	var deliveryManager = dijit.byId("deliveryManager");
	dojo.byId("toRetrieve").value=false;
	var pays = ["VISAMACHINE","VISADEBITMACHINE","MASTERMACHINE","MASTERDEBITMACHINE","AMEXMACHINE","CHEQUE","INCASH"];
	dojo.byId("addrKey").value=deliveryManager.selectedAddress.id;
	if(deliveryManager.selectedAddress.isRetrieveAtRestaurant==true) {
		if(!confirm("Você selecionou que vai buscar seu ingresso na Vila Ré. Você deverá buscá-lo até dia 18 de setembro.\n Deseja continuar?")){
			return;
		}else{
			dojo.byId("addrKey").value=null;
			dojo.byId("toRetrieve").value=true;
			
		}
		
	}else{
		
	}
	
	
	var isAnyPaymentTypeSelected = false;
	var selectedPayment = null;
	for(var i = 0; i<pays.length;i++){
		if(dijit.byId(pays[i]).attr("checked")){
			isAnyPaymentTypeSelected=true;
			break;
		}
	}
	if(isAnyPaymentTypeSelected==false){
		alert("Por favor selecione uma forma de pagamento.");
		return false;
	}
	var prefDay = dojo.query("[name=prefDay]");
	var isAnyDaySelected=false;
	
	for(var i = 0; i<prefDay.length;i++){		
		if(prefDay[i].checked==true){
			isAnyDaySelected=true;
			break;
		}
	}
	if(isAnyDaySelected==false){
		alert("Por favor selecione algum dia da semana para fazer a entrega.");
		return false;
	}
	dojo.byId("compra").submit();
	 
}

</script>
</c:if>

<c:if test="${param.submitting=='true' }">
<%

OrdinarySell os = new OrdinarySell();
os.setClientId(client.getId());
os.setClientIp(SubmitOrderController.getClientIpData(request));

JsonObject json = new JsonObject();
JsonArray weekDays = new JsonArray();
String[] prefdays = request.getParameterValues("prefDay");
for(int i=0;i<prefdays.length;i++){
	weekDays.add(new JsonPrimitive(prefdays[i]));
}
json.add("prefDays",weekDays);
os.setExtraInfo(json);
ItemSold item = new ItemSold();
item.setDescription("Ingresso");
item.setPriceInCents(6000);
item.setQty(Integer.parseInt(request.getParameter("totalIngressos")));
item.setSell(os);
os.addItemSold(item);
String payStr = request.getParameter("payment");
Payment p = new Payment();
p.setType(PaymentType.valueOf(payStr));

os.setPayment(p);
//os.setRestId();

if("true".equals(request.getParameter("toRetrieve"))){
	os.setToDelivery(false);
	os=new OrdinarySellManager().executeBuy(os);
}else{
	os.setToDelivery(true);
	Key refAddress = KeyFactory.stringToKey(request.getParameter("addrKey"));
	os=new OrdinarySellManager().executeBuyWithDelivery(os,refAddress);	
}

request.setAttribute("sell",os);
response.sendRedirect("/noiteitaliana.do?sellId="+os.getId()+"&submitted=true");
%>
</c:if>
<cb:body closedMenu="true">

	<div id="conteudo_main" class="">
	<div style="margin: 10px 10px 10px 10px; width: 750px;">
	
	<div style="width: 300px; float: left;"><img
		src="/resources/NoiteItalianaVilaRe7.JPG" /></div>
	
	<div style="width: 400px; float: right;">
	
	<c:if test="${param.submitted=='true' }">
	<h2>Bom show!</h2>
	Muito obrigado.<br>
	O número do seu pedido é:  "${param.sellId }".<br>Um email foi enviado para ${client.email} com os dados desta compra.<br/>
	Sua compra foi registrada com sucesso.<br/> Tenha um bom Show!<br>
	</c:if>
	<c:if test="${empty param.submitting && empty param.submitted}">
	<h2>Noite Italiana</h2>
	<c:if test="${ empty client }">
	No dia 23 de setembro, a partir das 21 horas no Tênis Club Campinas, a <a href="/vilarepizza">Forneria Vila Ré</a> apresenta:
	<h2>Tiago Banda Show com Tony Angeli</h2>
	Com jantar completo e bebidas (água, refrigerante e cerveja) servidos pelo buffet <i>Confraria Della Vitoria</i>. Veja o menu preparado para este grande evento <a href="http://www.tcc.com.br/Social/Cardapio%20Jantar%20Italiano.pdf" target="_menu">clicando aqui</a><br> 
	Peça seus ingressos aqui para a noite italiana.<br>	
	Não perca esta sensacional oportunidade.<br>
	 Ingressos <br><ul><li> R$ 60,00 para clientes Vila Ré, Sócios do TCC <b>e usuários do ComendoBem</b>.</li><li>R$ 75,00 para convidados.</li></ul><br>
	  
	<div style="text-align: center;width: 400px;margin: 5px;">
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:window.location='/loginRegistro.do?forwardUrl=%2Fnoiteitaliana.do&mode=view'" name="login"	
		onclick="window.location='/loginRegistro.do?forwardUrl=%2Fnoiteitaliana.do&mode=view'">Quero comprar meu ingresso!</button>
		</div>	
	</c:if>
	<c:if test="${not empty client }">
 	 Olá ${client.name },<br>
 	 Peça seus ingressos aqui.<br> 
		
	
	<br>
	<form id="compra" action="/noiteitaliana.do" method="post">
	<input type="hidden" name="submitting" value="true">
	Número de Ingressos <select
		type="text" name="totalIngressos" id="totalIngressos" onchange="updateTotalCost()">
		<option>1</option>
		<option>2</option>
		<option>3</option>
		<option>4</option>
		<option>5</option>
		<option>6</option>
		<option>7</option>
		<option>8</option>
		<option>9</option>
		<option>10</option>
	</select> x R$ 60,00<br>	
	Telefone para contato: <input type="text" name="phone" value="${client.mainPhone}"><br><br>
	Forma de entrega do ingresso<hr>
	<div style="float:right;text-align: center;">
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:retrieveInRestaurant" id="retrieveInRestaurant"
		onclick="retrieveInRestaurant()">Buscar na Vila Ré</button><br/>		
		<div id="orSection">ou</div>	
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:publishAddressChangeRequestt" id="changeaddressbtn" name="changeaddress"	
		onclick="publishAddressChangeRequest()">Entregar na minha casa</button>
		</div>
	<div id="deliveryLabel"><i>Selecione como quer retirar seu ingresso.</i></div>
	<div id="deliveryAddress"></div>	
	<div class="endereco"></div>
	<div class="enderecoError"></div>
	<input type="hidden" name="toRetrieve" id="toRetrieve" value="false"/>
	<input type="hidden" name="addrKey" id="addrKey" />
	<br clear="all" style="clear: both;"/>
	<hr>
	Forma de pagamento: <br>
	<div style="margin-left:5px;">
	<div class="paymentType_INCASH" style="">
<input type="radio" name="payment" id="INCASH" value="INCASH"  class="INCASH paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="INCASH">Em dinheiro</label><br/>
</div>
<div class="paymentType_CHEQUE" style="">
<input type="radio" name="payment" id="CHEQUE" value="CHEQUE"  class="CHEQUE paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="CHEQUE">Cheque</label><br/>
</div>
	<div class="paymentType_VISAMACHINE" style="">
<input type="radio" name="payment" id="VISAMACHINE" value="VISAMACHINE"  class="VISAMACHINE paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="VISAMACHINE">Visa Cr&eacute;dito *</label><br/>
</div>
<div class="paymentType_VISADEBITMACHINE" style="">
<input type="radio" name="payment" id="VISADEBITMACHINE" value="VISADEBITMACHINE"  class="VISADEBITMACHINE paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="VISADEBITMACHINE">Visa Electron *</label><br/>
</div>
<div class="paymentType_MASTERMACHINE" style="">
<input type="radio" name="payment" id="MASTERMACHINE" value="MASTERMACHINE"  class="MASTERMACHINE paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="MASTERMACHINE">MasterCard Cr&eacute;dito *</label><br/>
</div>
<div class="paymentType_MASTERDEBITMACHINE" style="">
<input type="radio" name="payment" id="MASTERDEBITMACHINE" value="MASTERDEBITMACHINE"  class="MASTERDEBITMACHINE paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="MASTERDEBITMACHINE">Redeshop/Maestro *</label><br/>
</div>

<div class="paymentType_AMEXMACHINE" style="">
<input type="radio" name="payment" id="AMEXMACHINE" value="AMEXMACHINE"  class="AMEXMACHINE paymentType" dojoType="dijit.form.RadioButton"/>
 <label for="AMEXMACHINE">M&aacute;quina American Express *</label><br/>
</div>
<small>* Máquina será levada para cobrança na hora da entrega.</small>
</div>
<hr>
 
	A entrega será feita das 19:00 as 23:30 de segunda a segunda. <Br>
	Escolha o melhor dia para receber a entrega do(s) ingresso(s):<br>
	<table style="text-align: center;">
		<tr>
			<td><input type="checkbox" name="prefDay" value="seg"></td>
			<td><input type="checkbox" name="prefDay" value="ter"></td>
			<td><input type="checkbox" name="prefDay" value="qua"></td>
			<td><input type="checkbox" name="prefDay" value="qui"></td>
			<td><input type="checkbox" name="prefDay" value="sex"></td>
			<td><input type="checkbox" name="prefDay" value="sab"></td>
			<td><input type="checkbox" name="prefDay" value="dom"></td>

		</tr>
		<tr>
			<td>Segunda</td>
			<td>Terça</td>
			<td>Quarta</td>
			<td>Quinta</td>
			<td>Sexta</td>
			<td>Sábado</td>
			<td>Domingo</td>
		</tr>
	</table>
	<br clear="all" style="clear: both;"/>
	<div style="width: 100%;text-align: right;font-size: medium; font-weight: bold;margin:5px;">Custo total: R$ <span  style="font-size:20px;" id="totalCost"></span></div>
	<br clear="all" style="clear: both;"/><br clear="all" style="clear: both;"/><br clear="all" style="clear: both;"/>
	</form>
	<div id="barraEmbaixo" class="fundoCinza"><a
		id="submitButton" onclick="return submitForm();return false;"> <img style="cursor: pointer;" 
		src="/resources/img/btConfirmar.png" alt="Confirmar" /> </a></div>
	</div>
	</c:if>
	
	<br clear="all" />
	</div>
</c:if>
	

	</div>
</cb:body>
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false"></script>	
</html>