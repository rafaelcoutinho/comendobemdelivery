package br.copacabana.spring.client;

import br.com.copacabana.cb.entities.Neighborhood;

public class NeighborhoodBean {
	Neighborhood neigh;

	public NeighborhoodBean(Neighborhood neigh) {
		super();
		this.neigh = neigh;
	}

	public Neighborhood getNeigh() {
		return neigh;
	}

	public void setNeigh(Neighborhood neigh) {
		this.neigh = neigh;
	}
	
}
