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

@Entity(name = "HighlightedFoodCategory")
@NamedQueries({ @NamedQuery(name = "getAllHighlightFoodCategories", query = "SELECT f FROM HighlightedFoodCategory f"),
	@NamedQuery(name = "getHighlightFoodCategoriesByCat", query = "SELECT f FROM HighlightedFoodCategory f where foodCategory=:foodCat"), 
	@NamedQuery(name = "getRestaurantCatHighlights", query = "SELECT f FROM HighlightedFoodCategory f where  :restId member of restaurants")

})
public class HighlightedFoodCategory implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long nonuse;
	private Key foodCategory;
	@Expose
	private Set<Key> restaurants = new HashSet<Key>();

	public HighlightedFoodCategory(Key cat) {
		this.foodCategory = cat;

	}

	public Key getFoodCategory() {
		return foodCategory;
	}

	public void setFoodCategory(Key foodCategory) {
		this.foodCategory = foodCategory;
	}

	public Set<Key> getRestaurants() {
		return restaurants;
	}

	public void setRestaurants(Set<Key> restaurants) {
		this.restaurants = restaurants;
	}

	public void addRestaurant(Key restaurant) {
		this.restaurants.add(restaurant);
	}
}
