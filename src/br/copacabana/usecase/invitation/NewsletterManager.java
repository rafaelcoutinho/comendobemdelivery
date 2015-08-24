package br.copacabana.usecase.invitation;

import java.util.List;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.NewsLetterUser;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

public class NewsletterManager extends AbstractJPAManager<NewsLetterUser> {
	public NewsLetterUser createNewsletterUser(String email, String name) {
		NewsLetterUser invite = new NewsLetterUser(email, name);		
		invite.setName(name);
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().persist(invite);
		Datastore.getPersistanceManager().getTransaction().commit();
		return invite;
	}

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "getNewsletterUser";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return NewsLetterUser.class;
	}

	public void removeEntry(String email) {
		Datastore.getPersistanceManager().getTransaction().begin();
		NewsLetterUser ns = Datastore.getPersistanceManager().find(NewsLetterUser.class, email);
		Datastore.getPersistanceManager().remove(ns);
		Datastore.getPersistanceManager().getTransaction().commit();
	}

	public void stopNewsletter(String email, String comments) {
		Datastore.getPersistanceManager().getTransaction().begin();
		NewsLetterUser ns = Datastore.getPersistanceManager().find(NewsLetterUser.class, email);
		ns.setReceiveNewsletter(Boolean.FALSE);
		ns.setComment(comments);
		Datastore.getPersistanceManager().merge(ns);
		Datastore.getPersistanceManager().getTransaction().commit();
	}
	
	public List<NewsLetterUser> listNotRegisteredUsers(boolean receivesNewsLetter) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("usersByReceiveStatus");
		q.setParameter("status", receivesNewsLetter);
		return q.getResultList();

	}

}
