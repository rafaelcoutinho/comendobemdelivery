package br.copacabana.spring.order;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import br.com.copacabana.cb.entities.Feedback;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.util.TimeController;

import com.ibm.icu.util.Calendar;

public class ListFeedbackCommand extends RetrieveCommand {
	private String start;
	private String end;
	private SimpleDateFormat sdf = new SimpleDateFormat("kk:mm:ss dd-MM-yyyy");
	
	@Override
	public void execute() throws Exception {
		
		OrderManager oman = new OrderManager();
		RestaurantManager rman = new RestaurantManager();
		List<Feedback> list = new ArrayList<Feedback>();
		if (start != null) {
			sdf.setTimeZone(TimeController.getDefaultTimeZone());
			Date startDate = sdf.parse(start);
			Date endDate = sdf.parse(end);
			list = oman.getFeedbackByPeriod(startDate, endDate);
		} else {
			Calendar c = Calendar.getInstance();
			Date now = c.getTime();
			c.add(Calendar.WEEK_OF_YEAR, -1);
			Date lastWeek= c.getTime();
			list = oman.getFeedbackByPeriod(lastWeek, now);
		}
		List<FeedbackBean> list2 = new ArrayList<FeedbackBean>();
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			Feedback feedback = (Feedback) iterator.next();
			FeedbackBean fbean = new FeedbackBean(feedback, oman.get(feedback.getMealOrder()));
			fbean.setRestaurant(rman.getRestaurant(fbean.getMealOrder().getRestaurant()));

			list2.add(fbean);

		}

		this.entity = list2;

	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

}
