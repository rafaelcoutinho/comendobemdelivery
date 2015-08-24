package br.copacabana.order;

import br.com.copacabana.cb.entities.Plate;

public class PlateData {
	Plate plate;
	int qty=0;
	public Plate getPlate() {
		return plate;
	}
	public void setPlate(Plate plate) {
		this.plate = plate;
	}
	public int getQty() {
		return qty;
	}
	public void setQty(int qty) {
		this.qty = qty;
	}
}
