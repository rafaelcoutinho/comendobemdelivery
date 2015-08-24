<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.FractionPriceType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Pratos meio a meio</title>
<cb:header />
<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dijit/themes/tundra/tundra.css">
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

<link href="/styles/restaurant/areaTaxa.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/areaTaxa_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%
String action = request.getParameter("action");
Key k =  Authentication.getLoggedUserKey(session);

RestaurantManager rman =new RestaurantManager();
Restaurant rest = rman.getRestaurant(k);
if("save".equals(action)){
	String fractionPriceType = request.getParameter("fractionPriceType");	
	if(fractionPriceType!=null){
		rest.setFractionPriceType(FractionPriceType.valueOf(fractionPriceType));
		rman.persist(rest);
	}	
}
String currPriceType=rest.getFractionPriceType().name();
if(currPriceType==null){
	currPriceType=FractionPriceType.HALFHALF.name();
}
request.setAttribute("currPriceType",currPriceType);
%>
<script>
submitForm=function(){
	dojo.byId('submitForm').submit();
}
</script>
<%@include file="/static/commonScript.html"%>

<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp"><jsp:param
			name="isFunctions" value="true"></jsp:param></jsp:include>

	<div id="dadosFuncionalidades">
	<div id="funcionalidade">
	<table>
		<tr>
			<td><h2>Pre&ccedil;os de pratos meio a meio</h2>
			Configurar pol&iacute;tica para o c&aacute;lculo de pre&ccedil;os de pratos meio a meio.<br /><br />
			<form id="submitForm" action="fractionPlate.do" method="post" dojoType="dijit.form.Form">
			<input type="hidden" name="action" value="save">
			<select name="fractionPriceType" >
			
				<option value="HALFHALF" <c:if test="${currPriceType=='HALFHALF'}">selected="selected"</c:if>>Metade da soma dos pratos</option>
				<option <c:if test="${currPriceType=='MOREEXPENSIVEWINS'}">selected="selected"</c:if> value="MOREEXPENSIVEWINS">Pre&ccedil;o da mais cara</option>
			</select>
								
				</form>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><img
				src="/resources/img/btOk.png" alt="salvar"
				onclick="javascript:submitForm()" /></td>
		</tr>
	</table>


	</div>
	</div>


<jsp:include page="profileSide.jsp" ><jsp:param name="isFractionPlate" value="true"></jsp:param></jsp:include>

</cb:body>
</html>