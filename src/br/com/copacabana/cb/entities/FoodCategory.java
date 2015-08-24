package br.com.copacabana.cb.entities;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity(name="FoodCategory")
@NamedQueries( { @NamedQuery(name = "getFoodCategories", query = "SELECT f FROM FoodCategory f"), 
	@NamedQuery(name = "getFoodCategory", query = "SELECT f FROM FoodCategory f"), 
	@NamedQuery(name = "getFoodCategoryOrdered", query = "SELECT f FROM FoodCategory f ORDER BY f.id"), 
	@NamedQuery(name = "getFoodCategoryByName", query = "SELECT f FROM FoodCategory f WHERE f.name = :name"), 
	@NamedQuery(name = "getFoodCategoryByDescription", query = "SELECT f FROM FoodCategory f WHERE f.description = :description"), 
	@NamedQuery(name = "getMainFoodCategories", query = "SELECT  FROM FoodCategory  WHERE isMainCategory = true order by name"), 
})
public class FoodCategory implements Serializable {


	public FoodCategory(String name, String description, Boolean isMainCategory) {
		super();
		this.name = name;
		this.description = description;
		this.isMainCategory = isMainCategory;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String name;
	@Expose
	private String description;
	
	@Expose
	private String imgUrl;
	
	@Expose
	private Boolean isMainCategory=Boolean.FALSE;
	public FoodCategory() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getDescription() {
		return description;
	}

	public Key getId() {
		return id;
	}
	public String getIdStr() {
		return KeyFactory.keyToString(id);
	}
	public void setId(Key id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public Boolean getIsMainCategory() {
		return isMainCategory;
	}

	public void setIsMainCategory(Boolean isMainCategory) {
		this.isMainCategory = isMainCategory;
	}
}
