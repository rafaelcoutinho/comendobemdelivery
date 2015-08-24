package br.copacabana.usecase.discount;

import java.io.IOException;

import javax.persistence.NoResultException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.DiscountCoupom;
import br.com.copacabana.cb.entities.mgr.DiscountManager;
import br.copacabana.Authentication;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class DiscountChecker extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String code = req.getParameter("code");
		String restId = req.getParameter("restId");
		JsonObject json = new JsonObject();
		try {
			DiscountManager dm = new DiscountManager();
			DiscountCoupom disc = dm.get(code);

			if (disc != null) {
				if (disc.getAssocitedUser() != null && disc.getAssocitedUser().equals(Authentication.getLoggedUser(req.getSession()))) {
					json.add("valid", new JsonPrimitive(false));
					json.add("cause", new JsonPrimitive("not_valid_user"));
				} else {
					if(disc.getValidRestaurants()!=null && disc.getValidRestaurants().size()>0 && !disc.getValidRestaurants().contains(KeyFactory.stringToKey(restId))){
						json.add("valid", new JsonPrimitive(false));
						json.add("cause", new JsonPrimitive("not_valid_restaurant"));
					}else if (dm.isValid(disc)) {						
						json.add("value", new JsonPrimitive(disc.getValue()));
						json.add("type", new JsonPrimitive(disc.getType().name()));
						json.add("valid", new JsonPrimitive(true));
					} else {
						json.add("valid", new JsonPrimitive(false));
						json.add("cause", new JsonPrimitive("already_used_or_expired"));
					}

				}

			} else {
				json.add("valid", new JsonPrimitive(false));
				json.add("cause", new JsonPrimitive("not_valid_code"));
			}
		}catch (NoResultException e) {
			json.add("valid", new JsonPrimitive(false));
			json.add("cause", new JsonPrimitive("not_found"));
		} 
		catch (Exception e) {
			json.add("valid", new JsonPrimitive(false));
			json.add("error", new JsonPrimitive(e.getMessage()));
		}
		resp.getWriter().print(json.toString());
	}
}
