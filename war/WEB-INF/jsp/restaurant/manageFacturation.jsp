<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Faturas</title>

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

<link href="/styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />
<link
	href="/styles/user/manageOrders.css"
	type="text/css" rel="stylesheet" />
<%@include file="/static/commonScript.html"%>
<script type="text/javascript" src="/scripts/pages/faturas.js"></script>
<script type="text/javascript">
 
	        var currentMonth = 1+<%=Calendar.getInstance(new Locale("pt","BR")).get(Calendar.MONTH)%>;
			dojo.addOnLoad(function() {			
				
				dijit.byId('month').addOption({disabled:false,selected:false,label:'Em aberto: '+monthNames[currentMonth],value:currentMonth})
				var pos = currentMonth-1;
				if(pos<=0){
					pos +=12;
				}
				dijit.byId('month').addOption({disabled:false,selected:true,label:'&#218;ltima: '+monthNames[pos],value:pos})
				dijit.byId('month').addOption({});
				for(var i=2; i<4;i++){
					pos = currentMonth-i;
					if(pos<=0){
						pos +=12;
					}
					dijit.byId('month').addOption({disabled:false,selected:false,label:monthNames[pos],value:pos})
				}

				dijit.byId('month').attr('value',currentMonth-1);
				
				
			});


			function printFacture(){
				window.open('/printFacture.jsp?restName='+loggedRestaurant.name+'&monthNum='+currentFacture.monthNum+'&monthName='+currentFacture.monthName,'Fatura','width=800,height:400,resizable=yes,toolbar=no'); 
			}
			function loadFactureData(){
				loadFacture(dijit.byId('month').attr('value'),loggedRestaurant.id);
			}
			
			
</script>
</head>
<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp"><jsp:param
			name="isFaturas" value="true"></jsp:param></jsp:include>
	<form action="/monthOrders.do" method="post" id="factureForm"
		style="text-align: center;"><input type="hidden"
		name="restaurant" id="restId"></input> Selecione uma fatura:<select
		style="width: 230px;" dojoType="dijit.form.Select" id="month"></select>

	<input id="start" type="hidden" name="start" /> <input id="end"
		type="hidden" name="end" format="hh:mm:ss dd-mm-yyyy" /> <input
		dojoType="dijit.form.TextBox" type="hidden" name="status"
		value="DELIVERED"></input>
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:loadFactureData" onclick="loadFactureData()">Ver
	fatura</button>
	</form>
	<div id="facturePlace" style="border-top: 1px solid grey;">
	<table>
		<tbody id="factureTable"></tbody>
	</table>
	<div id="finalSection" style="display: none;">
	<div style="text-align: right; margin-right: 10px;">
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:printFacture" onclick="printFacture()"><img
		src="/resources/img/printer.png"></img> Imprimir</button>
	</div>
	<div style="margin-left: 10px;" id="legenda">
	<p>Legenda:
	<ol>
		<li>Valor dos pedidos referente ao restaurante.</li>
		<li>Valor dos pedidos pagos pelo site.</li>
		<li>Valor dos pedidos pagos diretamente ao restaurante.</li>
		<li>Valor da comiss&atilde;o j&aacute; retida pelo site.</li>
		<li>Valor da comiss&atilde;o devida ao site.</li>
	</ol>
	</p>
	</div>
	</div>

	</div>


	<br>
	<br />
</cb:body>
</html>