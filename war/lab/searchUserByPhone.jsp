<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="br.copacabana.CacheController"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>

<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/static/commonScript.html"%>
<link
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<link href="/styles/labstyle.css" rel="stylesheet" type="text/css" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
<link rel="stylesheet" href="/styles/tableSortable.css" type="text/css" />

<script>
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("com.copacabana.util");
</script>
<%!StringBuilder getJsonEntry(String phone,Client c,String type){
	StringBuilder sb = new StringBuilder();
	String identifier = stripeIndex(phone+c.getName());
	sb.append("{");
	sb.append("\"value\":");
	sb.append("\"").append(identifier).append("\",");
	sb.append("\"name\":");
	sb.append("\"").append(c.getName()).append("\",");
	sb.append("\"id\":");
	sb.append("\"").append(c.getIdStr()).append("\",");
	sb.append("\"phone\":");
	sb.append("\"").append(phone).append("\",");
	sb.append("\"kind\":");
	sb.append("\"").append(c.getId().getKind()).append("\",");
	sb.append("\"type\":");
	sb.append("\"").append(type).append("\",");
	sb.append("\"email\":");					
	if(c.getId().getKind().equals("CLIENT")){
	sb.append("\"").append(c.getUser().getLogin()).append("\"}");
	}else{
		sb.append("\"").append(((RestaurantClient)c).getTempEmail()).append("\"}");	
	}
	return sb;
}
%>
<%!String stripeIndex(String data){
	return data.replaceAll("\\s","").replaceAll("\\.","").replaceAll("-","");
}%>
<%
	String queryStr = request.getParameter("search");
	AddressManager am = new AddressManager();
	ClientManager cm = new ClientManager();
	RestaurantClientManager manager = new RestaurantClientManager();
	if (queryStr != null) {
		if (queryStr.contains("|")) {
			String[] data = queryStr.split("\\|");
			String userId = data[0];
			String userType = data[1];
			if(userType.equals("RESTAURANTCLIENT")){
				RestaurantClient rc =  manager.get(KeyFactory.stringToKey(userId));
				List l = new ArrayList();
				l.add(rc);
				request.setAttribute("restClients", l);
			}else{
				Client rc =  cm.get(KeyFactory.stringToKey(userId));
				List l = new ArrayList();
				l.add(rc);
				request.setAttribute("siteClients", l);
				
			}
		} else {
			List<RestaurantClient> list = manager.getRestaurantClients(Authentication.getLoggedUserKey(session), queryStr);
			List<Client> clients = manager.getSiteClientsWithPhone(queryStr);
			request.setAttribute("siteClients", clients);
			List<Client> siteClientsAddress = new ArrayList();
			request.setAttribute("restClients", list);
			if (clients.isEmpty() && list.isEmpty()) {
				//try to find addresses

				siteClientsAddress.addAll(manager.getClientsByAddressPhone(queryStr));
			}
			//clients.addAll(siteClientsAddress);
			request.setAttribute("siteClientsAddress", siteClientsAddress);
		}
	}
	Map<String, String> phoneByUser = new HashMap<String, String>();

	Set<String> allPhones = null;//(Set<String>) session.getAttribute("allPhonesCache");//CacheController.getCache().get("allPhonesCache");
	StringBuilder sb = new StringBuilder("[");
	if (allPhones == null) {

		
		allPhones = new HashSet<String>();

		for (Iterator iter = cm.list().iterator(); iter.hasNext();) {
			Client c = (Client) iter.next();
			phoneByUser.put(c.getMainPhone() + " " + c.getName(), c.getIdStr() + "|" + c.getId().getKind());
			
			sb.append(getJsonEntry(c.getMainPhone(),c,"contact")).append(",");
			
			
			
			allPhones.add(c.getContact().getPhone());
			StringBuilder alreadyAdded = new StringBuilder();
			alreadyAdded.append(c.getContact().getPhone()).append("|");
			for (Iterator<Key> iter2 = c.getAddresses().iterator(); iter2.hasNext();) {
				Key addressK = iter2.next();
				Address address = am.getAddress(addressK);
				if (!alreadyAdded.toString().contains(address.getPhone())) {
					alreadyAdded.append(address.getPhone()).append("|");
					phoneByUser.put(address.getPhone() + " " + c.getName(), c.getIdStr() + "|" + c.getId().getKind());
					String identifierAdd = stripeIndex(address.getPhone()+c.getName());
					sb.append(getJsonEntry(address.getPhone(),c,"address")).append(",");
				}
			}

		}

		List<RestaurantClient> allRestClientsList = manager.getRestaurantClients(Authentication.getLoggedUserKey(session));

		for (Iterator iter = allRestClientsList.iterator(); iter.hasNext();) {
			RestaurantClient c = (RestaurantClient) iter.next();

			allPhones.addAll(c.getPhones());
			for (Iterator<String> iter2 = c.getPhones().iterator(); iter2.hasNext();) {
				String phone = iter2.next();
				phoneByUser.put(phone + " " + c.getName(), c.getIdStr() + "|" + c.getId().getKind());
				String identifier = stripeIndex(phone+c.getName());
				sb.append(getJsonEntry(phone,c,"restClient")).append(",");
				
			}

		}
		if(sb.length()>1){
			sb.setLength(sb.length()-1);
		}
		sb.append("];");

	}

	request.setAttribute("allPhones", allPhones);
