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

<%!Plate createPlate(String plate,Key foodCatId){	
	//nome|preco em centavos|descricao*|codigo*
	Plate p = new Plate();
	StringTokenizer stokenPlate = new StringTokenizer(plate,"|");
	p.setName(((String) stokenPlate.nextElement()).trim());
	p.setFoodCategory(foodCatId);
	p.setPriceInCents(Integer.valueOf((String) stokenPlate.nextElement()));
	
	Double d = Double.valueOf(p.getPriceInCents()+"");
	d/=100;
	p.setPrice(d);
	if(stokenPlate.hasMoreElements()){				
		p.setDescription(((String) stokenPlate.nextElement()).trim());				
	}else{
		p.setDescription("");
	}
	if(stokenPlate.hasMoreElements()){		
		p.setRestInternalCode(((String) stokenPlate.nextElement()).trim());				
	}else{
		p.setRestInternalCode("");
	}
	return p;
}%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<%
	String restId = request.getParameter("restSelection");
	String action = request.getParameter("action");
	String foodCatId =request.getParameter("foodCategoriesSelection");
	String pasteNeeded="";
	if ("confirm".equals(action)||"paste".equals(action)) {
		
		out.print("Saving:<Br>");
		String newPlates = request.getParameter("newPlates");
		StringTokenizer stoken = new StringTokenizer(newPlates, "#");
		RestaurantManager rman = new RestaurantManager();
		PlateManager pm = new PlateManager();
		Restaurant r = rman.getRestaurant(KeyFactory
				.stringToKey(restId));
		out.println("Há "
				+ stoken.countTokens()
				+ "<br>Serão criados para o restaurante: "
				+ r.getName()
				+ "<br><table><tr><th>Nome</th><th>Desc</th><th>Preço</th><th>Código</th><tr>");
try{
		Key foodCat = KeyFactory.stringToKey(foodCatId);
		Map<Plate,List<Plate>> mapExtendedPlates= new HashMap<Plate,List<Plate>>();
		Datastore.getPersistanceManager().getTransaction().begin();
		while (stoken.hasMoreElements()) {
			String plateStr = (String) stoken.nextElement();
			StringTokenizer allPlates = new StringTokenizer(plateStr,"%%");
			String mainPlate = (String)allPlates.nextElement();
			Plate p = createPlate(mainPlate,foodCat);
			r.addPlate(p);
					
			out.print("<tr>");					
			out.print("<td>" + p.getName() + "</td>");
			out.print("<td>" + p.getDescription() + "</td>");
			out.print("<td>" + p.getPriceInCents() + "</td>");
			out.print("<td>" + p.getRestInternalCode() +"</td>");			
			out.print("</tr>");
			if(allPlates.hasMoreElements()){
				mapExtendedPlates.put(p,new ArrayList<Plate>());
			}
			while(allPlates.hasMoreElements()){
				//creating extended Plates				
				String extPlate  = (String)allPlates.nextElement();  
				Plate extP =  createPlate(extPlate,foodCat);
				mapExtendedPlates.get(p).add(extP);
			}						
		}		
		rman.update(r);
		Datastore.getPersistanceManager().getTransaction().commit();
		out.print("</table>Done!<br/><hr>Sub plates:<br>");
		for(Iterator<Plate> iter = mapExtendedPlates.keySet().iterator();iter.hasNext();){
			Plate p = iter.next();
			List<Plate> list = mapExtendedPlates.get(p);
			%>Plate: <%=p.getName() %> <%=p.getId()%> (<%=list.size() %>)<br><%
			int cc=0;
			for(Iterator<Plate> iterExt = list.iterator();iterExt.hasNext();){
				Plate ext = iterExt.next();
				ext.setExtendsPlate(p.getId());				
				ext.setAvailableTurn(p.getAvailableTurn());				
				r.addPlate(ext);
				cc++;
				out.println("--- "+cc+":"+ext.getName()+" R$ "+ext.getPriceInCents()+" - cód: "+ext.getRestInternalCode()+"<br>");
			}
			
		}
		rman.update(r);
		out.println("<hr>");
	}catch(Exception e){
		out.print("<b style='color:red'>"+e.getMessage()+"</b>");
		
		
	}
}
%>


