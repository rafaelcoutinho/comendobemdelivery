package br.copacabana.lab;

import java.io.IOException;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.channel.ChannelMessage;
import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;

public class NotifyUser extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.JSChannel");

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String user = req.getParameter("user");
		String msg = req.getParameter("msg");

		if (user != null) {
			this.sendMessage(user, msg);
		} else {
			// notify all
			for (Iterator iterator = GetChannelKey.users.iterator(); iterator.hasNext();) {
				String type = (String) iterator.next();
				this.sendMessage(type, msg);
			}
		}

	}

	public static void sendMessage(String user, String msg) {
		try {
			ChannelService channelService = ChannelServiceFactory.getChannelService();
			channelService.sendMessage(new ChannelMessage(user, msg));
		} catch (com.google.appengine.api.channel.ChannelFailureException e) {
			log.log(Level.SEVERE, "failed to send msg");
		}
	}
}
