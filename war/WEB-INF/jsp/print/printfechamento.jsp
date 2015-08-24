<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%><%@page import="java.util.Map.Entry"%><%@page import="java.util.ResourceBundle"%><%@page import="br.copacabana.spring.PlateManager"%><%@page import="java.util.Locale"%><%@page import="java.text.NumberFormat"%><%@page import="br.com.copacabana.cb.entities.Address"%><%@page import="br.copacabana.spring.AddressManager"%><%@page import="br.com.copacabana.cb.entities.OrderedPlate"%><%@page import="br.com.copacabana.cb.entities.Plate"%><%@page import="java.util.Iterator"%><%@page import="br.com.copacabana.cb.entities.MealOrder"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/><fmt:setBundle basename='messages'/><%!String[] getFormattedText(String txt,int width,int prev,boolean prefixed){
	List<String> returnTxt= new ArrayList<String>();
	String previous= "";
	for(int i=0;i<prev;i++){
		previous+=" ";
	}
	while(txt.length()>width){
		if(returnTxt.size()==0){
		returnTxt.add(txt.substring(0,width));
		}else{
			returnTxt.add(previous+txt.substring(0,width));
		}		
		txt=txt.substring(width);
	}
	String complete ="";
	if(txt.length()<width){
		for(int i=0;i<width-txt.length();i++){
			complete+=" ";
		}
	}
	if(returnTxt.size()==0){
		previous="";
	}
	if(!prefixed){
		returnTxt.add(previous+txt+complete);
	}else{
		returnTxt.add(previous+complete+txt);
	}
	
	return returnTxt.toArray(new String[returnTxt.size()]);//
}%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@ page language="java"  contentType="application/notepad charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%><%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%><%!
	String convertDoubleToCurrency(Double d){
		NumberFormat nf= NumberFormat.getInstance();
		nf.setMinimumFractionDigits(2);
		nf.setGroupingUsed(false);
		
		return nf.format(d);
	}
	
	%><%
		
	
	response.addHeader("Content-Disposition", "filename=DeliveryComendoBem.txt");	
%>========================================
Periodo 
 de <fmt:formatDate pattern="dd/MM/yyyy" value="${entity.start}" /> 
 a  <fmt:formatDate pattern="dd/MM/yyyy" value="${entity.end}" />
========================================
Pgto        Valor(R$) Pedidos      Media
----------------------------------------
<c:set var="totalPedidos" value="0"></c:set><c:set var="restBillBean" value="${entity}"></c:set><c:forEach items="${restBillBean.byPayment}" var="paymentTypeTotal"><%
String key =( (PaymentType)((Entry)pageContext.getAttribute("paymentTypeTotal")).getKey()).name();
Integer[] values =(Integer[])((Entry)pageContext.getAttribute("paymentTypeTotal")).getValue();

StringBuilder blank1=new StringBuilder();
for(int addBlank=8-values[0].toString().length();addBlank>0;addBlank--){
	blank1.append(" ");
}
StringBuilder blank2=new StringBuilder();
for(int addBlank=7-values[2].toString().length();addBlank>0;addBlank--){
	blank2.append(" ");
}
StringBuilder blank3=new StringBuilder();
for(int addBlank=9-((values[0]/values[2])+"").toString().length();addBlank>0;addBlank--){
	blank3.append(" ");
}

%><fmt:message key='payment.abbrev.${paymentTypeTotal.key}'/> <%=blank1.toString() %><fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${paymentTypeTotal.value[0]/100}" default="0"/></fmt:formatNumber><%=blank2 %> ${paymentTypeTotal.value[2]} <%=blank3 %><fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${paymentTypeTotal.value[0]/(100*paymentTypeTotal.value[2])}" default="0"/></fmt:formatNumber><c:set var="totalPedidos" value="${totalPedidos+ paymentTypeTotal.value[2]}"></c:set>
</c:forEach>----------------------------------------<c:set var="totais" value="${entity.totals}"/><%
StringBuilder blank5=new StringBuilder();
Integer valorTotal = (Integer)pageContext.getAttribute("totais");
for(int addBlank=8-(valorTotal).toString().length();addBlank>0;addBlank--){
	blank5.append(" ");
}
Long totalDePedidos = new Long(1);
try{
	totalDePedidos=((Long)pageContext.getAttribute("totalPedidos"));
}catch(Exception e){
	totalDePedidos = Long.parseLong((String)pageContext.getAttribute("totalPedidos"));	

}
StringBuilder blank4=new StringBuilder();
for(int addBlank=7-totalDePedidos.toString().length();addBlank>0;addBlank--){
	blank4.append(" ");
}
StringBuilder blank6=new StringBuilder();
if(totalDePedidos>0){

for(int addBlank=8-((valorTotal/totalDePedidos)+"").toString().length();addBlank>0;addBlank--){
	blank6.append(" ");
}
}
%><c:if test="${totalPedidos==0}">
Nenhum pedido feito no periodo
</c:if><c:if test="${totalPedidos>0}">
Total:  <%=blank5%> R$ <fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${entity.totals/100.0}" default="0"/></fmt:formatNumber><%=blank4 %> ${totalPedidos} <%=blank6 %> <fmt:formatNumber pattern="##.##" minFractionDigits="2"><c:out value="${(entity.totals/(100.0*totalPedidos))}" default="0"/></fmt:formatNumber>
</c:if>
======== www.ComendoBem.com.br ========= 
<%out.println("\f\r\n");%>