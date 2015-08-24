package br.copacabana.usecase.menu;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import br.com.copacabana.cb.entities.Plate;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

public class RestMenuBean implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4593070059435407837L;
	@Expose
	Key[] highlights=new Key[0];
	@Expose
	List<Plate> plates=new ArrayList<Plate>();

	public RestMenuBean(Key[] highlights, List<Plate> plates) {
		super();
		this.highlights = highlights;
		this.plates = plates;
	}

	public Key[] getHighlights() {
		return highlights;
	}

	public void setHighlights(Key[] highlights) {
		this.highlights = highlights;
	}

	public List<Plate> getPlates() {
		return plates;
	}

	public void setPlates(List<Plate> plates) {
		this.plates = plates;
	}

}
