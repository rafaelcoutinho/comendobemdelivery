package br.com.copacabana.cb.entities.mgr;

import java.security.NoSuchAlgorithmException;

import br.com.copacabana.cb.entities.PwdResetAuthorization;
import br.com.copacabana.cb.entities.UserBean;
import br.copacabana.Authentication;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.UserBeanManager;


public class PasswordManager extends AbstractJPAManager<PwdResetAuthorization> {

	
	
	public PwdResetAuthorization get(Long k) {
		return (PwdResetAuthorization) Datastore.getPersistanceManager().find(PwdResetAuthorization.class, k);
	}

	public String getAuthorizationToken(PwdResetAuthorization pra) throws NoSuchAlgorithmException {
		UserBean u = new UserBeanManager().get(pra.getUserId());
		return Authentication.getMD5Digets(pra.getId().toString() + u.getLogin()).toString();		
	}

	public boolean isExpired(PwdResetAuthorization pAuth) {
		return false;
	}
	@Override
	public String getDefaultQueryName() {
		return null;
	}
	@Override
	protected Class getEntityClass() {
		return PwdResetAuthorization.class;
	}
}
