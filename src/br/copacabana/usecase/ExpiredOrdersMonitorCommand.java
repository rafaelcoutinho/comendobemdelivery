package br.copacabana.usecase;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class ExpiredOrdersMonitorCommand extends RetrieveCommand implements Command {
	protected static final Logger log = Logger.getLogger("copacabana.Monitors");
	private static final int MAXWAITINGTIME = 15;

	@Override
	public void execute(Manager manager) throws Exception {

		OrderManager mMan = new OrderManager();
		Map<String, Object> m = new HashMap<String, Object>();
		List<MealOrder> a = new ArrayList<MealOrder>();
		m.put("status", MealOrderStatus.NEW);
		Calendar c = Calendar.getInstance();
		int maxWaitingTime = getConfiguredMaxTime();
		c.add(Calendar.MINUTE, -1 * maxWaitingTime);
		m.put("time", c.getTime());
		a = mMan.list("listToExpireMealOrders", m);
		StringBuffer sb = new StringBuffer("");
		if (log.isLoggable(Level.INFO)) {
			log.info("Executing expired order monitor. Checking for orders with " + maxWaitingTime + " minutes old.");
		}
		if (a.size() > 0) {
			sb.append("There are ").append(a.size()).append(" orders to expire. ");
			if (log.isLoggable(Level.INFO)) {
				log.info("There are " + a.size() + " orders to expire. ");
			}
			Queue queue = QueueFactory.getDefaultQueue();
			for (Iterator iterator = a.iterator(); iterator.hasNext();) {
				MealOrder mealOrder = (MealOrder) iterator.next();
				sb.append("Must expire: ").append(mealOrder.getId().getId()).append(" ").append(mealOrder.getOrderedTime().toGMTString()).append(", ");
				if (log.isLoggable(Level.INFO)) {
					log.info("Must expire: " + mealOrder.getId().getId() + " " + mealOrder.getOrderedTime().toGMTString() + ", ");
				}

				queue.add(TaskOptions.Builder.withUrl("/tasks/expireMealOrder.do").param("id", KeyFactory.keyToString(mealOrder.getId())).method(Method.POST));

			}

			try {
				MonitorPendingRequestsCommand.notifyUs("Houve um pedidos vencidos!", sb.toString());
			} catch (Exception e) {
				// TODO: handle exception
			}
		} else {
			log.info("No expired meal orders");
			sb.append("No expired meal orders");
		}
		this.entity = sb.toString();
	}

	private int getConfiguredMaxTime() {
		ConfigurationManager cm = new ConfigurationManager();
		String maxTimeStr = cm.getConfigurationValue("maxWaitingTime");
		int maxTime = MAXWAITINGTIME;
		if (maxTimeStr != null) {
			try {
				maxTime = Integer.parseInt(maxTimeStr);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return maxTime;
	}

}
