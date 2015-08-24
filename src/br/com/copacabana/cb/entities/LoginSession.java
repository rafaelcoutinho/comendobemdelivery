package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "listLoggedRestaurants", query = "SELECT ls FROM LoginSession ls where ls.loggedOut is null and type='RESTAURANT'"),

})
public class LoginSession implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4372459669484288171L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;

	@Expose
	private String type = "RESTAURANT";
	@Expose
	private Key loggedKey;
	@Expose
	@Temporal(TemporalType.DATE)
	private Date loggedIn = new Date();
	@Expose
	@Temporal(TemporalType.DATE)
	private Date loggedOut = new Date();

	@Expose
	private String basicInfo;

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Key getLoggedKey() {
		return loggedKey;
	}

	public void setLoggedKey(Key loggedKey) {
		this.loggedKey = loggedKey;
	}

	public Date getLoggedIn() {
		return loggedIn;
	}

	public void setLoggedIn(Date loggedIn) {
		this.loggedIn = loggedIn;
	}

	public Date getLoggedOut() {
		return loggedOut;
	}

	public void setLoggedOut(Date loggedOut) {
		this.loggedOut = loggedOut;
	}

	public String getBasicInfo() {
		return basicInfo;
	}

	public void setBasicInfo(String basicInfo) {
		this.basicInfo = basicInfo;
	}

}
