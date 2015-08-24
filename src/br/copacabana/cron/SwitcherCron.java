package br.copacabana.cron;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.SwitcherConf;
import br.copacabana.util.TimeController;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class SwitcherCron extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		List<SwitcherConf> todaysExecutions = SwitcherConf.listConfsByDay(TimeController.getDayOfWeek());
		Queue queue = QueueFactory.getQueue("switcherQueue");
		for (Iterator iterator = todaysExecutions.iterator(); iterator.hasNext();) {
			SwitcherConf switcherConf = (SwitcherConf) iterator.next();
			queue.add(TaskOptions.Builder.withUrl("/task/switchPlateState").param("id", switcherConf.getId().toString()).method(Method.GET));
		}

	}
}
