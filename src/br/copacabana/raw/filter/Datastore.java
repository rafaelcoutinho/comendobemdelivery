package br.copacabana.raw.filter;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

public class Datastore {
	protected static final Logger log = Logger.getLogger("copacabana.Persistence");

	private static EntityManager entityManager;
	private static EntityManagerFactory emfInstance = null;

	private static final ThreadLocal<EntityManager> PER_THREAD_PM = new ThreadLocal<EntityManager>();

	public static void initialize() {
		// System.setProperty(DatastoreEntityManagerFactory.DISABLE_DUPLICATE_EMF_EXCEPTION_PROPERTY,
		// "true");
		log.fine("initialized");

		if (entityManager == null || !entityManager.isOpen()) {
			Map<String, Object> m = new HashMap<String, Object>();
			m.put("datanucleus.identifier.case", "UpperCase");

			emfInstance = Persistence.createEntityManagerFactory("ComendoBemPersist", m);
			entityManager = emfInstance.createEntityManager();

		}
		// if (PMF != null) {
		// throw new IllegalStateException("initialize() already called");
		// }
		// PMF = JDOHelper.getPersistenceManagerFactory("jdo.properties");
	}

	public static EntityManager getPersistanceManager() {
		EntityManager pm = PER_THREAD_PM.get();
		if (pm == null) {
			pm = emfInstance.createEntityManager();
			PER_THREAD_PM.set(pm);
		}

		return pm;
	}

	public static void finishRequest() {
		log.fine("finished");

		EntityManager pm = PER_THREAD_PM.get();
		if (pm != null && pm.isOpen()) {
			PER_THREAD_PM.remove();
			EntityTransaction tx = pm.getTransaction();
			if (tx.isActive()) {
				tx.rollback();
			}
			pm.close();
		}
	}
}
