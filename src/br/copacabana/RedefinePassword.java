package br.copacabana;

import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.PwdResetAuthorization;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.PasswordManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;

public class RedefinePassword extends RetrieveCommand implements SessionCommand {
	HttpSession session;
	String t;
	String i;
	String newPwd;
	String newPwd2;
	String status = "";

	@Override
	public void execute() throws Exception {

		String token = t;
		String prId = i;
		if (token != null && token.length() > 0 && prId != null && prId.length() > 0) {
			PasswordManager pm = new PasswordManager();
			Long pId = Long.parseLong(prId);
			PwdResetAuthorization pAuth = pm.get(pId);
			if (pAuth != null) {
				if (!pm.isExpired(pAuth)) {
					try {
						String realToken = pm.getAuthorizationToken(pAuth);
						if (realToken.equals(token)) {
							status = "validAuth";
						}
						if (newPwd != null && newPwd.length() > 0) {
							if (newPwd.equals(newPwd2)) {
								UserBeanManager um = new UserBeanManager();
								UserBean u = um.get(pAuth.getUserId());
								u.setPassword(newPwd);
								um.persist(u);
								status = "pwdUpdated";
							} else {
								status = "pwdsDontMatch";
							}
						} else {
							status = "notValidPwd";
						}

						return;
					} catch (NoSuchAlgorithmException e) {
						e.printStackTrace();// Should not happen
					}
				}

			}
			status = "invalidToken";
		} else {
			status = "missingParams";
		}

	}

	@Override
	public Object getEntity() {
		// TODO Auto-generated method stub
		return status;
	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public String getT() {
		return t;
	}

	public void setT(String t) {
		this.t = t;
	}

	public String getI() {
		return i;
	}

	public void setI(String i) {
		this.i = i;
	}

	public String getNewPwd() {
		return newPwd;
	}

	public void setNewPwd(String newPwd) {
		this.newPwd = newPwd;
	}

	public String getNewPwd2() {
		return newPwd2;
	}

	public void setNewPwd2(String newPwd2) {
		this.newPwd2 = newPwd2;
	}

}
