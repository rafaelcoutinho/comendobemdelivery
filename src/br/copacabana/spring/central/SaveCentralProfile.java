package br.copacabana.spring.central;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.FormCommand;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class SaveCentralProfile implements FormCommand, SessionCommand {
	private HttpSession session;
	private CentralProfileBean central = new CentralProfileBean();

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		Central toSave = new Central();
		CentralManager cman = new CentralManager();
		if (central.getIdStr() != null && central.getIdStr().length() > 0) {
			toSave = cman.get(KeyFactory.stringToKey(central.getIdStr()));
		}
		toSave.setName(central.getName());
		toSave.setDescription(central.getDescription());
		toSave.setUrl(central.getUrl());
		toSave.setPersonInCharge(central.getPersonInCharge());
		toSave.getContact().setPhone(central.getContact().getPhone());
		toSave.getContact().setEmail(central.getContact().getEmail());
		cman.persist(toSave);

	}

	@Override
	public Object getInitialObject(Manager manager) {
		try {
			Key k = Authentication.getLoggedUserKey(session);
			central = new CentralProfileBean(new CentralManager().get(k));

		} catch (JsonException e) {
			e.printStackTrace();
		}

		return central;
	}

	@Override
	public Map<String, Object> getReferenceData(HttpServletRequest request, Manager manager) {
		Map<String, Object> model = new HashMap<String, Object>();
		this.session = request.getSession();
		CityManager cm = new CityManager();
		List<City> cities = cm.list();
		model.put("cities", cities);
		NeighborhoodManager nm = new NeighborhoodManager();
		model.put("neighborhoods", nm.list());

		model.put("central", getInitialObject(manager));
		return model;
	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public CentralProfileBean getCentral() {
		return central;
	}

	public void setCentral(CentralProfileBean central) {
		this.central = central;
	}
}
