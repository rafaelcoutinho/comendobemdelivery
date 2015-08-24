package br.copacabana;

public class SearchCriteria {
	private String city;
	private String neighbor;
	private String zip;
	private String freeform;
	private String openStatus;

	public String getNeighbor() {
		return neighbor;
	}

	public void setNeighbor(String neighbor) {
		this.neighbor = neighbor;
	}

	public String getZip() {
		return zip;
	}

	public void setZip(String zip) {
		this.zip = zip;
	}

	public String getFreeform() {
		return freeform;
	}

	public void setFreeform(String freeform) {
		this.freeform = freeform;
	}

	public String getOpenStatus() {
		return openStatus;
	}

	public void setOpenStatus(String openStatus) {
		this.openStatus = openStatus;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

}
