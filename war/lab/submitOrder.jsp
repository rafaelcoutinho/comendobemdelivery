<%@page import="br.com.copacabana.cb.entities.OrderType"%>
<%@page import="br.copacabana.usecase.erp.JSPUtils"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%>
<%@page import="br.copacabana.spring.DeliveryManager"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="java.util.Date"%>
<%@page import="br.com.copacabana.cb.entities.MealOrderStatus"%>
<%@page import="br.com.copacabana.cb.entities.OrderedPlate"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.com.copacabana.cb.entities.Payment"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantClientManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@ taglib
	prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale
	value='pt' />
<fmt:setBundle basename='messages' />

<%
	String clientId = request.getParameter("client");
	String[] plates = request.getParameterValues("plate");

	MealOrder mo = new MealOrder();
	Address deliveryAddress = null;
	if (request.getParameter("addressId") != null && request.getParameter("addressId").length() > 0) {
		deliveryAddress = new AddressManager().get(KeyFactory.stringToKey(request.getParameter("addressId")));
	} else {
		deliveryAddress = JSPUtils.getAddress(request);
	}

	mo.setAddress(deliveryAddress.getId());
	RestaurantClientManager rcman = new RestaurantClientManager();

	Client client = null;
	Key clientKey = KeyFactory.stringToKey(clientId);
	if (clientKey.getKind().equals("CLIENT")) {
		client = new ClientManager().get(clientKey);

		if (request.getSession().getAttribute("address.id") == null) {
			client.getAddresses().add(deliveryAddress.getId());
			new ClientManager().persist(client);
			client = new ClientManager().get(clientKey);
		}

	} else {
		client = rcman.get(clientKey);

		if (request.getSession().getAttribute("address.id") == null) {
			client.getAddresses().add(deliveryAddress.getId());
			rcman.persist((RestaurantClient) client);
			client = rcman.get(clientKey);
		}

	}
	OrderManager om = new OrderManager();
	mo.setClient((Client) client);
	mo.setClientName(client.getName());
	mo.setClientPhone(client.getMainPhone());
	if (client.getId().getKind().equals("CLIENT")) {
		mo.setClientRequestsOnRestaurant(om.getClientOrdersInRestaurant(client, mo.getRestaurant()).size());
		mo.setClientRequestsOnSite(om.getClientOrdersInSite(client).size());
	} else {
		mo.setClientRequestsOnRestaurant(0);
		mo.setClientRequestsOnSite(0);
	}
	if (request.getParameter("cpf") != null && request.getParameter("cpf").length() > 0) {
		mo.setCpf(request.getParameter("cpf"));
	}
	mo.setConvenienceTaxInCents(0);
	Key deliveryRange = KeyFactory.stringToKey(request.getParameter("deliveryRangeId"));
	DeliveryRange delRange = new DeliveryManager().get(deliveryRange);

	mo.setDeliveryCostInCents((int) (delRange.getCost() * 100));
	mo.setDeliveryCost(delRange.getCost());
	mo.setObservation(request.getParameter("observation"));
	RestaurantManager rman = new RestaurantManager();
	Restaurant rest = rman.getRestaurant(Authentication.getLoggedUserKey(session));
	mo.setRestaurant(rest.getId());

	String delayForecast = request.getParameter("delayForecast");
	if (delayForecast != null && delayForecast.length() > 0) {
		mo.setPrepareForeCast(delayForecast);
	}

	PlateManager pm = new PlateManager();

	String[] plateName = (String[]) session.getAttribute("plateName");
	String[] plateQty = (String[]) session.getAttribute("plateQty");
	String[] platePrice = (String[]) session.getAttribute("platePrice");
	String[] plateCustom = (String[]) session.getAttribute("plateCustom");
	String[] plateFraction = (String[]) session.getAttribute("plateFraction");
	String[] plateId = (String[]) session.getAttribute("plateId");
	String[] plateFractionId = (String[]) session.getAttribute("plateFractionId");
	List<OrderedPlate> plateList = new ArrayList<OrderedPlate>();
	for (int i = 0; i < plateName.length; i++) {
		String name = plateName[i];
		Integer qty = Integer.parseInt(plateQty[i]);
		String id = plateId[i];
		Integer price = Integer.parseInt(platePrice[i]);
		boolean fraction = "true".equals(plateFraction[i]);
		boolean custom = "true".equals(plateCustom[i]);
		OrderedPlate op = new OrderedPlate();
		op.setName(name);
		op.setPriceInCents(price);
		op.setIsFraction(fraction);
		op.setQty(qty);
		op.setIsCustom(custom);
		if (fraction) {
			Set<Key> ids = new HashSet<Key>();
			ids.add(KeyFactory.stringToKey(id));
			ids.add(KeyFactory.stringToKey(plateFractionId[i]));
			op.setFractionPlates(ids);
		} else {
			if (!custom) {
				op.setPlate(KeyFactory.stringToKey(id));
			}
		}
		op.setMealorder(mo);
		mo.getPlates().add(op);
	}

	mo.setOrderedTime(new Date());
	mo.updateTotals();
	mo.setStatus(MealOrderStatus.PREPARING);
	mo.setOrderType(OrderType.ERP);
	String ptypeStr = request.getParameter("paymentType");
	PaymentType ptype = PaymentType.valueOf(ptypeStr);
	Payment pay = new Payment();
	pay.setType(ptype);
	if (ptype.equals(PaymentType.INCASH)) {
		String amountInCash = request.getParameter("amountInCash");

		Double cost = Double.parseDouble(amountInCash);
		pay.setAmountInCash(cost);
	}

	mo.setPayment(pay);

	om.create(mo);
	response.sendRedirect("showFinalOrder.jsp?trac=" + mo.getId().getId() + "&xlated=" + mo.getXlatedId() + "&orderId=" + KeyFactory.keyToString(mo.getId()));
%>