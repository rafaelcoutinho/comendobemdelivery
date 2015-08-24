<%@page import="br.copacabana.usecase.menu.DeletePlate"%>
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
	if ("delete".equals(action)) {
		EntityManagerBean em = CityIdentifier
				.getEntityManager(getServletContext());
		out.print("Deleting:<Br>");
		DeletePlate del = new DeletePlate();
		
		String[] toDelete = request.getParameterValues("toDelete");
		for(int i=0;i<toDelete.length;i++){
			del.setId(toDelete[i]);
			out.println("- "+toDelete[i]+"<br>");
			del.execute();
		}
		
		out.print("Done!<br/><hr>");
	}
	

	if ("save".equals(action)) {

	}
%>


<%@include file="/static/commonScript.html"%>
<script>
	dojo.addOnLoad(function() {

		initRests();
	});
	function initRests() {
		loadOtherRestaurants();
		dijit.byId('restSelection').onChange = loadRestData;
		dijit.byId('restSelection').attr('value','<%=restId%>');
		
	}
	function toggle(){
		var cs = dojo.query("[type=checkbox]");
		for(var i=0;i<cs.length;i++){
			var item = cs[i];			
			if(item.checked==false){
				item.checked=true;
			}else{
				item.checked=false;	
			}
		}
	}
	function selectPossiblyDupe(){
		var cs = dojo.query("[type=checkbox]");
		var seen= "";
		for(var i=0;i<cs.length;i++){
			var item = cs[i];
			var cname = item.attributes.customname.value;
			if(seen.indexOf(cname)>-1){
				item.checked=true;
			}else{
				seen+=cname+"|";
				item.checked=false;
			}
			
		}
	}
	function list(items){
		dojo.empty(dojo.byId('listOfNewPlates'));
		dojo.byId('tocopy').value='';
		for ( var i = 0; i < items.length; i++) {
			if(pstore.getValue(items[i], "extendsPlate")){
				continue;
			}
			var div = dojo.create('div', {},dojo.byId('listOfNewPlates'));
			dojo.create('input', {type:'checkbox',name:'toDelete',checked:'checked', value:pstore.getValue(items[i], "id"),"customname":pstore.getValue(items[i], "name")},div);
			dojo.create('span', {				
				innerHTML : pstore.getValue(items[i], "name")+" R$"+pstore.getValue(items[i], "price"),				
			}, div);
			
			dojo.byId('tocopy').value+=
				pstore.getValue(items[i], "name")+
				"|"+
				pstore.getValue(items[i], "price")+
				"|"+pstore.getValue(items[i], "description")+"#";
		}
		
	}
	var pstore=null;
	function error(err){
		console.error(err);
	}
	function loadRestData() {
		console.log("/restPlateList.do?key="
				+ dijit.byId('restSelection').value);
		pstore = new dojo.data.ItemFileReadStore({
			url : "/restPlateList.do?key=" + dijit.byId('restSelection').value
		});
		pstore.fetch({onComplete: list, onError: error});
		

	}
	function loadOtherRestaurants() {
		var stateStore = new dojo.data.ItemFileReadStore({
			url : "/admin/listRestaurants.do"
		});
		dijit.byId("restSelection").store = stateStore;
	}
	var listOfNewPlates = [];
	function addNewPlateToList() {
		var str = dijit.byId('platesSelection').textbox.value;
		for ( var i = 0; i < listOfNewPlates.length; i++) {
			if (str == listOfNewPlates[i]) {
				var a = confirm('Tem Certeza?')
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
	function removeIt(id){
		listOfNewPlates[id]=null;
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
<a href="menuBulkupdate2.jsp">Criar pratos</a><br/>
<form action="menuBulkdelete.jsp"  method="post">
Selecione um restaurante: <input type="hidden" name="action"
	value="delete"> <select dojoType="dijit.form.FilteringSelect"
	id="restSelection" name="restSelection" autoComplete="true"></select> <br />
<a href="javascript:toggle()">Select/deselect all</a> - <a href="javascript:selectPossiblyDupe()">Select duplicates</a>
<br />

<div id="listOfNewPlates"></div>
<input type="submit" value="Delete!">
</form>
ToCopy: <textarea id="tocopy" cols="100" rows="20"></textarea>
</body>