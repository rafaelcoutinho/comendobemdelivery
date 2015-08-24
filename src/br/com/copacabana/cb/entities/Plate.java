package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Transient;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ 
	@NamedQuery(name = "getPlate", query = "SELECT p FROM Plate p"),	
	@NamedQuery(name = "getPlateByName", query = "SELECT p FROM Plate p WHERE p.name = :name"), 
	@NamedQuery(name = "getPlateByDescription", query = "SELECT p FROM Plate p WHERE p.description = :description"), 
	@NamedQuery(name = "getPlateByPrice", query = "SELECT p FROM Plate p WHERE p.price = :price"), 
	@NamedQuery(name = "getPlateOrdered", query = "SELECT p FROM Plate p ORDER BY p.id"), 
	@NamedQuery(name = "getPlateByClient", query = "SELECT p FROM Plate p WHERE p.client.id = :client_id"), 
	@NamedQuery(name = "getRestaurantByCategory1", query = "SELECT p FROM Plate p WHERE p.foodCategory.k=:foodCat"), 
	@NamedQuery(name = "getRestaurantByCategory", query = "SELECT DISTINCT p.restaurant FROM Plate p WHERE p.foodCategory=:foodCat and p.restaurant.siteStatus not in ('BLOCKED','TEMPUNAVAILABLE')"), 
	@NamedQuery(name = "getPlateByRestaurant", query = "SELECT p FROM Plate p WHERE p.restaurant = :restaurant"), 
	@NamedQuery(name = "getPlateOptions", query = "SELECT p FROM Plate p WHERE p.extendsPlate = :plateId"), 
	@NamedQuery(name = "getPlateByRestaurantOrderedByName", query = "SELECT p FROM Plate p WHERE p.restaurant = :restaurant order by status,title,price"),
	@NamedQuery(name = "getPlateByRestaurantForPeriod", query = "SELECT p FROM Plate p WHERE p.restaurant = :restaurant and availableTurn=:turn order by status,title,price"), 
	@NamedQuery(name = "getPlateWithNullTurn", query = "SELECT p FROM Plate p WHERE availableTurn!=:turn"),
	@NamedQuery(name = "getAllSizeOptionsForRestaurant", query = "SELECT p FROM Plate p WHERE p.restaurant = :restaurant and p.extendsPlate is not null and p.plateSize=:size"),
	
	@NamedQuery(name = "getRestPlateByCategory", query = "SELECT p FROM Plate p WHERE p.foodCategory=:foodCat and p.restaurant = :restaurant"),
	@NamedQuery(name = "getRestPlateByCategorySpecial", query = "SELECT p FROM Plate p WHERE p.foodCategory=:foodCat and p.restaurant = :restaurant order by restInternalCode,title"),

})
public class Plate implements Serializable {
	public Plate(String title) {
		super();
		this.title = title;
	}

	public Plate() {
		// TODO Auto-generated constructor stub
	}

	@Expose
	private Key extendsPlate;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String title;
	@Expose
	private String imageUrl;

	private Long imageKey;
	@Expose
	private String description;
	@Expose
	private Double price = 0.0;

	@Expose
	private TurnType availableTurn = TurnType.ANY;

	@Enumerated(EnumType.STRING)
	@Expose
	private PlateSize plateSize = PlateSize.NONE;

	// @OneToMany(fetch = EAGER, cascade = CascadeType.ALL)
	@Transient
	private List<Key> recommendations = new ArrayList<Key>();

	// @OneToMany(fetch = EAGER, cascade = CascadeType.REFRESH)

	@Expose
	private List<Key> sideDishes = new ArrayList<Key>();
	@Expose
	private Boolean discount = Boolean.FALSE;
	@Expose
	private Double originalPrice = 0.0;

	@Expose
	private Key foodCategory;

	@Expose
	@ManyToOne(cascade = CascadeType.REFRESH)
	private Restaurant restaurant;

	@Enumerated(EnumType.STRING)
	@Expose
	private PlateStatus status = PlateStatus.AVAILABLE;

	@Expose
	private Boolean allowsFraction = Boolean.FALSE;

	@Expose
	private String restInternalCode = "";

	private Integer priceInCents = 0;

	@Expose
	private Integer originalPriceInCents = 0;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public PlateStatus getStatus() {
		return status;
	}

	public void setStatus(PlateStatus status) {
		this.status = status;
	}

	public void addRecommendation(Recommendation recommendation) {
		this.recommendations.add(recommendation.getId());
	}

	public String getDescription() {
		return description;
	}

	public Boolean getDiscount() {
		return discount;
	}

	public Key getFoodCategory() {
		return foodCategory;
	}

	public String getName() {
		return title;
	}

	public void setRecommendations(List<Key> recommendations) {
		this.recommendations = recommendations;
	}

	public Double getOriginalPrice() {
		return originalPrice;
	}

	public Double getPrice() {
		return price;
	}

	public Integer getPriceInCents() {
		return priceInCents;
	}

	public List<Key> getRecommendations() {
		return recommendations;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setDiscount(Boolean discount) {
		this.discount = discount;
	}

	public void setFoodCategory(Key foodCategory) {
		this.foodCategory = foodCategory;
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public void setName(String name) {
		this.title = name;
	}

	public void setOriginalPrice(Double originalPrice) {
		this.originalPrice = originalPrice;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public void setPrice(Integer price) {
		this.priceInCents = price;
		this.price = Double.valueOf(this.priceInCents);
		this.price /= 100;
	}

	/** 
	 */

	@Override
	public boolean equals(Object o) {
		if (o instanceof Plate) {
			if (((Plate) o).getId().equals(this.getId())) {
				return true;
			}
		}
		return false;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	//
	// public Long getId() {
	// return id;
	// }

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public List<Key> getSideDishes() {
		return sideDishes;
	}

	public void setSideDishes(List<Key> sideDishes) {
		this.sideDishes = sideDishes;
	}

	public Boolean getAllowsFraction() {
		return allowsFraction;
	}

	public void setAllowsFraction(Boolean allowsFraction) {
		this.allowsFraction = allowsFraction;
	}

	public Long getImageKey() {
		return imageKey;
	}

	public void setImageKey(Long imageKey) {
		this.imageKey = imageKey;
	}

	public Key getExtendsPlate() {
		return extendsPlate;
	}

	public void setExtendsPlate(Key extendsPlate) {
		this.extendsPlate = extendsPlate;
	}

	public boolean isExtension() {
		return this.extendsPlate != null;
	}

	public TurnType getAvailableTurn() {
		return availableTurn;
	}

	public void setAvailableTurn(TurnType onlyForTurn) {
		this.availableTurn = onlyForTurn;
	}

	public PlateSize getPlateSize() {
		return plateSize;
	}

	public void setPlateSize(PlateSize plateSize) {
		this.plateSize = plateSize;
	}

	public String getRestInternalCode() {
		return restInternalCode;
	}

	public void setRestInternalCode(String restInternalCode) {
		this.restInternalCode = restInternalCode;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(this.getId());
	}

	public Integer getOriginalPriceInCents() {
		return originalPriceInCents;
	}

	public void setOriginalPriceInCents(Integer originalPriceInCents) {
		this.originalPriceInCents = originalPriceInCents;
	}

	public void setPriceInCents(Integer priceInCents) {
		this.priceInCents = priceInCents;
	}

}
