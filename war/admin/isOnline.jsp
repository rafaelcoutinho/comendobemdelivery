
<%@page import="br.copacabana.usecase.XMPPUserProvider"%>

Online (<%=request.getParameter("user") %>): <%=XMPPUserProvider.isOnline(request.getParameter("user"))%>
