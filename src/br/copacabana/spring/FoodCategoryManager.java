package br.copacabana.spring;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.HighlightedFoodCategory;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.Restaurant.SiteStatus;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class FoodCategoryManager extends AbstractJPAManager<FoodCategory> {

	public String getDefaultQueryName() {

		return "getFoodCategories";
	}

	public Set<Restaurant> getRestaurantsByCategory(Key catid, Key cityId) {
		HighlightedFoodCategory hfoodcat = getHighlighCategory(catid);
		RestaurantManager rman = new RestaurantManager();
		Set<Restaurant> rlist = new HashSet<Restaurant>();
		AddressManager am = new AddressManager();
		for (Iterator iterator = hfoodcat.getRestaurants().iterator(); iterator.hasNext();) {
			Key rkey = (Key) iterator.next();
			Restaurant r = rman.getRestaurant(rkey);
			if(SiteStatus.BLOCKED.equals(r.getSiteStatus())){
				continue;
			}
			if(r==null){
				log.log(Level.SEVERE,"r is null");
			}
			log.log(Level.SEVERE,"addres key"+r.getAddress());
			if (cityId != null) {
				
				if (cityId.equals(am.getAddress(r.getAddress()).getNeighborhood().getCity().getId())) {
					rlist.add(r);
				}
			} else {
				rlist.add(r);
			}

		}

		return rlist;

	}

	public FoodCategory getFoodCategoryByName(String name) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getFoodCategoryByName");
		query.setParameter("name", name);
		return (FoodCategory) query.getSingleResult();
	}

	public HighlightedFoodCategory getHighlighCategory(Key cat) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getHighlightFoodCategoriesByCat");
		query.setParameter("foodCat", cat);
		HighlightedFoodCategory hcat = null;
		try {
			hcat = (HighlightedFoodCategory) query.getSingleResult();
		} catch (javax.persistence.NoResultException e) {

			if (hcat == null) {
				hcat = new HighlightedFoodCategory(cat);
				Datastore.getPersistanceManager().getTransaction().begin();
				Datastore.getPersistanceManager().persist(hcat);
				Datastore.getPersistanceManager().getTransaction().commit();
			}
		}
		return hcat;
	}

	public void associateHighlightCat(Key cat, Key rest) {
		HighlightedFoodCategory hcat = getHighlighCategory(cat);
		hcat.addRestaurant(rest);

		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().merge(hcat);
		Datastore.getPersistanceManager().getTransaction().commit();

	}

	public Key[] getHighlightedFoodCategory(Key restKey) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getRestaurantCatHighlights");
		query.setParameter("restId", restKey);
		List<HighlightedFoodCategory> l = query.getResultList();
		Key[] catKeys = new Key[l.size()];
		int i = 0;
		for (Iterator iterator = l.iterator(); iterator.hasNext();) {
			HighlightedFoodCategory highlightedFoodCategory = (HighlightedFoodCategory) iterator.next();
			catKeys[i++] = highlightedFoodCategory.getFoodCategory();
		}
		return catKeys;

	}

	public List<FoodCategory> getMainFoodCategories() {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getMainFoodCategories");
		return query.getResultList();
	}

	public void dissociateAll(Key restKey) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getRestaurantCatHighlights");
		query.setParameter("restId", restKey);
		List<HighlightedFoodCategory> l = query.getResultList();
		for (Iterator iterator = l.iterator(); iterator.hasNext();) {
			HighlightedFoodCategory highlightedFoodCategory = (HighlightedFoodCategory) iterator.next();
			highlightedFoodCategory.getRestaurants().remove(restKey);
			Datastore.getPersistanceManager().getTransaction().begin();
			Datastore.getPersistanceManager().merge(highlightedFoodCategory);
			Datastore.getPersistanceManager().getTransaction().commit();

		}

	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return FoodCategory.class;
	}
}
