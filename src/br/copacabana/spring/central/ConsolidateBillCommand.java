package br.copacabana.spring.central;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;

public class ConsolidateBillCommand extends RetrieveCommand implements SessionCommand {
	private HttpSession session;
	private String start;
	private String end;

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	@Override
	public void execute(Manager manager) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("kk:mm:ss dd-MM-yyyy");
		sdf.setTimeZone(TimeController.getDefaultTimeZone());
		if (this.start != null && this.end != null) {
			Date start = sdf.parse(this.start);
			Date end = sdf.parse(this.end);
			CentralManager cm = (CentralManager) manager;
			Key centralKey = Authentication.getLoggedUserKey(session);
			Central c = cm.get(centralKey);
			List<Key> restaurants = c.getRestaurants();
			OrderManager om = new OrderManager();
			RestaurantManager rm = new RestaurantManager();
			ConsolidatedBillBean consolidateBean = new ConsolidatedBillBean(c, start, end);
			for (Iterator iterator = restaurants.iterator(); iterator.hasNext();) {
				Key restKey = (Key) iterator.next();
				RestaurantOrdersBean bean = new RestaurantOrdersBean(rm.getRestaurant(restKey), start, end);
				bean.setOrders(om.getCompleteOrders(restKey, start, end));
				consolidateBean.addRestaurantOrders(bean);
			}
			this.entity = consolidateBean;
		}

	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

}
