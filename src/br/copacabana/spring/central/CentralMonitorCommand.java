package br.copacabana.spring.central;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class CentralMonitorCommand extends RetrieveCommand<CentralBean> implements SessionCommand {
	@Override
	public void execute(Manager eman) throws Exception {
		Key k = Authentication.getLoggedUserKey(session);
		// TODO confirm it's a central....?
		CentralManager manager = (CentralManager) eman;
		CentralBean cb = new CentralBean();
		Central c = manager.get(k);
		cb.setCentral(c);
		ChannelService channelService = ChannelServiceFactory.getChannelService();
		String token = channelService.createChannel(KeyFactory.keyToString(k));
		cb.setToken(token);
		updateCentralBean(cb, c.getRestaurants());

		this.entity = cb;
	}

	protected void updateCentralBean(CentralBean cb, List<Key> rests) {

		RestaurantManager rman = new RestaurantManager();
		OrderManager oman = new OrderManager();
		int index = 0;
		int maxNewOrders = -1;
		int maxOnGoingOrders = -1;
		int maxNewOrdersIndex = -1;
		int maxOnGoingOrdersIndex = -1;
		RestaurantMonitorBean maxNewRests = null;
		RestaurantMonitorBean maxOngoingRests = null;
		for (Iterator<Key> iterator = rests.iterator(); iterator.hasNext();) {
			Key restKey = (Key) iterator.next();
			RestaurantMonitorBean rbean = new RestaurantMonitorBean();
			rbean.setRestaurant(rman.getRestaurant(restKey));
			rbean.setNewOrders(oman.getNewOrdersForRestaurant(restKey));
			rbean.setOnGoingOrders(oman.getOnGoingOrdersForRestaurant(restKey));
			if (rbean.getNewOrders().size() > maxNewOrders) {
				maxNewOrders = rbean.getNewOrders().size();
				maxNewOrdersIndex = index;
				maxNewRests = rbean;

			}
			if (rbean.getOnGoingOrders().size() > maxOnGoingOrders) {
				maxOnGoingOrders = rbean.getOnGoingOrders().size();
				maxOngoingRests = rbean;
			}
			cb.getRests().add(rbean);
			index++;
		}
		if (maxNewOrders > 0) {
			// cb.getRests().get(maxNewOrdersIndex).setSelected(true);
			maxNewRests.setSelected(true);
			cb.setSelected(maxNewRests.getRestaurant());
		} else if (maxOnGoingOrders > 0) {
			maxOngoingRests.setSelected(true);
			cb.setSelected(maxOngoingRests.getRestaurant());

		} else if (cb.getRests().size() > 0) {
			cb.getRests().get(0).setSelected(true);
			cb.setSelected(cb.getRests().get(0).getRestaurant());
		}

	}

	HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
