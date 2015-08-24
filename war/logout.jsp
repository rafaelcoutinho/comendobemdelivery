
<%@page import="br.copacabana.usecase.SessionMonitor"%>
<%
	request.getSession().removeAttribute("loggedUser");
	request.getSession().removeAttribute("userType");
	request.getSession().removeAttribute("loggedTime");
	request.getSession().removeAttribute("USER_MUST_VERIFY_EMAIL");
	request.getSession().removeAttribute("ConfEmailWarnMessage");
	request.getSession().removeAttribute("userName");
	
	try {
		SessionMonitor.removeLoggedInInfo(session, session.getServletContext());
	} catch (Exception e) {

	}
	request.getSession().invalidate();
	response.sendRedirect("/");
%>
