package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
@NamedQueries( { @NamedQuery(name = "getPerson", query = "SELECT p FROM Person p"), @NamedQuery(name = "getPersonOrdered", query = "SELECT p FROM Person p ORDER BY p.id"), @NamedQuery(name = "getPersonByName", query = "SELECT p FROM Person p WHERE p.name = :name"), @NamedQuery(name = "getPersonByEmail", query = "SELECT p FROM Person p WHERE p.email.email = :email_email") })
public abstract class Person {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String name;
	@Expose
	private String rg;
	@Expose
	private String cpf;
	@Expose
	@Temporal(TemporalType.DATE)
	private Date birthday;
	

	public enum Gender {
		MALE, FEMALE
	};

	
	public Key getId() {
		return id;
	}
	public String getIdStr() {
		return KeyFactory.keyToString(id);
	}
	public String getName() {
		return name;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRg() {
		return rg;
	}

	public void setRg(String rg) {
		this.rg = rg;
	}

	public String getCpf() {
		return cpf;
	}

	public void setCpf(String cpf) {
		this.cpf = cpf;
	}

	
	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}


}
