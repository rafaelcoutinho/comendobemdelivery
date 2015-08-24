package br.copacabana.spring;

import java.util.List;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class NeighborhoodManager extends AbstractJPAManager<Neighborhood> {

	public Neighborhood get(Key k) {
		return super.find(k, Neighborhood.class);
	}

	@Override
	public String getDefaultQueryName() {

		return "getNeighborhood";
	}

	public Neighborhood getNeighborByName(String name) {
		System.out.println(name);
		Query q = Datastore.getPersistanceManager().createNamedQuery("getNeighborhoodByName");
		q.setParameter("name", name);
		return (Neighborhood) q.getSingleResult();
	}

	public List<Neighborhood> getNeighborLikeName(String name) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getNeighborhoodLikeName");
		q.setParameter("name", name + "%");
		return q.getResultList();
	}

	public List<Neighborhood> getNeighborLikeNameByCity(String name, City c) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getNeighborhoodLikeNameInCity");
		q.setParameter("name", name + "%");
		q.setParameter("city", c);
		return q.getResultList();
	}

	public List<Neighborhood> getOrderedNeighborByCity(City city) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("searchNeighborhoodByCity");
		q.setParameter("city", city);
		return q.getResultList();
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return Neighborhood.class;
	}

}
