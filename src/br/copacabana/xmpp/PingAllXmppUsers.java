package br.copacabana.xmpp;

import java.io.IOException;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.XMPPUser;
import br.copacabana.EntityManagerBean;

import com.google.gson.JsonObject;

public class PingAllXmppUsers extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.XMPP");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());

		EntityManagerBean em = (EntityManagerBean) wac.getBean("entityManager");
		Query q = em.getEntityManager().createNamedQuery("getXmppUserSinceLastUse");
		Calendar yesterday = Calendar.getInstance();
		yesterday.add(Calendar.DAY_OF_YEAR, -1);
		q.setParameter("date", yesterday.getTime());
		List<XMPPUser> list = q.getResultList();
		if (list.size() == 0) {
			log.log(Level.INFO, "No xmpp user found to be pingged");
			resp.getWriter().print("No xmpp user found to be pingged");
		} else {
			for (Iterator iterator = list.iterator(); iterator.hasNext();) {
				XMPPUser xmppUser = (XMPPUser) iterator.next();
				JsonObject msg = XmppController.getPingMsg();
				try {
					log.log(Level.INFO, "Pinging {0} lastUse {1}", new Object[] { xmppUser.getUserId(), xmppUser.getLastUse().toGMTString() });
				} catch (Exception e) {
					// TODO: handle exception
				}
				XmppController.sendMessage(xmppUser.getUserId(), msg.toString());
			}
			resp.getWriter().print("Ping sent to "+list.size()+" clients");
		}
		

	}
}
