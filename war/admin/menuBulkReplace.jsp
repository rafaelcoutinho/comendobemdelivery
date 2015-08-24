<%@page import="javax.persistence.Query"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.StringTokenizer"%>
<%@ taglib prefix="cb"
	tagdir="/WEB-INF/tags"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn"
	uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/admin/adminHeader.jsp"></jsp:include>
<%
	RestaurantManager rm = new RestaurantManager();
	PlateManager pm = new PlateManager();

	FoodCategoryManager fm = new FoodCategoryManager();
	String restId = request.getParameter("restSelection");
	String foodCatId = request.getParameter("foodCategoriesSelection");
	List<Plate> list = new ArrayList<Plate>();
	if (restId != null) {

		Key foodKey = KeyFactory.stringToKey(foodCatId);
		FoodCategory fc = fm.get(foodKey);
		Key restKey = KeyFactory.stringToKey(restId);
		Restaurant r = rm.get(restKey);
		if ("save".equals(request.getParameter("action"))) {
			String[] keysStr = request.getParameterValues("id");

			String[] restInternalCode = request
					.getParameterValues("restInternalCode");
			String[] desc = request
			.getParameterValues("description");
			for (int i = 0; i < keysStr.length; i++) {
				Datastore.getPersistanceManager().getTransaction().begin();
				Key k = KeyFactory.stringToKey(keysStr[i]);
				Plate p = pm.get(k);
				p.setRestInternalCode(restInternalCode[i]);
				p.setDescription(desc[i]);
				pm.persist(p);
				Datastore.getPersistanceManager().getTransaction().commit();
			}

		}
		Query query = Datastore.getPersistanceManager().createNamedQuery("getRestPlateByCategorySpecial");
		query.setParameter("foodCat", foodKey);
		query.setParameter("restaurant", r);
		 
		list = query.getResultList();
	}
%>



<body>
	<form action="menuBulkReplace.jsp" method="post">
		 Restaurante:<select name="restSelection">
			<%
			for (Iterator<Restaurant> iter = rm.list().iterator(); iter
					.hasNext();) {
				Restaurant r = iter.next();
				String selected = "";
				System.out.println(r.getIdStr());
				if (r.getIdStr().equals(restId)) {
					selected = "selected='selected'";
				}
				
		%><option <%=selected%> value="<%=r.getIdStr()%>"><%=r.getName()%></option>
			<%
				}
			%>
		</select><Br> <select name="foodCategoriesSelection">
			<%
				for (Iterator<FoodCategory> iter = fm.list().iterator(); iter
						.hasNext();) {
					FoodCategory r = iter.next();
					String selected = "";
					if (r.getIdStr().equals(foodCatId)) {
						selected = "selected='selected'";
					}
			%><option <%=selected %> value="<%=r.getIdStr()%>"><%=r.getName()%></option>
			<%
				}
			%>
		</select><br /><input type="submit" value="carregar"></form>
		
		<form action="menuBulkReplace.jsp" method="post"><input type="hidden" value="${param.restSelection }" name="restSelection">
		<input type="hidden" value="${param.foodCategoriesSelection }" name="foodCategoriesSelection">
		<table>
			<thead>
				<tr>
					<th>Id</th>
					<th>title</th>
					<th>restInternalCode</th>
					<th>Descricao</th>
					<th>priceInCents</th>
					<th>Extende o prato</th>

				</tr>
			</thead>
			<tbody>
				<%
					for (Iterator<Plate> iter = list.iterator(); iter.hasNext();) {
						Plate p = iter.next();
						request.setAttribute("plate",p);
				%><tr>
					<td><input type="hidden" name="id" value="<%=p.getIdStr()%>" />${plate.id.id }
					</td>
					<td><input type="text" name="title" value="${plate.title }" />
					</td>
					<td><input type="text" name="restInternalCode"
						value="<%=p.getRestInternalCode()%>" />
					</td>
					<td><textarea type="text" name="description" >${plate.description}</textarea>
					</td>
					<td><input type="text" name="priceInCents"
						value="<%=p.getPriceInCents()%>" />
					</td>
					<td>
						<%
							if (p.getExtendsPlate() != null) {
								Plate main = pm.get(p.getExtendsPlate());
								if(main!=null){
						%>Extende prato: <%=main.getTitle()%>
						<%
							}else{
								%>possui extends mas nao acha prato<%
							}
								}
						%>
					</td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<%
			if (list!=null&&list.size() > 0) {
		%><input type="hidden" value="save" name="action">
		<%
			}
		%>
		<input type="submit">
	</form>
</body>