package br.copacabana.spring.backoffice;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.central.RestaurantMonitorBean;

public class LoadAllRestaurantsCommand extends RetrieveCommand<List<RestaurantMonitorBean>> implements SessionCommand {
	@Override
	public void execute(Manager eman) throws Exception {

		RestaurantManager rman = new RestaurantManager();
		List<Restaurant> restList = rman.list();
		List<RestaurantMonitorBean> list = new ArrayList<RestaurantMonitorBean>(restList.size());
		for (Iterator<Restaurant> iterator = restList.iterator(); iterator.hasNext();) {
			Restaurant rest = (Restaurant) iterator.next();
			RestaurantMonitorBean rbean = new RestaurantMonitorBean();
			rbean.setRestaurant(rest);
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
