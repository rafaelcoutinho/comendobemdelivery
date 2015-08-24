package br.copacabana.usecase;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.RestPlateHighlights;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.UrledCommand;
import br.copacabana.exception.DirectRestaurantNotFoundException;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.usecase.beans.ShowRestaurantBean;

public class ShowRestaurant extends RetrieveCommand implements UrledCommand {

	private String url;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		String uniqueUrlName = getUniqueRestaurantName(url);
		RestaurantManager restMan = new RestaurantManager();
		Restaurant rest = null;
		if (uniqueUrlName != null) {
			rest = restMan.getRestaurantByUniqueURL(uniqueUrlName);
			if (rest == null) {
				throw new DirectRestaurantNotFoundException("Restaurant with uniqueUrl:" + uniqueUrlName + " was not found");
			}
		}

		// Plate selectedPlate = null;
		// if (plateKey != null) {
		// Set<Plate> sps = rest.getPlates();
		//
		// for (Iterator iterator = sps.iterator(); iterator.hasNext();) {
		// Plate plate = (Plate) iterator.next();
		// if (plate.getId().equals(plateKey)) {
		// selectedPlate = plate;
		// break;
		// }
		// }
		//
		// }

		this.entity = new ShowRestaurantBean(rest, null);
		PlateManager plateManager = new PlateManager();
		RestPlateHighlights high = plateManager.getRestaurantPlateHighlighs(rest.getId());
		((ShowRestaurantBean) this.entity).setHighlights(high);
		try {
			AddressManager add = new AddressManager();
			Address address = add.getAddress(rest.getAddress());
			((ShowRestaurantBean) this.entity).setAddress(address);
		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	private String getUniqueRestaurantName(String url2) {
		int p2 = url2.lastIndexOf(".restaurante");
		int p1 = url2.lastIndexOf("/");
		return url2.substring(p1 + 1, p2);
	}

	@Override
	public void setRequestedUrl(String url) {
		this.url = url;

	}
}
