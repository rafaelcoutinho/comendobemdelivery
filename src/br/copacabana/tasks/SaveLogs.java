package br.copacabana.tasks;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.copacabana.spring.ConfigurationManager;

public class SaveLogs extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String logText = req.getParameter("logs");
		String version = req.getParameter("version");
		ConfigurationManager cm = new ConfigurationManager();
		try {
			cm.createOrUpdateExtended("logs_"+username+"_"+version,"Date: "+new Date().toGMTString()+"\n-----------\n"+logText);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
