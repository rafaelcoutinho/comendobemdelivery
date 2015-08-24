package br.com.copacabana.cb.entities.mgr;

import java.text.MessageFormat;
import java.util.List;
import java.util.ResourceBundle;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.WarnMessage;
import br.com.copacabana.cb.entities.WarnMessage.MessageType;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class WarnMessageManager extends AbstractJPAManager<WarnMessage> {

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return WarnMessage.class;
	}

	public WarnMessage getOrCreateConfEmailByUser(Key userId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getConfEmailWarnMessageByUser");
		q.setParameter("userBean", userId);
		List<WarnMessage> l = q.getResultList();
		if (l.isEmpty()) {
			UserBean ub = Datastore.getPersistanceManager().find(UserBean.class, userId);
			ResourceBundle bundle = ResourceBundle.getBundle("messages");
			String msg = bundle.getString("confirmEmail.warn.msg");
			msg = MessageFormat.format(msg, ub.getLogin());

			WarnMessage w = new WarnMessage(msg, MessageType.CONFIRM_EMAIL, userId);
			Datastore.getPersistanceManager().getTransaction().begin();
			Datastore.getPersistanceManager().persist(w);
			Datastore.getPersistanceManager().getTransaction().commit();
			return w;
		} else {
			return l.get(0);
		}
	}

}
