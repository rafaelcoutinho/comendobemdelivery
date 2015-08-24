<%@page import="br.com.copacabana.cb.entities.PlateStatus"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="br.com.copacabana.cb.entities.PlateSize"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%><%@page import="br.com.copacabana.cb.entities.Plate"%><%@page import="br.copacabana.spring.RestaurantManager"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="java.util.List"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="java.util.Iterator"%><%@page import="java.util.HashSet"%><%@page import="br.copacabana.spring.ClientManager"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.copacabana.spring.RestaurantClientManager"%>
	{"plates":[<%
Restaurant r = new RestaurantManager().get(Authentication.getLoggedUserKey(session));
FoodCategoryManager fman = new FoodCategoryManager();
for(Iterator<Plate> iter = r.getPlates().iterator();iter.hasNext();){
	Plate p = iter.next();
	FoodCategory cat = fman.get(p.getFoodCategory());
	request.setAttribute("p",p);
	String ext = null;
	if(p.getExtendsPlate()!=null){
		ext="\""+KeyFactory.keyToString(p.getExtendsPlate())+"\"";
	}
	String plateSize =PlateSize.NONE.name();
	if(p.getPlateSize()!=null){
		plateSize=p.getPlateSize().name();
	}
	int isAvailable=0;
	if(PlateStatus.AVAILABLE.equals(p.getStatus())){
		isAvailable=1;
	}
	
	%>{"id":"${p.idStr }","title":"${p.title }",
	"allowsFraction":"${p.allowsFraction }",
	"plateSize":"<%=plateSize%>",
	"priceInCents":${p.priceInCents },
	"foodCategory":"<%=cat.getName() %>",
	"extendsPlate":<%=ext%>,
	"isAvailable":<%=isAvailable %>
}<%
if(iter.hasNext()){
	%>,<%
}
}
%>],"status":"online"}