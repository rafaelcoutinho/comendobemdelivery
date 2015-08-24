<%@page import="br.copacabana.AuthenticationController"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="br.copacabana.exception.DataNotFoundException"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.spring.UserBeanManager"%>
<%
	String userFBId = request.getParameter("fbid");
	UserBeanManager um = new UserBeanManager();
	try {
		UserBean ub = null;
		if (userFBId != null) {
			ub = um.getByFBId(userFBId);
			Authentication auth = new Authentication();
			AuthenticationController.setSessionValues(auth,session);
			response.getWriter().print("{status:'success'}");
		}
	} catch (DataNotFoundException e) {
		//must create new user
		
	}
%>