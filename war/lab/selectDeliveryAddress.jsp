<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@ taglib
	prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale
	value='pt' />
<fmt:setBundle basename='messages' />
<%
	String clientId = request.getParameter("client");
	RestaurantManager rman = new RestaurantManager();
	Restaurant rest = rman.getRestaurant(Authentication.getLoggedUserKey(session));
	RestaurantClientManager rcman = new RestaurantClientManager();
	Client client = null;
	Key clientKey= KeyFactory.stringToKey(clientId);
	if(clientKey.getKind().equals("CLIENT")){
		client=new ClientManager().get(clientKey);
	}else{
		client=rcman.get(clientKey);
		
		//chekc if adding eamil to client
		String email = request.getParameter("email");
		if(email!=null && email.length()>0){
			((RestaurantClient)client).setTempEmail(email);
			Datastore.getPersistanceManager().getTransaction().begin();
			rcman.persist((RestaurantClient)client);
			Datastore.getPersistanceManager().getTransaction().commit();
			client=rcman.get(clientKey);
		}
		
	}
	AddressManager addMan = new AddressManager();
	List<Address> deliveryAddresses = new ArrayList<Address>();
	for(Iterator<Key> iter = client.getAddresses().iterator();iter.hasNext();){
		Key k = iter.next();
		deliveryAddresses.add(addMan.get(k));
	}
	Address address=new Address();
	if(request.getParameter("selAddress")!=null){
		address = addMan.get(KeyFactory.stringToKey(request.getParameter("selAddress")));
	}else{
		if(client.getAddresses().size()>0){
			address=addMan.get(client.getAddresses().get(0));
		}else{
			address.setPhone(client.getMainPhone());
		}
		
	}
	request.setAttribute("address",address);
	request.setAttribute("deliveryAddresses",deliveryAddresses);
	
	NeighborhoodManager nman = new NeighborhoodManager();
	List bairros = nman.getOrderedNeighborByCity(new CityManager().getCityByName("Campinas"));
	request.setAttribute("bairros",bairros);
	
%>
<html>
<head>
<link href="/styles/labstyle.css" rel="stylesheet" type="text/css" />
<link
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<script
	src="/scripts/jquery-1.4.4.min.js"></script>
<script
	src="/scripts/jquery-ui-1.8.10.custom.min.js"></script>
<style type="text/css">
.inRange{
	cursor: pointer;
	text-decoration: underline;
}
.notInRange{
color:#090909;
}
</style>
<%@include file="/static/commonScript.html" %>
<script>

dojo.require("dijit.form.CurrencyTextBox");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("com.copacabana.util");

var clientAddresses = [<%

for(Iterator<Key> iter = client.getAddresses().iterator();iter.hasNext();){
	Key k = iter.next();
	Address addresses = addMan.get(k);
	String addressStr=addresses.getFormattedString();
	addressStr=addressStr.replaceAll("\\\"","\\\\\"");
	
	%>{"neigh":"<%=addresses.getNeighborhood().getIdStr()%>","addressStr":"<%=addressStr%>","id":"<%=addresses.getIdStr()%>"}<%if(iter.hasNext()){%>,<%}
}
%>];

var delRanges={<%
DeliveryRange deliveryRangeData = null;
String strr="";

for(Iterator<DeliveryRange> iter = rest.getDeliveryRanges().iterator();iter.hasNext();){
	DeliveryRange del = iter.next();
	if(address!=null && address.getNeighborhood()!=null &&  del.getNeighborhood().equals(address.getNeighborhood().getId())){
		request.setAttribute("isInRange","true");
	}
	String idN = KeyFactory.keyToString(del.getNeighborhood());
	if(!strr.contains(idN)){
	%>
	"<%=idN%>":{"id":"<%=del.getIdStr()%>","costInCents":<%=del.getCostInCents()%>}<%if(iter.hasNext()){%>,<%}
	strr+="|"+idN;
	}
}
%>};

