package br.copacabana;

import br.com.copacabana.cb.entities.mgr.Manager;

public interface Command<E> {
	public void execute() throws Exception;

	public void execute(Manager manager) throws Exception;
}
