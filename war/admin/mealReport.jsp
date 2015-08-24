<%@page import="br.com.copacabana.cb.entities.MealOrderStatus"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.com.copacabana.cb.entities.Payment.PaymentType"%>
<%@page import="br.com.copacabana.cb.entities.Payment"%>
<%@page import="java.text.ParseException"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.copacabana.util.TimeController"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn"
	uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%><%@page
	import="com.google.gson.JsonParser"%><%@page
	import="com.google.gson.JsonElement"%><%@page
	import="com.google.gson.JsonObject"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%><fmt:setLocale value='pt' />
<%@page import="java.util.Locale"%>
<c:if test="${param.isMobile ne 'true'}">
	<jsp:include page="/admin/adminHeader.jsp"></jsp:include>
	<br>
</c:if>
<%!final int CLIENT = 1;%>
<%!final int RESTAURANT = 2;%>
<%!final int PAYMENT = 3;%>
<%!final int STATUS = 4;%>
<%!SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");%>
<%!Date getDate(String str) throws ParseException {
		sdf.setTimeZone(TimeController.getDefaultTimeZone());
		return sdf.parse(str);

	}%>
<%
	
	try {
		String patternDay = "kk:mm dd";

		OrderManager om = new OrderManager();
		RestaurantManager rm = new RestaurantManager();
		List<MealOrder> mlist = new ArrayList<MealOrder>();
		String startStr = request.getParameter("start");
		String endStr = request.getParameter("end");
		String fby = request.getParameter("filterBy");
		if (startStr == null) {
			startStr = "01/01/2009";
		} else {
			if(fby==null){
			fby = "0";
			}
			
		}
		if (endStr == null) {
			endStr = "01/01/2015";
		}
		Date start = getDate(startStr);
		Date end = getDate(endStr);
		StringBuffer sb = new StringBuffer();
		StringBuffer sbDesc = new StringBuffer();
		sbDesc.append("data "+startStr+" a "+endStr);
		if (fby != null) {
			 
			Integer filterBy = Integer.parseInt(fby);
			String filterParam = request.getParameter("filterParam");
			sb.append("<input type='hidden' name='subFilter' value='"+filterBy+"'>");
			sb.append("<input type='hidden' name='subFilterValues' value='"+filterParam+"'>");
			Query q = null;
			switch (filterBy) {
			case STATUS: 
			case 0: {
				
				sb= new StringBuffer();	
				q = Datastore.getPersistanceManager().createQuery("select from MealOrder where orderedTime>:start and orderedTime<=:end");
				break;
			}
			case CLIENT: {
				
				Client ck = new ClientManager().get(KeyFactory.stringToKey(filterParam));
				sbDesc.append(", cliente "+ck.getEmail());
				q = Datastore.getPersistanceManager().createQuery("select from MealOrder where client=:ancestor and orderedTime>:start and orderedTime<=:end");
				q.setParameter("ancestor", ck);
				break;
			}
			case RESTAURANT: {
				Key ck = KeyFactory.stringToKey(filterParam);
				sbDesc.append(", restaurante");
				q = Datastore.getPersistanceManager().createQuery("select from MealOrder where restaurant=:rest and orderedTime>:start and orderedTime<=:end");
				q.setParameter("rest", ck);
				break;
			}
			case PAYMENT: {
				PaymentType ck = Payment.PaymentType.valueOf(filterParam);
				q = Datastore.getPersistanceManager().createQuery("select from MealOrder where orderedTime>:start and orderedTime<=:end");
				q.setParameter("payment", ck);
				sbDesc.append(", pagamento: "+ck.name());
				break;
			}
			
			}
			q.setParameter("start",start);
			q.setParameter("end",end);
			mlist=q.getResultList();
			if(filterBy==PAYMENT){
				List<MealOrder> olist = new ArrayList<MealOrder>();
				for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
					MealOrder mo = iter.next();
					if(mo.getPayment().getType().equals(Payment.PaymentType.valueOf(filterParam))){
						olist.add(mo);
					}
				}
				mlist=olist;
			}
			if(filterBy==STATUS){
				List<MealOrder> olist = new ArrayList<MealOrder>();
				for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
					MealOrder mo = iter.next();
					if(mo.getStatus().equals(MealOrderStatus.valueOf(filterParam))){
						olist.add(mo);
					}
				}
				mlist=olist;
			}
			String[] subFilters = request.getParameterValues("subFilter");
			String[] subFiltersValues = request.getParameterValues("subFilterValues");
			if(subFilters!=null){
				for(int i = 0;i<subFilters.length;i++){
					int filter = Integer.parseInt(subFilters[i]);
					String filterParam2 = subFiltersValues[i];
					if(filter!=0){
						sb.append("<input type='hidden' name='subFilter' value='"+filter+"'>");
						sb.append("<input type='hidden' name='subFilterValues' value='"+filterParam2+"'>");
						System.out.println("f "+filter+" : "+filterParam2);
						switch (filter) {						
						case CLIENT: {							
							Client ck = new ClientManager().get(KeyFactory.stringToKey(filterParam2));
							List<MealOrder> olist = new ArrayList<MealOrder>();
							for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
								MealOrder mo = iter.next();
								if(mo.getClient().getId().equals(ck.getId())){
									olist.add(mo);
								}
							}
							
							mlist=olist;
							sbDesc.append(", scliente: "+ck.getEmail());
							break;
						}
						case RESTAURANT: {
							Key ck = KeyFactory.stringToKey(filterParam2);
							
							List<MealOrder> olist = new ArrayList<MealOrder>();
							for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
								MealOrder mo = iter.next();
								if(mo.getRestaurant().equals(ck)){
									olist.add(mo);
								}
							}
							sbDesc.append(", srestaurante");
							mlist=olist;
							break;
						}
						case PAYMENT: {
							List<MealOrder> olist = new ArrayList<MealOrder>();
							for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
								MealOrder mo = iter.next();
								System.out.println(filterParam2);
								if(mo.getPayment().getType().equals(Payment.PaymentType.valueOf(filterParam2))){
									olist.add(mo);
								}
							}
							mlist=olist;
							sbDesc.append(", spagamento: "+filterParam2);
							break;
						}

						}
					}
				}
				
			}
			sbDesc.append(" <a href='mealReport.jsp'>resetar filtro</a>");
		}
