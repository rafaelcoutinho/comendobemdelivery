<%@page import="com.google.appengine.api.users.UserService"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%><html>
<head>

</head>
<body>
<h2>Ferramentas administrativas</h2>
<%UserService userService = UserServiceFactory.getUserService(); String thisURL = request.getRequestURI();%>
<%= "<p>Olá, " + request.getUserPrincipal().getName() + "!  <a href=\"" + userService.createLogoutURL(thisURL) + "\">sign out</a>.</p>"%>
<table><tr>
<td>
<a href="/backoffice/monitorar.do">Backoffice</a> |
<a href="pedidosatuais.jsp" >Monitorar</a> |
<a href="criaStateOrCity.jsp" >Cria Cidade ou Estado</a> | 
<a href="criaNeighbor.jsp"  >Cria Bairro</a> | 
<a href="criaRestaurante.jsp"  >Cria Restaurante</a> |
<a href="editRestaurant.jsp"  >Edit Restaurant</a> |
<a href="menuBulkupdate2.jsp"> PlateManager</a> | 
<a href="criaConf.jsp" >Cria configuracoes / Dicas </a> |
<a href="criaFoodCategory.jsp" >Cria cat. comida</a> | 
<a href="CreateHighCats.jsp" >Atualiza cat destaque</a> |
<a href="limpaCache.jsp" >Limpa cache</a> |
<a href="../ImageUploader.jsp" >Enviar Image</a> |
<a href="listUnassignedLocations.jsp" >Locations Report</a> |
<a href="managerPayPal.jsp" >Pay Pal</a> |
<a href="CheckPayPalPayment.jsp" >PaymentControl</a> |
<a href="CreateMsgForUser.jsp" >Warning Message</a> |
<a href="CreateExpiredEmailContents.jsp" >Email management</a> |
<a href="NewsLetterClientsSimple.jsp">Clientes</a> |
<a href="NotRegisteredNewsletterUsers.jsp">NewsLetter</a> |
<a href="SendEmailsByRange.jsp">Users/bairro</a> |
<a href="monitorXMPP.jsp">XMPP</a> |
<a href="whoislogged.jsp" >Logged users</a> |      
<a href="LoginAs.jsp" >Login as</a> |               
<a href="manageCentral.jsp" >Manage Central</a> |
<a href="ManageGambis.jsp" >Gambiarras</a> |
<a href="ListLoyaltyPoints.jsp" >Ranking Fidelidade</a> |
<a href="manageCupom.jsp" >Descontos</a> |
<a href="managePrintTypes.jsp" >Tipos de impressao</a> |
<a href="manageUserLog.jsp" >Registros de ações</a> |
<a href="manageERPRests.jsp" >ERP</a> |
<a href="RestClients.jsp" >Clientes ERP</a> |
<a href="manageDelayNotification.jsp" >Alertas</a> |
<a href="sendSpam1stStep.jsp" >Spammer</a> |
<a href="checkClientMonitorLogs.jsp" >Logs Monitor</a> |
<a href="manageSrcDestination.jsp" >Source traffic</a> |
<a href="mealReport.jsp" >Relatorio Pedidos</a> |
<a href="manageClientLevel.jsp" >Reputação de clientes</a> |
<a href="managePayPalPayerIds.jsp" >Paypal ids suspeitos</a> |


</td></tr>

</table>