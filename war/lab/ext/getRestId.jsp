<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page
	import="java.util.logging.Level"%>
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
		Restaurant r = (Restaurant) auth.getEntity();
		JsonObject json = new JsonObject();
		FoodCategoryManager fman = new FoodCategoryManager();

		json.add("restId", new JsonPrimitive(r.getIdStr()));
		json.add("status", new JsonPrimitive("ok"));
%><%=json.toString()%>
<%
	} else {
%>{"status":"failed","msg":"authentication"}<%
	}
%>