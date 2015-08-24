package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;

import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class NeighborPropertyEditor extends PropertyEditorSupport {

	private Manager<Neighborhood> lookupManager;

	public NeighborPropertyEditor(Manager<Neighborhood> lookupManager) {
		this.lookupManager = lookupManager;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {

		if (text != null && !text.equals("")) {
			Key id = KeyFactory.stringToKey(text);
			Neighborhood person = Datastore.getPersistanceManager().find(Neighborhood.class, id);
			setValue(person);
		} else {
			setValue(null);
		}

	}

	@Override
	public String getAsText() {
		Neighborhood person = (Neighborhood) getValue();
		if (person == null) {
			return "";
		}
		return person.getName();
	}

}
