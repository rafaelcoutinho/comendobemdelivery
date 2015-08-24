package br.copacabana.spring;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.exception.DataNotFoundException;
import br.copacabana.exception.NotUniqueLoginException;

import com.google.appengine.api.datastore.Key;

public class UserBeanManager extends AbstractJPAManager<UserBean> {

	public UserBean getUserBean(Key k) {
		return this.find(k, UserBean.class);
	}

	@Override
	public UserBean create(UserBean user) throws Exception {
		checkIfUniqueLogin(user);
		return super.create(user);
	}

	public UserBean getByLogin(String login) throws DataNotFoundException {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", login);
		List<UserBean> l = list("getUserByLogin", m);

		if (l == null || l.isEmpty()) {
			throw new DataNotFoundException("There is no userbean with login=" + login + "");
		}
		return l.get(0);
	}

	public UserBean getByFBId(String fbid) throws DataNotFoundException {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("facebookId", fbid);
		List<UserBean> l = list("getUserByFBId", m);

		if (l == null || l.isEmpty()) {
			throw new DataNotFoundException("There is no userbean with fbid=" + fbid + "");
		}
		return l.get(0);
	}

	public void checkIfUniqueLogin(UserBean user) throws NotUniqueLoginException {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", user.getLogin());
		List<UserBean> l = list("getUserByLogin", m);
		// need to do it due the lack of uniqueness support from google app
		// engine :(
		if (user.getId() == null) {

			if (!l.isEmpty()) {
				throw new NotUniqueLoginException(user.getLogin());
			}
		} else {
			if (!l.isEmpty()) {
				if (!l.get(0).getId().equals(user.getId())) {
					throw new NotUniqueLoginException(user.getLogin());
				}
			}
		}
	}

	@Override
	public UserBean update(UserBean user) throws Exception {
		checkIfUniqueLogin(user);
		return super.update(user);
	}

	public String getDefaultQueryName() {

		return "getUser";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return UserBean.class;
	}

}
