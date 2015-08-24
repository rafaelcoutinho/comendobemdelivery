package br.copacabana;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.SessionCommand;

import com.google.gson.annotations.Expose;

public class GetLoggedUserCommand extends RetrieveCommand implements SessionCommand {
	private static final String LOGGED_USER = "loggedUser";
	private static final String ALREADY_TRIED = "ALREADY_TRIED";
	private HttpSession session;

	public HttpSession getSession() {
		return session;
	}

	public void setSession(HttpSession session) {
		this.session = session;
	}

	private String username;
	private String password;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public void execute(Manager manager) {

		if (username != null) {
			Authentication authentication = new Authentication();
			throw new java.lang.RuntimeException("old authentication");

		}
		UserBean user = (UserBean) session.getAttribute(LOGGED_USER);
		if (user == null) {
			Integer tried = (Integer) session.getAttribute(ALREADY_TRIED);
			if (tried != null) {
				entity = new AuthenticationError(true);
			} else {
				entity = new AuthenticationError(false);
			}
		} else {
			entity = user;
		}

	}

	public class AuthenticationError {
		private static final String USER_CREDENTIALS_NOT_VALID = "USER_CREDENTIALS_NOT_VALID";
		private static final String USER_NOT_AUTHENTICATED = "USER_NOT_AUTHENTICATED";
		@Expose
		private String failure;

		public String getFailure() {
			return failure;
		}

		public AuthenticationError(boolean b) {
			if (b) {
				failure = USER_CREDENTIALS_NOT_VALID;
			} else {
				failure = USER_NOT_AUTHENTICATED;
			}
		}

	}

}
