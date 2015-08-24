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

public class GetRestaurantOrdersByStatusAndMonth extends ListCommandFilteredBy implements SessionCommand, GsonSerializable {

	private HttpSession session;
	private String status;
	private String monthNum;
	private String year;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	@Override
	public void execute(Manager manager) throws JsonException {
		Key userKey = Authentication.getLoggedUserKey(session);
		OrderManager om = (OrderManager) manager;
		//TODO these can be written with an OR query http://gae-java-persistence.blogspot.com/
		if (getKey() == null) {
			// pending orders
			Map<String, Object> m = new HashMap<String, Object>();
			m.put("restaurant", userKey);
			String[] statuses = status.split(",");
			List a = new ArrayList();
			for (int i = 0; i < statuses.length; i++) {
				m.put("status", MealOrderStatus.valueOf(statuses[i]));
				a.addAll(om.list("getMealOrderByStatusByRestaurant", m));
			}

			this.entity = a;
		} else {
			//nothing to do??
		}
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		return m;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
