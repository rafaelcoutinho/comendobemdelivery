package br.copacabana.spring;

import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;

public class StateManager extends AbstractJPAManager<State> {

	public StateManager() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "getStates";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return State.class;
	}

}
