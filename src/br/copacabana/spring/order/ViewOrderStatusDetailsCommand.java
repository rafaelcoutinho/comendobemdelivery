package br.copacabana.spring.order;

import java.util.List;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderLogEntry;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.KeyFactory;

public class ViewOrderStatusDetailsCommand extends RetrieveCommand {
	private String id;

	@Override
	public void execute(Manager manager) throws Exception {
		OrderManager oman = new OrderManager();

		MealOrder mo = oman.get(KeyFactory.stringToKey(id));
		RestaurantManager rman = new RestaurantManager();
		List<MealOrderLogEntry> log = oman.getMealOrderHistory(mo);
		OrderStatusBean ob = new OrderStatusBean(mo, log, rman.getRestaurant(mo.getRestaurant()));
		this.entity = ob;

	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

}
