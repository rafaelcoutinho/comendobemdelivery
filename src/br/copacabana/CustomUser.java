package br.copacabana;

import java.util.Set;

import org.acegisecurity.GrantedAuthority;
import org.acegisecurity.userdetails.User;

import br.com.copacabana.cb.entities.Person;
import br.com.copacabana.cb.entities.UserBean;

/**
 * @author StasB
 */
public class CustomUser extends User {
	private static final long serialVersionUID = 1L;

	protected UserBean login;
	protected Person person;

	public Person getPerson() {
		return person;
	}

	public void setPerson(Person person) {
		this.person = person;
	}

	public CustomUser(String s, String s1, boolean b, boolean b1, boolean b2, boolean b3, GrantedAuthority[] grantedAuthorities) throws IllegalArgumentException {
		super(s, s1, b, b1, b2, b3, grantedAuthorities);
	}

	public CustomUser(String username, String password, boolean active, GrantedAuthority[] authorities) {
		super(username, password, active, authorities);
	}

	public boolean isUserInRole(String role) {
		final GrantedAuthority[] authorities = super.getAuthorities();

		for (int i = 0; i < authorities.length; i++)
			if (role.equals(authorities[i].getAuthority()))
				return true;

		return false;
	}

	public boolean isUserInAnyRole(Set<String> roles) {
		final GrantedAuthority[] authorities = super.getAuthorities();

		for (int i = 0; i < authorities.length; i++)
			if (roles.contains(authorities[i].getAuthority()))
				return true;

		return false;
	}

	/**
	 * This is needed so that we can use an Acegi tag on a page to get user name
	 * <code>&lt;authz:authentication operation="loginDisplayName"/&gt;</code>
	 */
	public String getLoginDisplayName() {

		return login.getLogin();
	}

	/** @return the login */
	public UserBean getLogin() {
		return login;
	}

	/**
	 * @param login
	 *            the login to set
	 */
	public void setLogin(UserBean login) {
		this.login = login;
	}
}
