package br.copacabana.usecase.beans;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.PlateStatus;
import br.com.copacabana.cb.entities.RestPlateHighlights;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.marshllers.PlateWrapperSerializer;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class ShowRestaurantBean {
	public ShowRestaurantBean(Restaurant rest, Plate selectedPlate) {
		super();
		this.rest = rest;
		restaurantKeyStr = KeyFactory.keyToString(rest.getId());
		this.selectedPlate = selectedPlate;
	}

	private Restaurant rest;
	private Address address;
	private String restaurantKeyStr;
	private Plate selectedPlate;

	public Restaurant getRestaurant() {
		return rest;
	}

	/**
	 * somente dos highlights
	 * 
	 * @return
	 */
	public List<String> getPlateImages() {
		List<String> l = new ArrayList<String>();

		for (Iterator<Plate> iterator = rest.getPlates().iterator(); iterator.hasNext();) {
			Plate p = (Plate) iterator.next();
			if (high.getPlates().contains(p.getId())) {
				if (p.getImageUrl() != null && p.getImageUrl().length() > 0) {
					l.add(p.getImageUrl().substring(1));
				}
			}
		}
		return l;
	}

	public String getPlatesItemStore() {
		StringBuilder builder = new StringBuilder("{ identifier:\"id\", label: \"name\", items: [");
		if (rest.getPlates().size() == 0) {
			builder.append("]}");
			return builder.toString();
		}
		PlateWrapperSerializer pser = new PlateWrapperSerializer();
		for (Iterator<Plate> iterator = rest.getPlates().iterator(); iterator.hasNext();) {
			Plate p = (Plate) iterator.next();
			String str = pser.serialize(p, null, null).toString();
			builder.append(str);
			builder.append(",");
		}
		builder.setLength(builder.length() - 1);
		builder.append("]}");
		return builder.toString();

	}

	public String getPlatesItemStoreOnlyAvailable() {

		StringBuilder builder = new StringBuilder("{ highlights: [ ");
		for (Iterator iterator = high.getPlates().iterator(); iterator.hasNext();) {
			Key type = (Key) iterator.next();
			builder.append("'");
			builder.append(KeyFactory.keyToString(type));
			builder.append("',");
		}
		builder.setLength(builder.length() - 1);
		builder.append("],plates:[");
		if (rest.getPlates().size() == 0) {
			builder.append("]}");
			return builder.toString();
		}
		PlateWrapperSerializer pser = new PlateWrapperSerializer();
		for (Iterator<Plate> iterator = rest.getPlates().iterator(); iterator.hasNext();) {
			Plate p = (Plate) iterator.next();
			if (p.getStatus().equals(PlateStatus.AVAILABLE)) {
				String str = pser.serialize(p, null, null).toString();
				builder.append(str);
				builder.append(",");
			}
		}
		builder.setLength(builder.length() - 1);
		builder.append("]}");
		return builder.toString();

	}

	public String getPaymentsArrayString() {

		if (rest.getAcceptablePayments().size() == 0) {
			return "[]";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("[\"");
		for (Iterator iterator = rest.getAcceptablePayments().iterator(); iterator.hasNext();) {
			String type = (String) iterator.next();
			sb.append(type).append("\",\"");
		}

		sb.setLength(sb.length() - 2);
		sb.append("]");
		return sb.toString();

	}

	public void setRest(Restaurant rest) {
		this.rest = rest;
	}

	public Plate getSelectedPlate() {
		return selectedPlate;
	}

	public void setSelectedPlate(Plate selectedPlate) {
		this.selectedPlate = selectedPlate;
	}

	public String getRestaurantKeyStr() {
		return restaurantKeyStr;
	}

	public void setRestaurantKeyStr(String restaurantKeyStr) {
		this.restaurantKeyStr = restaurantKeyStr;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	RestPlateHighlights high;

	public void setHighlights(RestPlateHighlights high) {
		this.high = high;

	}

}
