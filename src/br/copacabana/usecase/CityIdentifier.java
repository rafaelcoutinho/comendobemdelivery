package br.copacabana.usecase;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.City;
import br.copacabana.EntityManagerBean;
import br.copacabana.JsonViewController;
import br.copacabana.spring.CityManager;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class CityIdentifier {
	protected static final Logger log = Logger.getLogger(JsonViewController.class.getName());

	public static EntityManagerBean getEntityManager(ServletContext servletContext) {

		WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);

		EntityManagerBean em = (EntityManagerBean) wac.getBean("entityManager");
		return em;
	}

	public static City findDefaultCity(HttpServletRequest request, ServletContext context) {
		CityManager man = new CityManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("name", "Sao Paulo");
		List<City> l = man.list("getCityByName", m);
		if (l.isEmpty()) {
			return null;
		}
		return l.get(0);

	}

	public static City findCityByIP(HttpServletRequest request, ServletContext context) {

		String ip = null;
		if (request.getHeader("x-forwarded-for") != null) {
			ip = request.getHeader("x-forwarded-for");

		} else {
			if (request.getRemoteAddr() != null) {
				ip = request.getRemoteAddr();
			} else {
				ip = request.getRemoteHost();
			}

		}
		if (ip != null) {
			String cityName = null;
			try {
				cityName = fecthCityFromService(ip);//
				if (cityName != null && !cityName.equals("null")) {
					CityManager man = new CityManager();

					Map<String, Object> m = new HashMap<String, Object>();
					m.put("name", cityName);
					List<City> l = man.list("getCityByName", m);
					if (!l.isEmpty()) {
						return l.get(0);
					} else {
						log.info("Can't find city with name: '" + cityName + "'");
						return null;
					}
				}

			} catch (Exception e) {
				log.log(Level.SEVERE, "failed identifying city", e);
				log.log(Level.SEVERE, "City name returned:" + cityName);
				return null;
			}
		}
		return null;

	}

	private static String fecthCityFromService(String ip) {
		URL urlObject = null;
		URLConnection con = null;

		BufferedReader in = null;
		log.info("Geolocationg ip:" + ip);
		try {
			String url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20pidgets.geoip%20where%20ip%3D%27" + ip + "%27&format=json&diagnostics=false&env=http%3A%2F%2Fdatatables.org%2Falltables.env&callback=cbfunc";
			urlObject = new URL(url.toString());
			con = urlObject.openConnection();
			// con.setDoOutput(true);
			con.setUseCaches(false);
			// con.setRequestProperty("Content-Type",
			// "application/x-www-form-urlencoded");
			// printout = new DataOutputStream(con.getOutputStream());
			// printout.writeBytes(params.toString());
			// printout.flush();
			// closing it earlier is better, anyway in finally block it's
			// also being closed.
			// printout.close();

			in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			char[] b = new char[1];
			StringBuffer sb = new StringBuffer();
			String jsonString;
			JsonObject geoData = new JsonObject();
			JsonParser pa = new JsonParser();

			while ((jsonString = in.readLine()) != null) {
				sb.append(jsonString);

			}

			jsonString = sb.toString();
			jsonString = jsonString.substring(jsonString.indexOf('(') + 1, jsonString.length() - 1);
			log.info("Response:" + jsonString);
			geoData.add("geodata", pa.parse(jsonString));
			if (geoData.get("geodata").getAsJsonObject().get("query").getAsJsonObject().get("results").getAsJsonObject().get("Result").getAsJsonObject().get("city") != null) {
				return geoData.get("geodata").getAsJsonObject().get("query").getAsJsonObject().get("results").getAsJsonObject().get("Result").getAsJsonObject().get("city").getAsString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "failed identifying city: " + e.getMessage());
			log.log(Level.FINE, "failed identifying city: ", e);
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

		}
		return null;
	}

	public static void main(String[] args) {
		System.out.println(fecthCityFromService("201.53.197.113"));
	}

	public static String findCityKeyByIP(HttpServletRequest request, ServletContext context) {
		City c = findCityByIP(request, context);
		if (c != null) {
			return KeyFactory.keyToString(c.getId());
		}
		return null;
	}
}
