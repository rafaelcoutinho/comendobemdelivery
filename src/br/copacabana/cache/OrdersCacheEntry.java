package br.copacabana.cache;

import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;

import com.google.appengine.api.datastore.Key;

public class OrdersCacheEntry implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4118182471330264172L;
	private Map<Key, Set<Long>> newOrdersByRestaurant = new HashMap<Key, Set<Long>>();
	private long logicClock = 0;

	public void addOrder(MealOrder mo) {
		logicClock++;
		Set<Long> setList = newOrdersByRestaurant.get(mo.getRestaurant());
		if (setList == null) {
			setList = new HashSet<Long>();
		}
		setList.add(mo.getId().getId());
		newOrdersByRestaurant.put(mo.getRestaurant(), setList);
	}

	public void removeOrder(MealOrder mo) {
		logicClock++;
		Set<Long> setList = newOrdersByRestaurant.get(mo.getRestaurant());
		if (setList != null) {
			setList.remove(mo.getId().getId());
			newOrdersByRestaurant.put(mo.getRestaurant(), setList);
		}
	}

	public boolean hasNewOrders(Restaurant rest) {
		return this.hasNewOrders(rest.getId());
	}

	public long getLogicClock() {
		return logicClock;
	}

	public boolean hasAny() {
		return newOrdersByRestaurant!=null && newOrdersByRestaurant.size()>0;
	}

	public boolean hasNewOrders(Key id) {
		Set<Long> setList = newOrdersByRestaurant.get(id);
		return setList != null && setList.size() > 0;
	}
	

}
