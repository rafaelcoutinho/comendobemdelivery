package br.copacabana.usecase.beans;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.GsonSerializable;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class GetClientOrders extends RetrieveCommand implements SessionCommand, GsonSerializable {

	private HttpSession session;
	private String status;
	private String addLatestOnes;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	@Override
	public void execute(Manager manager) throws JsonException {
		Key userKey = Authentication.getLoggedUserKey(session);
		ClientOrdersResponseBean response = new ClientOrdersResponseBean();
		OrderManager om = new OrderManager();

		// pending orders
		Map<String, Object> m = new HashMap<String, Object>();
		Client c = (Client) new ClientManager().get(userKey);
		m.put("client", c);
		String[] statuses = new String[] { MealOrderStatus.WAITING_CUSTOMER.name(), MealOrderStatus.NEW.name(), MealOrderStatus.VISUALIZEDBYRESTAURANT.name(), MealOrderStatus.PREPARING.name(), MealOrderStatus.INTRANSIT.name() };
		List<MealOrder> l = new ArrayList<MealOrder>();
		if (status != null) {
			statuses = status.split(",");
		}
		for (int i = 0; i < statuses.length; i++) {
			m.put("status", MealOrderStatus.valueOf(statuses[i]));
			l.addAll(om.list("getPendingMealOrderByClientByStatus", m));
		}
		response.setOrders(l);
		response.setOrderStatus(statuses);
		if (this.getAddLatestOnes() != null) {

			List<MealOrder> recent = new ArrayList<MealOrder>();

			MealOrder lastExpiredMealOrder = getRecentOrder(MealOrderStatus.EXPIRED, om, c);
			if (lastExpiredMealOrder != null) {
				recent.add(lastExpiredMealOrder);
			}

			MealOrder lastCancelledMealOrder = getRecentOrder(MealOrderStatus.CANCELLED, om, c);
			if (lastCancelledMealOrder != null) {
				recent.add(lastCancelledMealOrder);
			}

			MealOrder lastDeliveredMealOrder = getRecentOrder(MealOrderStatus.DELIVERED, om, c);
			if (lastDeliveredMealOrder != null) {
				recent.add(lastDeliveredMealOrder);
			}

			response.setRecentOrders(recent);
		}

		this.entity = response;

	}

	private MealOrder getRecentOrder(MealOrderStatus status, OrderManager om, Client c) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("client", c);
		m.put("status", status);

		List<MealOrder> recent = new ArrayList<MealOrder>();

		List<MealOrder> ll = om.list("getLatestClientMealOrder", m);
		MealOrder lastMealOrder = null;
		if (ll != null && ll.size() > 0) {
			lastMealOrder = ll.get(0);
		}

		return lastMealOrder;
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager manager) {
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

	public String getAddLatestOnes() {
		return addLatestOnes;
	}

	public void setAddLatestOnes(String addLatestOnes) {
		this.addLatestOnes = addLatestOnes;
	}

}
