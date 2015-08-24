package br.copacabana.usecase.control;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.app.Configuration;
import br.copacabana.spring.ConfigurationManager;

public class FromSource extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");
	public static final String PREFIX_DEST = "fromSourceDestination_";
	public static final String PREFIX_COUNTER = "fromSourceCounter_";

	private synchronized void incCounter(String id) throws Exception {
		ConfigurationManager cm = new ConfigurationManager();
		Configuration cc =  cm.get(PREFIX_COUNTER + id);
		Integer counter = 0;
		if (cc != null) {
			counter = Integer.parseInt(cc.getValue());
		}
		counter++;
		cm.createOrUpdate(PREFIX_COUNTER + id, counter.toString());
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String i = req.getParameter("i");
		String url = "/";
		if (i != null) {
			Configuration urlConf = new ConfigurationManager().get(PREFIX_DEST + i);
			if (urlConf == null) {
				url = "/";
			} else {
				url=urlConf.getValue();
				try {
					incCounter(i);
				} catch (Exception e) {
					log.log(Level.SEVERE, "cannot inc counter", e);
				}
			}
		}
		UserActionManager.registerFromSource(req);
		resp.sendRedirect(url);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
