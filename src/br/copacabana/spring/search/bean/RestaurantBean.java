package br.copacabana.spring.search.bean;

import br.com.copacabana.cb.entities.Restaurant;

import com.google.appengine.api.datastore.KeyFactory;

public class RestaurantBean {
	private Restaurant restaurant;

	public RestaurantBean(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(restaurant.getId());
	}

	public String getDirectAccessUrl() {
		if (restaurant.getUniqueUrlName() != null && restaurant.getUniqueUrlName().length() > 0) {
			return "/" + restaurant.getUniqueUrlName();
		} else {
			return "/?showRestaurant=true&restaurantId=" + this.getIdStr();
		}
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

}
