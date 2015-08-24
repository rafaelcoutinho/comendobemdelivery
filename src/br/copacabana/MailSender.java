package br.copacabana;

import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import br.com.copacabana.cb.app.Configuration;
import br.copacabana.spring.ConfigurationManager;

public class MailSender {

	protected static final Logger log = Logger.getLogger("copacabana.Mailer");

	public void sendFromSystemEmail(String toEmail, String subject, String msg) {
		ConfigurationManager cm = new ConfigurationManager();
		Configuration confEmail = cm.find("contactEmail", Configuration.class);
		String replyTo = "contato@comendobem.com.br";
		if (confEmail != null) {
			replyTo = confEmail.getValue();
		}

		this.sendEmail(replyTo, "ComendoBem", replyTo, "ComendoBem", toEmail, "", subject, msg);

	}

	public void sendEmail(String from, String fromAlias, String replyTo, String replyToAlias, String to, String toAlias, String subject, String msgBody) {
		Multipart mp = new MimeMultipart();
		MimeBodyPart htmlPart = new MimeBodyPart();
		try {
			htmlPart.setContent(msgBody, "text/html");
			mp.addBodyPart(htmlPart);
			sendEmail(from, fromAlias, replyTo, replyToAlias, to, toAlias, subject, mp);
		} catch (AddressException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Failed to send Email", e);
		} catch (MessagingException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Failed to send Email", e);
		}

	}

	public void sendEmail(String from, String fromAlias, String replyTo, String replyToAlias, String to, String toAlias, String subject, Multipart mp) {
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		try {

			MimeMessage msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(from, fromAlias));
			msg.setReplyTo(new InternetAddress[] { new InternetAddress(replyTo, replyToAlias) });
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to, toAlias));
			// msg.setHeader("Return-path", replyTo);
			msg.setSubject(subject, "UTF-8");
			msg.setHeader("Content-Type", "text/plain; charset=UTF-8");
			// msg.setText(msgBody);
			msg.setContent(mp);
			Transport.send(msg);
			if (log.isLoggable(Level.INFO)) {
				log.log(Level.INFO, "A mail was sent from {1} ({0}) to replyto {3} ({2}) to {4} regarding {6}\nMsg: \n{7} ", new String[] { from, fromAlias, replyTo, replyToAlias, to, toAlias, subject });
			}

		} catch (AddressException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Failed to send Email", e);
		} catch (MessagingException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Failed to send Email", e);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Failed to send Email", e);
		}
	}

}
