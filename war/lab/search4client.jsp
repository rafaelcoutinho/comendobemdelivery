<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="java.util.List"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="java.util.Iterator"%><%@page import="java.util.HashSet"%><%@page import="br.copacabana.spring.ClientManager"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%
String queryStr = request.getParameter("term");
System.out.println("phone: "+queryStr);
Set<String> allPhones = (Set<String>) CacheController.getCache().get("allPhonesCache");
RestaurantClientManager manager = new RestaurantClientManager();
if (allPhones == null) {

	ClientManager cm = new ClientManager();
	allPhones = new HashSet<String>();
	for (Iterator iter = cm.list().iterator(); iter.hasNext();) {
		Client c = (Client) iter.next();
		allPhones.add(c.getContact().getPhone());
	}

	List<RestaurantClient> allRestClientsList = manager.getRestaurantClients(Authentication.getLoggedUserKey(session));

	for (Iterator iter = allRestClientsList.iterator(); iter.hasNext();) {
		RestaurantClient c = (RestaurantClient) iter.next();
		allPhones.addAll(c.getPhones());
	}
	/*try{
	for (Iterator iter = am.list().iterator(); iter.hasNext();) {			
			Address address = (Address) iter.next();				
			allPhones.add(address.getPhone());			
	}
	}catch(Exception e){
		e.printStackTrace();
		
	}*/
	CacheController.getCache().put("allPhonesCache",allPhones);
}
System.out.println("there are "+allPhones.size()+" phones");
request.setAttribute("allPhones", allPhones);
%>{"status":"ok","results":[<c:forEach var="phone" items="${allPhones}" begin="0" varStatus="status">"${phone}"<c:if test="${status.last==false}">,</c:if></c:forEach>]}