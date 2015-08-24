package br.copacabana;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;

import br.copacabana.usecase.control.UserActionManager;

import com.google.gson.JsonObject;

/**
 * @author Rafael Coutinho
 */
public class ReplaceOrderController extends JsonViewController {
	private String formView;
	private String successView;

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("mode", "view");
		try {
			HttpSession session = request.getSession();
			session.removeAttribute("payPalPayment");
			session.removeAttribute("convenienceTaxes");
			session.removeAttribute("totalAmountInCents");
			session.removeAttribute("deliveryCostInCents");
			model.put("replacing", Boolean.TRUE);
			return new ModelAndView(getSuccessView(), model);
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to replace order.");
			try {
				String orderData = "";
				log.log(Level.SEVERE, "Checking logged user.");
				JsonObject user = Authentication.getLoggedUser(request.getSession());
				if (user == null) {
					log.log(Level.SEVERE, "user is not logged in.");
				}
				String loggedUserId = user.get("entity").getAsJsonObject().get("id").getAsString();
				log.log(Level.SEVERE, "logged user id {0}", loggedUserId);

				if (request.getParameter("orderData") == null) {
					log.log(Level.SEVERE, "Order is not in request, checking session");
					orderData = (String) request.getSession().getAttribute("orderData");
				} else {
					log.log(Level.SEVERE, "Order is in request");
					orderData = request.getParameter("orderData");
				}
				if (orderData == null) {
					log.log(Level.SEVERE, "Order was null!");
				}
				log.log(Level.SEVERE, "Order is order  :" + orderData);
				log.log(Level.SEVERE, "Exception was {0}.", e);
				log.log(Level.SEVERE, "Error was {0}.", e.getMessage());

				UserActionManager.registerMajorError(request, e, loggedUserId, request.getSession().getId(), "replacing order");

			} catch (Exception ex) {
				log.log(Level.SEVERE, "Failed during loggin of error was {0}.", e);
				UserActionManager.registerMajorError(request, e, "replacing order 2");
			}
			throw e;
		}
	}

	public String getFormView() {
		return formView;
	}

	public void setFormView(String formView) {
		this.formView = formView;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}