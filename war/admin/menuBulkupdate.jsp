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
				+ "<br><table><tr><th>Nome</th><th>Desc</th><th>Preço</th><th></th><tr>");
try{
		while (stoken.hasMoreElements()) {
			String plate = (String) stoken.nextElement();
			StringTokenizer stokenPlate = new StringTokenizer(plate,
					"|");
			out.print("<tr>");
			int i = 0;
			Plate p = new Plate();
			p.setName(((String) stokenPlate.nextElement()).trim());
			p.setFoodCategory(KeyFactory.stringToKey(foodCatId));
			p.setPriceInCents(Integer.parseInt((String) stokenPlate.nextElement()));
			
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
			out.print("<td>" + p.getName() + "</td>");
			out.print("<td>" + p.getDescription() + "</td>");
			out.print("<td>" + p.getPrice() + "</td>");
			out.print("<td>" + p.getRestInternalCode() + "</td>");
			r.addPlate(p);
			out.print("</tr>");	
			
		}
		//if ("paste".equals(action)){
			rman.update(r);
		//}
		
		out.print("</table>Done!<br/><hr>");
	
	
	}catch(Exception e){
		out.print("<b style='color:red'>"+e.getMessage()+"</b>");
		
		
	}
	}
%>


<%@include file="/static/commonScript.html"%>
<script>
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
<a href="menuBulkdelete.jsp">Apagar pratos</a>
<br />
<form action="menuBulkupdate.jsp" onsubmit="updateValues()"
	method="post">Selecione um restaurante: <input type="hidden"
	name="action" value="confirm"> <select
	dojoType="dijit.form.FilteringSelect" id="restSelection"
	name="restSelection" autoComplete="true"></select> <br />
<select dojoType="dijit.form.FilteringSelect"
	id="foodCategoriesSelection" name="foodCategoriesSelection"
	autoComplete="true"></select> <br />

Format: NOME|PRECO|DESCRICAO*|Código interno*<br>
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
<form action="menuBulkupdate.jsp" onsubmit="updateValues()"
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