%>
<script>
var filterchars=function(ui,event){
	ui.currentTarget.value=ui.currentTarget.value.replace(/\s/g,'');
	ui.currentTarget.value=ui.currentTarget.value.replace(/-/g,'');
	
}
	var showNewClient = function(){ $("[name=phone]").attr('value',$("[name=search]").attr('value'));$("#newClientForm").dialog('open')}
	$(document).ready(
			
			function() {
				$( "#newClientForm" ).dialog({autoOpen:false,minWidth:400});
				$( "#addClientEmail" ).dialog({autoOpen:false,minWidth:400,modal:true});
				
	            $( "#continueAndSaveEmail" ).button({
	                icons: {
	                    primary: "ui-icon-check"
	                },
	                text: true
	                
	            });
	            
	            $( "#continueOnly" ).button({
	                icons: {
	                    primary: "ui-icon-close"
	                },
	                text: true
	            });
	            $( "#continueAndSaveEmail" ).click(continueAndSave);
	            $( "#continueOnly" ).click(continueNoSave);
				//$( "button").button();
				//$( "button").click()
				$("input#autocomplete").keyup(filterchars);
				$("input#autocomplete").autocomplete(
						{
							minLength: 4,
							delay: 500,
							search: function(event, ui) { 
								console.log("evet",event);
								console.log("ui",ui);
							},
							 select: function(event, ui) {
								 console.log("event",event);
									console.log("ui",ui.item);
								if(ui.item.value!=null){									
									$("input#autocomplete").attr("value",ui.item.name);
									updateTable(ui.item);
									//$("form#search").submit();
									
							 	}
								 
							 },
							 focus: function( event, ui ) {									
									return false;
							},
							source : allPhones
						}).data( "autocomplete" )._renderItem = function( ul, item ) {
							return $( "<li></li>" )
							.data( "item.autocomplete", item )
							.append( "<a>" + item.phone+ " "+ item.name+"</a>" )
							.appendTo( ul );
					};;
				
				
			});
	
	
	
	
	
	
	
	
	var allPhones = <%=sb.toString()%>;
	
var validate=function(){
	if(dijit.byId("name").attr("value").length==0 || dijit.byId("name").validate()==false){
		dijit.byId('name').displayMessage(dijit.byId('name').invalidMessage);
		return false;
	};
	if(dijit.byId("phone").validate()==false){
		dijit.byId('phone').displayMessage(dijit.byId('phone').invalidMessage);
		return false;
	}
	if(dijit.byId("email").attr('value').length>0 && dijit.byId("email").validate()==false){
		dijit.byId('email').displayMessage(dijit.byId('email').invalidMessage);
		return false;
	}
	return true;
}

var checkNSave=function(userid){
	var dEmail=dijit.byId("tempEmail");
	if(dEmail.validate()==false){
		dEmail.displayMessage(dEmail.invalidMessage);
		return false;
	}else{
		var json={
			id:userid,
			email:dEmail.attr("value")
		}
		var retFct = function(data){			
			dEmail.displayMessage("E-mail salvo com sucesso.");
		}
		$.post("/lab/updateRestClient.jsp", json,retFct ,"json").error(function(data) { console.log(data);alert("Erro ao salvar email de cliente."); });
		
	}
	
}

var currentClient=null;
var updateTable=function(clientData){
	$("#resultsBody").empty();
	currentClient=clientData;
	if(clientData.email==null || clientData.email.length==0 || clientData.email=="null"){
		
 		$( "#addClientEmail" ).dialog("open");	
 	}else{
 		var row = "<tr><td><a href='selectDeliveryAddress.jsp?client="+clientData.id+"'>"+clientData.name+"</a></td>";
 		row+="<td>"+clientData.email+"</td></tr>";
 		$("#resultsBody").append(row);
 	}

}
var continueNoSave=function(){
	window.location="selectDeliveryAddress.jsp?client="+currentClient.id
}
var continueAndSave=function(){
	var dEmail=dijit.byId("tempEmail");
	if(dEmail.validate()==false){
		dEmail.displayMessage(dEmail.invalidMessage);
		return false;
	}else{
		window.location="selectDeliveryAddress.jsp?client="+currentClient.id+"&email="+dEmail.attr("value")
	}
}
</script>

