package br.copacabana.usecase;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import br.com.copacabana.cb.entities.LoginSession;
import br.copacabana.Authentication;
import br.copacabana.DateDeSerializer;
import br.copacabana.DateSerializer;
import br.copacabana.GsonBuilderFactory;
import br.copacabana.KeySerializer;
import br.copacabana.marshllers.DateTimeSerializer;
import br.copacabana.spring.JsonException;

import com.google.appengine.api.datastore.Key;
import com.google.gson.GsonBuilder;

public class SessionMonitor implements HttpSessionListener,HttpSessionBindingListener {

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {

	}

	private static TimeZone defaultTZ = TimeZone.getTimeZone("America/Sao_Paulo");
	private static Locale brazilLocale = new Locale("pt", "br");
	protected static final Logger log = Logger.getLogger("copacabana.SessionMonitor");

	@Override
	public void sessionDestroyed(HttpSessionEvent evt) {
		removeLoggedInInfo(evt.getSession(),evt.getSession().getServletContext());

	}
	
	public static void removeLoggedInInfo(HttpSession session, ServletContext ctx){
		log.info("Session is being destroyed");
		if (Authentication.isUserLoggedIn(session)) {
			log.info("Session had an logged user");
			try {
				Key k = Authentication.getLoggedUserKey(session);
				log.info("Logged user key: " + k.getId() + " kind:" + k.getKind());
				//if (k.getKind().equalsIgnoreCase("Restaurant")) {					
					LoginSession ls =null;
					synchronized (mutex) {
						Map<Key, LoginSession> mls = (Map<Key, LoginSession>) ctx.getAttribute("activeSessions");
						ls = mls.remove(k);
						ctx.setAttribute("activeSessions", mls);
					}
				// Due to Googles 'No API environment is registered for this
				// thread.' we won't persist it.
				// WebApplicationContext wac =
				// WebApplicationContextUtils.getRequiredWebApplicationContext(ctx);
				// EntityManagerBean em = (EntityManagerBean)
				// wac.getBean("entityManager");
				// JPAManager<LoginSession> man = new
				// JPAManager<LoginSession>(em);
				// ls.setLoggedOut(new Date());
				// man.persist(ls);
				// log.info("Session registered.");
				//}
			} catch (JsonException e) {
				e.printStackTrace();
				log.log(Level.SEVERE, e.getErrorMsg(),e.getCause());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				log.log(Level.SEVERE, e.getMessage(),e);
			}
		}
		
	}

	private static String mutex = "";

	public static void addLoggedIn(LoginSession ls, ServletContext servletContext) {
		synchronized (mutex) {
			Map<Key, LoginSession> mls = (Map<Key, LoginSession>) servletContext.getAttribute("activeSessions");
			if (mls == null) {
				mls = new HashMap<Key, LoginSession>();
			}
			mls.put(ls.getLoggedKey(), ls);
			servletContext.setAttribute("activeSessions", mls);
		}
	}

	public static String getLoggedUsersJson(HttpServletRequest request) {
		DateSerializer dateSerializer = new DateSerializer(request);
		DateDeSerializer dateDeSerializer = new DateDeSerializer(request);

		GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();// new
																	// GsonBuilder().setPrettyPrinting().serializeNulls().excludeFieldsWithoutExposeAnnotation();
		gsonBuilder.registerTypeAdapter(Date.class, new DateTimeSerializer());		
		gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
		Map<Key, LoginSession> mls = (Map<Key, LoginSession>) request.getSession().getServletContext().getAttribute("activeSessions");
		if (mls == null) {
			return gsonBuilder.create().toJson(new ArrayList());
		}
		return gsonBuilder.create().toJson(mls.values());
	}

	@Override
	public void valueBound(HttpSessionBindingEvent arg0) {

		
	}

	@Override
	public void valueUnbound(HttpSessionBindingEvent evt) {
		removeLoggedInInfo(evt.getSession(),evt.getSession().getServletContext());
		
	}
}