var createDeliveryRange=function(){
	
	var cost=dijit.byId("newDeliveryRangeCost");
	if(cost.validate()==false){
		cost.displayMessage(cost.invalidMessage);
		return false;
	}else{
		var minDijit=dijit.byId("newDeliveryRangeMinimun");
		if(minDijit.validate()==false){
			minDijit.displayMessage(minDijit.invalidMessage);
			return false;
		}
		var json ={
				nId:$("#newDeliveryRangeId").attr("value"),
				cost:cost.attr("value"),
				minimum:dijit.byId("newDeliveryRangeMinimun").attr("value")
			}		
		var retFct = function(data){
			try{				
				delRanges[$("#newDeliveryRangeId").attr("value")]=
					{
						"id":data.delId,
						"costInCents":data.delCostInCents
					}
				$("#submitButton").attr('disabled',false);
				$("#status").html("Taxa de entrega R$ "+(data.delCostInCents/100));
				//window.location=window.location;
				$("#newDeliveryRange").dialog("close");
			}catch(e){
				console.error(e);
			}
		}
		$.post("/lab/addDeliveryRange.jsp", json,retFct ,"json").error(function(data) { console.log(data);alert("Erro ao salvar área de entrega."); });
		
	}
	
}
var showDeliveryRangeForm=function(delRange,name){
	
	
	$("#newDeliveryRangeId").attr("value",delRange);
	
	$("#newDeliveryRangeName").html(name);
	$("#newDeliveryRange").dialog("open");
	
}
	$(document).ready(function() {
		$("#newDeliveryRange").dialog({
			autoOpen : false,
			modal:true
		});
		$("#createNewDeliveryRange").click(createDeliveryRange);
		if($("#currAddresses")){			
			$("#currAddresses").change(function(event,ui){
					window.location='selectDeliveryAddress.jsp?client=${param.client}&selAddress='+$(this).attr('value')
				});			
		}
		
		$("#neighborhood").change(function(event,ui){
			if($(this).attr('value')==-1){
				return;
			}
			var delRange = delRanges[$(this).attr('value')];
			$("#status").empty();
			if(!delRange){
				var neigh=$(this).attr('value');
				
				var fct=function(){					
					showDeliveryRangeForm(neigh,$("option[value="+neigh+"]").html());
				}
				$("#status").html("Fora da área de entrega! <a href='#' >Adicionar região de entrega</a>");
				$("#status").click(fct);
				
				$("#submitButton").attr('disabled',true);
			}else{
				$("#submitButton").attr('disabled',false);
				$("#status").html("Taxa de entrega "+com.copacabana.util.moneyFormatter(delRange.costInCents/100.0));
				$("#newAddressDialog [name=deliveryRangeId]").attr("value",delRange.id);
				$("#newAddressDialog [name=deliveryRangeCostInCents]").attr("value",delRange.costInCents);
				
			}
			
		});
		
		
		var html = "<table><thead><th>Endereço</th><th>Taxa</th></thead><tbody>";
		var htmlOut = "<table><thead><th>Endereço</th><th></th></thead><tbody>";
		var totalInRange=0;
		var totalOutOfRange=0;
		for(var id in clientAddresses){
			var address = clientAddresses[id];	
			if(delRanges[address.neigh]){
				totalInRange++;
				html+="<tr><td class='inRange' addressId='"+id+"'>"+address.addressStr+" </td><td>"+com.copacabana.util.moneyFormatter(delRanges[address.neigh].costInCents/100.0)+"</td><tr>";
			}else{
				htmlOut+="<tr><td class='notInRange' >"+address.addressStr+" </td><td neigh='"+address.neigh+"' class='notInRange'>+ adicionar área</td></tr>";
				totalOutOfRange++;
			}
		}
		html+="</tbody></table>";
		htmlOut+="</tbody></table>";
		if(totalInRange>0){
			$("#addressList").append("Endereços cadastrados: "+html);
		}else{
			$("#addressList").append("Não há endereços cadastrados para este cliente.");
		}
		if(totalOutOfRange>0){
			$("#addressListNotInRange").append("Endereços cadastrados fora da área de entrega: "+htmlOut);
		}
		$("button").button();
		if(totalInRange==0 && totalOutOfRange==0){
			$("#newAddressDialog").dialog({
				autoOpen : true,
				width:750,
				height:400
			});
		}else{
			$("#newAddressDialog").dialog({
				autoOpen : false,
				width:750,
				height:400
			});
			
		}
		$("#openNewAddressDialog").click(function(){$("#newAddressDialog").dialog("open");})
		$(".notInRange").click(function(){
			var neigh = $(this).attr("neigh");
			showDeliveryRangeForm(neigh,$("option[value="+neigh+"]").html());	
		});
		$(".inRange").click(function(){
			com.copacabana.util.showLoading("Aguarde...");
			var address = clientAddresses[$(this).attr("addressId")];
			var deliveryCost = delRanges[address.neigh];
			
			$("#selectedForm").append("<input type='hidden' name='addressId' value='"+address.id+"'>");
			$("#selectedForm").append("<input type='hidden' name='deliveryRangeCostInCents' value='"+deliveryCost.costInCents+"'>");
			$("#selectedForm").append("<input type='hidden' name='deliveryRangeId' value='"+deliveryCost.id+"'>");
			
			$("#selectedForm").submit();
		});
	});
	
