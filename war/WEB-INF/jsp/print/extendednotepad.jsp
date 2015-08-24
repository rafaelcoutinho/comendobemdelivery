<%@page import="br.copacabana.spring.PlateManager"%><%@page import="java.util.Locale"%><%@page import="java.text.NumberFormat"%><%@page import="br.com.copacabana.cb.entities.Address"%><%@page import="br.copacabana.spring.AddressManager"%><%@page import="br.com.copacabana.cb.entities.OrderedPlate"%><%@page import="br.com.copacabana.cb.entities.Plate"%><%@page import="java.util.Iterator"%><%@page import="br.com.copacabana.cb.entities.MealOrder"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt'/><fmt:setBundle basename='messages'/><%!String[] getFormattedText(String txt,int width,int prev,boolean prefixed){
	List<String> returnTxt= new ArrayList<String>();
	String previous= "";
	for(int i=0;i<prev;i++){
		previous+=" ";
	}
	txt=txt.replace('ç','c').replace('Ç','C').replace('ã','a').replace('Ã','A').replace('õ','o').replace('Õ','O').replace('é','e').replace('É','E').replace('í','i').replace('Í','I');
	txt=txt.replace('ô','o').replace('Ô','O').replace('ú','u').replace('Ú','U').replace('ê','e').replace('Ê','E');
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
	
	return returnTxt.toArray(new String[returnTxt.size()]);
}%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@ page language="java"  contentType="application/notepad; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%><%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%><%!
	String convertDoubleToCurrency(Double d){
		NumberFormat nf= NumberFormat.getInstance();
		nf.setMinimumFractionDigits(2);
		nf.setGroupingUsed(false);
		
		return nf.format(d);
	}
	
	%><%
	MealOrder mo = (MealOrder)request.getAttribute("order");	
	
	response.addHeader("Content-Disposition", "filename=ComendoBem_"+mo.getXlatedId()+".txt");	
%>========================================
Pedido ${order.xlatedId}
Data: <fmt:formatDate pattern="kk:mm dd/MM/yyyy" value="${order.orderedTime}" timeZone="America/Sao_Paulo"/>
========================================
Cliente
 Nome: ${order.clientName}
 Telefone: ${order.clientPhone}<c:if test="${not empty order.cpf}">
 CPF: ${order.cpf}</c:if>
========================================
Qtd Produto             Unit.     Valor
----------------------------------------
<%PlateManager pm = new PlateManager();
for(Iterator<OrderedPlate> iter = mo.getPlates().iterator();iter.hasNext();){
	OrderedPlate p = iter.next();
	String pname=p.getName();	
	String[] name = getFormattedText(pname,19,4,false);
	if(Boolean.TRUE.equals(p.getIsFraction())){
		List<String> l = new ArrayList<String>();
		String[] parts = pname.split("1/2");
		String size = parts[0].trim();
		if(size.length()>0){
			size+=":";
		}
		String p1 = parts[1].trim();
		String p2 = parts[2].trim();
		String[] b = getFormattedText("1/2 "+size+p1,19,4,false);
		for(int i =0;i<b.length;i++){
			l.add(b[i]);
		}		
		b = getFormattedText("1/2 "+size+p2,19,4,false);
		for(int i =0;i<b.length;i++){
			if(i==0){
				l.add("    "+b[i]);
			}else{
				l.add(b[i]);
			}
		}
		
		name=l.toArray(new String[l.size()]);
	}
	
	Double priceInCents = p.getPriceInCents()/100.0;
	String qty = getFormattedText(p.getQty()+"",3,0,false)[0];
	String priceStr = convertDoubleToCurrency(priceInCents);
	String unit = getFormattedText(priceStr,6,0,true)[0];
	priceInCents*=p.getQty();
	String preco = getFormattedText(convertDoubleToCurrency(priceInCents),8,0,true)[0];
%><%=qty%> <%= name[0]%>  <%= unit%> <%= preco%>
<%
for(int j =1;j<name.length;j++){
%><%=name[j] %>
<%} %><%}

%>
1   Custo entrega               <fmt:formatNumber pattern="##" minFractionDigits="2" currencyCode="BRL" minIntegerDigits="1"><c:out value="${order.deliveryCostInCents/100.0}" default="0"/></fmt:formatNumber>
<c:if test="${not empty order.discountInfo and not empty order.discountInfo.value}">
1   Desconto                  <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.discountInfo.value/100.0}" default="0"/></fmt:formatNumber>
</c:if><c:if test="${not empty order.observation }">************* Observação ***************
<%String[] obs = getFormattedText(mo.getObservation(),38,0,false);
for(int j =0;j<obs.length;j++){
	%><%=obs[j] %>
<%
} %></c:if>----------------------------------------
                        TOTAL <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.totalAmountInCents/100.0}" default="0"/></fmt:formatNumber>
