<%@page import="java.util.Collection"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.PlateSize"%>
<%@page import="br.com.copacabana.cb.entities.PlateStatus"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="br.com.copacabana.cb.entities.mgr.AbstractJPAManager"%>
<%@page import="br.copacabana.usecase.erp.JSPUtils"%>
<%@page import="org.apache.jasper.compiler.JspUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.google.appengine.api.datastore.Category"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
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
<%!Map<Key,Plate> regularPlates = new HashMap<Key,Plate>();%>
<%!StringBuilder getJSArray(Collection<Plate> smallPs) {
		PlateManager pm = new PlateManager();
		StringBuilder sbSmall = new StringBuilder();
		sbSmall.append("[");
		if (smallPs != null) {
			for (Iterator<Plate> smallOptions = smallPs.iterator(); smallOptions.hasNext();) {
				Plate small = smallOptions.next();
				sbSmall.append("{\"title\":\"");
				sbSmall.append(small.getTitle());
				sbSmall.append("\",\"id\":\"");
				sbSmall.append(small.getIdStr());
				
				if (small.getExtendsPlate() != null) {
					sbSmall.append("\",\"extends\":\"");
					sbSmall.append(KeyFactory.keyToString(small.getExtendsPlate()));
					sbSmall.append("\",\"extendsTitle\":\"");
					Plate extender = pm.get(small.getExtendsPlate());
					regularPlates.put(extender.getId(),extender);
					sbSmall.append(extender.getTitle());
				}
				sbSmall.append("\",\"priceInCents\":");
				sbSmall.append(small.getPriceInCents());

				sbSmall.append("},");
			}
		}
		if(sbSmall.length()>1){
			sbSmall.setLength(sbSmall.length() - 1);
		}
		sbSmall.append("]");
		return sbSmall;
	}%>
<%!void setAddressInSession(HttpServletRequest request) {

		String street = request.getParameter("address.street");
		String num = request.getParameter("address.number");
		String phone = request.getParameter("address.phone");
		String add = request.getParameter("address.additionalInfo");
		String neigh = request.getParameter("address.neighborhood");
		request.getSession().setAttribute("address.street", street);
		request.getSession().setAttribute("address.number", num);
		request.getSession().setAttribute("address.phone", phone);
		request.getSession().setAttribute("addressId", request.getParameter("addressId"));
		request.getSession().setAttribute("address.additionalInfo", add);
		request.getSession().setAttribute("address.neighborhood", neigh);

	}%>
<%


	AbstractJPAManager rcman = new RestaurantClientManager();
	Client client = null;
	String clientId = request.getParameter("client");
	Key clientKey = KeyFactory.stringToKey(clientId);
	if (clientKey.getKind().equals("CLIENT")) {
		rcman = new ClientManager();
	} else {
		rcman = new RestaurantClientManager();
	}
	Address addr = null;
	AddressManager addMan = new AddressManager();
	setAddressInSession(request);
	if(request.getParameter("addressId")==null || request.getParameter("addressId").length()==0){
		addr = JSPUtils.getAddress(request);	
	}else{
		addr = 	addMan.get(KeyFactory.stringToKey(request.getParameter("addressId")));
		request.getSession().setAttribute("address.id", request.getParameter("addressId"));
	}
	
	client = (Client)rcman.get(clientKey);
	if(!client.getAddresses().contains(addr.getId())){
		client.getAddresses().add(addr.getId());
	}
		
	
	
	RestaurantManager rman = new RestaurantManager();
	Restaurant rest = rman.getRestaurant(Authentication.getLoggedUserKey(session));
	
	
	Map<Key, List<Plate>> group = new HashMap<Key, List<Plate>>();
	Map<String, List<Plate>> plateMap = new HashMap<String, List<Plate>>();
	FoodCategoryManager fman = new FoodCategoryManager();

	PlateManager pm = new PlateManager();

	StringBuilder sbSmall = getJSArray(pm.getRestaurantSizeOptions(rest, PlateSize.SMALL));
	StringBuilder sbMedium = getJSArray(pm.getRestaurantSizeOptions(rest, PlateSize.MEDIUM));
	StringBuilder sbRegular = getJSArray(regularPlates.values());

	for (Iterator iter = rest.getPlates().iterator(); iter.hasNext();) {
		Plate p = (Plate) iter.next();
		if (p.getStatus().equals(PlateStatus.AVAILABLE)) {

			if (p.isExtension()) {
				List<Plate> options = group.get(p.getExtendsPlate());
				if (options == null) {
					options = new ArrayList<Plate>();
				}
				options.add(p);
				group.put(p.getExtendsPlate(), options);

			} else {
				FoodCategory cat = fman.get(p.getFoodCategory());
				List<Plate> ll = plateMap.get(cat.getName());
				if (ll == null) {
					ll = new ArrayList<Plate>();
				}
				ll.add(p);
				plateMap.put(cat.getName(), ll);
			}
		}
	}

	request.setAttribute("plateMap", plateMap);
	request.setAttribute("plates", rest.getPlates());
