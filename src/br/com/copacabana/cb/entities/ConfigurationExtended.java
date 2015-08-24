package br.com.copacabana.cb.entities;

import javax.jdo.annotations.PrimaryKey;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Text;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "listExtended", query = "SELECT c FROM ConfigurationExtended c")})
public class ConfigurationExtended {
	@Id
	@Column(name = "id") 
	@PrimaryKey
	@Expose
	private String key;
	@Expose
	private Text value = new Text("");

	public ConfigurationExtended() {
		// TODO Auto-generated constructor stub
	}

	public ConfigurationExtended(String key, String value) {
		this.key = key;
		this.value = new Text(value);
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value.getValue();
	}

	public void setValue(String value) {
		this.value = new Text(value);
	}

}
