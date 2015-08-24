package br.copacabana.usecase;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.Locations;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.mgr.LocationsManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.RetrieveCommand;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.NeighborhoodManager;

public class AutoLocate extends RetrieveCommand implements Command, ReturnValueCommand {
	private String x;
	private String y;
	private String formattedAddress;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		LocationsManager lMan = new LocationsManager();
		Map<String, Object> m = new HashMap<String, Object>();

		m.put("x", Float.valueOf(x));
		m.put("y", Float.valueOf(y));
		List<Locations> locs = lMan.list("getLocationWitNeighBasedOnCoords", m);
		if (locs.isEmpty()) {
			m.put("formattedAddress", formattedAddress);
			locs = lMan.list("getLocationBasedOnFormattedAddress", m);
		}

		List<Neighborhood> n = new ArrayList<Neighborhood>();
		if (!locs.isEmpty()) {
			NeighborhoodManager nMan = new NeighborhoodManager();
			for (Iterator iterator = locs.iterator(); iterator.hasNext();) {
				Locations loc = (Locations) iterator.next();
				Neighborhood neighborhood = nMan.find(loc.getNeighborhood(), Neighborhood.class);
				n.add(neighborhood);
			}
		} else {
			if (lMan.list("getLocationByFormattedAddress", m).size() == 0) {
				AddXYCoordsLocation saveXY = new AddXYCoordsLocation();
				saveXY.setFormattedAddress(formattedAddress);
				saveXY.setX(Float.valueOf(x));
				saveXY.setY(Float.valueOf(y));
				saveXY.execute();
				log.info("XY location saved for " + formattedAddress);
			}
		}
		this.entity = n;

	}

	public String getFormattedAddress() {
		return formattedAddress;
	}

	public void setFormattedAddress(String formattedAddress) {
		this.formattedAddress = formattedAddress;
	}

	public String getX() {
		return x;
	}

	public void setX(String x) {
		this.x = x;
	}

	public String getY() {
		return y;
	}

	public void setY(String y) {
		this.y = y;
	}
}
