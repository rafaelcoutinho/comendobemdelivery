package br.copacabana.usecase.menu;

import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.RestPlateHighlights;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.com.copacabana.cb.entities.mgr.PictureManager;
import br.copacabana.CacheController;
import br.copacabana.Command;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.KeyFactory;

public class DeletePlate implements Command {
	private String id;
	protected static final Logger log = Logger.getLogger("copacabana.Timing");

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		try {
			long start = -1;
			if (log.isLoggable(Level.INFO)) {
				log.info("Starting perf data for deletePlate");
				start = System.currentTimeMillis();
			}
			PlateManager jpaMan = new PlateManager();
			log.log(Level.FINE, "Deleting {0}", getId());
			Plate p = jpaMan.find(KeyFactory.stringToKey(id), Plate.class);
			if (p.getImageKey() != null) {
				PictureManager picMan = new PictureManager();
				picMan.delete(p.getImageKey());
			}

			Restaurant r = p.getRestaurant();

			log.log(Level.FINE, "Found the restaurant {0}", r.getName());

			RestPlateHighlights restHighlights = jpaMan.getRestaurantPlateHighlighs(r.getId());
			if (restHighlights.getPlates().contains(p.getId())) {
				restHighlights.getPlates().remove(p.getId());
				jpaMan.persist(restHighlights);
			}
			List<Plate> options = jpaMan.getPlateOptions(p);
			log.log(Level.FINE, "Deleting {0} options of this plate", options.size());
			for (Iterator<Plate> iterator = options.iterator(); iterator.hasNext();) {
				Plate option = (Plate) iterator.next();

				r.removePlate(option);
				// jpaMan.delete(option);
			}
			log.log(Level.FINE, "Found the plate {0}", p);

			r.removePlate(p);
			log.log(Level.FINE, "removed it from restaurant");
			new RestaurantManager().persist(r);
			log.log(Level.FINE, "Persisted the restaurant");
			long stop = 0;
			if (log.isLoggable(Level.INFO)) {
				stop = System.currentTimeMillis();
				log.info("DB manipulation took: " + (stop - start) + "ms");
			}

			CacheController.invalidateCache("listRestaurantPlatesFast", KeyFactory.keyToString(r.getId()));

			if (log.isLoggable(Level.INFO)) {
				long stop2 = System.currentTimeMillis();
				log.info("Cache manipulation took: " + (stop2 - stop) + "ms");
				log.info("Total manipulation took: " + (stop2 - start) + "ms");
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to delete plate {0} ", getId());
			log.log(Level.SEVERE, "Error ", e);
		}

	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

}
