package br.copacabana.usecase.beans;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.Command;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class RetrieveUserNewsCommand implements SessionCommand, Command, ReturnValueCommand {
	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;
	}

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		JsonObject loggedUser = Authentication.getLoggedUser(session);
		String userType = loggedUser.get("userType").getAsString();
		if (userType.equals("client")) {
			newsHtml = getClientNews(loggedUser);
		} else {
			newsHtml = getRestaurantNews(loggedUser);
		}

	}

	private JsonObject getRestaurantNews(JsonObject loggedUser) {
		JsonObject res = new JsonObject();
		return res;
	}

	private JsonObject getClientNews(JsonObject loggedUser) throws JsonException {

		List<MealOrder> orders = getLatestOrders();
		JsonObject res = new JsonObject();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM kk:mm", new Locale("pt", "br"));
		sdf.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
		JsonArray jarr = new JsonArray();
		for (Iterator iterator = orders.iterator(); iterator.hasNext();) {
			MealOrder mealOrder = (MealOrder) iterator.next();
			JsonObject mo = new JsonObject();
			mo.add("status", new JsonPrimitive(mealOrder.getStatus().name()));
			mo.add("id", new JsonPrimitive(KeyFactory.keyToString(mealOrder.getId())));
			mo.add("orderedTime", new JsonPrimitive(sdf.format(mealOrder.getOrderedTime())));
			jarr.add(mo);
		}
		res.add("latestOrders", jarr);

		return res;
	}

	private List<MealOrder> getLatestOrders() throws JsonException {
		Key userKey = Authentication.getLoggedUserKey(session);
		OrderManager om = new OrderManager();

		// pending orders
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("clientId", userKey);
		return new OrderManager().list("listLatestClientOrders", m);

	}

	private JsonObject newsHtml = new JsonObject();

	@Override
	public Object getEntity() {
		return newsHtml;
	}

}
