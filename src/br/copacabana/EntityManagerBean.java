package br.copacabana;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

import br.copacabana.raw.filter.Datastore;

public class EntityManagerBean {
	private EntityManager entityManager;
	private EntityManagerFactory emfInstance=null;
private String mutex="";
	public static EntityManager getEntityManager() {
		
//		System.setProperty(DatastoreEntityManagerFactory.DISABLE_DUPLICATE_EMF_EXCEPTION_PROPERTY, "true");
//		synchronized (mutex) {
//			if (entityManager == null || !entityManager.isOpen()) {
//				 Map<String, Object> m = new HashMap<String, Object>();
//				 m.put("datanucleus.identifier.case", "UpperCase");
//				
//				emfInstance= Persistence.createEntityManagerFactory("ComendoBemPersist",m);
//				entityManager = emfInstance.createEntityManager();
//			}
//			return entityManager;
//		}
		Datastore.initialize();
		return Datastore.getPersistanceManager();
	}
	@Deprecated
	public void flush() {
		synchronized (mutex) {
			if(entityManager!=null){
				entityManager.flush();
				entityManager.close();
				emfInstance.close();
			}			
			entityManager=null;
			
		}
	}
	public void finish(){
		Datastore.finishRequest();
	}

}
