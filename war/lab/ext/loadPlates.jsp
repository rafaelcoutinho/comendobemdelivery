<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="com.google.gson.Gson"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="br.copacabana.marshllers.PlateWrapperSerializer"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="br.copacabana.KeySerializer"%>
<%@page import="br.copacabana.KeyDeSerializer"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.Date"%>
<%@page import="br.copacabana.GsonBuilderFactory"%>
<%@page import="br.copacabana.DateDeSerializer"%>
<%@page import="br.copacabana.DateSerializer"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%
	br.copacabana.usecase.ListRestaurantHighlightsPlates lister = new br.copacabana.usecase.ListRestaurantHighlightsPlates();
	lister.setKey(KeyFactory.stringToKey(request.getParameter("rid")));
	lister.execute();
	
	DateSerializer dateSerializer = new DateSerializer(request);
	DateDeSerializer dateDeSerializer = new DateDeSerializer(request);
	
	GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();// new GsonBuilder().setPrettyPrinting().serializeNulls().excludeFieldsWithoutExposeAnnotation();
	gsonBuilder.registerTypeAdapter(Date.class, dateSerializer);
	gsonBuilder.registerTypeAdapter(Date.class, dateDeSerializer);
	gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
	gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
	gsonBuilder.registerTypeAdapter(Plate.class, new PlateWrapperSerializer());
	Gson gson = gsonBuilder.serializeSpecialFloatingPointValues().create();
	
	String json = gson.toJson(lister.getEntity()); // Or use new
	json=GsonBuilderFactory.escapeString(json);
	
	 
	String jsonP = request.getParameter("callback");
%><%=jsonP%>(<%=json %>)