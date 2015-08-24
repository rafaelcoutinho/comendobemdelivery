package br.copacabana.spring;

import java.util.List;

import javax.persistence.Query;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.ConfigurationExtended;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

public class ConfigurationManager extends AbstractJPAManager<Configuration> {

	public ConfigurationManager() {
		super();
		// TODO Auto-generated constructor stub
	}

	public void createOrUpdateExtended(String key, String value) throws Exception {
		ConfigurationExtended conf = Datastore.getPersistanceManager().find(ConfigurationExtended.class, key);
		if (conf != null) {
			conf.setValue(value);
			Datastore.getPersistanceManager().merge(conf);
		} else {
			conf = new ConfigurationExtended(key, value);
			Datastore.getPersistanceManager().persist(conf);
		}
	}
	public ConfigurationExtended getConfigurationExtended(String id) {
		ConfigurationExtended conf = Datastore.getPersistanceManager().find(ConfigurationExtended.class, id);
		return conf;
	}
	public String getConfigurationExtendedValue(String id) {
		ConfigurationExtended conf = Datastore.getPersistanceManager().find(ConfigurationExtended.class, id);
		if (conf != null) {
			return conf.getValue();
		}
		return "";
	}

	public void createOrUpdate(String key, String value) throws Exception {
		Configuration conf = this.find(key, Configuration.class);
		if (conf != null) {
			conf.setValue(value);
		} else {
			conf = new Configuration(key, value);
		}
		this.persist(conf);
	}

	public String getConfigurationValue(String id) {
		Configuration conf = this.find(id, Configuration.class);
		if (conf != null) {
			return conf.getValue();
		}
		return "";
	}

	@Override
	public String getDefaultQueryName() {

		return "";
	}

	@Override
	protected Class getEntityClass() {
		return Configuration.class;
	}

	public List<ConfigurationExtended> listExtends(){
		Query q = Datastore.getPersistanceManager().createNamedQuery("listExtended");
		return q.getResultList();
	}
}
