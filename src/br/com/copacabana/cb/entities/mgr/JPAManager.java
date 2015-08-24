package br.com.copacabana.cb.entities.mgr;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityManager;
import javax.persistence.Query;

import br.com.copacabana.cb.KeyWrapper;
import br.copacabana.EntityManagerBean;

public class JPAManager<E> implements Manager<E> {
	private static final String ENTITY_PACKAGE_PREFIX = "br.com.copacabana.cb.entities.";
	protected static EntityManager em = null;
	protected static EntityManagerBean em2;

	public EntityManagerBean getEntityManagerBean() {
		return em2;
	}

	public List query(String query){
		Query q = em.createQuery(query);        
		return q.getResultList();//(List<FoodCategory>) manager.list("getFoodCategories", m);
	}
	public JPAManager(EntityManagerBean em2) {
//		if (em == null) {
//			em = em2.getEntityManager();
//		}
//		this.em2 = em2;
	}

	public JPAManager() {

	}

	public JPAManager(JPAManager jpam) {
		this.em2 = jpam.em2;
		if (em == null) {
			em = EntityManagerBean.getEntityManager();
		}

	}

	protected EntityManager getEntityManager() {
		if (em == null) {
			// EntityManagerFactory emf =
			// Persistence.createEntityManagerFactory("ComendoBemPersist");
			
			em = EntityManagerBean.getEntityManager();// emf.createEntityManager();
		}
		return em;
	}

	// @Action(Action.ACTION_TYPE.CREATE)
	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#create(E)
	 */
	public E create(E user) throws Exception {
		EntityManager em = getEntityManager();
		try {
			boolean commit = false;
			// if (!em.getTransaction().isActive()) {
			em.getTransaction().begin();
			commit = true;
			// }
			em.persist(user);
			if (commit) {
				em.getTransaction().commit();
			}

		} catch (Exception ex) {
			try {
				if (em.getTransaction().isActive()) {
					em.getTransaction().rollback();
				}
			} catch (Exception e) {
				ex.printStackTrace();
				throw e;
			}
			throw ex;
		}
		return user;
	}

