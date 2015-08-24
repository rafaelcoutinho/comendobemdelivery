package br.copacabana.usecase;

import br.com.copacabana.cb.app.Configuration;
import br.copacabana.CacheController;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.usecase.beans.HighlightTip;

public class GetDailyTip extends RetrieveCommand<HighlightTip> {

	public void execute(br.com.copacabana.cb.entities.mgr.Manager manager) {
	}

	public void execute() {

		ConfigurationManager cm = new ConfigurationManager();

		HighlightTip dh = new HighlightTip();
		dh.setImageAlt(getConfValue("dailyHighlightImageAlt", cm));
		dh.setImageUrl(getConfValue("dailyHighlightImageUrl", cm));
		dh.setName(getConfValue("dailyHighlightName", cm));
		dh.setUrl(getConfValue("dailyHighlightURL", cm));
		dh.setDescription(getConfValue("dailyHighlightDesc", cm));
		dh.setTitle(getConfValue("dailyHighlightTitle", cm));
		entity = dh;

	}

	public static String getConfValue(String key, ConfigurationManager cm) {
		String conf = (String) CacheController.getCache().get(key);
		if (conf != null) {
			return conf;
		}
		Configuration weeklyHighlightImageAlt = cm.get(key);
		if (weeklyHighlightImageAlt == null) {
			// logger.error("Cannot find " + key + "configuration");
			return "";
		}
		return weeklyHighlightImageAlt.getValue();
	}
}
