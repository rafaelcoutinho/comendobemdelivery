package br.copacabana.spring.central.web;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.UrledCommand;
import br.copacabana.exception.DirectRestaurantNotFoundException;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.central.CentralBean;
import br.copacabana.spring.central.RestaurantMonitorBean;

import com.google.appengine.api.datastore.Key;

public class ShowCentral extends RetrieveCommand implements UrledCommand {

	private String url;

	@Override
	public void execute(Manager manager) throws Exception {
	}

	public void execute() throws Exception {
		String uniqueUrlName = getUniqueRestaurantName(url);
		CentralManager centralManager = new CentralManager();
		Central central = null;
		if (uniqueUrlName != null) {
			central = centralManager.getCentralByUniqueURL(uniqueUrlName);
			if (central == null) {
				throw new DirectRestaurantNotFoundException("Central with uniqueUrl:" + uniqueUrlName + " was not found");
			}
		}
		CentralBean cb = new CentralBean();

		RestaurantManager rman = new RestaurantManager();
		cb.setCentral(central);
		List<RestaurantMonitorBean> list = new ArrayList<RestaurantMonitorBean>(central.getRestaurants().size());
		for (Iterator<Key> iterator = central.getRestaurants().iterator(); iterator.hasNext();) {
			Key restKey = (Key) iterator.next();
			RestaurantMonitorBean rbean = new RestaurantMonitorBean();
			rbean.setRestaurant(rman.getRestaurant(restKey));
			list.add(rbean);
		}
		cb.setRests(list);
		this.entity = cb;

	}

	private String getUniqueRestaurantName(String url2) {
		int p2 = url2.lastIndexOf(".central");
		int p1 = url2.lastIndexOf("/");
		return url2.substring(p1 + 1, p2);
	}

	@Override
	public void setRequestedUrl(String url) {
		this.url = url;

	}
}
