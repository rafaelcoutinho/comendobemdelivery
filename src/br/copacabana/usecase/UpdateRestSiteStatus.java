package br.copacabana.usecase;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.Restaurant.SiteStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.Key;

public class UpdateRestSiteStatus implements Command {
	private Key id;
	private String siteStatus;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		RestaurantManager rman = new RestaurantManager();
		Restaurant r = rman.getRestaurant(id);
		r.setSiteStatus(SiteStatus.valueOf(siteStatus));
		rman.persist(r);
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public String getSiteStatus() {
		return siteStatus;
	}

	public void setSiteStatus(String siteStatus) {
		this.siteStatus = siteStatus;
	}
}
