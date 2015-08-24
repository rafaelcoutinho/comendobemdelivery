package br.copacabana.usecase;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.usecase.beans.HighlightTip;

public class GetWeeklyTip extends RetrieveCommand<HighlightTip> {
	public void execute(Manager manager) {
		execute();
	}

	public void execute() {

		ConfigurationManager cm = new ConfigurationManager();

		HighlightTip dh = new HighlightTip();
		// dh.setDescription(cm.getConfiguration("dailyHighlightDescription").getValue());

		dh.setImageAlt(GetDailyTip.getConfValue("weeklyHighlightImageAlt", cm));
		dh.setImageUrl(GetDailyTip.getConfValue("weeklyHighlightImageUrl", cm));
		dh.setName(GetDailyTip.getConfValue("weeklyHighlightName", cm));
		dh.setUrl(GetDailyTip.getConfValue("weeklyHighlightURL", cm));
		dh.setDescription(GetDailyTip.getConfValue("weeklyHighlightDesc", cm));
		dh.setTitle(GetDailyTip.getConfValue("weeklyHighlightTitle", cm));

		entity = dh;

	}

}
