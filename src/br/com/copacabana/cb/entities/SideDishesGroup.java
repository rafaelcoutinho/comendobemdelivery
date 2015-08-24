package br.com.copacabana.cb.entities;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Transient;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( {@NamedQuery(name = "defaultQuery", query = "SELECT s FROM SideDishesGroup s"), @NamedQuery(name = "getSideDishesGroup", query = "SELECT s FROM SideDishesGroup s"), @NamedQuery(name = "getSideDishesGroupOrdered", query = "SELECT s FROM SideDishesGroup s ORDER BY s.id"), @NamedQuery(name = "getSideDishesGroupByName", query = "SELECT s FROM SideDishesGroup s WHERE s.name = :name"), @NamedQuery(name = "getSideDishesGroupByDescription", query = "SELECT s FROM SideDishesGroup s WHERE s.description = :description"), @NamedQuery(name = "getSideDishesGroupByRestaurant", query = "SELECT s FROM SideDishesGroup s WHERE s.restaurant.id = :restaurant_id") })
public class SideDishesGroup {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id; 

	private Boolean mutex = Boolean.FALSE;

	public Boolean getMutex() {
		return mutex;
	}

	public void setMutex(Boolean mutex) {
		this.mutex = mutex;
	}

	@Expose
	private String name;
	@Expose
	private String description;
	@Transient
	private Restaurant restaurant;

	// @OneToMany(fetch = FetchType.EAGER, mappedBy =
	// "group",cascade=CascadeType.ALL)
	@Transient
	private List<SideDish> sideDishes = new ArrayList<SideDish>();

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

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public List<SideDish> getSideDishes() {
		return sideDishes;
	}

	public void setSideDishes(List<SideDish> sideDishes) {
		this.sideDishes = sideDishes;
	}

	public void addSideDish(SideDish sideDish) {

		this.sideDishes.add(sideDish);
	}
}
