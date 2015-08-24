<%@page import="br.copacabana.spring.DeliveryManager"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="br.com.copacabana.cb.entities.OrderedPlate"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.PlateManager"%>
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
	String[] plateName = request.getParameterValues("plateName");
	String[] plateQty = request.getParameterValues("plateQty");
	String[] platePrice = request.getParameterValues("platePrice");
	String[] plateCustom = request.getParameterValues("plateCustom");
	String[] plateFraction = request.getParameterValues("plateFraction");
	String[] plateId = request.getParameterValues("plateId");
	String[] plateFractionId = request.getParameterValues("plateFractionId");
	session.setAttribute("plateName",plateName);
	session.setAttribute("plateQty",plateQty);
	session.setAttribute("platePrice",platePrice);
	session.setAttribute("plateCustom",plateCustom);
	session.setAttribute("plateFraction",plateFraction);
	session.setAttribute("plateId",plateId);
	session.setAttribute("plateFractionId",plateFractionId);
	PlateManager pm = new PlateManager();
	/*List<OrderedPlate> plateList = new ArrayList<OrderedPlate>();	
	for(int i=0;i<plateName.length;i++){		
		String name = plateName[i];
		Integer qty = Integer.parseInt(plateQty[i]);
		String id = plateId[i];
		Integer price = Integer.parseInt(platePrice[i]);
		boolean fraction = "true".equals(plateFraction[i]);
		boolean custom = "true".equals(plateCustom[i]);
		OrderedPlate op = new OrderedPlate();
		op.setName(name);
		op.setPriceInCents(price);
		op.setIsFraction(fraction);
		op.setQty(qty);
		op.setIsCustom(custom);
		if(fraction){
			Set<Key> ids = new HashSet<Key>();
			ids.add(KeyFactory.stringToKey(id));
			ids.add(KeyFactory.stringToKey(plateFractionId[i]));
			op.setFractionPlates(ids);
		}else{
			if(!custom){
				op.setPlate(KeyFactory.stringToKey(id));
			}
		}
		
	}*/
	RestaurantManager rman = new RestaurantManager();
	Restaurant rest = rman.getRestaurant(Authentication.getLoggedUserKey(session));
	RestaurantClientManager rcman = new RestaurantClientManager();
	Client client = null;
	Key clientKey= KeyFactory.stringToKey(clientId);
	if(clientKey.getKind().equals("CLIENT")){
		client=new ClientManager().get(clientKey);
	}else{
		client=rcman.get(clientKey);
	}
	
	request.setAttribute("plates", rest.getPlates());
	DeliveryRange deliveryRangeData = null;
	if(request.getParameter("deliveryRangeId")!=null && request.getParameter("deliveryRangeId").length()>0){
		String delIdStr = request.getParameter("deliveryRangeId");
		Key delId = KeyFactory.stringToKey(delIdStr);
		deliveryRangeData=new DeliveryManager().get(delId);
		
	}else{
	Key neigh = KeyFactory.stringToKey((String)request.getSession().getAttribute("address.neighborhood"));
	
	for(Iterator<DeliveryRange> iter = rest.getDeliveryRanges().iterator();iter.hasNext();){
		DeliveryRange del = iter.next();
		
		if(del.getNeighborhood().equals(neigh)){
			
			deliveryRangeData=del;
			break;
		}
	}
	}
	
	
	request.setAttribute("deliveryRangeData",deliveryRangeData);
	request.setAttribute("plates",plateName);
	request.setAttribute("client",client);
	
	NeighborhoodManager nman = new NeighborhoodManager();
	List bairros = nman.getOrderedNeighborByCity(new CityManager().getCityByName("Campinas"));
	request.setAttribute("bairros",bairros);
%>
<html>
<head><link href="/styles/labstyle.css" rel="stylesheet" type="text/css" />

<link
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />

<%@include file="/static/commonScript.html" %>
<script>
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("com.copacabana.util");
</script>
</head>
<body>
<jsp:include page="labheader.jsp"><jsp:param value="checkout" name="step"/> </jsp:include>
<div class="body">
<div id="header">Pagamento</div>
<form action="submitOrder.jsp" method="post" onsubmit="return validate();">
<input type="hidden" name="client" value="${param.client }">
<input type="hidden" name="addressId" value="${param.addressId }">
<input type="hidden" name="delayForecast" value="${param.delayForecast }">
<i>Resumo pedido</i><br>
Taxa de entrega: R$ <fmt:formatNumber pattern="##" minFractionDigits="2"
					minIntegerDigits="1" value="${deliveryRangeData.cost}"></fmt:formatNumber><br>
