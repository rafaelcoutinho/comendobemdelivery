package br.copacabana.spring.central;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class LoadCentralCommand extends RetrieveCommand implements SessionCommand {
	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	@Override
	public void execute(Manager manager) throws Exception {
		CentralManager cm = (CentralManager) manager;
		Key k = Authentication.getLoggedUserKey(session);
		this.entity = cm.get(k);
	}

}
