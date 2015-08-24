package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.mgr.Manager;

import com.google.appengine.api.datastore.KeyFactory;

public class KeyWrapperPropertyEditor extends PropertyEditorSupport {

	private Manager lookupManager;

	public KeyWrapperPropertyEditor(Manager lookupManager) {
		this.lookupManager = lookupManager;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {

		if (text != null && !text.equals("")) {
			KeyWrapper kw = new KeyWrapper();
			kw.setK(KeyFactory.stringToKey(text));

			setValue(kw);
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
