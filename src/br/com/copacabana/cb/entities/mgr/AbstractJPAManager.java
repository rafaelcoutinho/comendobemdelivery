package br.com.copacabana.cb.entities.mgr;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import br.copacabana.EntityManagerBean;
import br.copacabana.raw.filter.Datastore;

public abstract class AbstractJPAManager<E> implements Manager<E> {
	protected static final Logger log = Logger.getLogger("copacabana.Managers");

	public abstract String getDefaultQueryName();

	public List query(String query) {
		return this.list(query, new HashMap<String, Object>());
	}

	@Override
	public List<E> list(String qname) {
		return query(qname);
	}

	@Override
	public List<E> list() {
		return query(getDefaultQueryName());
	}

	@Override
	public List<E> list(String qname, Map<String, Object> m) {
		Query query = Datastore.getPersistanceManager().createNamedQuery(qname);
		if (m != null) {
			for (Iterator iterator = m.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry<String, Object> entry = (Map.Entry<String, Object>) iterator.next();
				query.setParameter(entry.getKey(), entry.getValue());
			}
		}
		return query.getResultList();
	}

	public E create(E obj) throws Exception {
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().persist(obj);
		Datastore.getPersistanceManager().getTransaction().commit();
		return obj;
	}

	// TODO Check if ok?
	public String delete(E sideDishes) throws Exception {
		EntityManager em = Datastore.getPersistanceManager();
		try {
			em.getTransaction().begin();
			sideDishes = em.merge(sideDishes);
			em.remove(sideDishes);
			em.getTransaction().commit();
		} catch (Exception ex) {
			ex.printStackTrace();
			try {
				if (em.getTransaction().isActive()) {
					em.getTransaction().rollback();
				}
			} catch (Exception e) {
				ex.printStackTrace();
				throw e;
			} finally {

				em.getTransaction().rollback();
			}
			throw ex;
		}
		return "";
	}

	@Override
	public EntityManagerBean getEntityManagerBean() {

		return null;
	}

	@Override
	public E update(E obj) throws Exception {
		Datastore.getPersistanceManager().merge(obj);
		return obj;
	}

	@Override
	public E persist(E obj) throws Exception {
		Datastore.getPersistanceManager().persist(obj);
		return obj;
	}

	@Override
	public E find(Object id, Class c) {
		return (E) Datastore.getPersistanceManager().find(c, id);
	}

	public E get(Object id) {
		return (E) Datastore.getPersistanceManager().find(this.getEntityClass(), id);
	}

	protected abstract Class getEntityClass();

	@Override
	public void endTransaction() {
		System.err.println("?? endtransaction");

	}

	@Override
	public String deleteInTransaction(E obj) throws Exception {
		System.err.println("?? endtransaction");
		return null;
	}

}
