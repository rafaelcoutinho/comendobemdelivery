package br.copacabana.usecase.control;

import java.util.Enumeration;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.MealOrder;
import br.copacabana.Authentication;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.usecase.MonitorPendingRequestsCommand;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class UserActionManager {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");

	private static void queueAction(String data, String sessionId, String user, String state, String action) {
		Queue queue = QueueFactory.getQueue("userActions");
		TaskOptions task = TaskOptions.Builder.withUrl("/tasks/registerAction").method(Method.POST);
		task.param("data", data);
		task.param("sessionId", sessionId);
		task.param("state", state);
		task.param("user", user);
		task.param("action", action);

		queue.add(task);
	}

	public static void startOrder(String orderStr, String loggedUser, String sessionId) {
		try {
			queueAction(orderStr, sessionId, loggedUser, "started", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}
	}

	public static void completeWithPayPalOrder(MealOrder mo, String loggedUserId, String sessionId) {
		try {
			queueAction("complted paypal ordering " + mo.getXlatedId(), sessionId, loggedUserId, "completeWithPayPal", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}

	}

	public static void registerPaypalPaymentRefusal(HttpServletRequest req) {
		try {
			Key k = Authentication.getLoggedUserKey(req.getSession());
			queueAction("user refused to pay using paypal ", req.getSession().getId(), KeyFactory.keyToString(k), "refuse paypal", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}
	}

	public static void registerNotInRange(HttpServletRequest req) {
		try {
			Key k = Authentication.getLoggedUserKey(req.getSession());
			String nid = req.getParameter("nid");
			String restId = req.getParameter("restid");
			String bairro = "Não identificado.";
			String rest = "Não identificado.";

			if (restId != null) {
				rest = new RestaurantManager().get(KeyFactory.stringToKey(restId)).getName();
			}
			try {
				if (nid != null) {
					bairro = new NeighborhoodManager().get(KeyFactory.stringToKey(nid)).getName();
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
			queueAction("user not in range do restaurante:'" + rest + "' Bairro:'" + bairro + "'", req.getSession().getId(), KeyFactory.keyToString(k), "not in range", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}
	}

	public static void completeOrder(MealOrder mo, String loggedUser, String sessionId) {
		try {
			queueAction("completed ordering " + mo.getXlatedId(), sessionId, loggedUser, "complete", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}
	}

	public static void startOrderNotLogged(String orderData, String id) {
		try {
			queueAction(orderData, id, "", "startedNotLogged", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}

	}

	public static void startedPayPalPayment(String mealOrderStr, String loggedUser, String sessionId) {
		try {
			queueAction(mealOrderStr, sessionId, loggedUser, "startedPayPalPayment", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}
	}

	public static void cancelledPayPalPayment(String mealOrderStr, String loggedUser, String sessionId) {
		try {
			queueAction(mealOrderStr, sessionId, loggedUser, "cancelledPayPalPayment", "ordering");

		} catch (Exception e) {
			log.severe("failed to queue user action");
		}

	}

	public static void registerMajorError(HttpServletRequest req, Exception exception, String loggedUser, String sessionId, String action) {
		try {
			StringBuilder sb = new StringBuilder();
			sb.append(getRequestData(req));
			sb.append("--------");
			sb.append(getExceptionData(exception));
			sb.append("--------");
			queueAction(sb.toString(), sessionId, loggedUser, "error", action);
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}
	}

	private static String getExceptionData(Exception e) {
		if (e != null) {
			StringBuilder text = new StringBuilder();
			text.append("Exception class ").append(e.getClass().getName()).append("\n");
			for (int i = 0; i < e.getStackTrace().length; i++) {
				StackTraceElement stack = e.getStackTrace()[i];
				text.append("Exception filename ").append(stack.getFileName()).append("\n");
				text.append(stack.getClassName()).append(" ").append(stack.getMethodName()).append(":").append(stack.getLineNumber()).append("\n\n");
			}

			return text.toString();
		}

		return "No exception";
	}

	private static String getRequestData(HttpServletRequest req) {
		Enumeration headerParams = req.getHeaderNames();
		StringBuilder text = new StringBuilder("Request info:\n");
		text.append("Header data\n");
		while (headerParams.hasMoreElements()) {
			String name = (String) headerParams.nextElement();
			text.append(name).append("=").append(req.getHeader(name)).append("\n");
		}
		text.append("RequUI=").append(req.getRequestURI()).append("\n");
		text.append("QueryString=").append(req.getQueryString()).append("\n");

		return text.toString();
	}

	public static void requestingPayPalToken(String mealOrderStr, String loggedUser, String sessionId) {
		try {
			queueAction(mealOrderStr, sessionId, loggedUser, "requestingPayPalToken", "ordering");
		} catch (Exception e) {
			log.severe("failed to queue user action");
		}

	}

	public static void registerMajorError(HttpServletRequest request, Exception e, String string) {
		try {
			if (Authentication.isUserLoggedIn(request.getSession())) {
				Key k = Authentication.getLoggedUserKey(request.getSession());
				registerMajorError(request, e, KeyFactory.keyToString(k), request.getSession().getId(), string);
			} else {
				registerMajorError(request, e, "", request.getSession().getId(), string);
			}
		} catch (Exception ee) {

		}

	}

	public static void cancelledPayPalPayment(String mealOrderStr, HttpServletRequest request) {
		try {
			if (Authentication.isUserLoggedIn(request.getSession())) {
				Key k = Authentication.getLoggedUserKey(request.getSession());
				cancelledPayPalPayment(mealOrderStr, KeyFactory.keyToString(k), request.getSession().getId());
			} else {
				cancelledPayPalPayment(mealOrderStr, "", request.getSession().getId());
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	public static void payPalAutorizedMoreThanOnce(HttpSession session) {
		try {
			if (Authentication.isUserLoggedIn(session)) {
				Key k = Authentication.getLoggedUserKey(session);
				try {

					queueAction("", session.getId(), KeyFactory.keyToString(k), "payPayAuthorizedMoreThanOnce", "ordering");

				} catch (Exception e) {
					log.severe("failed to queue user action");
				}

			}
		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	public static void registerPaypalPaymentFailure(HttpServletRequest request, String token, String payerID, String message) {
		try {
			HttpSession session = request.getSession();
			if (Authentication.isUserLoggedIn(session)) {
				Key k = Authentication.getLoggedUserKey(session);
				try {

					queueAction(message + " payerId:" + payerID + " token:" + token, session.getId(), KeyFactory.keyToString(k), "paypalError", "ordering");

				} catch (Exception e) {
					log.severe("failed to queue user action");
				}

			}
		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	public static void registerPaypalPaymentIOFailure(HttpServletRequest request, String token, String payerID, String message) {
		try {
			HttpSession session = request.getSession();
			if (Authentication.isUserLoggedIn(session)) {
				Key k = Authentication.getLoggedUserKey(session);
				try {

					queueAction(message + " payerId:" + payerID + " token:" + token, session.getId(), KeyFactory.keyToString(k), "paypalIOError", "ordering");

				} catch (Exception e) {
					log.severe("failed to queue user action");
				}

			}
		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	public static void registerFromSource(HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			String userId = "";
			if (Authentication.isUserLoggedIn(session)) {
				userId = KeyFactory.keyToString(Authentication.getLoggedUserKey(session));
			}

			queueAction("user came from source " + request.getParameter("i"), session.getId(), userId, "entered", "fromSource");

		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	public static void blackListUserLoggedIn(Client client, HttpSession session) {
		try {

			try {

				queueAction("Usuario " + client.getName() + " (" + client.getEmail() + ") se logou", session.getId(), client.getIdStr(), "blacklist", "loggedin");
				MonitorPendingRequestsCommand.notifyUs("Black listed se logou", "Usuario " + client.getName() + " (" + client.getEmail() + ") se logou");
			} catch (Exception e) {
				log.severe("failed to queue user action");
			}

		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	public static void registerPaypalBlackList(HttpServletRequest request, String token, String payerID, String message) {
		try {
			HttpSession session = request.getSession();
			if (Authentication.isUserLoggedIn(session)) {
				Key k = Authentication.getLoggedUserKey(session);
				try {

					queueAction(message + " payerId:" + payerID + " token:" + token, session.getId(), KeyFactory.keyToString(k), "paypalBlacklist", "ordering");

				} catch (Exception e) {
					log.severe("failed to queue user action");
				}

			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}

}
