package br.copacabana.spring.client;

import java.util.logging.Level;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class ConfirmEmail extends RetrieveCommand implements SessionCommand {
	String cid;
	private HttpSession session;

	@Override
	public void execute() throws Exception {
		try {
			Key cId = KeyFactory.stringToKey(cid);
			ClientManager cm = new ClientManager();

			Client c = cm.get(cId);
			c.setMustVerifyEmail(Boolean.FALSE);
			cm.persist(c);
			this.entity = "success";
		} catch (Exception e) {
			log.log(Level.SEVERE, "confirming email", e);
			this.entity = "error";
		}
	}

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
