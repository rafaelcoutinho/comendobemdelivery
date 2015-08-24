package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;

@Entity
@NamedQueries({ @NamedQuery(name = "allOldAuthorizations", query = "SELECT c FROM PwdResetAuthorization c where c.requestDate<:date"),

})
public class PwdResetAuthorization {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private Key userId;
	private Date requestDate = new Date();

	public PwdResetAuthorization(Key userid) {
		this.userId = userid;
	}

	public Key getUserId() {
		return userId;
	}

	public void setUserId(Key userId) {
		this.userId = userId;
	}

	public Date getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(Date requestDate) {
		this.requestDate = requestDate;
	}

	public Long getId() {
		return id;
	}
}
