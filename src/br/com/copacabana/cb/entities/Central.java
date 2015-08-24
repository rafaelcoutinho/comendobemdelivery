package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;

import org.apache.commons.collections.Factory;
import org.apache.commons.collections.list.LazyList;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "allCentrals", query = "SELECT c FROM Central c"),

@NamedQuery(name = "getCentralByUserBean", query = "SELECT r FROM Central r WHERE r.user = :login"), 

@NamedQuery(name = "getRestaurantsCentral", query = "SELECT r FROM Central r WHERE r.restaurants.contains(:restaurant)"),
@NamedQuery(name = "getCentralByUrl", query = "SELECT r FROM Central r WHERE r.directAccess=:uniqueUrl"),


})
public class Central implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;

	/**
	 * 
	 */
	private static final long serialVersionUID = -7419019263095965340L;

	@OneToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@Expose
	private ContactInfo contact = new ContactInfo();

	@Expose
	private String name;
	@Expose
	private String personInCharge;

	@Expose
	private String url;
	@Expose
	private String description;
	@Expose
	private String imageUrl;
	@Expose
	private String imageKey;

	@Expose
	private String directAccess;
	@Expose
	private Key mainAddress;
	@OneToOne(optional = false, cascade = CascadeType.ALL)
	@Expose
	private UserBean user = new UserBean();
	@Expose
	private List<Key> restaurants = LazyList.decorate(new ArrayList(), new Factory() {
		@Override
		public Object create() {
			return KeyFactory.createKey("", "");
		}
	});

	public Central(String email) {
		super();
		this.user = new UserBean(email);
		this.contact = new ContactInfo(email);
	}

	public Central() {
		super();

	}

	public Central(UserBean user) {
		super();
		this.user = user;
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public ContactInfo getContact() {
		return contact;
	}

	public void setContact(ContactInfo contact) {
		this.contact = contact;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Key getMainAddress() {
		return mainAddress;
	}

	public void setMainAddress(Key mainAddress) {
		this.mainAddress = mainAddress;
	}

	public UserBean getUser() {
		return user;
	}

	public void setUser(UserBean user) {
		this.user = user;
	}

	public List<Key> getRestaurants() {
		return restaurants;
	}

	public void setRestaurants(List<Key> restaurants) {
		this.restaurants = restaurants;
	}

	public String getPersonInCharge() {
		return personInCharge;
	}

	public void setPersonInCharge(String personInCharge) {
		this.personInCharge = personInCharge;
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

	public String getImageKey() {
		return imageKey;
	}

	public void setImageKey(String imageKey) {
		this.imageKey = imageKey;
	}

	public String getDirectAccess() {
		return directAccess;
	}

	public void setDirectAccess(String directAccess) {
		this.directAccess = directAccess;
	}

}
