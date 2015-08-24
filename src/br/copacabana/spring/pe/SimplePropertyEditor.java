package br.copacabana.spring.pe;

import java.beans.PropertyEditorSupport;
import java.lang.reflect.InvocationTargetException;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class SimplePropertyEditor<E> extends PropertyEditorSupport {

	private Manager<E> lookupManager;
	private Class clazz;

	public SimplePropertyEditor(Manager<E> lookupManager, Class clazz) {
		this.lookupManager = lookupManager;
		this.clazz = clazz;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {
		try {
			if (text != null && !text.equals("")) {
				Key id = KeyFactory.stringToKey(text);

				setValue(Datastore.getPersistanceManager().find(this.clazz, id));
			} else {
				setValue(null);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			throw new IllegalArgumentException(e.getMessage());
		}

	}

	@Override
	public String getAsText() {
		Object obj = getValue();
		try {
			return (String) obj.getClass().getMethod("getName", String.class).invoke(obj, new Object[0]);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";

	}

}
