package br.com.copacabana.cb.entities;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import br.copacabana.spring.PlateManager;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getOrderedPlate", query = "SELECT p FROM OrderedPlate p") })
public class OrderedPlate {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;

	@ManyToOne
	private MealOrder mealorder;
	@Expose
	private Double price;
	@Expose
	private Integer priceInCents = 0;

	@Expose
	private int qty;
	@Expose
	private String name;
	@Expose
	private String restInternalCode;
	@Expose
	private Key plate;
	@Expose
	private Boolean isFraction = Boolean.FALSE;
	@Expose
	private Boolean isCustom = Boolean.FALSE;
	@Expose
	private Set<Key> fractionPlates = new HashSet<Key>();

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Key getPlate() {
		return plate;
	}

	public void setPlate(Key plate) {
		this.plate = plate;
	}

	public MealOrder getMealorder() {
		return mealorder;
	}

	public void setMealorder(MealOrder mealorder) {
		this.mealorder = mealorder;
	}

	public Boolean getIsFraction() {
		return isFraction;
	}

	public void setIsFraction(Boolean isFraction) {
		this.isFraction = isFraction;
	}

	public Set<Key> getFractionPlates() {
		return fractionPlates;
	}

	public void setFractionPlates(Set<Key> frationPlates) {
		this.fractionPlates = frationPlates;
	}

	public String getRestInternalCode() {
		return restInternalCode;
	}

	public String getForceRestInternalCode() {
		if (restInternalCode == null || restInternalCode.length() == 0) {
			Key plateId = null;
			if (this.isFraction) {
				plateId = this.fractionPlates.iterator().next();
			} else {
				plateId = this.plate;
			}
			Plate p = new PlateManager().get(plateId);
			restInternalCode = p.getRestInternalCode();
		}
		return restInternalCode;
	}

	public void setRestInternalCode(String restInternalCode) {
		this.restInternalCode = restInternalCode;
	}

	public Integer getPriceInCents() {
		return priceInCents;
	}

	public void setPriceInCents(Integer priceInCents) {
		this.priceInCents = priceInCents;
	}

	public Boolean getIsCustom() {
		return isCustom;
	}

	public void setIsCustom(Boolean isCustom) {
		this.isCustom = isCustom;
	}

}
