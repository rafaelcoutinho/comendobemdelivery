package br.com.copacabana.web;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.WarnMessage;
import br.copacabana.EntityManagerBean;
import br.copacabana.raw.filter.Datastore;

public class MsgRead extends HttpServlet {
	/**
		 * 
		 */
	private static final long serialVersionUID = 1L;
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
			EntityManagerBean em = (EntityManagerBean) wac.getBean("entityManager");

			WarnMessage warn = Datastore.getPersistanceManager().find(WarnMessage.class, Long.parseLong(req.getParameter("id")));
			warn.setRead(true);
			Datastore.getPersistanceManager().persist(warn);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
