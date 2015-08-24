package br.copacabana.lab;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;

public class TicTacToeServlet extends HttpServlet {
	  public static int i = 0;
	  @Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    // Game creation, user sign-in, etc. omitted for brevity.
	    String userId = "rafael";

	    ChannelService channelService = ChannelServiceFactory.getChannelService();

	    // The 'Game' object exposes a method which creates a unique string based on the game's key
	    // and the user's id.
	    String token = channelService.createChannel("user_"+i++);
	    String index = "<body>  <script>    channel = new goog.appengine.Channel('{{ token }}');    socket = channel.open();    socket.onopen = onOpened;    socket.onmessage = onMessage;    socket.onerror = onError;    socket.onclose = onClose;  </script></body>";	
	    // Index is the contents of our index.html resource, details omitted for brevity.
	    index = index.replaceAll("\\{\\{ token \\}\\}", token);

	    resp.setContentType("text/html");
	    resp.getWriter().write(index);
	  }
	}