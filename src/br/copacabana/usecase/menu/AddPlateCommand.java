package br.copacabana.usecase.menu;

import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.JsonViewItemFileReadStoreController;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.KeyFactory;

public class AddPlateCommand implements Command, ReturnValueCommand {

	private Plate plate = new Plate();
	private FoodCategory foodcategory = new FoodCategory();
	private Restaurant restaurant = new Restaurant();

	protected static final Logger log = Logger.getLogger("copacabana.Timing");

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	public void execute() throws Exception {
		long start = -1;
		if (log.isLoggable(Level.INFO)) {
			log.info("Starting perf data for addPlateCommand");
			start = System.currentTimeMillis();
		}
		if (plate.getFoodCategory() == null) {
			plate.setFoodCategory(this.foodcategory.getId());
		}
		if (plate.getId() == null) {
			RestaurantManager rman = new RestaurantManager();
			plate.setPriceInCents(Double.valueOf(plate.getPrice()*100.0).intValue());
			restaurant.addPlate(plate);
			rman.update(restaurant);

		} else {
			PlateManager man = new PlateManager();
			Plate toUpdate = man.find(plate.getId(), Plate.class);
			boolean mustUpdateOptions = false;
			if (!toUpdate.getFoodCategory().equals(plate.getFoodCategory())) {
				mustUpdateOptions = true;
			}
			if (!toUpdate.getStatus().equals(plate.getStatus())) {
				mustUpdateOptions = true;
			}

			toUpdate.setDescription(plate.getDescription());
			toUpdate.setFoodCategory(plate.getFoodCategory());
			toUpdate.setName(plate.getName());
			
			toUpdate.setPrice(plate.getPrice());
			toUpdate.setPriceInCents(Double.valueOf(plate.getPrice()*100.0).intValue());
			toUpdate.setTitle(plate.getTitle());
			toUpdate.setPlateSize(plate.getPlateSize());
			toUpdate.setStatus(plate.getStatus());
			plate.setImageUrl(toUpdate.getImageUrl());
			man.update(toUpdate);
			if (mustUpdateOptions) {
				for (Iterator<Plate> iterator = man.getPlateOptions(plate).iterator(); iterator.hasNext();) {
					Plate option = (Plate) iterator.next();
					option.setFoodCategory(toUpdate.getFoodCategory());
					option.setStatus(toUpdate.getStatus());
					man.update(option);
				}
			}
			man.endTransaction();
		}
		long stop = 0;
		if (log.isLoggable(Level.INFO)) {
			stop = System.currentTimeMillis();
			log.info("DB manipulation took: " + (stop - start) + "ms");
		}
		// cleaning cache.
		JsonViewItemFileReadStoreController.invalidateCacheValue("listRestaurantPlatesFast", KeyFactory.keyToString(restaurant.getId()));
		if (log.isLoggable(Level.INFO)) {
			long stop2 = System.currentTimeMillis();
			log.info("Cache manipulation took: " + (stop2 - stop) + "ms");
			log.info("Total manipulation took: " + (stop2 - start) + "ms");
		}

	}

	public Plate getPlate() {
		return plate;
	}

	public void setPlate(Plate plate) {
		this.plate = plate;
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public FoodCategory getFoodcategory() {
		return foodcategory;
	}

	public void setFoodcategory(FoodCategory foodcategory) {
		this.foodcategory = foodcategory;
	}

	@Override
	public Object getEntity() {

		return plate;
	}

}
