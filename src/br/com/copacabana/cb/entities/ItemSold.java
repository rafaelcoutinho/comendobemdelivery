package br.com.copacabana.cb.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import com.google.appengine.api.datastore.Key;

@Entity
public class ItemSold {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Key id;
	@ManyToOne
	private OrdinarySell sell;
	private Integer qty = 0;
	private Integer priceInCents = 0;
	private String description = "";
	private String observation = "";

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public OrdinarySell getSell() {
		return sell;
	}

	public void setSell(OrdinarySell sell) {
		this.sell = sell;
	}

	public Integer getQty() {
		return qty;
	}

	public void setQty(Integer qty) {
		this.qty = qty;
	}

	public Integer getPriceInCents() {
		return priceInCents;
	}

	public void setPriceInCents(Integer priceInCents) {
		this.priceInCents = priceInCents;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getObservation() {
		return observation;
	}

	public void setObservation(String observation) {
		this.observation = observation;
	}
}
