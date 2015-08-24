<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.com.copacabana.cb.entities.mgr.PaymentManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.com.copacabana.cb.app.Configuration"%>
<%
	
	ConfigurationManager cman = new ConfigurationManager();
	br.copacabana.order.paypal.PayPalProperties ppp = new br.copacabana.order.paypal.PayPalProperties(cman);
%>





<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.com.copacabana.cb.entities.Payment"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%><jsp:include page="/admin/adminHeader.jsp"></jsp:include> <form method="post"
	action="<%=ppp.getUrl()%>" target="_blank"><input type=hidden
	name=USER value="<%=ppp.getUser()%>"> <input type=hidden
	name=PWD value="<%=ppp.getPassword()%>"> <input type=hidden
	name=SIGNATURE value="<%=ppp.getSignature()%>"> <input
	type=hidden name=VERSION value="61.0"> Token:<input name=TOKEN
	value="" id="tokenForm"> <input type=submit name=METHOD
	value="GetExpressCheckoutDetails"></form>
<Br />
<ul>
	<%
		PaymentManager jman = new PaymentManager();
		OrderManager moman = new OrderManager();
		Locale brazilLocale = new Locale("pt", "br");
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", brazilLocale);
		List<Payment> l = jman.list("getPayment");
		for (Iterator<Payment> iter = l.iterator(); iter.hasNext();) {
			Payment p = iter.next();
			if (p.getType().equals(Payment.PaymentType.PAYPAL)) {
	%><li>token: '<a href="#"
		onclick="document.getElementById('tokenForm').value='<%=p.getToken()%>';"><%=p.getToken()%></a>'
	<span
		onclick="document.getElementById('p_<%=p.getId().getId()%>').style.display='block'">exibir
	</div>
	<div id="p_<%=p.getId().getId()%>" style="display: none">

	<table>
		<tr>
			<td>Id</td>
			<td><%=p.getId().getId()%></td>
		</tr>
		<tr>
			<td>PayerId:</td>
			<td>'<%=p.getPayerId()%>'</td>
		</tr>
		<tr>
			<td>Amt:</td>
			<td><%=p.getTotalValue()%></td>
		</tr>
		<tr>
			<td>Data</td>
			<td>
			<%
				Map<String, Object> m = new HashMap<String, Object>();
						m.put("payment", p);
						List<MealOrder> lm = moman.list("getMealByPayment", m);
						if (lm.size() > 0) {
							out.print(sdf.format(lm.get(0).getOrderedTime()));
						} else {
							out.print("not found...");

						}
			%>
			</td>
		</tr>
	</table>
	</div>
	</span></li>
	<%
		}
		}
	%>
</ul>


<hr>
</hr>
<form method=post action="<%=ppp.getUrl()%>"><input type=hidden
	name=USER value="<%=ppp.getUser()%>"> <input type=hidden
	name=PWD value="<%=ppp.getPassword()%>"> <input type=hidden
	name=SIGNATURE value="<%=ppp.getSignature()%>"> <input
	type=hidden name=VERSION value="61.0"> <input type=hidden
	name="CURRENCYCODE" value="BRL" /> <input type=hidden
	name="PAYMENTACTION" value="Authorization"> Payer<input
	type=text name=PAYERID value=""> Token<input type=text
	name=TOKEN value=""> Amt:<input type=text name=AMT value="">
<input type="hidden" name="METHOD" value="DoExpressCheckoutPayment"></input>
<input type="submit"></form>
