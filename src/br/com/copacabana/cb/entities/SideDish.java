package br.com.copacabana.cb.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import br.com.copacabana.cb.KeyWrapper;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;
@Entity
@NamedQueries({@NamedQuery(name="getSideDish", query = "SELECT s FROM SideDish s"),@NamedQuery(name="getSideDishesOrdered", query = "SELECT s FROM SideDish s ORDER BY s.id"),
@NamedQuery(name="getSideDishByName", query = "SELECT s FROM SideDish s WHERE s.name = :name"),
@NamedQuery(name="getSideDishByDescription", query = "SELECT s FROM SideDish s WHERE s.description = :description"),
@NamedQuery(name="getSideDishByImageUrl", query = "SELECT s FROM SideDish s WHERE s.imageUrl = :imageUrl"),
@NamedQuery(name="getSideDishByGroupId", query = "SELECT s FROM SideDish s WHERE s.group.id = :groupId"),
@NamedQuery(name="getSideDishByQuantity", query = "SELECT s FROM SideDish s WHERE s.quantity = :quantity"),
@NamedQuery(name="getSideDishByPrice", query = "SELECT s FROM SideDish s WHERE s.price = :price"),
@NamedQuery(name="getSideDishByAvailable", query = "SELECT s FROM SideDish s WHERE s.available = :available"),
@NamedQuery(name = "getSideDishesByRestaurant", query = "SELECT p FROM SideDish p WHERE p.restaurant.k = :restaurant_id") })
public class SideDish {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String name;
	@Expose
	private String description;
	@Expose
	private Double price=0.0;
	@Expose
	private String imageUrl;
	
	@Expose
	private KeyWrapper<Restaurant> restaurant = new KeyWrapper<Restaurant>();
	
	@Expose
	private Boolean available = Boolean.TRUE;
		
	
	public Double getPrice() {
		return price;
	}
	public void setPrice(Double price) {
		this.price = price;
	}
	public Boolean getAvailable() {
		return available;
	}
	public void setAvailable(Boolean available) {
		this.available = available;
	}
	
	
	public Key getId() {
		return id;
	}
	public void setId(Key id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}

	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public KeyWrapper<Restaurant> getRestaurant() {
		return restaurant;
	}
	public void setRestaurant(KeyWrapper<Restaurant> restaurant) {
		this.restaurant = restaurant;
	}
	
}
