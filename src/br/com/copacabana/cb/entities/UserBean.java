package br.com.copacabana.cb.entities;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getUser", query = "SELECT s FROM UserBean s"), @NamedQuery(name = "getUserOrdered", query = "SELECT s FROM UserBean s ORDER BY s.login"), @NamedQuery(name = "getUserByStatus", query = "SELECT s FROM UserBean s WHERE s.status = :status"), @NamedQuery(name = "getUserByLogin", query = "SELECT s FROM UserBean s WHERE s.login = :login"), @NamedQuery(name = "getUserByFBId", query = "SELECT s FROM UserBean s WHERE s.facebookId = :facebookId") })
public class UserBean implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -493534287629889952L;

	public enum Queries {
		getUser, getUserOrdered, getUserByStatus, getUserByLogin
	};

	public enum UserStatus {
		BLOCKED, NORMAL
	};

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private Boolean isFacebook = Boolean.FALSE;
	@Expose
	private String facebookId = "";

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	@Expose
	private String login;
	@Enumerated(EnumType.STRING)
	@Expose
	private UserStatus status = UserStatus.NORMAL;

	private String password;

	public UserBean(String login, String password) {
		super();
		this.login = login;
		this.password = password;
	}

	public UserBean(String email) {
		this.setLogin(email);
	}

	public UserBean() {
		// TODO Auto-generated constructor stub
	}

	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	public UserStatus getStatus() {
		return status;
	}

	public void setStatus(UserStatus status) {
		this.status = status;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Boolean getIsFacebook() {
		return isFacebook;
	}

	public void setIsFacebook(Boolean isFacebook) {
		this.isFacebook = isFacebook;
	}

	public String getFacebookId() {
		return facebookId;
	}

	public void setFacebookId(String facebookId) {
		this.facebookId = facebookId;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(this.id);
	}

	public boolean isRestaurant() {		
		return "RESTAURANT".equals(this.getId().getParent().getKind());
	}
	public boolean isClient() {		
		return "CLIENT".equals(this.getId().getParent().getKind());
	}
	public boolean isCentral() {		
		return "CENTRAL".equals(this.getId().getParent().getKind());
	}
}
