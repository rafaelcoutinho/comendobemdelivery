<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%><%@page import="br.copacabana.spring.DeliveryManager"%><%@page import="br.copacabana.spring.OrderManager"%><%@page import="br.com.copacabana.cb.entities.Payment"%><%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%><%@page import="br.com.copacabana.cb.entities.OrderType"%><%@page import="br.com.copacabana.cb.entities.MealOrderStatus"%><%@page import="java.util.Date"%><%@page import="br.com.copacabana.cb.entities.OrderedPlate"%><%@page import="java.util.HashSet"%><%@page import="br.com.copacabana.cb.entities.MealOrder"%><%@page import="java.util.Enumeration"%><%@page import="br.copacabana.spring.AddressManager"%><%@page import="br.com.copacabana.cb.entities.Neighborhood"%><%@page import="br.copacabana.spring.NeighborhoodManager"%><%@page import="br.copacabana.spring.ClientManager"%><%@page import="br.com.copacabana.cb.entities.Client"%><%@page import="com.google.appengine.api.datastore.Key"%><%@page import="com.google.appengine.api.datastore.KeyFactory"%><%@page import="br.com.copacabana.cb.entities.Address"%><%@page import="java.util.logging.Level"%><%@page import="java.util.logging.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page import="br.com.copacabana.cb.entities.UserBean"%><%@page import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page import="br.copacabana.spring.RestaurantClientManager"%><%@page import="br.copacabana.Authentication"%><%@page import="br.com.copacabana.cb.entities.Restaurant"%><%@page import="br.copacabana.spring.RestaurantManager"%><%
	Logger log = Logger.getLogger("copacabana.Servlet");
try{
String id=request.getParameter("id");
	
Address address = new Address();

String street=request.getParameter("address[street]");
address.setStreet(street);
String phone=request.getParameter("address[phone]");
address.setPhone(phone);
String additionalInfo=request.getParameter("address[additionalInfo]");
address.setAdditionalInfo(additionalInfo);
String number=request.getParameter("address[number]");
address.setNumber(number);

NeighborhoodManager nman = new NeighborhoodManager();

String neighId=request.getParameter("address[neighborhood][id]");
Neighborhood n = nman.get(KeyFactory.stringToKey(neighId));
if(n==null){
	log.severe("Bairro invalido, usando o 1o");
	n=nman.list().iterator().next();
}
address.setNeighborhood(n);

AddressManager addMan = new AddressManager();
address=addMan.createAddres(address);
Key addKey = address.getId();

OrderManager om = new OrderManager();
MealOrder mo = new MealOrder();
mo.setAddress(addKey);
Key clientId = KeyFactory.stringToKey(request.getParameter("clientId"));
Client client = null;
if(clientId.getKind().equals("CLIENT")){
	client = new ClientManager().get(clientId);
}else{
	client= new RestaurantClientManager().get(clientId);
}
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

String delayForecast = request.getParameter("delayForecast");
if (delayForecast != null && delayForecast.length() > 0) {
	mo.setPrepareForeCast(delayForecast);
}

int i = 0;
while(request.getParameter("plates["+i+"][name]")!=null){
	String name = request.getParameter("plates["+i+"][name]");
	log.info("plate: "+name);
	Integer qty = Integer.parseInt(request.getParameter("plates["+i+"][qty]"));
	log.info("plate.qty: "+qty);
	String idPlate = request.getParameter("plates["+i+"][id]");
	log.info("plate.id: "+idPlate);
	String isCustom = request.getParameter("plates["+i+"][custom]");
	log.info("plate.custom: "+isCustom);
	String isFraction = request.getParameter("plates["+i+"][fraction]");
	log.info("plate.fraction: "+isFraction);
	Integer price = Integer.parseInt(request.getParameter("plates["+i+"][priceInCents]"));
	log.info("plate.price: "+price);
	boolean fraction = "true".equals(isFraction);
	boolean custom = "true".equals(isCustom);
	
	OrderedPlate op = new OrderedPlate();
	
	op.setName(name);
	op.setPriceInCents(price);
	op.setIsFraction(fraction);
	op.setQty(qty);
	op.setIsCustom(custom);
	if (fraction) {
		Set<Key> ids = new HashSet<Key>();
		ids.add(KeyFactory.stringToKey(idPlate));
		String fractionId = request.getParameter("plates["+i+"][fractionId]");		
		ids.add(KeyFactory.stringToKey(fractionId));
		op.setFractionPlates(ids);
	} else {
		if (!custom) {
			op.setPlate(KeyFactory.stringToKey(idPlate));
		}
	}
	op.setMealorder(mo);
	mo.getPlates().add(op);
	i++;
}



if (request.getParameter("cpf") != null && request.getParameter("cpf").length() > 0) {
	mo.setCpf(request.getParameter("cpf"));
}


mo.setConvenienceTaxInCents(0);
Key deliveryRange = KeyFactory.stringToKey(request.getParameter("deliveryRangeId"));
DeliveryRange delRange = new DeliveryManager().get(deliveryRange);

mo.setDeliveryCostInCents((int) (delRange.getCost() * 100));
mo.setDeliveryCost(delRange.getCost());

RestaurantManager rman = new RestaurantManager();
Restaurant rest = rman.getRestaurant(Authentication.getLoggedUserKey(session));
mo.setRestaurant(rest.getId());

mo.setObservation(request.getParameter("observation"));
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



%>{"status":"ok","id":"<%=KeyFactory.keyToString(mo.getId()) %>","oldId":"<%=id %>","idXlated":"<%=mo.getXlatedId() %>"}<%}
	catch(Exception e){
		
		log.log(Level.SEVERE,"Error ao syncronizar pedidos",e);
		log.log(Level.SEVERE,"id",request.getParameter("id"));
		log.log(Level.SEVERE,"address[street]",request.getParameter("address[street]"));
		log.log(Level.SEVERE,"address[phone]",request.getParameter("address[phone]"));
		log.log(Level.SEVERE,"address[number]",request.getParameter("address[number]"));
		log.log(Level.SEVERE,"address[neighborhood][id]",request.getParameter("address[neighborhood][id]"));
		log.log(Level.SEVERE,"paymentType",request.getParameter("paymentType"));
		log.log(Level.SEVERE,"clientId",request.getParameter("clientId"));
		log.log(Level.SEVERE,"amountInCash",request.getParameter("amountInCash"));
		log.log(Level.SEVERE,"observation",request.getParameter("observation"));
		log.log(Level.SEVERE,"deliveryRangeId",request.getParameter("deliveryRangeId"));
		log.log(Level.SEVERE,"cpf",request.getParameter("cpf"));
		
		
}%>