package br.copacabana.spring.restaurant;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.central.RestaurantOrdersBean;
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
		Date start = null;
		Date end = null;
		if (this.start == null) {
			start = TimeController.getTodayMidnight();
			end = new Date();

		} else {
			start = sdf.parse(this.start);
			end = sdf.parse(this.end);
		}

		OrderManager om = new OrderManager();
		RestaurantManager rm = new RestaurantManager();
		Key restKey = Authentication.getLoggedUserKey(session);
		RestaurantOrdersBean bean = new RestaurantOrdersBean(rm.getRestaurant(restKey), start, end);
		bean.setOrders(om.getCompleteOrders(restKey, start, end));

		this.entity = bean;

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
