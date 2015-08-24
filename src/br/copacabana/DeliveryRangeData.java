package br.copacabana;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.DeliveryRange;
import br.com.copacabana.cb.entities.Neighborhood;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

public class DeliveryRangeData implements Comparable<DeliveryRangeData>{
	/**
	 * 
	 */

	public DeliveryRangeData(Neighborhood neighborhood, DeliveryRange deliveryRange, City c) {
		super();

		this.city = c;
		this.neighborhood = neighborhood;
		this.deliveryRange = deliveryRange;
	}

	@Expose
	Neighborhood neighborhood;
	@Expose
	DeliveryRange deliveryRange;
	@Expose
	City city;

	public Neighborhood getNeighborhood() {
		return neighborhood;
	}
	public String getNeighborhoodId(){
		return KeyFactory.keyToString(getNeighborhood().getId());
	}
	public String getDeliveryRangeId(){
		return KeyFactory.keyToString(getDeliveryRange().getId());
	}
	public String getCityId(){
		return KeyFactory.keyToString(getCity().getId());
	}
	public void setNeighborhood(Neighborhood neighborhood) {
		this.neighborhood = neighborhood;
	}

	public DeliveryRange getDeliveryRange() {
		return deliveryRange;
	}

	public void setDeliveryRange(DeliveryRange deliveryRange) {
		this.deliveryRange = deliveryRange;
	}
	public City getCity() {
		return city;
	}
	public void setCity(City city) {
		this.city = city;
	}
	
	@Override
	public int compareTo(DeliveryRangeData o) {
		if(this.getNeighborhood()==null || o.getNeighborhood()==null){
			return this.getCity().getName().compareTo(o.getCity().getName());
		}else{
			return this.getNeighborhood().getName().compareTo(o.getNeighborhood().getName());
		}
		
	}

}