package br.copacabana.lab;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.channel.ChannelMessage;
import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;

public class TicTacPost extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String gameId = req.getParameter("g");
		String user = req.getParameter("user");
		
		for (int i = 0; i < TicTacToeServlet.i; i++) {
			ChannelService channelService = ChannelServiceFactory.getChannelService();
			String channelKey = "user_"+i;
			channelService.sendMessage(new ChannelMessage(channelKey, "bla bla "+TicTacToeServlet.i));
		}
			
		
	}
}
