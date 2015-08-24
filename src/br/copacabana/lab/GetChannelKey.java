package br.copacabana.lab;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.copacabana.Authentication;

import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class GetChannelKey extends HttpServlet {
	public static Set<String> users = new HashSet<String>();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ChannelService channelService = ChannelServiceFactory.getChannelService();
		String userId = "admin";
		try {
			Key k = Authentication.getLoggedUserKey(req.getSession());
			userId = KeyFactory.keyToString(k);
		} catch (Exception e) {
			System.err.println("not logged in, might be admin");
		}
		users.add(userId);
		// The 'Game' object exposes a method which creates a unique string
		// based on the game's key
		// and the user's id.
		String token = channelService.createChannel(userId);
		JsonObject json = new JsonObject();
		json.add("user", new JsonPrimitive(userId));
		json.add("token", new JsonPrimitive(token));
		resp.setContentType("plain/text");
		resp.getWriter().print(json.toString());
	}
}