<%@include file="/static/commonScript.html"%>
<script>
dojo.require("com.copacabana.RoundedButton");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.TitlePane");
dojo.require("com.copacabana.util");
	dojo.addOnLoad(function() {

		initRests();
	});
	function loadFoodCat(){
    	var stateStore = new dojo.data.ItemFileReadStore({
            url: "/listFoodCategoriesItemFileReadStore.do"
        });
        dijit.byId("foodCategoriesSelection").store = stateStore;
        dijit.byId('foodCategoriesSelection').attr('value','<%=foodCatId%>');
        
        dijit.byId("foodCategoriesSelection2").store = stateStore;
        dijit.byId('foodCategoriesSelection2').attr('value','<%=foodCatId%>');
        
    }
	function initRests() {
		loadOtherRestaurants();
		dijit.byId('restSelection').onChange = loadRestData;
		dijit.byId('restSelection2').attr('value','<%=restId%>');
		dijit.byId('restSelection').attr('value','<%=restId%>');
		loadFoodCat();
	}
	function loadRestData() {
		console.log("/restPlateList.do?key="
				+ dijit.byId('restSelection').value);
		var stateStore = new dojo.data.ItemFileReadStore({
			url : "/restPlateList.do?key=" + dijit.byId('restSelection').value
		});
		dijit.byId("platesSelection").store = stateStore;

	}
	function loadOtherRestaurants() {
		var stateStore = new dojo.data.ItemFileReadStore({
			url : "/admin/listRestaurants.do"
		});
		dijit.byId("restSelection").store = stateStore;
		dijit.byId("restSelection2").store = stateStore;
	}
	var listOfNewPlates = [];
	function addNewPlateToList() {
		var str = dijit.byId('platesSelection').textbox.value;
		for ( var i = 0; i < listOfNewPlates.length; i++) {
			if (str == listOfNewPlates[i]) {
				var a = confirm('TemCerteza?')
				console.log(a)
				if (a == false) {
					return;
				}
			}
		}
		var i = listOfNewPlates.length;
		listOfNewPlates.push(str);
		updateList();
	}
	function removeIt(id) {
		listOfNewPlates[id] = null;
		delete listOfNewPlates[id];
		updateList();
	}
	function updateList() {
		dojo.empty(dojo.byId('listOfNewPlates'));
		for ( var i = 0; i < listOfNewPlates.length; i++) {
			var line = dojo.create('div', {
				id : i,
				innerHTML : i + ' - ' + listOfNewPlates[i] + ' '
			}, dojo.byId('listOfNewPlates'));
			dojo.create('a', {
				href : '#',
				innerHTML : 'x',
				style : 'color:red',
				onclick : 'removeIt(' + i + ')'
			}, line);
		}
	}
	checkIfddNewPlateToList = function(evt) {
		if (evt.keyCode == 13) {
			addNewPlateToList();
		}
	}
	function updateValues() {
		var str = '';
		if (listOfNewPlates.length > 0) {
			for ( var i = 0; i < listOfNewPlates.length; i++) {
				if (listOfNewPlates[i] && listOfNewPlates[i] != 'undefined') {
					str += listOfNewPlates[i] + '#';
				}
			}
			dojo.byId('newPlates').value = str;
			return true;
		}
		return false;
	}
</script>
<body class="tundra">
<a href="menuBulkdelete.jsp">Apagar pratos</a> | <a href="menuBulkReplace.jsp">Editar em lote	</a>
<br />
<form action="menuBulkupdate2.jsp" onsubmit="updateValues()"
	method="post">Selecione um restaurante: <input type="hidden"
	name="action" value="confirm"> <select
	dojoType="dijit.form.FilteringSelect" id="restSelection"
	name="restSelection" autoComplete="true"></select> <br />
<select dojoType="dijit.form.FilteringSelect"
	id="foodCategoriesSelection" name="foodCategoriesSelection"
	autoComplete="true"></select> <br />

Format: NOME|PRECO|DESCRICAO*|Código interno*<i>%%SubPlate1</i><br>
Menu--: <select dojoType="dijit.form.FilteringSelect"
	id="platesSelection" onkeypress="checkIfddNewPlateToList"
	name="platesSelection" autoComplete="true" style="width: 500px"
	invalidMessage="Nome de prato nao existe"></select> <br />
<br />
<input type="hidden" name="newPlates" id="newPlates">
<div id="listOfNewPlates"></div>
<br />
<input type="submit"></form>
<%if ("confirm".equals(action)) { %>
<jsp:include page="limpaCache.jsp"></jsp:include>
<%}%>
<form action="menuBulkupdate2.jsp" onsubmit="updateValues()"
	method="post"><input type="hidden" name="action" value="paste">
Selecione um restaurante: <select dojoType="dijit.form.FilteringSelect"
	id="restSelection2" name="restSelection" autoComplete="true"></select>
<br />
<select dojoType="dijit.form.FilteringSelect"
	id="foodCategoriesSelection2" name="foodCategoriesSelection"
	autoComplete="true"></select> <br />
ToPaste: <textarea id="toPaste" name="newPlates" cols="100" rows="20"><%if(request.getParameter("newPlates")!=null){out.print(request.getParameter("newPlates"));}%></textarea>
<input type="submit" value="PastePlates"></form>
</body>