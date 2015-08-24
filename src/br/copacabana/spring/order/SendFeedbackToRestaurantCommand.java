package br.copacabana.spring.order;

import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.ResourceBundle;

import br.com.copacabana.cb.entities.Feedback;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.MailSender;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.util.TimeController;

public class SendFeedbackToRestaurantCommand extends RetrieveCommand {

	String[] idFeedBack = new String[0];

	@Override
	public void execute() throws Exception {
		if (idFeedBack.length > 0) {
			OrderManager om = new OrderManager();
			Long l = Long.valueOf(idFeedBack[0]);
			Feedback f = om.getFeedback(l);
			Restaurant r = new RestaurantManager().get(om.get(f.getMealOrder()).getRestaurant());
			StringBuffer sb = new StringBuffer();
			ResourceBundle bundle = ResourceBundle.getBundle("messages");
			String mailIntroduction = bundle.getString("feedbacks.restaurant.msg.header");
			SimpleDateFormat sdf = new SimpleDateFormat("kk:mm dd/MM/yyyy", new Locale("pt", "br"));
			sdf.setTimeZone(TimeController.getDefaultTimeZone());
			sb.append(MessageFormat.format(mailIntroduction, r.getName()));
			sb.append(bundle.getString("feedbacks.restaurant.items.header"));

			String each = bundle.getString("feedbacks.restaurant.items.each");
			for (int i = 0; i < idFeedBack.length; i++) {
				Long id = Long.valueOf(idFeedBack[i]);
				Feedback feedback = om.getFeedback(id);
				String[] params = new String[10];
				MealOrder mo = om.get(feedback.getMealOrder());
				params[0] = mo.getId().getId() + "." + mo.getClient().getId().getId();
				params[1] = sdf.format(mo.getOrderedTime());
				params[8] = sdf.format(mo.getOrderedTime());
				params[9] = sdf.format(mo.getLastStatusUpdateTime());
				params[2] = bundle.getString("feedbacks.grade." + feedback.getOverall());
				params[3] = bundle.getString("feedbacks.grade." + feedback.getDeliveryTime());
				params[4] = bundle.getString("feedbacks.grade." + feedback.getStatusUpdate());
				params[5] = bundle.getString("feedbacks.grade." + feedback.getRestaurantInfo());
				params[6] = bundle.getString("feedbacks.grade." + feedback.getFoodQuality());
				if (feedback.getComment() != null && feedback.getComment().length() > 0) {
					params[7] = feedback.getComment();
				} else {
					params[7] = "Nenhum comentário";
				}
				String entry = MessageFormat.format(each, params);
				sb.append(entry);
				feedback.setSentToRestaurant(true);
				om.persist(feedback);
			}
			sb.append(bundle.getString("feedbacks.restaurant.msg.bottom"));
			MailSender ms = new MailSender();
			ms.sendFromSystemEmail(r.getUser().getLogin(), "Avaliações feitas por seus cliente", sb.toString());
		}
	}

	public String[] getIdFeedBack() {
		return idFeedBack;
	}

	public void setIdFeedBack(String[] idFeedBack) {
		this.idFeedBack = idFeedBack;
	}
}
