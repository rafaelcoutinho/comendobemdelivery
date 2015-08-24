package br.copacabana.spring;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;

public class GetSessionValueCommand extends RetrieveCommand implements SessionCommand {
	private HttpSession session;

	private String key;

	public HttpSession getSession() {
		return session;
	}

	public void setSession(HttpSession session) {
		this.session = session;
	}

	@Override
	public void execute(Manager manager) throws Exception {
		this.entity = session.getAttribute(key);
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

}
