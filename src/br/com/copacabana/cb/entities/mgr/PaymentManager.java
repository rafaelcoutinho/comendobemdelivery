package br.com.copacabana.cb.entities.mgr;

import br.com.copacabana.cb.entities.Payment;

public class PaymentManager extends AbstractJPAManager<Payment> {

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "getPayment";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return Payment.class;
	}

}
