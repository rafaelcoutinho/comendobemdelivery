package br.copacabana.spring.central;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.Restaurant;

import com.google.appengine.api.datastore.KeyFactory;

public class CentralBean {
	private Central central;
	private List<RestaurantMonitorBean> rests = new ArrayList<RestaurantMonitorBean>();
	private Restaurant selected = null;
	private String token;

	public Central getCentral() {
		return central;
	}

	public void setCentral(Central central) {
		this.central = central;
	}

	public List<RestaurantMonitorBean> getRests() {
		Collections.sort(rests);
		return rests;
	}

	public void setRests(List<RestaurantMonitorBean> rests) {
		this.rests = rests;
	}

	public Restaurant getSelected() {
		return selected;
	}

	public String getSelectedKey() {
		return KeyFactory.keyToString(selected.getId());
	}

	public void setSelected(Restaurant selected) {
		this.selected = selected;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

}
