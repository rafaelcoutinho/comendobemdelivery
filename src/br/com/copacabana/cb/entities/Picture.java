package br.com.copacabana.cb.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Blob;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "getPicture", query = "Select p from Picture p")})
public class Picture {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Long id;
	private Blob blob = null;
	private Blob small = null;
	private String fileName = "";

	public Picture(Blob blob, String fileName) {
		super();
		this.blob = blob;
		this.fileName = fileName;
	}

	public Picture(Blob blob) {
		super();
		this.blob = blob;
		
	}

	public Blob getBlob() {
		return blob;
	}

	public void setBlob(Blob blob) {
		this.blob = blob;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Blob getSmall() {
		return small;
	}

	public void setSmall(Blob small) {
		this.small = small;
	}
}