%>
<html>
<head>
<link href="/styles/labstyle.css" rel="stylesheet" type="text/css" />
<link
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
	<%@include file="/static/commonScript.html" %>
<script>

var restaurant = {
		"name":"<%=rest.getName()%>",
		"fractionType":"<%=rest.getFractionPriceType().name()%>",
		"currentDelay":"<%=rest.getCurrentDelay()%>"
}

var client = {
		"name":"<%=client.getName()%>",		
		"phone":"<%=client.getMainPhone()%>"
}
var deliveryAddress={
		"id":"<%=addr.getIdStr()%>",
		"street":"<%=addr.getStreet()%>",
		"number":"<%=addr.getNumber()%>",
		"phone":"<%=addr.getPhone()%>",
		"fmtString":"<%=addr.getFormattedString()%>"
}

var deliveryInfo={
		"id":"${param.deliveryRangeId}",
		"cost":${param.deliveryRangeCostInCents},
		"minumum":0
}

	var smallPlates = <%=sbSmall.toString()%>;
	var mediumPlates = <%=sbMedium.toString()%>;
	var regularPlates = <%=sbRegular.toString()%>;

	dojo.require("dijit.form.CurrencyTextBox");
	dojo.require("dijit.form.ValidationTextBox");
	dojo.require("com.copacabana.util");
	var order = {
		plateList : []
	}

	var mostraDialogPratoEspecial = function() {
		$("#customPlate").dialog("open");
	}

	$(document).ready(function() {
		$("#accordion").accordion({
			autoHeight : false,
			navigation : true,
			collapsible : true,
			active : -1
		});

		
		$("#customPlate").dialog({
			autoOpen : false
		});
		$("#halfSize").change(updateHalfPlates);
		

		$("#criaPrato").click(mostraDialogPratoEspecial);
		$("#createCustomButton").click(criarPratoEspecial);
		$("#halfOrder").button();
		$("#halfOrder").click(startHalfOrder);
		
		$("#createHalfPizza").button();
		$("#createHalfPizza").click(createHalfPizza);
		$("button").button();
		$(".addCartButton").click(function() {
			var newPlate;
			if (order.plateList[$(this).attr("plateId")] != null) {
				newPlate = order.plateList[$(this).attr("plateId")];
				newPlate.qty++;
			} else {
				newPlate = {
					id : $(this).attr("plateId"),
					name : $(this).attr("plateName"),
					priceInCents : parseInt($(this).attr("platePrice")),
					qty : 1,
					fraction : false,
					fractionId : -1,
					custom : false
				}
			}
			order.plateList[$(this).attr("plateId")] = newPlate;
			updatePlateList();

		}

		);
		
		
		$("#clientName").html(client.name);
		$("#addressPlace").html(deliveryAddress.fmtString);
		$("#addressPlace").append("<input type='hidden' name='addressId' value='"+deliveryAddress.id+"'>");
		$("#delayForecast").attr("value",restaurant.currentDelay);
		$("#editDeliveryTimeLink").click(toggleForeCast);
		$("#delCostSection").html(com.copacabana.util.moneyFormatter(deliveryInfo.cost/100.0));
		
		$("#delCostSection").append("<input type='hidden' name='deliveryRangeId' value='"+deliveryInfo.id+"'>");
		$("#delCostSection").append("<input type='hidden' name='deliveryRangeCostInCents' value='"+deliveryInfo.cost+"'>");
		
		updatePlateList();
		updateHalfPlates();
		
		
	});
	var editingForecast=false;
	var toggleForeCast = function(){
		
		if(editingForecast==false){
			editingForecast=true;
			$("#delayForecast").css("backgroundColor","white");
			$("#delayForecast").focus();
			$("#editDeliveryTimeLink").html("Ok");
		}else{
			editingForecast=false;
			$("#delayForecast").css("backgroundColor","F7F7F7");			
			$("#editDeliveryTimeLink").html("Editar");
		}
	}
	var addPlate=function(plate){
		var html = '<ul><li class="itemprice"><div class="totalItemPrice">';
		html+=com.copacabana.util.moneyFormatter((plate.priceInCents/100.0)*plate.qty);
		
		html+='<a href="javascript:removePlate(\''+plate.id+'\')" title="Apagar item" class="deleteLink"></a></div></li>';
		html+='<li>'+plate.qty+' '+plate.name+'</li></ul>';
		
		html+="<input name='plateQty' type='hidden' value='"+plate.qty + "'><input name='plateId' type='hidden' value='"+plate.id + "'><input name='plateName' type='hidden' value='"
		+plate.name + "'><input name='platePrice' type='hidden' value='"
		+plate.priceInCents + "'><input name='plateCustom' type='hidden' value='"
		+plate.custom + "'><input name='plateFraction' type='hidden' value='"
		+plate.fraction + "'><input name='plateFractionId' type='hidden' value='"
		+plate.fractionId + "'>";
		
		
		$("#OrderDetails").append(html);	
		
	}
	
	var setNoEntries=function(plate){
		var html = '<ul><li class="itemprice"><div class="totalItemPrice">';		
		html+='</div></li>';
		html+='<li>Nenhum item adicionado...</li></ul>';
		
		$("#OrderDetails").append(html);	
		
	}
	
	var updatePlateList = function() {
		$("#OrderDetails").empty();
		
		$("#plates").empty();
		var total = 0;
		var counter=0;
		for ( var id in order.plateList) {
			counter++;
			var plate = order.plateList[id];
			addPlate(plate);
			total += plate.priceInCents*plate.qty;
			/*$("#plates")
					.append(
							"<div><input name='plateQty' type='hidden' value='"
							+plate.qty + "'><input name='plateId' type='hidden' value='"
							+plate.id + "'><input name='plateName' type='hidden' value='"
							+plate.name + "'><input name='platePrice' type='hidden' value='"
							+plate.priceInCents + "'><input name='plateCustom' type='hidden' value='"
							+plate.custom + "'><input name='plateFraction' type='hidden' value='"
							+plate.fraction + "'><input name='plateFractionId' type='hidden' value='"
							+plate.fractionId + "'>"
									+ plate.qty
									+ "x "
									+ plate.name
									+ "<div style='float:right;color:red;cursor:pointer;' title='Remover prato' onclick='removePlate(\""
									+ plate.id + "\")'>x</div>" + "</div>");*/

		}
		if(counter==0){
			setNoEntries();
		}
		$("#subTotalSection").empty();
		$("#platesTotal").empty();
		var subTotal = (total / 100);
		var totalWithDelivery = subTotal+(deliveryInfo.cost/100.0);
		$("#subTotalSection").append(com.copacabana.util.moneyFormatter(totalWithDelivery));
		$("#platesTotal").append(com.copacabana.util.moneyFormatter(subTotal));
		//$("#totais").empty();
		//$("#totais").append("<div>Total R$ " + (total / 100));
	}
	var removePlate = function(pid) {		
		for ( var id in order.plateList) {
			var plate = order.plateList[id];
			if (plate.id == pid) {
				if (plate.qty > 1) {
					plate.qty--;
				} else {
					delete order.plateList[id];
				}
				break;
			}
		}
		updatePlateList();
	}
	var currEspPlatIndex = -1;
	var criarPratoEspecial = function() {
		if (dijit.byId("custom.name").attr("value").length == 0) {
			dijit.byId('custom.name').displayMessage(
					dijit.byId('custom.name').invalidMessage);
			return;
		}
		if (dijit.byId("custom.price").length == 0
				|| dijit.byId("custom.price").validate() == false) {
			dijit.byId('custom.price').displayMessage(
					dijit.byId('custom.price').invalidMessage);
			return;
		}
		var newPlate = {
			id : currEspPlatIndex,
			name : dijit.byId("custom.name").attr('value'),
			priceInCents : parseInt(dijit.byId('custom.price').attr("value") * 100),
			qty : 1,
			fraction : false,
			fractionId : -1,
			custom : true
		}
		order.plateList[currEspPlatIndex--] = newPlate;
		updatePlateList();
		$("#customPlate").dialog("close");
		dijit.byId("custom.name").attr("value", "");
		dijit.byId("custom.price").attr("value","0,00");
		
	}
	var localPlates =[];
	var updateHalfPlates=function(arg){
		var plates=[];
		switch($("#halfSize").attr("value")){
		case "SMALL":
			plates=smallPlates;
			break;
		case "MEDIUM":
			plates=mediumPlates;
			break;
		default:	
			plates=regularPlates;			
		}
	
		halfPlates = {
				plate1:null,
				plate2:null
		}
		$("#halfOne").empty();$("#halfTwo").empty();
		$("#halfOne").append("<option value='-1'>Selecione uma opção</option>");
		$("#halfTwo").append("<option value='-1'>Selecione uma opção</option>");
		for ( var id in plates) {
			var plate = plates[id];
			localPlates[plate.id]=plate;
			
			var pname=plate.title;
			if(plate.extendsTitle){
				pname=plate.extendsTitle+" "+plate.title;
			}
			localPlates[plate.id].fullName=	pname;
			$("#halfOne").append("<option value='"+plate.id+"'>"+pname+"</option>");
			$("#halfTwo").append("<option value='"+plate.id+"'>"+pname+"</option>");
		}	
		$("#halfOne").change(setHalfOne);
		$("#halfTwo").change(setHalfTwo);
	}
	var halfPlates = {
			plate1:null,
			plate2:null
	}
	function setHalfOne(){
		var value = $("#halfOne").attr('value');
		if(value!="-1"){
			$("#priceHalfOne").html(com.copacabana.util.moneyFormatter(localPlates[value].priceInCents/100.0));
			halfPlates.plate1=localPlates[value];
		}
		updateTotalHalfs();
	}
	function setHalfTwo(){
		var value = $("#halfTwo").attr('value');
		if(value!="-1"){
			$("#priceHalfTwo").html(com.copacabana.util.moneyFormatter(localPlates[value].priceInCents/100.0));
			halfPlates.plate2=localPlates[value];
		}
		updateTotalHalfs();
	}
	function updateTotalHalfs(){
		if(halfPlates.plate1!=null && halfPlates.plate2!=null){
			var price = parseInt(halfPlates.plate1.priceInCents);
			if(restaurant.fractionType!='MOREEXPENSIVEWINS'){
				price=(parseInt(halfPlates.plate1.priceInCents)+parseInt(halfPlates.plate2.priceInCents))/2;
			}
			if(parseInt(halfPlates.plate1.priceInCents)<parseInt(halfPlates.plate2.priceInCents)){
				price = parseInt(halfPlates.plate2.priceInCents);
			}
			halfPlates.price=price;
			$("#totalHalf").html(com.copacabana.util.moneyFormatter(price/100.0));
		}
	}
	
	var createHalfPizza=function (){
		
		var cost = halfPlates.price;
		var newPlate = {
				id : halfPlates.plate1.id,
				name : "1/2 "+halfPlates.plate1.fullName+" 1/2 "+halfPlates.plate2.fullName,
				priceInCents : cost,
				qty : 1,
				fraction : true,
				fractionId : halfPlates.plate2.id,
				custom : false
			};
			order.plateList[currEspPlatIndex--] = newPlate;
			updatePlateList();
			$("#halfOrderDialog").dialog("close");
				
	}
	function startHalfOrder(){
		$("#halfOrderDialog").dialog({
			autoOpen : false,
			width:540
		});
		$("#halfOrderDialog").dialog("open");
	}
	
	function validate(){
		var counter = 0;
		for ( var id in order.plateList) {
			counter++;
			break;
		}
		if(counter==0){
			alert("Por favor selecione ao menos 1 item para o pedido");
			return false;
		}
		return true;
	}
