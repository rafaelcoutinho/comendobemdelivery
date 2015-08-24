<%@page import="br.com.copacabana.cb.entities.PlateSize"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%><%@page import="br.com.copacabana.cb.entities.Plate"%><%@page import="br.copacabana.spring.RestaurantManager"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="java.util.List"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="java.util.Iterator"%><%@page import="java.util.HashSet"%><%@page import="br.copacabana.spring.ClientManager"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%
	
	Restaurant r = new RestaurantManager().get(Authentication.getLoggedUserKey(session));
	StringBuilder payments = new StringBuilder();
	for(Iterator<String> iter=r.getAcceptablePayments().iterator();iter.hasNext();){
		payments.append(iter.next());
		if(iter.hasNext()){
			payments.append("|");
		}
	}
%>{"status":"online" ,"name":"<%=r.getName()%>","id":"<%=r.getIdStr()%>","fractionPriceType":"<%=r.getFractionPriceType().name()%>","currentDelay":"<%=r.getCurrentDelay()%>","acceptedPaymentTypes":"<%= payments.toString()%>"}
