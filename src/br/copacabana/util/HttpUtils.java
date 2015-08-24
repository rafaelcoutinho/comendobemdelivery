package br.copacabana.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Logger;

public class HttpUtils {
	public static void main(String[] args) {
	Map<String,String > mm =new HashMap<String, String>();
	mm.put("access_token", "62056677401|6dESYOzFYrU1FidLbyicQiwlIy4");
	try {
		String s = getHttpContent("https://graph.facebook.com/103044479790788");
		System.out.println(s);
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
}

	public static String getHttpContent(String urlStr) throws IOException {
		return getHttpContent(urlStr, "iso-8859-1", new HashMap<String, String>());
	}

	public static HttpURLConnection getHttpConnection(String urlStr, String charSet, Map<String, String> props) throws IOException {
		URL url = new URL(urlStr);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		for (Iterator iterator = props.keySet().iterator(); iterator.hasNext();) {
			String k = (String) iterator.next();
			connection.addRequestProperty(k, props.get(k));
		}

		connection.setRequestMethod("GET");
		return connection;

	}

	public static HttpURLConnection getHttpPOSTConnection(String urlStr, String charSet, Map<String, String> props, Map<String, String> params) throws IOException {
		URL url = new URL(urlStr);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		for (Iterator iterator = props.keySet().iterator(); iterator.hasNext();) {
			String k = (String) iterator.next();
			connection.addRequestProperty(k, props.get(k));
		}

		connection.setRequestMethod("POST");
		connection.setDoOutput(true);
		OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
		StringBuilder sb = new StringBuilder();
		for (Iterator iterator = params.keySet().iterator(); iterator.hasNext();) {
			String name = (String) iterator.next();
			sb.append(name);
			sb.append("=");
			sb.append(URLEncoder.encode(params.get(name)));
			sb.append("\n");

		}
		System.out.println(sb.toString());
		writer.write(sb.toString());
		writer.close();

		return connection;

	}
	protected static final Logger log = Logger.getLogger("copacabana.Commands");
	public static String postHttpContent(String urlStr, String charSet, Map<String, String> props, Map<String, String> params) throws IOException {

		BufferedReader reader = new BufferedReader(new InputStreamReader(getHttpPOSTConnection(urlStr, charSet, props, params).getInputStream(), Charset.forName(charSet)));
		String line;
		log.info("Here");
		StringBuffer sbresponse = new StringBuffer();
		while ((line = reader.readLine()) != null) {
			sbresponse.append(line);
		}
		log.info("responding");
		return sbresponse.toString();
	}

	public static String getHttpContent(String urlStr, String charSet, Map<String, String> props) throws IOException {

		BufferedReader reader = new BufferedReader(new InputStreamReader(getHttpConnection(urlStr, charSet, props).getInputStream(), Charset.forName(charSet)));
		String line;log.info("Here2");
		StringBuffer sbresponse = new StringBuffer();
		while ((line = reader.readLine()) != null) {
			sbresponse.append(line);
		}log.info("resp 2"+sbresponse);
		return sbresponse.toString();
	}
}