	// @Action(Action.ACTION_TYPE.DELETE)
	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#delete(E)
	 */
	public String delete(E sideDishes) throws Exception {
		EntityManager em = getEntityManager();
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
		} finally {
			// em.close();

		}
		return "";
	}
	public String deleteInTransaction(E sideDishes) throws Exception {
		EntityManager em = getEntityManager();
		try {			
			em.remove(sideDishes);			
		} catch (Exception ex) {
			
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
		} finally {
			// em.close();

		}
		return "";
	}

	// @Action(Action.ACTION_TYPE.UPDATE)
	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#update(E)
	 */
	public E update(E sideDishes) throws Exception {
		EntityManager em = getEntityManager();
		try {
			em.getTransaction().begin();
			sideDishes = em.merge(sideDishes);
			em.getTransaction().commit();
		} catch (Exception ex) {
			try {
				if (em.getTransaction().isActive()) {
					em.getTransaction().rollback();
				}
			} catch (Exception e) {
				ex.printStackTrace();
				throw e;
			}
			throw ex;
		} finally {
			// em.close();
		}
		return sideDishes;
	}

	// @Action(Action.ACTION_TYPE.FIND)
	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#find(java.lang.Object,
	 * java.lang.Class)
	 */
	public E find(Object id, Class c) {
		E sideDishes = null;
		EntityManager em = getEntityManager();
		try {
			
			sideDishes = (E) em.find(c, id);
			loadAssociations(sideDishes, em);
		} catch (java.lang.IllegalArgumentException e) {
			e.printStackTrace();
			return null;
		} finally {
			// em.close();
		}
		return sideDishes;
	}
	
	public Object findObj(Object id, Class c) {
		
		EntityManager em = getEntityManager();
		try {
			
			Object sideDishes = (E) em.find(c, id);
			return sideDishes;
		} catch (java.lang.IllegalArgumentException e) {
			e.printStackTrace();
			return null;
		} finally {
			// em.close();
		}
	}

	public void loadAssociations(E entity) {
		this.loadAssociations(entity, em);
	}

	@SuppressWarnings("unchecked")
	private void loadAssociations(E loadedEntity, EntityManager em) {
		if (loadedEntity != null) {
			try {
				Method f = loadedEntity.getClass().getMethod("postLoad", new Class[0]);
				f.invoke(loadedEntity, new Object[0]);
			} catch (Exception e) {
				// TODO: handle exception
			}

			Method[] f = loadedEntity.getClass().getMethods();
			for (int i = 0; i < f.length; i++) {
				if (f[i].getReturnType().equals(KeyWrapper.class)) {
					if (f[i].getName().equals("") || Modifier.isStatic(f[i].getModifiers()))
						continue;

					KeyWrapper kw;
					try {
						kw = (KeyWrapper<Object>) f[i].invoke(loadedEntity, new Object[0]);

						String setterName = "s" + f[i].getName().substring(1);
						Method setter = loadedEntity.getClass().getMethod(setterName, KeyWrapper.class);
						if (kw == null || kw.getK() == null)
							continue;
						Object c = em.find(getClass().forName(ENTITY_PACKAGE_PREFIX + kw.getK().getKind()), kw.getK());
						if (c == null) {
							System.err.println("Failed to find " + kw.getK().getKind() + " with key " + kw.getK() + " for " + loadedEntity.getClass().getSimpleName());
						} else {
							kw.setValue(c);
							setter.invoke(loadedEntity, kw);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}

				} else {
					if (f[i].getReturnType().getPackage() != null && f[i].getReturnType().getPackage().getName().startsWith("br.com.copacabana.cb.entities")) {
						try {
							if (f[i].getParameterTypes().length == 0) {
								loadAssociations((E) f[i].invoke(loadedEntity, new Object[0]));
							}
						} catch (IllegalArgumentException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

					}
				}
			}
		}

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#list(java.lang.String)
	 */
	public List<E> list(String qname) {
		return this.list(qname, null);
	}

	// @NamedQueryTarget("getSideDish")
	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#list(java.lang.String,
	 * java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public List<E> list(String qname, Map<String, Object> m) {
		EntityManager em = getEntityManager();
		List<E> results = null;
		Query query = null;
		try {
			query = em.createNamedQuery(qname);
			if (m != null) {
				for (Iterator iterator = m.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry<String, Object> entry = (Map.Entry<String, Object>) iterator.next();
					query.setParameter(entry.getKey(), entry.getValue());
				}
			}
			results = (List<E>) query.getResultList();
			for (Iterator iterator = results.iterator(); iterator.hasNext();) {
				E entity = (E) iterator.next();
				loadAssociations(entity, em);
			}

		} catch (java.lang.IllegalArgumentException e) {
			e.printStackTrace();
		} finally {
			// em.close();

		}
		return results;
	}

	public List<E> list(String qname, Map<String, Object> m, int offset, int numberOfRecords) {
		EntityManager em = getEntityManager();
		List<E> results = null;
		Query query = null;
		try {
			query = em.createNamedQuery(qname);
			if (m != null) {
				for (Iterator iterator = m.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry<String, Object> entry = (Map.Entry<String, Object>) iterator.next();
					query.setParameter(entry.getKey(), entry.getValue());
				}
			}
			query.setFirstResult(offset);
			query.setMaxResults(numberOfRecords);
			results = (List<E>) query.getResultList();
			for (Iterator iterator = results.iterator(); iterator.hasNext();) {
				E entity = (E) iterator.next();
				loadAssociations(entity, em);
			}

		} catch (java.lang.IllegalArgumentException e) {
			e.printStackTrace();
		} finally {
			// em.close();

		}
		return results;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see br.com.copacabana.cb.entities.mgr.Manager#endTransaction()
	 */
	public void endTransaction() {
		// if (em != null) {
		// em.close();
		// em.clear();
		// em = null;
		// }

	}

	@Override
	public List<E> list() {
		return list(getDefaultQueryName());

	}

	public String getDefaultQueryName() {

		return null;
	}

	@Override
	public E persist(E sideDishes) throws Exception {
		try {
			return this.create(sideDishes);
		} catch (EntityExistsException e) {
			return this.update(sideDishes);
		}
	}

}
