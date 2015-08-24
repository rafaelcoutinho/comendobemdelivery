<%@page import="com.google.gson.JsonParser"%><%@page import="com.google.gson.JsonElement"%><%@page import="com.google.gson.JsonObject"%><html>
<head>
<title>ComendoBem - <%=request.getParameter("orderIdXlated") %></title>
</head>
<body style="width: 20em;border: solid black 1px;" onload="window.print()">
<div style="font-family: monospace;padding: 5px;">
<div style="font-weight: bold;text-align: center;">Pedido <%=request.getParameter("orderIdXlated") %></div><br/>
Data: <%=request.getParameter("orderedTime") %><br/>
-------------------------------------<br/>
<b>Cliente</b> <br>
 Nome: <%=request.getParameter("clientName") %><br/>
 Telefone: <%=request.getParameter("clientPhone") %><br/>
 <%if(request.getParameter("clientCPF")!=null){ %>
 CPF: <%=request.getParameter("clientCPF") %><br/>
 <%} %>
-------------------------------------<br/>
<b>Itens</b><br/>
<table>
<th>Qtd</th><th>Desc.</th><th>Unit.</th><th>Valor</th>
<%
String[] plates = request.getParameterValues("plate");
if(plates==null){
plates=new String[0];	
}
for(int i = 0;i<plates.length;i++){
String[] p = plates[i].split("\\|");

if(p[1].length()>14){
	//p[1]=p[1].substring(0,14);	
}
%>

<tr style="vertical-align: top;"><td><%=p[0]%></td><td style="width: 100px;"><%= p[1]%></td><td><%= p[2]%></td><td><%= p[3]%></td></tr>
<%} %>
<tr><td>1</td><td>Custo entrega</td><td>-</td><td><%=request.getParameter("deliveryCost")%></td></tr>
<tr><td colspan=5>-------------------------------------</td></tr>
<tr><td colspan="3" style="text-align: right;font-weight: bold;">TOTAL</td><td style="font-weight: bold;"><%=request.getParameter("totalCost")%></td></tr>
<%if(request.getParameter("pType").startsWith("t")){%>
<%if(request.getParameter("pType").startsWith("tINCASH")){ %>
	<tr><td colspan="3" style="text-align: right;">Dinheiro</td><td><%=request.getParameter("moneyAmount")%></td></tr>
	<tr><td colspan="3" style="text-align: right;">Troco</td><td><%=request.getParameter("moneyChange")%></td></tr>
<%}else{ %>
<tr><td colspan="5"><%=request.getParameter("pTypeName")%></td></tr>
<%} %>
<%}else{ %>

<tr><td colspan="5">Pagamento online *</td></tr>
<%} %>

</table>
-------------------------------------<br/>
<%if("1".equals(request.getParameter("retrieveAtRestaurant"))){ %>
 Pedido a ser retirado no estabelecimento.
<%}else{ %>
End. Entrega:<br/>
<i><%=request.getParameter("address")%><br/>Tel:<%=request.getParameter("addressPhone")%></i>
<%} %> 
<%if(request.getParameter("observation")!=null){ %>
-------------------------------------<br/>
Observa&ccedil;&atilde;o<br/>
<div style="width: 100%;border: 1px solid gray;"><%=request.getParameter("observation") %></div>

<%} %>
-------------------------------------<br/>
ComendoBem.com.br 
- O seu site de delivery online
</div>
 
</body>
</html>