<input type="hidden" name="deliveryRangeId" value="${deliveryRangeData.idStr }">
<c:set var="total" value="${deliveryRangeData.costInCents}" /> 
Items:<br>
<table>
	<thead>
		<tr>
			<th>Nome</th>
			<th>Preço (R$)</th>
			<Th></Th>
		</tr>
	</thead>
	<tbody>
		
		<%for(int i=0;i<plateName.length;i++){
				request.setAttribute("priceInCents",platePrice[i]);
				request.setAttribute("plateQty",plateQty[i]);
			%>
		
			<tr>
				<td><input name='plateQty' type='hidden' value='<%=plateQty[i] %>'>
					<input name='plateId' type='hidden' value='<%=plateId[i] %>'>
					<input name='plateName' type='hidden' value='<%=plateName[i] %>'>
					<input name='platePrice' type='hidden' value='<%=platePrice[i] %>'>
					<input name='plateCustom' type='hidden' value='<%=plateCustom[i] %>'>
					<input name='plateFraction' type='hidden' value='<%=plateFraction[i] %>'>
					<input name='plateFractionId' type='hidden' value='<%=plateFractionId[i] %>'>
				 ${plateQty}<sub>x</sub> <%=plateName[i] %></td>
				<td><fmt:formatNumber pattern="##" minFractionDigits="2"
					minIntegerDigits="1" value="${priceInCents/100.0}"></fmt:formatNumber></td>				
			</tr>
			<c:set var="total" value="${total + (plateQty*priceInCents)}" />
		<%} %>		
		<tr><td style="font-weight: bold;">TOTAL</td><td style="font-style: italic;">R$ <fmt:formatNumber pattern="##" minFractionDigits="2"
					minIntegerDigits="1" value="${total/100.0}"></fmt:formatNumber></td></tr>
	</tbody>
</table>
<hr>
<div>Pagamento:<br/>
<input type="radio"" checked="checked" name="paymentType" value="INCASH"><label for="paymentType">Dinheiro</label> Troco para 
R$ <input id='amountInCash' name="amountInCash" type="text" style="width:100px;height:18px;"  dojoType="dijit.form.CurrencyTextBox" lang="pt-BR" value="0,00" fractional="true" required="true" selectOnClick="true" currency="" invalidMessage="Digite o valor com centavos, por exemplo 10,90."/><br>
<input type="radio" name="paymentType" value="<%= PaymentType.AMEXMACHINE.name() %>"><label for="paymentType">Amex</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.CHEQUE.name() %>"><label for="paymentType">Cheque</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.MASTERDEBITMACHINE.name() %>"><label for="paymentType">Maestro/Redeshop</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.MASTERMACHINE.name() %>"><label for="paymentType">Mastercad Crédito</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.TRMACHINE.name() %>"><label for="paymentType">Ticket Restaurante</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.TRSODEXHO.name() %>"><label for="paymentType">SodexHo</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.TRVOUCHER.name() %>"><label for="paymentType">Tíquete Papel</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.VRSMART.name() %>"><label for="paymentType">VRSmart</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.VISAMACHINE.name() %>"><label for="paymentType">Visa Crédito</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.VISADEBITMACHINE.name() %>"><label for="paymentType">VisaEletron</label><br>
<input type="radio" name="paymentType" value="<%= PaymentType.VISAVOUCHERMACHINE.name() %>"><label for="paymentType">Visa Vale</label><br>
</div>
<div>CPF: <input style="width: 150px;" type="text" name="cpf" validator="test" class="cpf" id="cpf" dojoType="dijit.form.ValidationTextBox" selectOnClick="true"></input><br></div>
<div>Observações: <textarea name="observation"></textarea>
</div>
<input type="submit" value="Enviar pedido">
<Br><hr>

</form>
</div>

</body>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
	<script>
	
	test=function(data){
		
		return com.copacabana.util.isCpfValid(data);
	}
	$(document).ready(			
			function() {
				
	});
	var checkvalue=function(txt){
		/*if(!isNaN(txt)){
		txt=txt+"";
		txt=txt.replace(new RegExp(',', 'g'),'');
		txt=txt.replace(new RegExp('\.', 'g'),'');
		console.log(txt);
		}*/
		return txt;
	}
	var alreadySubmitted=false;
	var validate=function(){
		try{
			var paymentType = $("[name=paymentType]:checked==checked");
			if(paymentType.attr('value')=="INCASH"){
				if(dijit.byId('amountInCash').validate()==false){
					dijit.byId('amountInCash').displayMessage(dijit.byId('amountInCash').invalidMessage);
					return false;
				}
				if(dijit.byId('amountInCash').attr('value')< ${total/100}){
					alert("Valor em dinheiro deve ser maior que valor total do pedido");
					return false;
				}
				
			}
			
			if(dijit.byId('cpf').attr('value').length>0 && dijit.byId('cpf').validate()==false){
				alert("CPF Inválido.");
				return false;
			}
		}catch(e){
			console.error(e);
		}
		if(alreadySubmitted==true){
			return false;
		}
		com.copacabana.util.showLoading("Enviando pedido...");
		alreadySubmitted=true;
		
		return true;
	}
	</script>
</html>