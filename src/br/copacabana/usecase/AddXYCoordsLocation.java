package br.copacabana.usecase;

import br.com.copacabana.cb.entities.Locations;
import br.com.copacabana.cb.entities.mgr.LocationsManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;

import com.google.appengine.api.datastore.Key;

public class AddXYCoordsLocation implements Command {
	private float x;
	private float y;
	private String formattedAddress;
	private Key neighborhood;
	private Key id;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		LocationsManager lman = new LocationsManager();
		Locations loc = new Locations(x, y, formattedAddress);
		if (id != null) {
			loc = lman.get(id);
			loc.setX(x);
			loc.setY(y);
			loc.setFormattedAddress(formattedAddress);
		}
		if (neighborhood != null) {
			loc.setNeighborhood(neighborhood);
		}

		lman.persist(loc);
	}

	public float getX() {
		return x;
	}

	public void setX(float x) {
		this.x = x;
	}

	public float getY() {
		return y;
	}

	public void setY(float y) {
		this.y = y;
	}

	public String getFormattedAddress() {
		return formattedAddress;
	}

	public void setFormattedAddress(String formattedAddress) {
		this.formattedAddress = formattedAddress;
	}

	public Key getNeighborhood() {
		return neighborhood;
	}

	public void setNeighborhood(Key neighborhood) {
		this.neighborhood = neighborhood;
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

}
