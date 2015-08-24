<%!String[] getFormattedText(String txt,int width,int prev){
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
}%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@ page language="java" contentType="text/plain; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%><%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%>
Pedido <%=request.getParameter("orderIdXlated") %>
Data: <%=request.getParameter("orderedTime") %>
----------------------------------------
Cliente
 Nome: <%=request.getParameter("clientName") %>
 Telefone: <%=request.getParameter("clientPhone") %>
 <%if(request.getParameter("clientCPF")!=null){ %>
 CPF: <%=request.getParameter("clientCPF") %>
 <%} %>
----------------------------------------
Itens
Qtd Desc.            Unit.     Valor
<%
String[] plates = request.getParameterValues("plate");
if(plates==null){
plates=new String[0];	
}
for(int i = 0;i<plates.length;i++){
	String[] p = plates[i].split("\\|");
	String[] name = getFormattedText(p[1],16,4);
	String qty = getFormattedText(p[0],3,0)[0];
	String unit = getFormattedText(p[2],9,0)[0];
	String preco = getFormattedText(p[3],9,0)[0];
%><%=qty%> <%= name[0]%> <%= unit%> <%= preco%>
<%
for(int j =1;j<name.length;j++){
%><%=name[j] %>
<%} %>

<%}

%>1   Custo entrega -            <%=request.getParameter("deliveryCost")%>
----------------------------------------
                        TOTAL <%=request.getParameter("totalCost")%>
<%if(request.getParameter("pType").startsWith("t")){%><%if(request.getParameter("pType").startsWith("tINCASH")){ %>
   Dinheiro    <%=request.getParameter("moneyAmount")%>
   Troco       <%=request.getParameter("moneyChange")%>
<%}else{ %>
<%=request.getParameter("pTypeName")%>
<%} %>
<%}else{ %>
Pagamento online *
<%} %>----------------------------------------
<%if("1".equals(request.getParameter("retrieveAtRestaurant"))){ %>
 Pedido a ser retirado no estabelecimento.
<%}else{ %>
End. Entrega:
<%
String[] end = getFormattedText(request.getParameter("address"),38,0);
for(int j =0;j<end.length;j++){
	%><%=end[j] %>
<%
}
%>Tel:<%=request.getParameter("addressPhone")%><%} %><%if(request.getParameter("observation")!=null){ %>
----------------------------------------
Observação:
<%String[] obs = getFormattedText(request.getParameter("observation"),38,0);
for(int j =0;j<obs.length;j++){
	%><%=obs[j] %>
<%
} %><%} %>----------------------------------------
ComendoBem.com.br 
O delivery mais gostoso da internet
<%out.println("\f\r\n");%>