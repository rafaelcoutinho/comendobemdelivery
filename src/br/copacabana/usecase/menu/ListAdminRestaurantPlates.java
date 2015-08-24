package br.copacabana.usecase.menu;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.TurnType;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.Command;
import br.copacabana.GsonSerializable;
import br.copacabana.RetrieveCommand;
import br.copacabana.ReturnValueCommand;
import br.copacabana.marshllers.PlateWrapperSerializer;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class ListAdminRestaurantPlates extends RetrieveCommand implements GsonSerializable, Command, ReturnValueCommand, SessionCommand {
	private String periodToFilter = TurnType.ANY.name();
	private boolean filterByPeriod = false;

	@Override
	public Object getEntity() {

		return plates;
	}

	private List<Plate> plates;

	@Override
	public void execute(Manager manager) throws Exception {
		PlateManager pm = (PlateManager) manager;

		Key restId = Authentication.getLoggedUserKey(session);
		RestaurantManager rman = new RestaurantManager();
		Restaurant r = rman.getRestaurant(restId);
		if (filterByPeriod == true) {
			plates = pm.listPlatesForTurn(r, TurnType.valueOf(periodToFilter));
		} else {
			plates = pm.listPlatesForTurn(r, TurnType.ANY);
		}
		if (plates == null) {
			plates = new ArrayList<Plate>();
		}

	}

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public String getPeriodToFilter() {
		return periodToFilter;
	}

	public void setPeriodToFilter(String periodToFilter) {
		this.periodToFilter = periodToFilter;
	}

	public boolean isFilterByPeriod() {
		return filterByPeriod;
	}

	public void setFilterByPeriod(boolean filterByPeriod) {
		this.filterByPeriod = filterByPeriod;
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(Plate.class, new PlateWrapperSerializer());
		return m;
	}

}
