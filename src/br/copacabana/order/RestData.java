package br.copacabana.order;

public class RestData {
	String name;
	Boolean isOpen;
	String id;

	public RestData() {
	}

	public RestData(String restKey, String name2, Boolean open) {
		this.id = restKey;
		this.name = name2;
		this.isOpen = open;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getIsOpen() {
		return isOpen;
	}

	public void setIsOpen(Boolean isOpen) {
		this.isOpen = isOpen;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

}
