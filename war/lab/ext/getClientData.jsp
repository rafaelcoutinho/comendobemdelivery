<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.google.gson.JsonNull"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.com.copacabana.cb.entities.Person.Gender"%>
<%@page import="br.copacabana.exception.DataNotFoundException"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonPrimitive"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.usecase.ServerClientMonitors"%>
<%@page import="br.copacabana.Authentication"%>
<%
	String username = request.getParameter("username");
	String token = request.getParameter("token");
	Authentication auth = new Authentication();
	Logger log = Logger.getLogger("copacabana.Commands");
	if (auth.tokenBasedAuthentication(username, token, ServerClientMonitors.getSeed(), "true", session)) {
		String email = request.getParameter("email");
		Client c = null;
		boolean newone=false;
		ClientManager cm = new ClientManager();
		try {
			log.info("getting Client by Email "+email);
			c = cm.getByLogin(email);
		} catch (DataNotFoundException exc) {
			log.log(Level.SEVERE,"Erro ao carregar "+email+" ",exc);
			c = new Client(email);
			c.setName(request.getParameter("name"));
			if (request.getParameter("gender") != null && !request.getParameter("gender").equals("male")) {
				c.setGender(Gender.FEMALE);
			}
			if (request.getParameter("fbid") != null && request.getParameter("fbid").length() > 0) {
				c.setMustVerifyEmail(false);
				c.getUser().setFacebookId(request.getParameter("fbid"));
				c.getUser().setIsFacebook(true);
			}
			if (request.getParameter("birthday") != null) {
				try {
					SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
					c.setBirthday(sdf.parse(request.getParameter("birthday")));
				} catch (Exception e) {

				}
			}
			cm.create(c);
			c = cm.getByLogin(email);
		}
		JsonObject resp = new JsonObject();
		JsonObject cjson = new JsonObject();

		cjson.add("name", new JsonPrimitive(c.getName()));
		cjson.add("id", new JsonPrimitive(c.getIdStr()));
		cjson.add("gender", new JsonPrimitive(c.getGender().name()));
		if(c.getMainPhone()!=null){
			cjson.add("mainPhone", new JsonPrimitive(c.getMainPhone()));
		}else{
			cjson.add("mainPhone", new JsonNull());
		}
		cjson.add("email", new JsonPrimitive(c.getEmail()));
		JsonArray addresses = new JsonArray();
		AddressManager addman = new AddressManager();
		for (Iterator<Key> iter = c.getAddresses().iterator(); iter.hasNext();) {
			Address add = addman.getAddress(iter.next());
			JsonObject addre = new JsonObject();
			addre.add("street", new JsonPrimitive(add.getStreet()));
			addre.add("id", new JsonPrimitive(add.getIdStr()));
			addre.add("additionalInfo", new JsonPrimitive(add.getAdditionalInfo()));
			addre.add("phone", new JsonPrimitive(add.getPhone()));
			JsonObject n = new JsonObject();
			n.add("id", new JsonPrimitive(add.getNeighborhood().getIdStr()));
			n.add("name", new JsonPrimitive(add.getNeighborhood().getName()));
			n.add("city", new JsonPrimitive(add.getNeighborhood().getCity().getName()));
			addre.add("neigh", n);
			addresses.add(addre);
		}
		cjson.add("addresses", addresses);
		resp.add("client", cjson);
		resp.add("isnew", new JsonPrimitive(newone));
		resp.add("status", new JsonPrimitive("ok"));
		
%><%=resp.toString()%>
<%
	}else{
%>{"status":"failed","msg":"authentication"}<%}%>