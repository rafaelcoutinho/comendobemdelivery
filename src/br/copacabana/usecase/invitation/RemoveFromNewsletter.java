package br.copacabana.usecase.invitation;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RemoveFromNewsletter extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email");
		String comments = req.getParameter("comments");
		NewsletterManager nman = new NewsletterManager();
		if (nman.get(email) == null) {
			resp.sendRedirect("/removerEmail.do?err=1");
		} else {
			nman.stopNewsletter(email, comments);
			resp.sendRedirect("/removerEmail.do?err=2");
		}
	}
}
