package br.copacabana;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.Restaurant.SiteStatus;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class RestaurantSearchCommand extends ListCommand<List<Restaurant>> {

	private SearchCriteria criteria = new SearchCriteria();

	public SearchCriteria getCriteria() {
		return criteria;
	}

	public void setCriteria(SearchCriteria criteria) {
		this.criteria = criteria;
	}

	@Override
	public void execute() {
		Set<Restaurant> results = new HashSet<Restaurant>();
		try {
			if (null != criteria.getNeighbor() && criteria.getNeighbor().length() > 0) {
				results.addAll(searchByNeighbor(criteria.getNeighbor(), criteria.getCity(), criteria.getOpenStatus()));
			} else {
				if (null != criteria.getCity() && criteria.getCity().length() > 0) {
					results.addAll(searchByCity(criteria.getCity(), criteria.getOpenStatus()));
				}
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro na busca.", e);
		}
		if (null != criteria.getFreeform() && criteria.getFreeform().length() > 0) {
			results.addAll(searchByFreeForm(criteria.getFreeform(), criteria.getOpenStatus()));
		}

		RestaurantManager rman = new RestaurantManager();

		// TODO this seems to be a bug, getting the restauratnt from the queries
		// above doesn't return all its data.
		
		List<Restaurant> realList = new ArrayList<Restaurant>();
		for (Iterator iterator = results.iterator(); iterator.hasNext();) {
			Restaurant restaurant = (Restaurant) iterator.next();
			if (SiteStatus.BLOCKED.equals(restaurant.getSiteStatus())) {
				continue;
			}
			realList.add(rman.get(restaurant.getId()));
		}
		Collections.sort(realList, new Comparator<Restaurant>() {

			@Override
			public int compare(Restaurant o1, Restaurant o2) {
				if(o1.isOpen()==o2.isOpen()){
					return o1.getName().compareTo(o2.getName());
				}else{
					if(o1.isOpen()==true){
						return -1;
					}else{
						return +1;
					}
				}				
				
			}
			
		});
		this.entity = realList;

	}

	private Collection<? extends Restaurant> searchByZip(String zip, String openStatus) {
		NeighborhoodManager neigMan = new NeighborhoodManager();
		AddressManager addMan = new AddressManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("zip", zip.toLowerCase() + "%");
		List<Restaurant> rests = new ArrayList<Restaurant>();
		List<Neighborhood> ns = neigMan.list("searchNeighborhoodByZip", m);
		for (Iterator iterator = ns.iterator(); iterator.hasNext();) {
			Neighborhood neighborhood = (Neighborhood) iterator.next();
			Map<String, Object> madd = new HashMap<String, Object>();
			madd.put("neighborhoodKey", neighborhood.getId());
			List<Address> adds = addMan.list("getAddressByNeighbor", madd);
			for (Iterator iterator2 = adds.iterator(); iterator2.hasNext();) {
				Address address = (Address) iterator2.next();
				Map<String, Object> mrest = new HashMap<String, Object>();
				m.put("address", address);
				try {
					rests.addAll(new RestaurantManager().list("restaurantByAddress", m));
				} catch (javax.persistence.PersistenceException e) {
					if (!e.getMessage().endsWith("Key of parameter value does not have a parent.")) {
						throw e;
					} else {
						System.err.println(e.getClass());
						System.err.println(e.getMessage());
					}
				}
			}
		}
		return rests;
	}

	private Collection<? extends Restaurant> searchByFreeForm(String freeform, String openStatus) {
		RestaurantManager rman = new RestaurantManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("name", criteria.getFreeform() + "%");
		return rman.list("searchRestaurant", m);
	}

	private Collection<? extends Restaurant> searchByNeighbor(String neighbor, String city, String openStatus) throws Exception {
		Key neighKey = KeyFactory.stringToKey(neighbor);
		Key cityKey = KeyFactory.stringToKey(city);
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("neighborhood", neighKey);
		m.put("city", cityKey);
		Set<Restaurant> restList = new HashSet<Restaurant>();
		RestaurantManager manager = new RestaurantManager();
		restList.addAll(manager.list("getRestaurantInNeighborhood", m));
		restList.addAll(manager.list("getRestaurantInDeliverEntireCity", m));

		return restList;

	}

	private Collection<? extends Restaurant> searchByNeighbor2(String neighbor, String openStatus) throws Exception {
		NeighborhoodManager neigMan = new NeighborhoodManager();
		AddressManager addMan = new AddressManager();

		Map<String, Object> m = new HashMap<String, Object>();
		// m.put("name", neighbor + "%");
		List<Restaurant> rests = new ArrayList<Restaurant>();

		// for (Iterator<Neighborhood> iterator =
		// neigMan.list("searchNeighborhoodByName", m).iterator();
		// iterator.hasNext();) {
		// Neighborhood neighborhood = (Neighborhood) iterator.next();

		Map<String, Object> madd = new HashMap<String, Object>();
		Neighborhood n = neigMan.find(com.google.appengine.api.datastore.KeyFactory.stringToKey(neighbor), Neighborhood.class);
		madd.put("neighborhood", n);
		List<Address> adds = addMan.list("getAddressByNeighborX", madd);
		for (Iterator<Address> iterator2 = adds.iterator(); iterator2.hasNext();) {
			Address address = (Address) iterator2.next();
			Map<String, Object> mrest = new HashMap<String, Object>();
			mrest.put("address", address.getId());
			try {
				rests.addAll(new RestaurantManager().list("restaurantByAddress", mrest));
			} catch (javax.persistence.PersistenceException e) {
				// this can happen if we iterate over an address that has
				// the neighborhood but isn't child of anyone.
				if (!e.getMessage().endsWith("Key of parameter value does not have a parent.")) {
					throw e;
				} else {
					e.printStackTrace();
					log.log(Level.SEVERE, "Failed search {0}", e);
				}
			}
		}
		// }

		return rests;
	}

	private Collection<? extends Restaurant> searchByCity(String city, String openStatus) throws Exception {
		Key cityKey = KeyFactory.stringToKey(city);
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("city", cityKey);
		Set<Restaurant> restList = new HashSet();
		RestaurantManager manager = new RestaurantManager();
		restList.addAll(manager.list("getRestaurantInDeliverEntireCity", m));
		CityManager cm = new CityManager();
		City c = cm.getCity(cityKey);

		for (Iterator<Neighborhood> iterator = c.getNeighborhoods().iterator(); iterator.hasNext();) {
			Neighborhood neig = (Neighborhood) iterator.next();
			m.put("neighborhood", neig.getId());
			restList.addAll(manager.list("getRestaurantInNeighborhood", m));
		}
		return restList;
	}
}
