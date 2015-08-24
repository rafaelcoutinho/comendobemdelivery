package br.copacabana.tasks;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;



public class EmailNotificator {

	public void addEmailToTheQueue() {
		Queue queue = QueueFactory.getDefaultQueue();
		
		queue.add(TaskOptions.Builder.withUrl("/path/to/my/worker"));

		
	}
}
