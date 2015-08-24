package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class FoodCategoryPropertyEditor extends PropertyEditorSupport {

	private Manager<FoodCategory> lookupManager;

	public FoodCategoryPropertyEditor(Manager<FoodCategory> lookupManager) {
		this.lookupManager = lookupManager;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {

		if (text != null && !text.equals("")) {
			Key id = KeyFactory.stringToKey(text);
			FoodCategory person = Datastore.getPersistanceManager().find(FoodCategory.class,id);
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
	}}
