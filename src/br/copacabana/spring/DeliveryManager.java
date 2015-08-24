package br.copacabana.spring;

import br.com.copacabana.cb.entities.DeliveryRange;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;

public class DeliveryManager extends AbstractJPAManager<DeliveryRange> {

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return DeliveryRange.class;
	}

}
