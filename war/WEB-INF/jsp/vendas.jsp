<%@page import="br.com.copacabana.cb.entities.SellStatus"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt' />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
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
.even{
background-color: white
}
.odd{
background-color: #f9f9f9
}
table{
width: 90%;
}
.desc{
font-style: italic;;
font-size: xx-small;
}
tbody td, tbody td input {
    text-align: left;
    }
    th{
font-weight: bold;
}
</Style>
<cb:header />
</head>
<%
OrdinarySellManager osm = new OrdinarySellManager();
if(request.getParameter("p")!=null){
	String pid = request.getParameter("p");
	
	
	OrdinarySell oo = osm.get(Long.parseLong(pid));
	oo.setStatus(SellStatus.valueOf(request.getParameter("s")));
	Datastore.getPersistanceManager().getTransaction().begin();
	osm.persist(oo);
	Datastore.getPersistanceManager().getTransaction().commit();
	response.sendRedirect("/listaNoite.do");
}

List<OrdinarySell> list = osm.list();
request.setAttribute("sells",list);
%>
<script>

function toggle(id){
	console.log(id,dojo.byId(id))
	var display = dojo.style(dojo.byId(id),"display");
	if(display=='block'){
		 dojo.style(dojo.byId(id),"display","none");
	}else{
		 dojo.style(dojo.byId(id),"display","block");
	}
}

</script>
<cb:body closedMenu="true">
<table>
<thead><tr><th>Id</th><th>Data</th><th>Cliente</th><th>Status</th></tr></thead>
<tbody>
<c:forEach items="${sells}" var="sell" varStatus="counter">
<c:if test="${counter.count%2==0 }">
<c:set var="className" value="even"/>
</c:if>
<c:if test="${counter.count%2!=0 }">
<c:set var="className" value="odd"/>
</c:if>
<tr class="${className }"><td>${sell.id }</td><td><fmt:formatDate value="${sell.soldAt }" type="both"
	timeStyle="long" dateStyle="short" pattern="dd MMMM 'às' kk:mm"
	timeZone="America/Sao_Paulo" /></td><td>${sell.client.name}</td><td>${sell.status }</td><td><div style="cursor: pointer;width: 100%;text-align: center;font-size: x-small;" onclick="toggle('sec_${sell.id}')">Ver detalhes</div></td></tr>
<tr ><td colspan="10">
<div id="sec_${sell.id}" style="width: 100%;display: none;border:1px solid orange;">
<span class="desc">Cliente:</span> ${sell.client.name}<br>
<c:if test="${sell.toDelivery eq true}" >
<span class="desc">Endereço de entrega:</span> ${sell.address.street }, ${sell.address.number }, ${sell.address.neighborhood.name }<br>
</c:if>

<c:if test="${sell.toDelivery eq false}" >
<span class="desc">Forma de entrega:</span> Cliente irá buscar no estabelecimento<br>
</c:if>
<c:forEach items="${sell.itemSold}" var="item">
<span class="desc">Total ingressos: </span>${item.qty }<br>
</c:forEach>
<span class="desc">Forma de pagamento: </span><fmt:message
	key='payment.${sell.payment.type}' /><br>


<span class="desc">Melhor dia para entrega: </span> ${sell.prefDays}<br>
<br>
<span class="desc">Alterar status para: </span> <a href="/listaNoite.do?p=${sell.id }&s=SCHEDULED">Agendada entrega</a> - <a href="/listaNoite.do?p=${sell.id }&s=COMPLETE">Entregue</a> - <a href="/listaNoite.do?p=${sell.id }&s=CANCELLED">Cancelado</a>
</div>

</td></tr>

</c:forEach>

</tbody>
</table>
	
</cb:body>
</html>