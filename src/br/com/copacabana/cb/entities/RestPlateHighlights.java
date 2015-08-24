package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getAllPlateHighlight", query = "SELECT f FROM RestPlateHighlights f"),
@NamedQuery(name = "getPlateHighlightByRest", query ="SELECT f FROM RestPlateHighlights f where restaurant=:restId"),
// @NamedQuery(name = "getRestaurantCatHighlights", query =
// "SELECT f FROM HighlightedFoodCategory f where  :restId member of restaurants")

})
public class RestPlateHighlights implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long nonuse;
	private Key restaurant;
	@Expose
	private Set<Key> plates = new HashSet<Key>();

	public RestPlateHighlights(Key restaurant) {
		super();
		this.restaurant = restaurant;
	}

	public void addPlate(Key p) {
		this.plates.add(p);
	}

	public Key getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Key restaurant) {
		this.restaurant = restaurant;
	}

	public Set<Key> getPlates() {
		return plates;
	}

	public void setPlates(Set<Key> plates) {
		this.plates = plates;
	}
}
