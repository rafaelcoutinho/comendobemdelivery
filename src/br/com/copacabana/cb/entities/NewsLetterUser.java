package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@NamedQueries({

@NamedQuery(name = "allNewsLetters", query = "SELECT c FROM NewsLetterUser c"), 
@NamedQuery(name = "allNewsLetterByEmail", query = "SELECT c FROM NewsLetterUser c where email=:email"),
@NamedQuery(name = "usersByReceiveStatus", query = "SELECT c FROM NewsLetterUser c where receiveNewsletter=:status order by lastStatusChange"),

})
public class NewsLetterUser {

	private String name;
	@Id
	private String email;
	private String comment;
	private Boolean receiveNewsletter = Boolean.TRUE;

	@Temporal(TemporalType.DATE)
	private Date date = new Date();

	@Temporal(TemporalType.DATE)
	private Date lastStatusChange = new Date();

	public NewsLetterUser(String email2, String name2) {
		email = email2;
		name = name2;
	}

	public String getName() {
		return name;
	}

	public void setName(String nome) {
		this.name = nome;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Boolean getReceiveNewsletter() {
		return receiveNewsletter;
	}

	public void setReceiveNewsletter(Boolean receiveNewsletter) {
		this.lastStatusChange = new Date();
		this.receiveNewsletter = receiveNewsletter;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public Date getLastStatusChange() {
		return lastStatusChange;
	}

	public void setLastStatusChange(Date lastStatusChange) {
		this.lastStatusChange = lastStatusChange;
	}

}
