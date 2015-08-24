package br.com.copacabana.cb.entities.mgr;

import java.util.List;
import java.util.Map;

import br.copacabana.EntityManagerBean;

public interface Manager<E> {

	EntityManagerBean getEntityManagerBean();
	// @Action(Action.ACTION_TYPE.CREATE)
	public abstract E create(E obj) throws Exception;

	// @Action(Action.ACTION_TYPE.DELETE)
	public abstract String delete(E obj) throws Exception;

	// @Action(Action.ACTION_TYPE.UPDATE)
	public abstract E update(E obj) throws Exception;
	public abstract E persist(E obj) throws Exception;
	// @Action(Action.ACTION_TYPE.FIND)
	public abstract E find(Object id, Class c);

	public abstract List<E> list(String qname);
	public abstract List<E> list();


	// @NamedQueryTarget("getSideDish")
	public abstract List<E> list(String qname, Map<String, Object> m);

	public abstract void endTransaction();
	public abstract String deleteInTransaction(E obj) throws Exception;
	

}