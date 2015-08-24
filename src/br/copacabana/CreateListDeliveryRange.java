package br.copacabana;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Logger;

import org.apache.commons.collections.Factory;
import org.apache.commons.collections.list.LazyList;

import br.com.copacabana.cb.entities.DeliveryRange;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.DeliveryManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.KeyFactory;

public class CreateListDeliveryRange implements Command {
	protected static final Logger log = Logger.getLogger("copacabana.Commands");
	private String restaurantId;
	private boolean onlyForRetrieval = true;
	private List<DeliveryRange> deliveryRanges = LazyList.decorate(new ArrayList(), new Factory() {
		@Override
		public Object create() {
			return new DeliveryRange();// .createKey("Address", null);
		}
	});

	private List<String> toDeleteDeliveries = LazyList.decorate(new ArrayList(), new Factory() {
		@Override
		public Object create() {
			return "";// .createKey("Address", null);
		}
	});

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		// DeliveryManager delMan = new DeliveryManager();
		RestaurantManager rm = new RestaurantManager();
		Restaurant rest2 = rm.find(KeyFactory.stringToKey(restaurantId), Restaurant.class);
		rest2.setDeliveryRanges(new HashSet<DeliveryRange>());

		for (Iterator<DeliveryRange> iterator = deliveryRanges.iterator(); iterator.hasNext();) {
			DeliveryRange delRange = new DeliveryRange();
			DeliveryRange dd = iterator.next();
			delRange.setCity(dd.getCity());
			delRange.setCost(dd.getCost());
			delRange.setCostInCents(dd.getCostInCents());
			delRange.setMinimumOrderValueInCents(dd.getMinimumOrderValueInCents());
			delRange.setMinimumOrderValue(dd.getMinimumOrderValue());
			delRange.setNeighborhood(dd.getNeighborhood());
			delRange.setRestaurant(rest2);
			rest2.addDeliveryRange(delRange);

		}
		rest2.setOnlyForRetrieval(isOnlyForRetrieval());

		rm.persist(rest2);

	}

	@Deprecated
	// was too slow
	public void executeOld(br.com.copacabana.cb.entities.mgr.Manager manager) throws Exception {

		DeliveryManager delMan = new DeliveryManager();
		RestaurantManager rm = new RestaurantManager();
		Restaurant rest2 = rm.find(KeyFactory.stringToKey(restaurantId), Restaurant.class);
		rest2.setOnlyForRetrieval(onlyForRetrieval);
		// Set<DeliveryRange> newDelRanges = new
		// HashSet<DeliveryRange>(deliveryRanges);

		rm.persist(rest2);
		for (Iterator iterator = deliveryRanges.iterator(); iterator.hasNext();) {
			DeliveryRange type = (DeliveryRange) iterator.next();
			Restaurant rest = rm.find(KeyFactory.stringToKey(restaurantId), Restaurant.class);
			type.setRestaurant(rest);
			if (type.getId() == null) {
				delMan.persist(type);
				rest.addDeliveryRange(type);
				rm.persist(rest);

			} else {
				delMan.persist(type);
			}
		}

		for (Iterator iterator = toDeleteDeliveries.iterator(); iterator.hasNext();) {
			Restaurant rest = rm.find(KeyFactory.stringToKey(restaurantId), Restaurant.class);
			String type = (String) iterator.next();
			DeliveryRange toDelete = delMan.find(KeyFactory.stringToKey(type), DeliveryRange.class);
			rest.removeDeliveryRange(toDelete);

			rm.persist(rest);

		}

	}

	public String getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(String restaurantId) {
		this.restaurantId = restaurantId;
	}

	public List<DeliveryRange> getDeliveryRanges() {
		return deliveryRanges;
	}

	public void setDeliveryRanges(List<DeliveryRange> deliveryRanges) {
		this.deliveryRanges = deliveryRanges;
	}

	public List<String> getToDeleteDeliveries() {
		return toDeleteDeliveries;
	}

	public void setToDeleteDeliveries(List<String> toDeleteDeliveries) {
		this.toDeleteDeliveries = toDeleteDeliveries;
	}

	public boolean isOnlyForRetrieval() {
		return onlyForRetrieval;
	}

	public void setOnlyForRetrieval(boolean onlyForRetrieval) {
		this.onlyForRetrieval = onlyForRetrieval;
	}

}
