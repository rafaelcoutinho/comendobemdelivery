package br.copacabana.usecase.beans;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.GsonSerializable;
import br.copacabana.ListCommandFilteredBy;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class GetPendingRestaurantOrders extends ListCommandFilteredBy implements SessionCommand, GsonSerializable {

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	@Override
	public void execute(Manager manager) throws JsonException {
		Key userKey = getKey();
		OrderManager om = (OrderManager) manager;

		if (getKey() == null) {
			userKey = Authentication.getLoggedUserKey(session);
		}
		// pending orders
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("restaurant", userKey);

		List a = new ArrayList();
		m.put("status", MealOrderStatus.NEW);
		a.addAll(om.list("getMealOrderByStatusByRestaurant", m));
		m.put("status", MealOrderStatus.VISUALIZEDBYRESTAURANT);
		a.addAll(om.list("getMealOrderByStatusByRestaurant", m));

		this.entity = a;
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		return m;
	}

}
