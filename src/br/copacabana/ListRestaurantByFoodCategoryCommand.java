package br.copacabana;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.FoodCategoryManager;
import br.copacabana.spring.PlateManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class ListRestaurantByFoodCategoryCommand extends RetrieveCommand {
	private Key cityId;

	public Key getCityId() {
		return cityId;
	}

	public void setCityId(Key cityId) {
		this.cityId = cityId;
	}
@Deprecated
	public void executeOld(Manager manager) {

		PlateManager pm = (PlateManager) manager;
		Map<String, Object> m = new HashMap<String, Object>();
		String strK = (String) getId();
		Key k = KeyFactory.stringToKey(strK);

		m.put("foodCat", k);
		List l = pm.list("getRestaurantByCategory", m);

		Set<Restaurant> restList = new HashSet<Restaurant>(l);
		if (cityId != null) {
			AddressManager am = new AddressManager();
			Set<Restaurant> filtered = new HashSet<Restaurant>();
			for (Iterator<Restaurant> iterator = restList.iterator(); iterator.hasNext();) {
				Restaurant object = (Restaurant) iterator.next();
				if (am.getAddress(object.getAddress()).getNeighborhood().getCity().getId().equals(cityId)) {
					filtered.add(object);
				}
			}
			this.entity = filtered;
		} else {
			this.entity = restList;
		}

	}

	public void execute(Manager manager) {
		FoodCategoryManager fc = new FoodCategoryManager();
		String strK = (String) getId();
		Key k = KeyFactory.stringToKey(strK);
		Set<Restaurant> restList = fc.getRestaurantsByCategory(k, cityId);

		this.entity = restList;

	}

}
