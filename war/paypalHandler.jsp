<%@page import="br.copacabana.usecase.control.UserActionManager"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.order.paypal.PayPalProperties"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.sagui.paypal.PayPalUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%
 Logger logger = Logger.getLogger("copacabana.Controllers");
session.removeAttribute("delayedPayment"); 
	ConfigurationManager confm = new ConfigurationManager();
	PayPalProperties ppp = new PayPalProperties(confm);
	PayPalUtils putils = new PayPalUtils(ppp.getUrl());
	String token = (String)session.getAttribute("pptoken");
	try {
		Map<String, String> map = putils.getDetails(token, ppp.getSignature(), ppp.getPassword(), ppp.getUser());
		logger.info("Paypal handler response: "+map.get("CHECKOUTSTATUS"));
		if ("PaymentActionCompleted".equals(map.get("CHECKOUTSTATUS"))) {
			session.setAttribute("delayedPayment", "true");
			response.sendRedirect("/payPalPaymentAuth.do?token=" + token + "&PayerID=" + request.getParameter("PayerID"));
%>
<%
	} else {
		Integer ccc = -1;
		try{
			ccc=Integer.parseInt(request.getParameter("c"));
		}catch(Exception e){
			
		}
		ccc++;
			if ("PaymentActionNotInitiated".equals(map.get("CHECKOUTSTATUS"))||"PaymentActionInProgress".equals(map.get("CHECKOUTSTATUS")) && ccc<3) {
				
%>
		Autorizando pagamento aguarde...<br/>
		<br/>Se em 5 segundos essa p&aacute;na n&aatilde;o atualizar <a href="/paypalHandler.jsp?c=<%=ccc %>&PayerID=<%= request.getParameter("PayerID")%>">clique aqui</a> 
		<script type="text/javascript">
		var delay = function(){
				window.location="/paypalHandler.jsp?c=<%=ccc %>&PayerID=<%= request.getParameter("PayerID")%>";
		}
		setTimeout("delay()",5000);
		
		</script>
<%
	} else {
		
				logger.log(Level.SEVERE,"failed to handle delayed paypal CHECKOUTSTATUS: {0}",map.get("CHECKOUTSTATUS"));
				UserActionManager.registerPaypalPaymentFailure(request,token,request.getParameter("PayerID"),"Checkoutstatus : "+map.get("CHECKOUTSTATUS"));
				response.sendRedirect("/payPalFailure.do");				
			}
		}

	} catch (Exception e) {
		UserActionManager.registerPaypalPaymentFailure(request,token,request.getParameter("PayerID"),e.getMessage());
		logger.log(Level.SEVERE,"failed to handle delayed paypal {0}",e);
		response.sendRedirect("/payPalFailure.do");
	}
%>