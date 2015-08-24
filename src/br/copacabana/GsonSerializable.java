package br.copacabana;

import java.util.Map;

import br.com.copacabana.cb.entities.mgr.Manager;

public interface GsonSerializable {

	
	Map<Class, Object> getGsonAdapters(Manager man);

}
