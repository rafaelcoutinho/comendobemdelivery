package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.apache.commons.collections.Factory;
import org.apache.commons.collections.list.LazyList;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getClient", query = "SELECT c FROM Client c"),
	@NamedQuery(name = "getClientByName", query = "SELECT c FROM Client c WHERE c.name = :name"),
	@NamedQuery(name = "getClientByAddress", query = "SELECT c FROM Client c WHERE c.address = :address"),
	@NamedQuery(name = "getClientByAddresses", query = "SELECT c FROM Client c WHERE c.addresses.contains(:address)"),
	@NamedQuery(name = "getClientByMainAddress", query = "SELECT c FROM Client c WHERE c.mainAddress=:address"),
	@NamedQuery(name = "getClientOrdered", query = "SELECT c FROM Client c ORDER BY c.id"), 
	@NamedQuery(name = "getClientByLogin", query = "SELECT c FROM Client c WHERE c.user=:login"), 
	@NamedQuery(name = "getClientByLoginString", query = "SELECT c FROM Client c WHERE c.user.login=:login"),
	@NamedQuery(name = "getClientByContact", query = "SELECT c FROM Client c WHERE c.contact=:contact"),
	@NamedQuery(name = "getNewsLetterClients", query = "SELECT c FROM Client c WHERE c.receiveNewsletter=true order by c.registeredOn"),
	@NamedQuery(name = "getNoNewsLetterClients", query = "SELECT c FROM Client c WHERE receiveNewsletter=false order by c.registeredOn") })
public class Client extends Person implements Serializable {
	
	@Enumerated(EnumType.ORDINAL)
	private ClientLevel level = ClientLevel.NewBie;
	/**
	 * 
	 */
	private static final long serialVersionUID = -7419019263095965340L;

	@OneToMany(fetch = FetchType.EAGER, cascade = { CascadeType.ALL })
	@Expose
	private List<Key> addresses = LazyList.decorate(new ArrayList(), new Factory() {
		@Override
		public Object create() {
			return KeyFactory.createKey("", "");
		}
	});

	@OneToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@Expose
	private ContactInfo contact = new ContactInfo();

	@Expose
	private Gender gender = Gender.MALE;

	@Expose
	private Key mainAddress;

	@Expose
	private Boolean receiveNewsletter = Boolean.TRUE;
	
	private Boolean mustVerifyEmail = Boolean.TRUE;

	@OneToMany(mappedBy = "client")
	@Column(name = "mealorders", insertable = true, updatable = true)
	private Set<MealOrder> mealOrders = new HashSet<MealOrder>();

	@OneToOne(optional = false, cascade = CascadeType.ALL)
	@Expose
	private UserBean user = new UserBean();

	public Client(String email) {
		super();
		this.user = new UserBean(email);
		this.contact = new ContactInfo(email);
	}

	public Client() {
		super();

	}

	public Client(UserBean user) {
		super();
		this.user = user;
	}

	public Client(UserBean user, ContactInfo contact, Boolean receiveNewsletter, Gender gender) {
		super();
		this.user = user;
		this.contact = contact;
		this.receiveNewsletter = receiveNewsletter;
		this.gender = gender;
	}

	public List<Key> getAddresses() {
		if (addresses == null) {
			addresses = new ArrayList();
		}
		return addresses;
	}

	public ContactInfo getContact() {
		return contact;
	}

	public Gender getGender() {
		return gender;
	}

	public Key getMainAddress() {
		// TODO setar main address

		return mainAddress;
	}

	public Boolean getReceiveNewsletter() {
		return receiveNewsletter;
	}

	public UserBean getSystemUser() {
		return user;
	}

	public UserBean getUser() {
		return user;
	}

	public void setAddresses(List<Key> addresses) {
		this.addresses = addresses;
	}

	public void setContact(ContactInfo contact) {
		this.contact = contact;
	}

	public void setGender(Gender gender) {
		this.gender = gender;
	}

	public void setMainAddress(Key mainAddress) {
		this.mainAddress = mainAddress;
	}

	public void setReceiveNewsletter(Boolean receiveNewsletter) {
		this.receiveNewsletter = receiveNewsletter;
	}

	public void setUser(UserBean user) {
		this.user = user;
	}

	public Set<MealOrder> getMealOrders() {
		return mealOrders;
	}

	public void setMealOrders(Set<MealOrder> mealOrders) {
		this.mealOrders = mealOrders;
	}

	@Temporal(TemporalType.DATE)
	private Date registeredOn = new Date();
	private String referredFrom = "unknown";

	public String getReferredFrom() {
		return referredFrom;
	}

	public void setReferredFrom(String referredFrom) {
		this.referredFrom = referredFrom;
	}

	public Date getRegisteredOn() {
		return registeredOn;
	}

	public void setRegisteredOn(Date registeredOn) {
		this.registeredOn = registeredOn;
	}
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof Client){
			Client other = (Client)obj;
			return other.getId().equals(this.getId());
		}
		return false;
	}
	public String getMainPhone(){
		return contact.getPhone();
	}

	public Boolean getMustVerifyEmail() {
		return mustVerifyEmail;
	}

	public void setMustVerifyEmail(Boolean mustVerifyEmail) {
		this.mustVerifyEmail = mustVerifyEmail;
	}
	public String getEmail(){
		return this.getUser().getLogin();
	}

	public ClientLevel getLevel() {
		return level;
	}

	public void setLevel(ClientLevel level) {
		this.level = level;
	}
}
