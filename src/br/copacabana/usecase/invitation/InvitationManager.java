package br.copacabana.usecase.invitation;

import java.util.Date;
import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Invitation;
import br.com.copacabana.cb.entities.InvitationState;
import br.com.copacabana.cb.entities.LoyaltyPoints;
import br.com.copacabana.cb.entities.NewsLetterUser;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;

import com.google.appengine.api.datastore.Key;

public class InvitationManager extends AbstractJPAManager<Invitation> {
	public Invitation createInvitation(Key userId, String email, String name) {
		Invitation invite = new Invitation(userId, email);
		invite.setName(name);
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().persist(invite);
		Datastore.getPersistanceManager().getTransaction().commit();
		NewsletterManager nm = new NewsletterManager();

		NewsLetterUser ns = nm.get(email);
		if (ns == null) {
			ns = new NewsLetterUser(email, name);
			Datastore.getPersistanceManager().getTransaction().begin();
			Datastore.getPersistanceManager().persist(ns);
			Datastore.getPersistanceManager().getTransaction().commit();
		}

		return invite;
	}

	public Invitation getInvitation(Long id) {
		return Datastore.getPersistanceManager().find(Invitation.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<Invitation> listAllInvitations(Key userId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("allUserInvitations");
		q.setParameter("userid", userId);
		return q.getResultList();
	}

	public List<Invitation> listConfirmedInvitationsFromDate(Key userId, Date d) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("allConfirmedUserInvitationsFromDate");
		q.setParameter("userid", userId);
		q.setParameter("since", d);
		return q.getResultList();
	}

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "getInvitation";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return Invitation.class;
	}

	public List<Invitation> getInvitationsByInviteeEmail(String email) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getInvitationsToEmail");
		q.setParameter("email", email);
		return q.getResultList();
	}

	public List<Invitation> getNotConfirmedInvitationsToEmail(String email) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getNotConfirmedInvitationsToEmail");
		q.setParameter("email", email);
		return q.getResultList();
	}

	public Invitation getMyInvitationByInviteeEmail(String email, Key userid) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getInvitationsToEmail");
		q.setParameter("userid", userid);
		q.setParameter("email", email);
		return (Invitation) q.getSingleResult();

	}

	public void confirmInvitation(Long invitationId) throws Exception {
		Invitation inv = this.getInvitation(invitationId);
		if (!InvitationState.CONFIRMED.equals(inv.getStatus())) {
			inv.setStatus(InvitationState.CONFIRMED);
			Datastore.getPersistanceManager().getTransaction().begin();
			this.persist(inv);
			Datastore.getPersistanceManager().getTransaction().commit();
			NewsletterManager ns = new NewsletterManager();
			ns.removeEntry(inv.getEmail());
			ClientManager cm = new ClientManager();
			LoyaltyPoints lo = null;
			try {
				lo = cm.getLoyaltyForCurrentMonth(cm.get(inv.getFrom()));
			} catch (NoResultException e) {
				lo = new LoyaltyPoints(inv.getFrom());
			}
			ConfigurationManager confman = new ConfigurationManager();
			int perInvitation = 200;
			lo.setConfirmedInvitations(lo.getConfirmedInvitations() + 1);
			if (confman.getConfigurationValue("loyalty.perInvitation") != null && confman.getConfigurationValue("loyalty.perInvitation").length() > 0) {
				perInvitation = (Integer.parseInt(confman.getConfigurationValue("loyalty.perInvitation")));
			}
			lo.setPerInvitation(perInvitation);
			cm.persistLoyaltyPoints(lo);

		}
	}

	public List<Invitation> getConfirmedInvitationRange(Date from, Date until) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getConfirmedInvitationsRange");
		q.setParameter("from", from);
		q.setParameter("until", until);
		return q.getResultList();
	}

	public Key getGetMyInviterId(Client client) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getMyInviter");
		q.setParameter("email", client.getUser().getLogin());
		return (Key) q.getSingleResult();

	}

}
