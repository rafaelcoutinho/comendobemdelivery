package br.copacabana.spring.backoffice;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.central.RestaurantOrdersBean;
import br.copacabana.util.TimeController;

public class ConsolidateBillCommand extends RetrieveCommand implements SessionCommand {
	private HttpSession session;
	private String start;
	private String end;
	private Boolean includeERP = Boolean.FALSE;
	
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
			RestaurantManager rm = new RestaurantManager();
			List<Restaurant> restaurants = rm.list();
			OrderManager om = new OrderManager();

			ConsolidatedBillBean consolidateBean = new ConsolidatedBillBean(start, end);
			for (Iterator iterator = restaurants.iterator(); iterator.hasNext();) {
				Restaurant rest = (Restaurant) iterator.next();
				RestaurantOrdersBean bean = new RestaurantOrdersBean(rest, start, end);
				if(Boolean.FALSE.equals(includeERP)){
					bean.setOrders(om.getCompleteOnlineOrders(rest.getId(), start, end));
				}else{
					bean.setOrders(om.getCompleteOrders(rest.getId(), start, end));
				}
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

	public Boolean getIncludeERP() {
		return includeERP;
	}

	public void setIncludeERP(Boolean includeERP) {
		this.includeERP = includeERP;
	}

}
