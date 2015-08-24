package br.copacabana.usecase;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.MealOrder;
import br.copacabana.Authentication;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.OrderManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class PrintOrder extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");
	private static final String DEFAULT_PRINT_JSP = "/WEB-INF/jsp/print/default.jsp";
	private static final String NOTEPAD_PRINT_JSP = "/WEB-INF/jsp/print/notepad.jsp";
	private static final String LARGER_PRINT_JSP = "/WEB-INF/jsp/print/larger.jsp";
	private static final String EXTENDED_NOTEPAD_PRINT_JPS = "/WEB-INF/jsp/print/extendednotepad.jsp";
	private static final String PREFIX = "imprime/pedido_";

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		OrderManager om = new OrderManager();
		String orderIdStr = req.getParameter("orderId");
		String path = req.getRequestURI();
		if (orderIdStr == null || orderIdStr.length() == 0) {
			int pos = path.indexOf(PREFIX);
			String id = path.substring(PREFIX.length() + pos);
			
			id = id.substring(0, id.length() - ".txt".length());			
			if (id.contains(".")) {
				try {
					String[] comps = id.split("\\.");
					Key clientId = KeyFactory.createKey("CLIENT", Long.valueOf(comps[0]));
					Long lid = Long.parseLong(comps[1]);
					Key mealId = KeyFactory.createKey(clientId, "MEALORDER", lid);
					id = KeyFactory.keyToString(mealId);
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}

			orderIdStr = id;
		}
		Key orderId = KeyFactory.stringToKey(orderIdStr);
		MealOrder order = om.get(orderId);
		ConfigurationManager cm = new ConfigurationManager();
		String notepadPrintKeys = cm.getConfigurationExtendedValue("notepadPrintKeys");
		String largerPrintKeys = cm.getConfigurationExtendedValue("largerPrintKeys");
		String extendednotepad = cm.getConfigurationExtendedValue("extendednotepadPrintKeys");
		if ((notepadPrintKeys != null && notepadPrintKeys.length() > 0) || (largerPrintKeys != null && largerPrintKeys.length() > 0)) {
			if (Authentication.isUserLoggedIn(req.getSession())) {
				try {
					Key userKey = Authentication.getLoggedUserKey(req.getSession());
					String userKeyStr = KeyFactory.keyToString(userKey);
					if (notepadPrintKeys.contains(userKeyStr)) {
						//System.out.println(req.getRequestURI());
						//if (req.getRequestURI().endsWith(".txt")) {
							printNotepad(order, req, resp);
//						} else {
//							resp.sendRedirect("printOrderTxt.txt?orderId=" + orderIdStr);
//						}
						return;
					}
					if (largerPrintKeys.contains(userKeyStr)) {
						printLarger(order, req, resp);
						return;
					}
					if (extendednotepad.contains(userKeyStr)) {
						printExtended(order, req, resp);
						return;
					}
					// if("RESTAURANT".equals(userKey.getKind())){
					//
					// }else if("CENTRAL".equals(userKey.getKind())){
					//
					// }

				} catch (JsonException e) {
					e.printStackTrace();
					log.log(Level.SEVERE, "Failed to check logged user when printing", e);
				}
			}
		}
		printDefault(order, req, resp);
	}

	private void printLarger(MealOrder om, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("order", om);
		req.getRequestDispatcher(LARGER_PRINT_JSP).forward(req, resp);
	}
	private void printExtended(MealOrder om, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("order", om);
		req.getRequestDispatcher(EXTENDED_NOTEPAD_PRINT_JPS).forward(req, resp);
	}

	private void printNotepad(MealOrder om, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("order", om);
		req.getRequestDispatcher(NOTEPAD_PRINT_JSP).forward(req, resp);
	}

	private void printDefault(MealOrder om, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("order", om);
		req.getRequestDispatcher(DEFAULT_PRINT_JSP).forward(req, resp);
	}
}
