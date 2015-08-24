package br.copacabana.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class UserMsgWarnerFilter implements Filter {

	@Override
	public void destroy() {

	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain chain) throws IOException, ServletException {

		try {
			HttpServletRequest request = (HttpServletRequest) arg0;
			if (Boolean.TRUE.equals(request.getSession().getAttribute("USER_MUST_VERIFY_EMAIL"))) {
				request.setAttribute("msgForUser", request.getSession().getAttribute("ConfEmailWarnMessage"));
				
			} 
//			else {
//				
//				if (Authentication.isUserLoggedIn(request.getSession())) {
//					JsonObject logged = Authentication.getLoggedUser(request.getSession());
//					String username = logged.get("user").getAsString();
//					UserBeanManager uman = new UserBeanManager();
//					Map<String, Object> m = new HashMap<String, Object>();
//					m.put("login", username);
//					java.util.List<UserBean> l = uman.list(UserBean.Queries.getUserByLogin.name(), m);
//					if (!l.isEmpty()) {
//						UserBean ub = l.get(0);
//						WarnMessageManager wm = new WarnMessageManager();
//						m = new HashMap<String, Object>();
//						m.put("userBean", ub.getId());
//						List<WarnMessage> ll = wm.list("getWarnMessageByUser", m);
//						if (!ll.isEmpty()) {
//							request.setAttribute("msgForUser", ll.get(0));
//						}
//					}
//				}
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		chain.doFilter(arg0, arg1);

	}

	private ServletContext ctx;

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		ctx = arg0.getServletContext();

	}

}
