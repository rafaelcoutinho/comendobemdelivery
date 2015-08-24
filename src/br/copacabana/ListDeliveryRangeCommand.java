package br.copacabana;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.DeliveryRange;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.RestaurantManager;

public class ListDeliveryRangeCommand extends ListCommandFilteredBy implements GsonSerializable {

	public void execute(Manager manager) {

		// Map<String, Object> m = new HashMap<String, Object>();
		// m.put(getQueryItemId(), getKey());
		// List<DeliveryRange> delRanges = manager.list(getQueryName(), m);

		RestaurantManager restMan = new RestaurantManager();
		Restaurant rest = restMan.find(getKey(), Restaurant.class);
		this.entity = new ArrayList<DeliveryRangeData>();
		for (Iterator iterator = rest.getDeliveryRanges().iterator(); iterator.hasNext();) {
			DeliveryRange delivery = (DeliveryRange) iterator.next();

			if (delivery.getNeighborhood() == null) {
				City c = (City) new CityManager().get(delivery.getCity());
				((List) this.entity).add(new DeliveryRangeData(null, delivery, c));
			} else {
				Neighborhood n = (Neighborhood) new NeighborhoodManager().get(delivery.getNeighborhood());
				((List) this.entity).add(new DeliveryRangeData(n, delivery, n.getCity()));
			}

		}

	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		// m.put(KeyWrapper.class, new KeyWrapperSerializer());
		return m;
	}
}
