package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;

@Entity
@NamedQueries({

@NamedQuery(name = "allInvitations", query = "SELECT c FROM Invitation c"), 
@NamedQuery(name = "allUserInvitations", query = "SELECT c FROM Invitation c where from=:userid order by status, lastStatusChange,date"),
@NamedQuery(name = "getInvitationsToEmail", query = "SELECT c FROM Invitation c where email=:email"), 
@NamedQuery(name = "getInvitationsToEmailFromUser", query = "SELECT c FROM Invitation c where email=:email and from=:userid"),
@NamedQuery(name = "getNotConfirmedInvitationsToEmail", query = "SELECT c FROM Invitation c where email=:email and status not in ('CONFIRMED')"),
@NamedQuery(name = "allConfirmedUserInvitationsFromDate", query = "SELECT c FROM Invitation c where from=:userid and lastStatusChange>:since and status='CONFIRMED'"),
@NamedQuery(name = "getConfirmedInvitationsRange", query = "SELECT c FROM Invitation c where lastStatusChange<=:until and lastStatusChange>:from and status='CONFIRMED'"),
@NamedQuery(name = "getMyInviter", query = "SELECT c.from FROM Invitation c where email=:email and status='CONFIRMED'")




})
public class Invitation {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	private Key from;
	private String email;
	private String name;
	@Temporal(TemporalType.DATE)
	private Date date = new Date();
	@Enumerated(EnumType.STRING)
	private InvitationState status = InvitationState.NEW;
	@Temporal(TemporalType.DATE)
	private Date lastStatusChange = new Date();

	public Invitation(Key userId, String email2) {
		this.from = userId;
		this.email = email2;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Key getFrom() {
		return from;
	}

	public void setFrom(Key from) {
		this.from = from;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public InvitationState getStatus() {
		return status;
	}

	public void setStatus(InvitationState status) {
		lastStatusChange = new Date();
		this.status = status;
	}

	public Date getLastStatusChange() {
		return lastStatusChange;
	}

	public void setLastStatusChange(Date lastStatusChange) {
		this.lastStatusChange = lastStatusChange;
	}

}
