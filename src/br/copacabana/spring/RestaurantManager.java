package br.copacabana.spring;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.exception.InvalidUniqueUrlNameException;
import br.copacabana.exception.NotUniqueUrlNameException;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class RestaurantManager extends AbstractJPAManager<Restaurant> {

	public String getDefaultQueryName() {

		return "getRestaurant";
	}

	@Override
	public Restaurant create(Restaurant r) throws Exception {
		UserBeanManager um = new UserBeanManager();
		um.checkIfUniqueLogin(r.getUser());
		return super.create(r);
	}

	// @Override
	// public Restaurant update(Restaurant r) throws Exception {
	//
	// return super.create(r);
	// }

	public Restaurant getRestaurant(Key key) {
		return this.find(key, Restaurant.class);
	}

	public Restaurant getRestaurantByUniqueURL(String uniqueUrlName) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("uniqueUrlName", uniqueUrlName);
		List<Restaurant> l = this.list("restaurantByUrlName", m);
		if (l != null && !l.isEmpty()) {
			return l.get(0);
		}
		return null;
	}

	public Restaurant getRestaurantByUserBean(UserBean ub) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("restaurantByUserBean");
		query.setParameter("login", ub);
		return (Restaurant) query.getSingleResult();
	}

	public void updateUniqueUrl(Key restKey, String newUrl) throws NotUniqueUrlNameException, Exception {
		Restaurant r = this.getRestaurant(restKey);
		if (newUrl != null && newUrl.length() != 0) {
			if (newUrl.contains(".") || newUrl.contains(",") || newUrl.contains("/") || newUrl.contains("\\")) {
				throw new InvalidUniqueUrlNameException(newUrl);
			} else {
				Restaurant r2 = getRestaurantByUniqueURL(newUrl);
				if (r2 != null && !r.getId().equals(r2.getId())) {
					throw new NotUniqueUrlNameException(newUrl);
				}
				r.setUniqueUrlName(newUrl);
				this.update(r);
			}
		}

	}

	@Override
	protected Class getEntityClass() {

		return Restaurant.class;
	}

	public List<Key> listRestKeys() {
		Query query = Datastore.getPersistanceManager().createNamedQuery("restaurantKeys");
		
		return query.getResultList();
	}
}
