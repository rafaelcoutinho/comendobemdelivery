package br.copacabana.usecase;

import br.com.copacabana.cb.entities.mgr.LocationsManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;

public class ListUnassignedLocations extends RetrieveCommand {
	@Override
	public void execute(Manager manager) throws Exception {
		LocationsManager lman = new LocationsManager();
		this.entity = lman.list("getUnassignedLocations");

	}
}
