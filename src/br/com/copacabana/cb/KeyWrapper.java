package br.com.copacabana.cb;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

import javax.persistence.Basic;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Transient;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@Embeddable
public class KeyWrapper<E> implements Serializable{

	@Basic(fetch=FetchType.EAGER)
	@Expose
	private Key k;
	
	@Transient
	@Expose
	public E value;

	public Key getK() {
		
		return k;
	}

	public void setK(Key k) {
		
		this.k = k;
	}

	public E getValue() {
		return value;
	}

	public void setValue(E obj) {
		this.value = obj;
		try {

			this.k = (Key) obj.getClass().getMethod("getId", null).invoke(obj, new Object[0]);

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
	}

	public static KeyWrapper wrap(Object ad) {
		KeyWrapper kw = new KeyWrapper();
		kw.setValue(ad);
		return kw;

	}


}
