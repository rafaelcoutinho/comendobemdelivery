package br.copacabana;

import java.util.HashMap;
import java.util.Map;

import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;

public class LoginCommand implements Command<UserBean> {
	private String username;
	private String password;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", username);
		// java.util.List<UserBean> l = new UserBeanManager().getByLogin();
		throw new Exception("????? should not be here!!");

	}

}
