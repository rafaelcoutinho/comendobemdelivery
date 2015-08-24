package br.copacabana.spring.central;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class LoadMyRestaurantsCommand extends RetrieveCommand<List<RestaurantMonitorBean>> implements SessionCommand {
	@Override
	public void execute(Manager eman) throws Exception {
		Key k = Authentication.getLoggedUserKey(session);
		// TODO confirm it's a central....?
		CentralManager manager = (CentralManager) eman;
		CentralBean cb = new CentralBean();
		Central c = manager.get(k);
		RestaurantManager rman = new RestaurantManager();
		cb.setCentral(c);
		List<RestaurantMonitorBean> list = new ArrayList<RestaurantMonitorBean>(c.getRestaurants().size());
		for (Iterator<Key> iterator = c.getRestaurants().iterator(); iterator.hasNext();) {
			Key restKey = (Key) iterator.next();
			RestaurantMonitorBean rbean = new RestaurantMonitorBean();
			rbean.setRestaurant(rman.getRestaurant(restKey));
			list.add(rbean);
		}
		this.entity = list;
	}

	HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
