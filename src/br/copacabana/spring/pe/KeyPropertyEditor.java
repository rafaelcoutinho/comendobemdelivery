package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class KeyPropertyEditor extends PropertyEditorSupport {
	@Override
	public void setAsText(String text) throws IllegalArgumentException {

		if (text != null && !text.equals("")) {
			Key id = KeyFactory.stringToKey(text);

			setValue(id);
		} else {
			setValue(null);
		}
	}

	@Override
	public String getAsText() {
		Key key = (Key) getValue();
		if (key == null) {
			return "";
		}
		return KeyFactory.keyToString(key);
	}
}
