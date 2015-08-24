package br.copacabana;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.acegisecurity.GrantedAuthority;
import org.acegisecurity.GrantedAuthorityImpl;
import org.acegisecurity.userdetails.UserDetails;
import org.acegisecurity.userdetails.UserDetailsService;
import org.acegisecurity.userdetails.UsernameNotFoundException;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.dao.DataAccessException;

import br.com.copacabana.cb.entities.UserBean;
import br.copacabana.exception.DataNotFoundException;
import br.copacabana.spring.UserBeanManager;

public abstract class CustomAuthenticationService implements InitializingBean, UserDetailsService {
	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	/** @see org.acegisecurity.userdetails.UserDetailsService#loadUserByUsername(java.lang.String) */
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		if (username == null)
			throw new NullPointerException("username argument is null ");
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", username);
		UserBean login;
		try {
			login = new UserBeanManager().getByLogin(username);// loginDao.list(UserBean.Queries.getUserByLogin.name(),
			// m);
		} catch (DataNotFoundException e) {
			throw new UsernameNotFoundException("User '" + username + "' not found");
		}

		if (login == null)
			throw new UsernameNotFoundException("User '" + username + "' not found");

		final String password = login.getPassword();

		if (StringUtils.isEmpty(password))
			log.log(Level.WARNING, "User [{0}] will not be enabled because password is null/blank", new String[] { login.getPassword() });

		final GrantedAuthority[] authorities = new GrantedAuthority[2];
		// TODO when I'm clear on PIRole vs. access role
		// new GrantedAuthority[ login.getRoles().size() + 1 ];
		// int i = 0;
		// for( SystemUserRole role : login.getRoles() )
		// authorities[ i++ ] = new GrantedAuthorityImpl(
		// role.getCanonicalName() );
		authorities[0] = new GrantedAuthorityImpl("ROLE_USER");
		int i = 1;

		// Todo hardcoded to active
		final CustomUser cUser = new CustomUser(login.getLogin(), password, true, authorities);

		cUser.setLogin(login);

		return cUser;
	}

	// /** @see
	// org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
	// */
	// public void afterPropertiesSet() throws Exception {
	// if (loginDao == null)
	// throw new BeanInitializationException("loginDao is null");
	// }

	// /**
	// * @param loginDao
	// * the loginDao to set
	// */
	// public void setLoginDao(JPAManager<UserBean> loginDao) {
	// this.loginDao = loginDao;
	// }
}
