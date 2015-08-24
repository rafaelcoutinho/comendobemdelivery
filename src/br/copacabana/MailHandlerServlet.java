package br.copacabana;

import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.app.Configuration;
import br.copacabana.spring.ConfigurationManager;

public class MailHandlerServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4765316059913785064L;
	protected static final Logger log = Logger.getLogger("copacabana.Mailer");
	String to;

	@Override
	public void init(ServletConfig config) throws ServletException {

		super.init(config);
		ConfigurationManager cm = new ConfigurationManager();
		Configuration confEmail = cm.find("contactEmail", Configuration.class);
		to = "contato@comendobem.com.br";
		if (confEmail != null) {
			to = confEmail.getValue();
		}

	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			Properties props = new Properties();
			Session session = Session.getDefaultInstance(props, null);
			MimeMessage msg = new MimeMessage(session, req.getInputStream());
			MailSender ms = new MailSender();
			ms.sendEmail(to, "CB App", to, "CB contato", to, to, "Received " + msg.getSubject() + " from " + msg.getSender(), (Multipart) msg.getContent());

			if (log.isLoggable(Level.INFO)) {
				log.log(Level.INFO, "A mail was received and is being redirected to ({0})", to);
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to process received msg", e);
		}
	}
}
