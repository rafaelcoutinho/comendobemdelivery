package br.copacabana.highlight;

import com.google.appengine.api.datastore.Key;

public class HighlightBean {
	Key[] categories = new Key[3];
	Key[] plates = new Key[5];
	Key restaurant = null;

	public Key[] getCategories() {
		return categories;
	}

	public void setCategories(Key[] categories) {
		this.categories = categories;
	}

	public Key[] getPlates() {
		return plates;
	}

	public void setPlates(Key[] plates) {
		this.plates = plates;
	}

	public Key getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Key restaurant) {
		this.restaurant = restaurant;
	}

}
