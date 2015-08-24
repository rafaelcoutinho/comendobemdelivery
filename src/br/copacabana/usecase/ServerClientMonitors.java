package br.copacabana.usecase;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.copacabana.Authentication;
import br.copacabana.GsonBuilderFactory;
import br.copacabana.KeyDeSerializer;
import br.copacabana.KeySerializer;
import br.copacabana.OrderDispatcher;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.spring.OrderManager;
import br.copacabana.usecase.beans.GetPendingRestaurantOrders;

import com.google.appengine.api.datastore.Key;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class ServerClientMonitors extends HttpServlet {
	private static final String NEW_REQUESTS = "NewRequests";
	private static final String NO_NEW_REQUESTS = "NoNewRequests";
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private GsonBuilder gsonBuilder;
	protected static final Logger logmonitor = Logger.getLogger("copacabana.Monitors");

	@Override
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		super.init(config);
		updateSeed();
		gsonBuilder = GsonBuilderFactory.getInstance();
		gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
		gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
		gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
		gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {
		String token = request.getParameter("token");
		String username = request.getParameter("u");
		if (request.getParameter("tokenAccess") != null) {
			handleTokenAccess(request, res, username, token);
		} else {
			if (request.getParameter("getSeed") != null) {
				res.getWriter().println(getSeed());
			} else {
				if (request.getParameter("updateSeed") != null) {
					updateSeed();
				}

			}
		}
	}

	private static String seed;

	private static void updateSeed() {

		seed = Calendar.getInstance(TimeZone.getTimeZone("America/Sao_Paulo")).get(Calendar.HOUR_OF_DAY) + "";
		if (logmonitor.isLoggable(Level.FINE)) {
			logmonitor.log(Level.FINE, "Updating seed to {0}", seed);
		}

	}

	public static String getSeed() {
		return seed;
	}

	public void doPost(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {

		String token = request.getParameter("token");
		String username = request.getParameter("u");
		if (request.getParameter("tokenAccess") != null) {
			handleTokenAccess(request, res, username, token);
		} else {
			if (request.getParameter("getSeed") != null) {
				res.getWriter().println(getSeed());
			} else {
				try {
					
					
					OrderManager oman = new OrderManager();

					Authentication auth = new Authentication();
					String md5 = request.getParameter("isMD5");
					Boolean isMD5 = Boolean.FALSE;
					if (md5 != null && md5.equals("true")) {
						isMD5 = Boolean.TRUE;
					}
					if (auth.tokenBaseAuthenticate(username, token, getSeed(), isMD5)) {
						Object obj = auth.getEntity();
						if (obj instanceof Central) {
							CentralManager cm = new CentralManager();
							UserBean userBean = auth.getAuthenticatedUser();
							Central central = (Central) obj;
							String requestStatus = "";
							for (Iterator<Key> iterator = central.getRestaurants().iterator(); iterator.hasNext();) {
								Key restId = (Key) iterator.next();
								requestStatus = hasRestaurantNewOrdersEvenFaster(userBean, restId, oman);
								if (NEW_REQUESTS.equals(requestStatus)) {
									res.getWriter().println("{status:'OK',response:{requestStatus:'" + requestStatus + "'}}");
									return;
								}

							}
							res.getWriter().println("{status:'OK',response:{requestStatus:'" + requestStatus + "'}}");
						} else {
							UserBean userBean = auth.getAuthenticatedUser();
							Restaurant rest = (Restaurant) auth.getEntity();
							String requestStatus = hasRestaurantNewOrdersEvenFaster(userBean, rest.getId(), oman);
							res.getWriter().println("{status:'OK',response:{requestStatus:'" + requestStatus + "'}}");
						}

					} else {
						// System.out.println("authentication failed");
						res.getWriter().println("{status:'Fail',response:{errorType:'AuthenticationFailed'}}");
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					res.getWriter().println("{status:'Fail',response:{errorType:'ServerError'}}");
				}
			}

		}
	}

	private static Map<Key, Long> localCache = new HashMap<Key, Long>();
	private static Map<Key, String> lastStatus = new HashMap<Key, String>();

	private String hasRestaurantNewOrdersEvenFaster(UserBean userBean, Key restId, OrderManager oman) throws Exception {
		OrderDispatcher od = new OrderDispatcher();
		Long l = localCache.get(userBean.getId());
		String requestStatus = NO_NEW_REQUESTS;
		if (l == null || l < od.lastChangeTime()) {
			// Restaurant rest = (Restaurant) auth.getEntity();
			if (od.hasNewOrders(restId)) {
				requestStatus = NEW_REQUESTS;
			}
			localCache.put(userBean.getId(), od.lastChangeTime());
			lastStatus.put(userBean.getId(), requestStatus);
		} else {
			requestStatus = lastStatus.get(userBean.getId());
		}
		return requestStatus;
	}

	private String hasRestaurantNewOrdersFaster(Authentication auth, OrderManager oman) throws Exception {
		Restaurant rest = (Restaurant) auth.getEntity();
		String requestStatus = NO_NEW_REQUESTS;
		if (new OrderDispatcher().hasNewOrders(rest)) {
			requestStatus = NEW_REQUESTS;
		}
		return requestStatus;

	}

	private String hasRestaurantNewOrders(Authentication auth, OrderManager oman) throws Exception {

		Restaurant rest = (Restaurant) auth.getEntity();
		GetPendingRestaurantOrders getPendingCommand = new GetPendingRestaurantOrders();
		getPendingCommand.setKey(rest.getId());
		getPendingCommand.execute(oman);

		// Map<Class, Object> m = ((GsonSerializable)
		// getPendingCommand).getGsonAdapters(oman);
		// for (Iterator iterator = m.keySet().iterator(); iterator.hasNext();)
		// {
		// Class clazz = (Class) iterator.next();
		// Object serializer = (Object) m.get(clazz);
		// gsonBuilder.registerTypeAdapter(clazz, serializer);
		// }

		Gson gson = gsonBuilder.create();
		List list = (List) getPendingCommand.getEntity();
		// String json = gson.toJson(list);
		String requestStatus = NO_NEW_REQUESTS;
		if (!list.isEmpty()) {
			requestStatus = NEW_REQUESTS;
		}
		return requestStatus;

	}

	public static List<MealOrder> loadAllRestNewOrders(Authentication auth, OrderManager oman) throws Exception {
		Object obj = auth.getEntity();
		OrderDispatcher dispatcher = new OrderDispatcher();
		if (obj instanceof Central) {
			Central central = (Central) obj;
			List<MealOrder> list = new ArrayList<MealOrder>();
			for (Iterator<Key> iterator = central.getRestaurants().iterator(); iterator.hasNext();) {
				Key restId = (Key) iterator.next();
				// list.addAll(oman.getNewOrdersForRestaurant(restId));//This
				// was slow and CPU intensive
				if (dispatcher.hasNewOrders(restId)) {
					list.addAll(oman.getNewOrdersForRestaurant(restId));// This
																		// was
																		// slow
																		// and
																		// CPU
																		// intensive
				}
			}
			return list;
		} else {
			Restaurant rest = (Restaurant) auth.getEntity();
			List<MealOrder> list = new ArrayList<MealOrder>();
			if (dispatcher.hasNewOrders(rest)) {
				GetPendingRestaurantOrders getPendingCommand = new GetPendingRestaurantOrders();
				getPendingCommand.setKey(rest.getId());
				getPendingCommand.execute(oman);

				list = (List) getPendingCommand.getEntity();
			}
			return list;
		}

	}

	private void handleTokenAccess(HttpServletRequest request, HttpServletResponse res, String username, String token) throws IOException {
		ServletContext context = getServletContext();
		WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
		OrderManager oman = (OrderManager) applicationContext.getBean("orderManager");
		try {

			Authentication auth = new Authentication();
			String md5 = request.getParameter("isMD5");

			if (auth.tokenBasedAuthentication(username, token, getSeed(), md5, request.getSession())) {
				if ("central".equals(auth.getUserType())) {
					res.sendRedirect("/central/monitorar.do");
				} else {
					res.sendRedirect("/pedidos.do");
				}
			} else {
				res.sendError(res.SC_FORBIDDEN);
			}
		} catch (Exception e) {
			res.sendError(res.SC_FORBIDDEN);
		}
	}

}
