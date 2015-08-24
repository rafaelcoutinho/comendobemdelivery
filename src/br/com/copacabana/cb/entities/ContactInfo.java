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
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ 
	@NamedQuery(name = "getContactInfo", query = "SELECT c FROM ContactInfo c"), 
	@NamedQuery(name = "getContactInfoOrdered", query = "SELECT c FROM ContactInfo c ORDER BY c.email"),
    @NamedQuery(name = "getContactInfoByPhone", query = "SELECT c FROM ContactInfo c WHERE c.phone = :phone"),
	@NamedQuery(name = "getContactInfoByAlternativePhones", query = "SELECT c FROM ContactInfo c WHERE c.alternativePhones = :alternativePhones") })
public class ContactInfo implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String email;
	@Expose
	private String phone;

	public ContactInfo() {
		super();

	}

	public ContactInfo(String email, String phone) {
		super();
		this.email = email;
		this.phone = phone;
	}

	public ContactInfo(String email) {
		super();
		this.email = email;
	}

	@Expose
	private Set<String> alternativePhones = new HashSet<String>();
	@Expose
	private Set<String> faxes = new HashSet<String>();

	public void addAlternativePhones(String alternativePhone) {
		this.alternativePhones.add(alternativePhone);
	}

	public Set<String> getAlternativePhones() {
		return alternativePhones;
	}

	public String getEmail() {
		return email;
	}

	public String getPhone() {
		return phone;
	}

	public void removeAlternativePhones(String alternativePhone) {
		this.alternativePhones.remove(alternativePhone);
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public Set<String> getFaxes() {
		return faxes;
	}

	public void setFaxes(Set<String> faxes) {
		this.faxes = faxes;
	}

	public void setAlternativePhones(Set<String> alternativePhones) {
		this.alternativePhones = alternativePhones;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(this.id);
	}
}