</head>
<body>
<jsp:include page="labheader.jsp"><jsp:param name="step"
		value="lookup" /></jsp:include>
<div class="body">
<div id="header">Busque o cliente</div>
<form id="search" action="searchUserByPhone.jsp"><br />
Digite telefone: <input id="autocomplete" type="text" name="search"
	value="${param.tel }"> <a href="#" onclick="showNewClient()">Cadastrar
novo cliente</a><br>

</form>
<hr>
<c:if test="${empty param.search}">
	<div class="instructions">Digite o telefone do cliente e
	selecione os resultados exibidos.</div>
</c:if> 
<div id="localSearch">
<span id="searchStatus"></span><br/>
<div class="resultType"></div>
<table cellspacing=0 cellpadding=2>
	<thead>
	<tr>
		<th>Nome</th>
		<th>E-mail</th>
		
	</tr>						
	</thead>
	<tbody id="resultsBody">
		<tr>
			<td><a
				href="selectDeliveryAddress.jsp?client=${client.idStr }">${client.name}</a></td>
		</tr>
	</tbody>
</table>
</div>
<c:if test="${not empty param.search}">
	<c:if
		test="${empty siteClients and empty restClients and empty siteClientsAddress}">
Nenhum cliente foi encontrado com o telefone "${param.search }"
</c:if>
	<c:if
		test="${not empty siteClients or not empty restClients or not empty siteClientsAddress}">
Há ${fn:length(siteClients)+ fn:length(restClients)} clientes encontrados: 
		<c:if test="${empty siteClients}">

</c:if>

		

<c:if test="${not empty siteClients}">
			<div class="resultType">Clientes do site</div>
			<table cellspacing=0 cellpadding=2>
				<thead>
					<tr>
						<th>Nome</th>	
						<th>E-mail</th>
						</tr>					
				</thead>
				<tbody>
					<c:forEach var="client" items="${siteClients}" begin="0"
						varStatus="status">
						<tr>
							<td><a
								href="selectDeliveryAddress.jsp?client=${client.idStr }">${client.name}</a></td>
							
					</c:forEach>
				</tbody>
			</table>
		</c:if>
		<hr>
		<c:if test="${empty restClients}">
Nenhum cliente da base do restaurante.
</c:if>
		<c:if test="${not empty restClients}">
			<div class="resultType">Clientes do restaurante</div>
			<table>
				<thead>
					<tr>
						<th>Nome</th>						
						<th>E-mail</th>
				</thead>
				<tbody>
					<c:forEach var="client" items="${restClients}" begin="0"
						varStatus="status">
						<tr>
							<td><a
								href="selectDeliveryAddress.jsp?client=${client.idStr }">${client.name}</a></td>
							<td>
							<c:if test="${empty client.tempEmail }">							
							<input type="text" id="tempEmail_${client.idStr }" promptMessage="Cliente sem e-mail, quer cadastrar?" required="false"
								regExpGen="com.copacabana.util.emailFormat" trim="true"
									dojoType="dijit.form.ValidationTextBox" onblur="checkNSave('${client.idStr }')">
							</c:if>
							<c:if test="${not empty client.tempEmail }">
							${client.tempEmail}
							</c:if>
							</td>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</c:if>
</c:if></div>
</body>
<div title="Cliente sem e-mail, quer cadastrar?" id="addClientEmail"
	style="display: none; padding: 20px; font-size: medium;width: 250px;">
Adicionar e-mail para <span id="noMailName"></span>	
<input type="text" id="tempEmail" promptMessage="Cliente sem e-mail, quer cadastrar?" required="false"
								regExpGen="com.copacabana.util.emailFormat" trim="true"
									dojoType="dijit.form.ValidationTextBox" ><br/>
										<br>
<button id="continueAndSaveEmail">Salvar e-mail</button> <button id="continueOnly">Continuar sem salvar</button>
</div>

<div title="Cadastro de novo cliente" id="newClientForm"
	style="display: none; padding: 20px; font-size: medium;">
<form action="createRestClient.jsp" method="post"
	onsubmit="return validate();">nome<br>
<input type="text" name="name" id="name" properCase="true"
	invalidMessage="Nome é obrigatório"
	dojoType="dijit.form.ValidationTextBox" regExp=".+"><br>
telefone<br>
<input class="mandatory" required="true" id="phone"
	dojoType="dijit.form.ValidationTextBox" width="220"
	title='N&uacute;mero de telefone' cssClass="required" trim="true"
	name="phone" regExpGen="com.copacabana.util.phoneFormat"
	invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN" /><bR>
e-mail<bR>
<input type="text" name="email" id="email" required="false"
	regExpGen="com.copacabana.util.emailFormat" trim="true"
	dojoType="dijit.form.ValidationTextBox"><br/>
<input type="submit" value="Criar"></form>
</div>

</html>