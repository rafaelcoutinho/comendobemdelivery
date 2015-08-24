<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><html>
<head>
<link href="/styles/user/general.css" type="text/css" rel="stylesheet" />

<link href="/styles/user/manageOrders.css" type="text/css"
	rel="stylesheet" />
	
<%@include file="/static/commonScript.html"%>
<script type="text/javascript" src="/scripts/pages/faturas.js"></script>
</head>
<body>
<table>
	<tr>
		<td width="10"><img alt="logo comendo bem"
			src="/resources/img/logo.png"></td>
		<td style="font-size: xx-large; text-align: left;">
		<%if("closing".equals(request.getParameter("type"))){
		%>Fechamento <br><span style="font-size: medium">Período de <%=request.getParameter("start")%> a <%=request.getParameter("end")%> </span><br/><%=request.getParameter("restName")%> 
		<%}else{ %>
		Fatura
		m&ecirc;s de <%=request.getParameter("monthName")%><br/><%=request.getParameter("restName")%>
		<%} %>
		</td>
	</tr>
	<tr>
		<td colspan="2">
		
		<form action="/monthOrders.do" method="post" id="factureForm"
		style="text-align: center;"><input type="hidden"
		name="restaurant" id="restId"></input> 
	<input id="start" type="hidden" name="start" /> <input id="end"
		type="hidden" name="end" format="hh:mm:ss dd-mm-yyyy" /> <input
		dojoType="dijit.form.TextBox" type="hidden" name="status"
		value="DELIVERED"></input>
	
	</form>
	<div id="facturePlace" style="border-top: 1px solid grey;">
	<table>
		<tbody id="factureTable"></tbody>
	</table>
	<div id="finalSection" style="display: none;">
		
		</td>
	</tr>
</table>
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
</body>

<script type="text/javascript">
<!--
function imprimir(){
	window.print();
}
function loadData(){
	var loggedUser = ${sessionScope.loggedUser};
	var loggedRestaurant = loggedUser.entity;
	var id=loggedRestaurant.id;
	dojo.subscribe('factureLoaded',imprimir);
	<%if("closing".equals(request.getParameter("type"))){
		%>
		loadDataByDateRange('<%=request.getParameter("start")%>','<%=request.getParameter("end")%>',id);
		<%
	}else{%>
		loadFacture(<%=request.getParameter("monthNum")%>,id);
	<%}%>
}
dojo.addOnLoad(loadData);
	

//-->
</script>

</html>