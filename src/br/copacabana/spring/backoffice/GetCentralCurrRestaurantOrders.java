package br.copacabana.spring.backoffice;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.GsonSerializable;
import br.copacabana.ListCommandFilteredBy;
import br.copacabana.marshllers.RestaurantMonitorBeanSerializer;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.central.RestaurantMonitorBean;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;

import com.google.appengine.api.datastore.Key;

public class GetCentralCurrRestaurantOrders extends ListCommandFilteredBy implements SessionCommand, GsonSerializable {
	private HttpSession session;

	@Override
	public void execute(Manager manager) throws Exception {
		OrderManager om = (OrderManager) manager;
		
		Key k = getKey();
		RestaurantManager rm = new RestaurantManager();
		om.getOnGoingOrdersForRestaurant(k);
		RestaurantMonitorBean rbean = new RestaurantMonitorBean();
		rbean.setNewOrders(om.getNewOrdersForRestaurant(k));
		rbean.setOnGoingOrders(om.getOnGoingOrdersForRestaurant(k));
		rbean.setRestaurant(rm.getRestaurant(k));
		this.entity=rbean;
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		m.put(RestaurantMonitorBean.class, new RestaurantMonitorBeanSerializer(man));
		return m;
	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}
}
