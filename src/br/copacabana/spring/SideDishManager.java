package br.copacabana.spring;

import br.com.copacabana.cb.entities.SideDish;
import br.com.copacabana.cb.entities.mgr.JPAManager;
import br.copacabana.EntityManagerBean;

public class SideDishManager extends JPAManager<SideDish> {
	public SideDishManager(EntityManagerBean em) {
		super(em);
	}

	@Override
	public String getDefaultQueryName() {

		return "getSideDish";
	}
}
