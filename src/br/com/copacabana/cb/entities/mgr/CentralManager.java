package br.com.copacabana.cb.entities.mgr;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.UserBean;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class CentralManager extends AbstractJPAManager<Central> {

	@Override
	public String getDefaultQueryName() {

		return "allCentrals";
	}

	public Central getCentralByUserBean(UserBean login) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getCentralByUserBean");
		query.setParameter("login", login);
		return (Central) query.getSingleResult();

	}

	private Central central = null;

	public boolean isRestaurantManagedByCentral(Key restaurant) {
		try {
			central = null;
			Query query = Datastore.getPersistanceManager().createNamedQuery("getRestaurantsCentral");
			query.setParameter("restaurant", restaurant);
			central = (Central) query.getSingleResult();
			return true;
		} catch (NoResultException e) {
			return false;
		}

	}

	public Central getRestaurantCentral() {
		if (central == null) {
			throw new IllegalStateException("Must be called after isRestaurantManagedByCentral");
		}

		return central;
	}

	public Central getCentralByUniqueURL(String uniqueUrlName) {
		Query query = Datastore.getPersistanceManager().createNamedQuery("getCentralByUrl");
		query.setParameter("uniqueUrl", uniqueUrlName);
		return (Central) query.getSingleResult();

	}

	@Override
	protected Class getEntityClass() {

		return Central.class;
	}
}
