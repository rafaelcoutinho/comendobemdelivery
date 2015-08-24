package br.com.copacabana.cb.app;

import javax.jdo.annotations.PrimaryKey;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "listAllConf", query = "SELECT c FROM Configuration c")})
public class Configuration {
	@Id
	@Column(name = "id")
	@PrimaryKey
	@Expose
	private String key;
	@Expose
	private String value;

	public Configuration() {
		// TODO Auto-generated constructor stub
	}

	public Configuration(String key, String value) {
		this.key = key;
		this.value = value;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}
