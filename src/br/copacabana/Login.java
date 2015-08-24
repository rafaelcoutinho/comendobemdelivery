package br.copacabana;

import java.io.Serializable;

import br.com.copacabana.cb.entities.Person;

import com.google.gson.annotations.Expose;

/**
 * This POJO represent Person_login
 * 
 * @hibernate.class schema="vistrada.xpn" table="LOGIN"
 * @author Jia, Stas
 */
public class Login implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3959634239624920849L;
	@Expose
	private Long id = new Long(-1);
	@Expose
	private String username;
	@Expose
	private String password;
	
	private String pwencrypt;
	
	public String getPwencrypt() {
		return pwencrypt;
	}


	public void setPwencrypt(String pwencrypt) {
		this.pwencrypt = pwencrypt;
	}


	@Expose
	private boolean temporary = false;
	
	private Person person;


	public String getUsername() {
		return username;
	}
	

	public void setUsername(String username) {
		this.username = username;
	}

	public boolean isTemporary() {
		return temporary;
	}

	public void setTemporary(boolean temporary) {
		this.temporary = temporary;
	}

	public Person getPerson() {
		return person;
	}

	public void setPerson(Person person) {
		this.person = person;
	}

	public Login() {
	};

	/** @see java.lang.Object#hashCode() */
	@Override
	public int hashCode() {
		final Long thisId = getId();
		return thisId == null ? 0 : thisId.hashCode();
	}

	/** @see java.lang.Object#equals(java.lang.Object) */
	@Override
	public boolean equals(Object obj) {
		if (obj == null || !(obj instanceof Login))
			return false;
		else if (this == obj)
			return true;

		final Long id = getId(), id2 = ((Login) obj).getId();
		return id == null ? id2 == null : id.equals(id2);
	}

	/**
	 * @return the id
	 * @hibernate.id generator-class="identity" unsaved-value="undefined"
	 * @hibernate.column name="ID"
	 */
	public Long getId() {
		return id;
	}

	/***
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password
	 *            the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}


	/** @see java.lang.Object#toString() */
	@Override
	public String toString() {
		final StringBuffer buf = new StringBuffer();

		buf.append("{Login: id=").append(getId());
		buf.append(", username='").append(username).append("'");
		buf.append(", password='").append(password).append("'");
		buf.append(", temporary='").append(temporary).append("'");
		return buf.toString();
	}
}
