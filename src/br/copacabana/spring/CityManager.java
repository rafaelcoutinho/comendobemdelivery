package br.copacabana.spring;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class CityManager extends AbstractJPAManager<City> {

	public CityManager() {
		super();
	}

	@Override
	public String getDefaultQueryName() {
		return "getCities";
	}

	public City getCity(Key cityKey) {
		return Datastore.getPersistanceManager().find(City.class, cityKey);
	}

	public City getCityByName(String name) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getCityByName");
		query.setParameter("name", name);
		return (City) query.getSingleResult();
	}

	@Override
	protected Class getEntityClass() {
		return City.class;
	}

	

}
