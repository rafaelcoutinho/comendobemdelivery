<%@page import="br.com.copacabana.cb.entities.Address"%><%@page import="br.copacabana.spring.AddressManager"%><%@page import="br.com.copacabana.cb.entities.OrderedPlate"%><%@page import="br.com.copacabana.cb.entities.Plate"%><%@page import="java.util.Iterator"%><%@page import="br.com.copacabana.cb.entities.MealOrder"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/><fmt:setBundle basename='messages'/><%!String[] getFormattedText(String txt,int width,int prev){
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
	returnTxt.add(previous+txt+complete);
	
	return returnTxt.toArray(new String[returnTxt.size()]);
}%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@ page language="java"  contentType="application/notepad; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%><%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%><%
	MealOrder mo = (MealOrder)request.getAttribute("order");	
	
	response.addHeader("Content-Disposition", "filename=pedido_"+mo.getXlatedId()+".txt");	
%>Pedido ${order.xlatedId}
Data: <fmt:formatDate pattern="kk:mm dd/MM/yyyy" value="${order.orderedTime}" timeZone="America/Sao_Paulo"/>
----------------------------------------
Cliente
 Nome: ${order.clientName}
 Telefone: ${order.clientPhone}
<c:if test="${not empty order.cpf}">
 CPF: ${order.cpf}
</c:if>----------------------------------------
Itens
Qtd Desc.            Unit.     Valor
<%


for(Iterator<OrderedPlate> iter = mo.getPlates().iterator();iter.hasNext();){
	OrderedPlate p = iter.next();
	
	String[] name = getFormattedText(p.getName(),16,4);
	Double priceInCents = p.getPriceInCents()/100.0;
	String qty = getFormattedText(p.getQty()+"",3,0)[0];
	String unit = getFormattedText(priceInCents.toString(),9,0)[0];
	
	
	String preco = getFormattedText(priceInCents.toString(),9,0)[0];
%><%=qty%> <%= name[0]%> <%= unit%> <%= preco%>
<%
for(int j =1;j<name.length;j++){
%><%=name[j] %>
<%} %><%}

%>
1   Custo entrega -           <fmt:formatNumber pattern="##,##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.deliveryCostInCents/100.0}" default="0"/></fmt:formatNumber>
<c:if test="${not empty order.discountInfo and not empty order.discountInfo.value}">
1   Desconto -                <fmt:formatNumber pattern="##,##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.discountInfo.value/100.0}" default="0"/></fmt:formatNumber>
</c:if>----------------------------------------
                        TOTAL <fmt:formatNumber pattern="##,##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.totalAmountInCents/100.0}" default="0"/></fmt:formatNumber>
<c:if test="${order.payment.type eq 'INCASH' }">
   Dinheiro    R$ <fmt:formatNumber pattern="##,##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.payment.amountInCash}" default="0"/></fmt:formatNumber> 
   Troco       R$ <fmt:formatNumber pattern="##,##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.payment.amountInCash-(order.totalAmountInCents/100.0)}" default="0"/></fmt:formatNumber>
</c:if><c:if test="${order.payment.type ne 'INCASH' }"><fmt:message key='payment.${order.payment.type}'/></c:if><c:if test="${order.payment.type eq 'PAYPAL' }">
** NECESSARIO DOCUMENTO DE IDENTIDADE **
**          E ASSINATURA              **</c:if>
----------------------------------------
<c:if test="${order.retrieveAtRestaurant}">
Pedido a ser retirado no estabelecimento
</c:if><c:if test="${not order.retrieveAtRestaurant}">
End. Entrega:
<%
Address add= new AddressManager().get(mo.getAddress());
String address = add.getFormattedString();
String[] end = getFormattedText(address,38,0);
for(int j =0;j<end.length;j++){
	%><%=end[j] %>
<%
}
if(add.getPhone()!=null && add.getPhone().length()>0){
%>Tel: <%=add.getPhone()%>
<%}%></c:if>----------------------------------------<c:if test="${not empty order.observation }">
Observação:
<%String[] obs = getFormattedText(mo.getObservation(),38,0);
for(int j =0;j<obs.length;j++){
	%><%=obs[j] %>
<%
} %>----------------------------------------</c:if>
ComendoBem.com.br 
O delivery mais gostoso da internet
<%out.println("\f\r\n");%>