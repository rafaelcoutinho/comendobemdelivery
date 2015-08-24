<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="java.util.Collections"%>
<%@page import="br.copacabana.DeliveryRangeData"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="br.com.copacabana.cb.entities.City"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - &Aacute;rea de Entrega</title>
	
	<cb:header />
	<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dijit/themes/tundra/tundra.css">
	<link href="/styles/restaurant/profile.css" type="text/css" rel="stylesheet" />
	
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
		<link href="/styles/restaurant/profile_ie_8.css" type="text/css" rel="stylesheet" />
	</c:if>
	
	<link href="/styles/restaurant/areaTaxa.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/restaurant/areaTaxa_ie_7.css" type="text/css" rel="stylesheet" />
		<link href="/styles/restaurant/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	
<%@include file="/static/commonScript.html" %>
<script type="text/javascript" src="/scripts/pages/areaEntrega.js"></script>	
</head>
<form action="/persistDeliveries.do" style="display: none" id="createDeliveries" name="createDeliveries">
</form>

<%
RestaurantManager restMan = new RestaurantManager();
Restaurant rest = restMan.getRestaurant(Authentication.getLoggedUserKey(session));
NeighborhoodManager nman=new NeighborhoodManager();
CityManager cman = new CityManager();
List l = new ArrayList();
StringBuilder sb = new StringBuilder("");
for (Iterator iterator = rest.getDeliveryRanges().iterator(); iterator.hasNext();) {
	DeliveryRange delivery = (DeliveryRange) iterator.next();

	if (delivery.getNeighborhood() == null) {
		City c = (City) cman.get(delivery.getCity());
		l.add(new DeliveryRangeData(null, delivery, c));
	} else {
		Neighborhood n = (Neighborhood) nman.get(delivery.getNeighborhood());
		l.add(new DeliveryRangeData(n, delivery, n.getCity()));
		sb.append("currentNeighs['").append(KeyFactory.keyToString(n.getId())).append("']=true;\n");
		
	}

}

Collections.sort(l);
request.setAttribute("delRanges",l);				
		
%>
<style>
td{
text-align: center; 
}
</style>
<cb:body closedMenu="true">
	
	<jsp:include page="restheader.jsp" ><jsp:param name="isFunctions" value="true"></jsp:param></jsp:include>
	
	<div id="dadosFuncionalidades">
		<div id="funcionalidade">
			<h2>&Aacute;rea de Entrega</h2>
			<div><input type="checkbox" name="onlyForRetrieval" id="onlyForRetrieval" dojoType="dijit.form.CheckBox"/> <label for="onlyForRetrieval"> Somente pedidos a retirar no restaurante.</label></div>
			<p>
				Cadastre os bairros que o seu restaurante atende:<br />
				
				
				<div><label for="deliverCity">Cidade:</label>
				
				<select dojoType="dijit.form.FilteringSelect" id="citySelection"
		 autoComplete="true"
		invalidMessage="Cidade inválida" width="280"></select></div> 
				<br />
				
				<div><label for="deliverNeighborhood">Bairro:</label>
				
				<select dojoType="dijit.form.FilteringSelect"  id="neighSelection" labelFunc="myLabelFunc"
		name="address.neighborhood" autoComplete="true" selectOnClick="true" queryExpr="*" 
		invalidMessage="Bairro inválido"></select>
		<button baseClass="orangeButton" dojoType="dijit.form.Button" dojoAttachEvent="onclick:onToolButtonClick2" id="addDeliveryBtn" >Adicionar</button></div>
	
			
			<table width="100%">
			
			<tr><th colspan="2"><h2>Regi&atilde;o</h2></th>
			<th colspan="2"><h2>Taxa de Entrega</h2></th>
			</tr>
			<tr>
			<th>Cidade</th>
			<th>Bairro</th>
			<th>Taxa</th>
			<th>Valor M&iacute;nimo</th>
			<th>&nbsp;</th>
			</tr>
			<tbody id="deliveryRangesTable">
			
			
			

			<c:forEach items="${delRanges}" var="delRange" varStatus="status">
			<tr id="tr_${delRange.deliveryRangeId}">
			<td >${delRange.city.name}
			
			<input type="hidden" name="delRangeItem[${status.count-1}].id" value="${delRange.deliveryRangeId}">
			<c:if test="${empty delRange.neighborhood }">
			<input type="hidden" name="delRangeItem[${status.count-1}].city" value="${delRange.cityId}"></td>
			<input type="hidden" name="delRangeItem[${status.count-1}].neighborhood" value=""></td>
			<td >Todos os bairros</td>
			</c:if>
			<c:if test="${not empty delRange.neighborhood }">
				<input type="hidden" name="delRangeItem[${status.count-1}].neighborhood" value="${delRange.neighborhoodId}"></td>
				<td >${delRange.neighborhood.name}</td>
			</c:if>
						
			<td >
			
			
			<input id="delRangeItem[${status.count-1}].cost" type="text" style="width:60px;height:18px;" dojoType="dijit.form.CurrencyTextBox" lang="pt-BR" value="${delRange.deliveryRange.cost }" fractional="true" required="true" selectOnClick="true" currency="" invalidMessage="Digite o valor com centavos, por exemplo 10,90."/>
			
			
			</td>			
			<td >
			
			<input id="delRangeItem[${status.count-1}].minimumOrderValue" type="text" style="width:60px;height:18px;" dojoType="dijit.form.CurrencyTextBox" lang="pt-BR" value="${delRange.deliveryRange.minimumOrderValue}" fractional="true" required="true" selectOnClick="true" currency="" invalidMessage="Digite o valor com centavos, por exemplo 10,90."/>
			</td>
			<td >
			
			<button dojoType="dijit.form.Button" type="button" 	baseClass="orangeButton">Apagar
			<script type="dojo/method" event="onClick" args="evt">removeNeighNewer("${delRange.deliveryRangeId}")</script>
			</button>
			</td></tr>
			
			</c:forEach>
			</tbody>
			
			</table>
			<form action="/persistDeliveries.do" id="createDeliveryNew" method="get" name="createDelivery">
			
			<div id='deliveriesFormSection' style="display: block"></div>
			</form>
			
			
			
			<div id="barraSalvar" class="fundoCinza barraSalvar" >
				
					<img src="/resources/img/btSalvar.png" alt="salvar"  onclick="save()"/>
				
			</div>
		</div>
		
		<jsp:include page="profileSide.jsp" ><jsp:param name="isArea" value="true"></jsp:param></jsp:include>
	</div>
	
</cb:body>
<script>
counter = <%=l.size()%>;
<%=sb.toString()%>
</script>
<form action="/createDelivery.do" style="display: none" id="createDelivery" name="createDelivery">
<input type="text" name="restaurant.id" id="restaurant.id"/>
<input type="text" name="neighborhood.id" id="neighborhood.id"/>
<input type="text" name="cost" id="cost"/>
<input type="text" name="minimumOrderValue" id="deliveryCost.minimumOrderValue"/>
<input type="text" name="id" id="deliveryId"/>
</form>
<form action="/deleteDelivery.do" style="display: none" id="deleteDelivery" name="deleteDelivery">
<input type="text" name="id" id="idToDelete"/>
</form>
</html>