package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.CityManager;

import com.google.appengine.api.datastore.KeyFactory;

public class CityPropertyEditor extends PropertyEditorSupport {

	private Manager lookupManager;

	public CityPropertyEditor(Manager lookupManager) {
		this.lookupManager = lookupManager;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {

		if (text != null && !text.equals("")) {
			CityManager cityMan = new CityManager();
			City person = cityMan.find(KeyFactory.stringToKey(text), City.class);
			setValue(person);
		} else {
			setValue(null);
		}

	}

	@Override
	public String getAsText() {
		City person = (City) getValue();
		if (person == null) {
			return "";
		}
		return person.getName();
	}

}
