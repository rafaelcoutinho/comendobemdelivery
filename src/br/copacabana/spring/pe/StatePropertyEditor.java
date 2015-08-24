package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;

import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.raw.filter.Datastore;

public class StatePropertyEditor extends PropertyEditorSupport {

	private Manager<State> lookupManager;

	public StatePropertyEditor(Manager<State> lookupManager) {
		this.lookupManager = lookupManager;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {

		if (text != null && !text.equals("")) {
			Long id = Long.valueOf(text);
			State person = Datastore.getPersistanceManager().find(State.class, id);
			setValue(person);
		} else {
			setValue(null);
		}

	}

	@Override
	public String getAsText() {
		State person = (State) getValue();
		if (person == null) {
			return "";
		}
		return person.getName();
	}

}
