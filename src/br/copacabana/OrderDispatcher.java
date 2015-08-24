package br.copacabana;

import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.cache.OrdersCacheEntry;

import com.google.appengine.api.datastore.Key;

public class OrderDispatcher {
	protected static final Logger log = Logger.getLogger("copacabana.Caches");

	public void removeOrder(MealOrder mo) {
		if (log.isLoggable(Level.INFO)) {
			log.log(Level.INFO, "Removing new order from cache. id={0}", mo.getId().getId());
		}
		OrdersCacheEntry newOrderCache = getCacheObject();
		newOrderCache.removeOrder(mo);
		CacheController.getCache().put("newOrderCache", newOrderCache);
	}

	public void placeOrder(MealOrder mo) {
		if (log.isLoggable(Level.INFO)) {
			log.log(Level.INFO, "Adding new order to cache. id={0}", mo.getId().getId());
		}
		OrdersCacheEntry newOrderCache = getCacheObject();
		newOrderCache.addOrder(mo);
		CacheController.getCache().put("newOrderCache", newOrderCache);

	}

	private synchronized OrdersCacheEntry getCacheObject() {
		OrdersCacheEntry m = (OrdersCacheEntry) CacheController.getCache().get("newOrderCache");
		if (m == null) {
			m = new OrdersCacheEntry();
		}
		return m;
	}

	public long lastChangeTime() {
		return getCacheObject().getLogicClock();
	}

	public boolean hasNewOrders(Restaurant rest) {
		return this.hasNewOrders(rest.getId());
	}
	public boolean hasNewOrders(Key restId) {
		return getCacheObject().hasNewOrders(restId);
	}
	public boolean hasAnyOrders() {
		return getCacheObject().hasAny();
	}

}
