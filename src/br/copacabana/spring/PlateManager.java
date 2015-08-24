package br.copacabana.spring;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.PlateSize;
import br.com.copacabana.cb.entities.RestPlateHighlights;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.TurnType;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class PlateManager extends AbstractJPAManager<Plate> {

	@Override
	public String getDefaultQueryName() {

		return "getPlate";
	}

	public RestPlateHighlights getRestaurantPlateHighlighs(Key restId) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getPlateHighlightByRest");
		query.setParameter("restId", restId);
		RestPlateHighlights plateHigh = null;
		try {
			plateHigh = (RestPlateHighlights) query.getSingleResult();
		} catch (javax.persistence.NoResultException e) {

			if (plateHigh == null) {
				plateHigh = new RestPlateHighlights(restId);
				Datastore.getPersistanceManager().getTransaction().begin();
				Datastore.getPersistanceManager().persist(plateHigh);
				Datastore.getPersistanceManager().getTransaction().commit();
			}
		}
		return plateHigh;

	}

	@Deprecated
	public void associatePlateHighlight(Key rest, Key plateId) {
		RestPlateHighlights hcat = getRestaurantPlateHighlighs(rest);
		hcat.addPlate(plateId);
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().merge(hcat);
		Datastore.getPersistanceManager().getTransaction().commit();

	}

	public void persist(RestPlateHighlights high) {
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().merge(high);
		Datastore.getPersistanceManager().getTransaction().commit();
	}

	public Plate getPlate(Key type) {

		return this.find(type, Plate.class);
	}

	public List<Plate> getRestaurantSizeOptions(Restaurant rest,PlateSize size) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getAllSizeOptionsForRestaurant");
		query.setParameter("restaurant", rest);
		query.setParameter("size", size);
		return query.getResultList();
	}
	
	public List<Plate> getPlateOptions(Plate p) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getPlateOptions");
		query.setParameter("plateId", p.getId());

		return query.getResultList();

	}

	public void updateHighlights(Key restaurant, Key[] plates) {
		RestPlateHighlights rhigh = this.getRestaurantPlateHighlighs(restaurant);

		Set<Key> ps = new HashSet<Key>();
		for (int i = 0; i < plates.length; i++) {
			Key plateId = plates[i];
			if (plateId != null) {
				ps.add(plateId);
			}
		}
		rhigh.setPlates(ps);
		this.persist(rhigh);

	}

	public List<Plate> listPlatesForTurn(Restaurant rest, TurnType turn) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getPlateByRestaurantForPeriod");
		query.setParameter("restaurant", rest);
		query.setParameter("turn", turn);
		return query.getResultList();
	}

	public List<Plate> listAllNonUpdatePlate() {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getPlateWithNullTurn");
		query.setParameter("turn", TurnType.ANY);
		return query.getResultList();
	}

	@Override
	protected Class getEntityClass() {

		return Plate.class;
	}

	public List<Plate> listPlatesByCat(Restaurant rest, FoodCategory category) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getRestPlateByCategory");
		query.setParameter("foodCat", category.getId());
		query.setParameter("restaurant", rest);
		return query.getResultList();

	}
}
