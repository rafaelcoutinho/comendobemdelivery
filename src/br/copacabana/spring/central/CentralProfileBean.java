package br.copacabana.spring.central;

import org.springframework.beans.BeanUtils;

import br.com.copacabana.cb.entities.Central;

import com.google.appengine.api.datastore.KeyFactory;

public class CentralProfileBean extends Central {
	public CentralProfileBean() {
		
	}
	public CentralProfileBean(Central central) {
		BeanUtils.copyProperties(central, this);
	}

	public String getIdStr() {
		return KeyFactory.keyToString(this.getId());
	}

	public String getUserId() {
		return KeyFactory.keyToString(this.getUser().getId());
	}

	public String getContactId() {
		return KeyFactory.keyToString(this.getContact().getId());
	}
}
