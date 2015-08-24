<%@page import="br.copacabana.usecase.SessionMonitor"%><%
String json=SessionMonitor.getLoggedUsersJson(request);
%><%=json%>