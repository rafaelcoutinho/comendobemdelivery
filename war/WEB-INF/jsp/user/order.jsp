<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%><%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="br.copacabana.CacheController"%>
<%@page import="br.copacabana.order.paypal.PayPalProperties.PayPalConfKeys"%>
<%@page import="br.copacabana.order.paypal.PayPalProperties"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Fazendo Pedido</title>

<cb:header />
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
<link href="/styles/user/order.css" type="text/css"
	rel="stylesheet" />
<%@include file="/static/commonScript.html" %>


<script type="text/javascript">
			<c:set var="newline" value="\n"/>
			dojo.require("dojox.math");
			dojo.require("dojox.math.round");

			
			var onlyForRetrieval=${param.onlyForRetrieval};
			var clientCpf='${param.clientCpf}';
			var restaurantAddressKey='<%=request.getParameter("restaurantAddressKey") %>';
			var restaurantAddress=<%=request.getParameter("restaurantAddress") %>;
			<c:if test="${not empty param.hasSpecificLogic}">
				var specificLogic = ${param.hasSpecificLogic};				
			</c:if>
			
			var order = ${sessionScope.orderData};
			var payPalData={
				level:${param.level},
				pppFixedRate:<%=CacheController.getCache().get(PayPalProperties.PayPalConfKeys.pppFixedRate.name())%>.00,
				pppPercentageValue:<%=CacheController.getCache().get(PayPalProperties.PayPalConfKeys.pppPercentageValue.name())%>,
				calculateConvenience:function(){
					return com.copacabana.util.moneyFormatter(this.pppFixedRate);
				},
				calculateTax:function(itemsValue,deliveryCost,discInfo){
					var totalValue=deliveryCost+itemsValue;
					if(discInfo && discInfo.discValue && this.discount.isValid==true){						
						totalValue-=discInfo.discValue;
					}
					var taxValue = ((totalValue)*this.pppPercentageValue)+(this.pppFixedRate/100);
					//taxValue+=this.pppFixedRate;
					taxValue = dojox.math.round(taxValue, 2)
					var taxStr =com.copacabana.util.moneyFormatter(taxValue);
					return taxStr;
				}
			};
			dojo.addOnLoad(function() {
				fillUserData();
				fillOrderWidget(restaurantAddress,onlyForRetrieval);
			});
			</script>
			<script type="text/javascript" src="/scripts/pages/clientOrder.js"></script>
			<style>
.discBtn {
	text-align: right;
	afont-size: x-small;
	afont-weight: bold;
	cursor: pointer;
	
	
}
.discSection{
font-weight: normal;
text-align: right;
cursor: default;
height: 13px;
}
</style>
</head>
<cb:body closedMenu="true">
	<jsp:include page="clientheader.jsp" ><jsp:param name="isOrderPage" value="true"></jsp:param></jsp:include>
	<c:if test="${not empty param.orderSubmitError}">
	<c:if test="${not empty param.isClientLevel}">
	<b style="color:red">A sua conta no ComendoBem ainda n&atilde;o permite fazer pagamentos online.</b><br>
	<b>${param.orderSubmitError}</b>
	</c:if>
	<c:if test="${empty param.isClientLevel}">
	<b style="color:red">Houve um erro no processamento do seu pedido. Por favor tente novamente ou contate-nos contato@comendobem.com.br</b><br>${param.orderSubmitError}</c:if>
	</c:if>
	<div id="dadosCliente" class="fundoCinza">
	<h2>Dados Pessoais</h2>

	<p id="informacoes">Nome: <span id="nome"></span><br />	
	<span id="deliveryLabel">Endere&ccedil;o de Entrega:</span><span id="deliveryAddress" style="display: inline;"></span> 
	
	</p>
		<div id="mudarEndereco" >
		<c:if test="${param.onlyForRetrieval==true}">
			Este restaurante n&atilde;o faz entregas. <br/> Todos os pedidos devem ser retirados<br/> diretamente no estabelecimento.
		</c:if>
		<c:if test="${param.onlyForRetrieval==false}">
		<c:if test="${param.noTakeAwayOrders==false}">			
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:retrieveInRestaurant" id="retrieveInRestaurant"
		onclick="retrieveInRestaurant()">Buscar no restaurante</button><br/>
		
		<div id="orSection">ou</div>
	</c:if>
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:publishAddressChangeRequest" id="changeaddressbtn" name="changeaddress"	
		onclick="publishAddressChangeRequest()">Entregar em outro endere&ccedil;o</button>
	
	

		</c:if>
		</div>
	</div>
	
	

	<div id="pedidoSection"></div>
	
	<br/><br/>	

</cb:body>
<c:if test="${not empty param.hasSpecificLogicJavascript}">		
		<script type="text/javascript" src="${param.hasSpecificLogicJavascript}"></script>		
</c:if>
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false"></script>	
</html>
