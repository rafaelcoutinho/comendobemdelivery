package br.copacabana.spring.backoffice;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.central.CentralMonitorCommand;

import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;

public class MonitorCommand extends CentralMonitorCommand implements SessionCommand {
	@Override
	public void execute(Manager eman) throws Exception {
	
		MonitoringBean cb = new MonitoringBean();
		
		ChannelService channelService = ChannelServiceFactory.getChannelService();
		String token = channelService.createChannel("backoffice");		
		cb.setToken(token);
		RestaurantManager rman = new RestaurantManager();
		
		updateCentralBean(cb, rman.listRestKeys());
		
		
		this.entity = cb;
	}

	HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