</script>
<link href="/styles/discPlateSelection.css" rel="stylesheet" type="text/css" />
</head>
<body>
<jsp:include page="labheader.jsp"><jsp:param
		value="menuSelection" name="step" />
</jsp:include>
<div id="container">
<div class="fourcol">
<div id="header">Fazer pedido</div>
<a href="#" id="criaPrato">Cria prato especial</a>


<div id="accordion">
<%
	for (Iterator iter = plateMap.keySet().iterator(); iter.hasNext();) {
		String catName = (String) iter.next();
		List<Plate> ps = plateMap.get(catName);
		request.setAttribute("plates1", ps);
%>
<h3><a href="#section"><%=catName%></a></h3>
<div>
<%
	if (catName.toLowerCase().startsWith("pizza")) {
%><div id="halfOrder">Criar pizza meio a meio</div>
<%
	}
%>
<table>
	<thead>
		<tr>
			<th>Nome</th>
			<th>Preço</th>
			<Th></Th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="plate" items="${plates1}" varStatus="status">		
			<tr>
				<td>${plate.title}</td>
				<td><fmt:formatNumber pattern="##" minFractionDigits="2"
					minIntegerDigits="1" value="${plate.priceInCents/100.0}"></fmt:formatNumber></td>
				<td>
				<button class="addCartButton"   plateId="${plate.idStr}" plateName="${plate.title}"
					platePrice="${plate.priceInCents}">Pedir</button>
				</td>
			</tr>
			<%
				Plate p = (Plate) pageContext.getAttribute("plate");
						if (group.get(p.getId()) != null && !group.get(p.getId()).isEmpty()) {
							for (Iterator<Plate> iterOptions = group.get(p.getId()).iterator(); iterOptions.hasNext();) {
								request.setAttribute("plateOption", iterOptions.next());
			%><tr>
				<td>${plate.title} - <i>${plateOption.title}</i></td>
				<td><fmt:formatNumber pattern="##" minFractionDigits="2"
					minIntegerDigits="1" value="${plateOption.priceInCents/100.0}"></fmt:formatNumber></td>
				<td>
				<button class="addCartButton" plateId="${plateOption.idStr}" plateName="${plate.title} - ${plateOption.title}"
					platePrice="${plateOption.priceInCents}">Pedir</button>
				</td>
			</tr>
			<%
				}
			}
			%>
		</c:forEach>
	</tbody>
</table>
</div>
<%
	}