<c:if test="${order.payment.type eq 'INCASH' }">
   Dinheiro    R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.payment.amountInCash}" default="0"/></fmt:formatNumber> 
   Troco       R$ <fmt:formatNumber pattern="##" minFractionDigits="2" minIntegerDigits="1"><c:out value="${order.payment.amountInCash-(order.totalAmountInCents/100.0)}" default="0"/></fmt:formatNumber>
</c:if><c:if test="${order.payment.type ne 'INCASH' }"><fmt:message key='payment.${order.payment.type}'/></c:if><c:if test="${order.payment.type eq 'PAYPAL' }">
** NECESSARIO DOCUMENTO DE IDENTIDADE **
**          E ASSINATURA              **</c:if>
========================================
<c:if test="${order.retrieveAtRestaurant}">
Pedido a ser retirado no estabelecimento
</c:if><c:if test="${not order.retrieveAtRestaurant}">End. Entrega:
<%
Address add= new AddressManager().get(mo.getAddress());
String address = add.getFormattedString();
String[] end = getFormattedText(address,38,0,false);
for(int j =0;j<end.length;j++){
	%><%=end[j] %>
<%
}
if(add.getPhone()!=null && add.getPhone().length()>0){
%>Tel: <%=add.getPhone()%>
<%}%></c:if>
======== www.ComendoBem.com.br ========= 






========================================
Pedido ${order.xlatedId}
Data: <fmt:formatDate pattern="kk:mm dd/MM/yyyy" value="${order.orderedTime}" timeZone="America/Sao_Paulo"/>
========================================
Cliente
Nome: ${order.clientName}
Telefone: ${order.clientPhone}<c:if test="${order.retrieveAtRestaurant}">
Pedido a ser retirado no estabelecimento
</c:if><c:if test="${not order.retrieveAtRestaurant}">
Endereço:
<%
Address add= new AddressManager().get(mo.getAddress());
String address = add.getFormattedString();
String[] end = getFormattedText(address,38,0,false);
for(int j =0;j<end.length;j++){
	%><%=end[j] %>
<%
}
if(add.getPhone()!=null && add.getPhone().length()>0){
%>Tel: <%=add.getPhone()%>
<%}%></c:if><c:if test="${not empty order.cpf}">CPF: ${order.cpf}
</c:if>========================================
Qtd Produto             
----------------------------------------
<%
for(Iterator<OrderedPlate> iter = mo.getPlates().iterator();iter.hasNext();){
	OrderedPlate p = iter.next();
	String pname=p.getName();
	String[] name = getFormattedText(pname,36,4,false);
	if(Boolean.TRUE.equals(p.getIsFraction())){
		List<String> l = new ArrayList<String>();
		String[] parts = pname.split("1/2");
		String size = parts[0].trim();
		if(size.length()>0){
			size+=":";
		}
		String p1 = parts[1].trim();
		String p2 = parts[2].trim();
		String[] b = getFormattedText("1/2 "+size+p1,36,4,false);
		for(int i =0;i<b.length;i++){
			l.add(b[i]);
		}		
		b = getFormattedText("1/2 "+size+p2,36,4,false);
		for(int i =0;i<b.length;i++){
			if(i==0){
				l.add("    "+b[i]);
			}else{
				l.add(b[i]);
			}
		}
		
		name=l.toArray(new String[l.size()]);
	}
	//Double priceInCents = p.getPriceInCents()/100.0;
	String qty = getFormattedText(p.getQty()+"",3,0,false)[0];
	//String priceStr = convertDoubleToCurrency(priceInCents);
	//String unit = getFormattedText(priceStr,6,0,true)[0];
	//priceInCents*=p.getQty();
	//String preco = getFormattedText(convertDoubleToCurrency(priceInCents),8,0,true)[0];
%><%=qty%> <%= name[0]%>
<%
for(int j =1;j<name.length;j++){
%><%=name[j] %>
<%} %><%}

%><c:if test="${not empty order.observation }">******** Observação **********
<%String[] obs = getFormattedText(mo.getObservation(),38,0,false);
for(int j =0;j<obs.length;j++){
	%><%=obs[j] %>
<%
} %>----------------------------------------</c:if>
======== www.ComendoBem.com.br =========
<%out.println("\f\r\n");%>