package br.copacabana.spring.client;

import java.util.HashSet;
import java.util.Set;

import br.com.copacabana.cb.entities.Neighborhood;

public class NeighborhoodListBean {
	Set<Neighborhood> set = new HashSet<Neighborhood>();

	public NeighborhoodListBean(Set<Neighborhood> set) {
		super();
		this.set = set;
	}
	

}