%>
<%@include file="/static/commonScript.html"%>


Pedidos
<br>
<script >
	var filterBy = function(type, value) {
		dojo.create("input", {
			type : "text",
			value : value,
			"name" : "filterParam"
		}, dojo.byId("form"));
		dojo.create("input", {
			type : "text",
			value : type,
			"name" : "filterBy"
		}, dojo.byId("form"));
		dojo.byId("form").submit();
}
//-->
</script>
<form action="mealReport.jsp" id="form">
<%=sb.toString() %><Br>
Periodo: <input
	name="start" value="<%=sdf.format(start)%>"> <input name="end"
	value="<%=sdf.format(end)%>"> <input type="submit" value="filtrar"><br>
	<%=sbDesc.toString() %><br>
	<%Integer total = 0; %>
<table>
	<thead>
		<tr>
		<th>#</th>
			<th>Data</th>
			<th>Restaunte</th>
			<th>Cliente</th>
			<th>email</th>
			<th>Pagto</th>
			<th>PayPalPayerId</th>
			<th>Valor</th>
			<th>Status</th>
		</tr>
	</thead>
	<tbody>
		<%
			for (Iterator<MealOrder> iter = mlist.iterator(); iter.hasNext();) {
					MealOrder mo = iter.next();
					String restId = KeyFactory.keyToString(mo.getRestaurant());
					String restName = rm.getRestaurant(mo.getRestaurant()).getName();
		%>
		<tr><td><a href="manageorder.jsp?id=<%=mo.getIdStr()%>"><%=mo.getXlatedId() %></a></td>
			<td><%=sdf.format(mo.getOrderedTime())%></td>
			<td ><a href="#" onclick="filterBy(2,'<%=restId%>');return false;"><%=restName%></a></td>
			<td ><%=mo.getClientName()%> <a onclick="filterBy(1,'<%=mo.getClient().getIdStr()%>')">filtrar</a></td>
			<td ><%=mo.getClient().getEmail()%> <%=mo.getClient().getLevel().name() %></td>
			<td ><%=mo.getPayment().getType().name()%> <a onclick="filterBy(3,'<%=mo.getPayment().getType().name()%>')">filtrar</a></td>
			<td><%if(Payment.PaymentType.PAYPAL.equals(mo.getPayment().getType())){ %><%=mo.getPayment().getPayerId() %><%} %></td>			
			<td><%=mo.getAmountLessTaxes()%> </td>			
			<td><%=mo.getStatus().name()%> <a onclick="filterBy(4,'<%=mo.getStatus().name()%>')">filtrar</a></td>
		</tr>
		<%
			total+=mo.getAmountLessTaxes();
			}
		%>
	</tbody>
</table>
<b>Total: <%=((Double.valueOf(""+total))/100.0) %></b>
</form>
<%
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
