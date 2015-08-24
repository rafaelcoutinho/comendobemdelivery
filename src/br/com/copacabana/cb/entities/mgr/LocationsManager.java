package br.com.copacabana.cb.entities.mgr;

import br.com.copacabana.cb.entities.Locations;

public class LocationsManager extends AbstractJPAManager<Locations> {

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "getAllLocations";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return Locations.class;
	}

}