%>
</div>

</div>
<div id="sidebar" class="twocol">
<div id="Orderinfobox" class="boxed">
<div class="orderInfo"></div>
<h5 class="order">Pedido</h5>
<form action="completeOrder.jsp" method="POST" onsubmit="return validate();">
<table cellspacing="0" cellpadding="0" border="0">

<colgroup>
    <col class="maincol">
    <col class="sidecol">
</colgroup>

<tbody>
    <tr id="clientDisplay">
	    <td class="main">Cliente<br>
	    <strong id="clientName"></strong></td>	        
		<td><a id="clientEditLink" href="searchUserByPhone.jsp" class="discreteAnchor">Editar</a></td>	    
	</tr> 
	<tr id="addressDisplay">
	    <td class="main">Endereço<br>
	    <strong id="addressPlace"></strong></td>	        
		<td><a id="addressEditLink" href="selectDeliveryAddress.jsp?client=${param.client}" class="discreteAnchor">Editar</a></td>	    
	</tr>    
    <tr style="display:none;" id="addressSelect">						
	<td>&nbsp;</td>
	 </tr>
       <tr style="" id="deliveryTimeDisplay">
	<td class="main">Prazo de entrega<br><input type="text" name="delayForecast" id="delayForecast" class="inputView" value="30 minutos"/></td>
	<td><a id="editDeliveryTimeLink" style="cursor: pointer;">Editar</a></td>
    </tr>						
