package br.com.copacabana.cb.entities;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ 
	@NamedQuery(name = "getDeliveryRange", query = "SELECT a FROM DeliveryRange a"),
	@NamedQuery(name = "getDeliveryRangeByNeighbor", query = "SELECT a FROM DeliveryRange a where a.neighborhood.k =:keyPassed"),
	@NamedQuery(name = "getDeliveryRangeByRestaurant", query = "SELECT a FROM DeliveryRange a where a.restaurant.k =:restaurantKey"),
	@NamedQuery(name = "getRestaurantInNeighborhood", query = "SELECT a.restaurant FROM DeliveryRange a where a.neighborhood =:neighborhood"),
	@NamedQuery(name = "getRestaurantInDeliverEntireCity", query = "SELECT a.restaurant FROM DeliveryRange a where a.city =:city and neighborhood is null")

})
public class DeliveryRange implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7263907411261317767L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private Key neighborhood;

	@Expose
	private Key city;

	@Expose
	private Double cost = 0.0;

	@Expose
	private Integer costInCents = 0;
	@Expose
	private Integer minimumOrderValueInCents = 0;

	@Expose
	private boolean isPercentage = false;
	@Expose
	private Double minimumOrderValue = 0.0;
	@Deprecated
	private Integer minimumOrderValueInt = 0;
	@Deprecated
	private Integer costInt = 0;

	@ManyToOne(cascade = CascadeType.REFRESH)
	private Restaurant restaurant = new Restaurant();

	public Key getId() {
		return id;
	}
	public String getIdStr() {
		return KeyFactory.keyToString(id);
	}

	public void setId(Key id) {
		this.id = id;
	}

	public Key getNeighborhood() {
		return neighborhood;
	}

	public void setNeighborhood(Key neighborhood) {
		this.neighborhood = neighborhood;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof DeliveryRange) {
			DeliveryRange other = (DeliveryRange) obj;
			return other.getNeighborhood().equals(this.getNeighborhood()) && other.getRestaurant().getId().equals(this.getRestaurant().getId());
		}
		return false;
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public boolean isPercentage() {
		return isPercentage;
	}

	public void setPercentage(boolean isPercentage) {
		this.isPercentage = isPercentage;
	}

	public Double getMinimumOrderValue() {
		return minimumOrderValue;
	}

	
	public void setMinimumOrderValue(Double minimumOrderValue) {
		this.minimumOrderValue = minimumOrderValue;
		
	}

	public void setCost(Double cost) {
		this.cost = cost;
		
	}

	public Double getCost() {
		return cost;
	}

	public Integer getCostInCents() {

		return costInCents;
	}

	public Key getCity() {
		return city;
	}

	public void setCity(Key city) {
		this.city = city;
	}


	public Integer getMinimumOrderValueInCents() {
		return minimumOrderValueInCents;
	}

	public void setMinimumOrderValueInCents(Integer minimumOrderValueInCents) {
		this.minimumOrderValueInCents = minimumOrderValueInCents;
	}

	public void setCostInCents(Integer costInCents) {
		this.costInCents = costInCents;
	}
}