</script>
</head>
<body>
<jsp:include page="labheader.jsp"><jsp:param value="address" name="step"/></jsp:include>

<div class="body">
<div id="header">Endereço de entrega</div><div style="float:right;"><button id="openNewAddressDialog">Novo endereço</button></div>
<br>
<div id="addressList"></div>
<hr>
<div id="addressListNotInRange"></div>




</div>

<form id="selectedForm" method="post" action="startOrder.jsp">
<input type="hidden" name="client" value="${param.client }">
</form>
</body>


<div title="Novo Endereço" id="newAddressDialog"
	style="display: none; padding: 20px; font-size: medium;">


<div style="margin: 3px; border: 1px solid;padding: 10px">Endereço de entrega:<br>
<form action="startOrder.jsp" method="post">
<input type="hidden" name="client" value="${param.client }">
<table>
<tr><td>Rua:</td><td><input type="text" name="address.street" value=""></td></tr><tr><td>
Número:</td><td><input type="text" name="address.number"
	value=""></td></tr><tr><td>
Complemento:</td><td><input type="text" name="address.additionalInfo"
	value=""></td></tr><tr><td>
Telefone:</td><td><input type="text" name="address.phone"
	value="<%=client.getMainPhone() %>"></td></tr><tr><td>
Bairro:</td><td><select name="address.neighborhood" id="neighborhood">
	<option >-- Selecione o bairro --</option>
	<c:forEach var="bairro" varStatus="status" items="${bairros }">		
		<option value="${bairro.idStr }" >${bairro.name }</option>
	</c:forEach></td></tr>
	<tr><td></td><td><input type="submit"  disabled="disabled" value="Utilizar endereço" id="submitButton"> <span id="status"></span> </td></tr>
</select>

</table>
<input type="hidden" name="deliveryRangeId" value=""/>
<input type='hidden' name='deliveryRangeCostInCents' value="">
<input type='hidden' name='deliveryRangeMinimumCost' value="0">
</form>
</div>

</div>


<div title="Área de entrega" id="newDeliveryRange" style="display: none; padding: 20px;font-size: medium;">
<input type="hidden" id="newDeliveryRangeId">
Bairro '<span id="newDeliveryRangeName"></span>':<br>
Taxa de entrega<br> 
<input class="mandatory" required="true" id="newDeliveryRangeCost"
			 dojoType="dijit.form.CurrencyTextBox" lang="pt-BR" value="0,00" fractional="true" required="true" selectOnClick="true" currency="" invalidMessage="Digite o valor com centavos, por exemplo 10,90."/>
<br>Valor m&iacute;nimo:<br>
<input class="mandatory" required="true" id="newDeliveryRangeMinimun"
			 dojoType="dijit.form.CurrencyTextBox" lang="pt-BR" value="0,00" fractional="true" required="true" selectOnClick="true" currency="" invalidMessage="Digite o valor com centavos, por exemplo 10,90."/>			 
<input type="button" id="createNewDeliveryRange" value="Salvar taxa">
</div>


</html>