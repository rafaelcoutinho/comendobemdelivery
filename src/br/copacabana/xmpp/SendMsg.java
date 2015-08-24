package br.copacabana.xmpp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.xmpp.JID;
import com.google.appengine.api.xmpp.Message;
import com.google.appengine.api.xmpp.MessageBuilder;
import com.google.appengine.api.xmpp.MessageType;
import com.google.appengine.api.xmpp.SendResponse;
import com.google.appengine.api.xmpp.XMPPService;
import com.google.appengine.api.xmpp.XMPPServiceFactory;

/**
 * Servlet implementation class SendMsg
 */
public class SendMsg extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SendMsg() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String to = request.getParameter("to");
		String from = request.getParameter("from");
		String msgStr = request.getParameter("msg");
		JID jid = new JID(to);
		
		String msgBody = msgStr;
		Message msg = null;
		if(from!=null){
			JID fromJid = new JID(from);
			msg = new MessageBuilder().withMessageType(MessageType.NORMAL).withFromJid(fromJid).withRecipientJids(jid).withBody(msgBody).build();
		}else{
			msg = new MessageBuilder().withRecipientJids(jid).withBody(msgBody).build();
		}
		
		boolean messageSent = false;
		XMPPService xmpp = XMPPServiceFactory.getXMPPService();		
		SendResponse status=null;
		try{
		//if (xmpp.getPresence(jid).isAvailable()) {
			status = xmpp.sendMessage(msg);
			messageSent = (status.getStatusMap().get(jid) == SendResponse.Status.SUCCESS);
			
			response.getWriter().print("Sent successfully");
		} catch (Exception e) {
			// TODO: handle exception
			response.getWriter().print("Failed: "+e.getLocalizedMessage());
		}

		if (!messageSent) {
			// Send an email message instead...
			System.err.println("Failed to send");
			System.err.println(status);
			response.getWriter().print("Failed");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
