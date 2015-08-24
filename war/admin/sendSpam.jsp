
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="br.copacabana.usecase.invitation.NewsletterManager"%>
<%@page import="com.google.appengine.api.taskqueue.TaskOptions.Method"%>
<%@page import="com.google.appengine.api.taskqueue.TaskOptions"%>
<%@page import="com.google.appengine.api.taskqueue.QueueFactory"%>
<%@page import="com.google.appengine.api.taskqueue.Queue"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<a href="index.jsp">voltar</a><br>
<%
	String from = request.getParameter("from");
	String fromName = request.getParameter("fromName");
	String text = request.getParameter("text");
	String subject = request.getParameter("subject");
	String[] emails = request.getParameter("email").split(",");
	
	if(request.getParameter("addBlogUrl")!=null){
		String blogUrl = request.getParameter("blogUrl");
		String html = "<span style=\"font-size: x-small;\">Caso não visualize esse e-mail, <a href=\""+blogUrl+"\">clique aqui</a>.</span><br>";
		text=html+text+"<br>"+html;
	}
	if(request.getParameter("addRemoveUrl")!=null){
		String html = "<br><span style=\"font-size: xx-small;\">Se não deseja mais receber estas mensagens <a href=\"http://www.comendobem.com.br/removerEmail.do\">clique aqui.</a></span><br>";
		text+=html;
	}	

	NewsletterManager nman = new NewsletterManager();
	ClientManager cm = new ClientManager();
	Queue queue = QueueFactory.getQueue("longLiveMailer");
	for (int i = 0; i < emails.length; i++) {
		TaskOptions task = TaskOptions.Builder.withUrl("/task/sendMail").method(Method.POST);
		task.param("type", "directMail");
		task.param("to", emails[i]);
		String toName = "";
		if (nman.get(emails[i]) != null) {
			toName = nman.get(emails[i]).getName();
		} else {
			try {
				if (cm.getByLogin(emails[i]) != null) {
					toName = cm.getByLogin(emails[i]).getName();
				}
			} catch (Exception e) {

			}
		}
		task.param("toName", toName);
		task.param("fromName", fromName);
		String textChanged = MessageFormat.format(text, toName);
		task.param("text", textChanged);
		task.param("from", from);
		String subj = MessageFormat.format(subject, toName);
		task.param("subject", subj);
		out.println("Adding " + emails[i] + " <br>");

		queue.add(task);
	}
%>