</tbody>
</table>

<table cellspacing="0" cellpadding="0" border="0" class="DataTable">
	<colgroup>
	    <col class="maincol">
	    <col class="sidecol">
	</colgroup>
	<tbody>
	    <tr>
		<td class="main">
		    Total pratos:
		</td>
		<td id="platesTotal">
		    $ 0.00
		</td>
	    </tr>
	    
	    <tr class="noline">
		<td class="main">
		    Taxa entrega:
		</td>
		<td id="delCostSection">
		    $ 0.00
		</td>
	    </tr>
	    <tr class="subtotal">
		<td class="main">	    
			Subtotal:		    
		</td>
		<td id="subTotalSection">
		    $ 0.00
		</td>
	    </tr>
	</tbody>
    </table>
    <div style="width: 100%;text-align: center;">
    <button>Finalizar pedido</button>
    </div>

<div id="OrderDetailTable">
    <h5>Produtos</h5>
    
    <input type="hidden" name="client" value="${param.client}"> 
    <div id="OrderDetails">
	    
	
    </div>
    
    
</div></form>
</div>

</div>
</div>
<div class="body">

</div>
</body>
<div title="Pizza meio a meio" id="halfOrderDialog"
	style="display: none; padding: 20px; font-size: medium;">

Tamanho:<select id="halfSize" >
    <option value="NONE" selected>
        Grande
    </option>
    <option value="MEDIUM" >
        Média
    </option>
    <option value="SMALL">
        Pequena
    </option></select><br>
<table><tr><td>
Metade 1
</td><td>Metade 2</td></tr>
<tr><td><select id="halfOne" ></select></td><td><select id="halfTwo" ></select></td></tr>
<tr><td><span id="priceHalfOne" ></span></td><td><span id="priceHalfTwo" ></span></td></tr>
<tr><td></td><td>Total: <span id="totalHalf" ></span></td></tr>
</table>

<input
	type="button" id="createHalfPizza" value="Criar pizza">
</div>
<div title="Prato especial" id="customPlate"
	style="display: none; padding: 20px; font-size: medium;">
descrição<br>
<input type="text" name="name" id="custom.name"
	invalidMessage="Descrição é obrigatória"
	dojoType="dijit.form.ValidationTextBox" regExp=".+"><br>
preço<br>
<input class="mandatory" required="true" id="custom.price"
	dojoType="dijit.form.CurrencyTextBox" lang="pt-BR" value="0,00"
	fractional="true" required="true" selectOnClick="true" currency=""
	invalidMessage="Digite o valor com centavos, por exemplo 10,90." /> <input
	type="button" id="createCustomButton" value="Inserir prato especial">
</div>

</html>