<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@include file="/static/commonScript.html" %>
<script>
dojo.require("com.copacabana.search.SearchRestaurantsWidget");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("com.copacabana.RestaurantWheelWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser"); 
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");

var loaddata = function(){	
	
	
	var xhrParams = {
			error : function(error){
						console.log('failed to load coords ',error);
					},
			url: "/admin/listUnassignedLocations.do",
			handleAs : 'json',
			load : listThem        			
	};
	dojo.xhrGet(xhrParams);
}
var cache ={};
var listThem=function(data) {
	console.log(data);
	var table = dojo.create("table",{border:1},dojo.byId('section'));
	createRow(table,"id","X","Y","Endereco","Lastaccess","Total");
	cache ={};
	for(var i =0;i<data.length;i++){
		if(cache[data[i].formattedAddress]!=null){
			cache[data[i].formattedAddress].data.count+=1;
			cache[data[i].formattedAddress].listOfCoords.push(data[i].x+','+data[i].y);
			
		}else{
			data[i].count=1;
			cache[data[i].formattedAddress]={data:data[i],listOfCoords:[data[i].x+','+data[i].y]};
		}
	}
	
	//for(var i =0;i<data.length;i++){
	for(var id in cache){
		var item = cache[id].data;
		console.log(id);
		console.log(item,id);
		createRow(table,item.id,item.x,item.y,item.formattedAddress,item.date,item.count);
	}
}

var selectIt= function (id,x,y,add){
	
dijit.byId("theForm").attr('value',{id:id,x:x,y:y,formattedAddress:add});
dijit.byId("autolocateForm").attr('value',{id:id,x:x,y:y,formattedAddress:add});
	
	
}
function showOtherData(formattedAddress){
console.log(formattedAddress);
var txt ="The other x,y coordinates for this same address are:\n";
for(var i=0;i<cache[formattedAddress].listOfCoords.length;i++){
txt+='('+cache[formattedAddress].listOfCoords[i]+')\n';
}
alert(txt);
}
var createRow=function(table,id,x,y,address,count,lastdate){

	var tr = dojo.create("tr",null,table);
	var td0 = dojo.create("td",null,tr);

	var action= dojo.create("div",{onClick:"selectIt('"+id+"','"+x+"','"+y+"','"+address+"')"},td0);
	//dojo.connect(action,'onClick',null,selectIt);
	action.innerHTML="Selecionar";
	
	var td = dojo.create("td",null,tr);
	td.innerHTML=x;
	var td2 = dojo.create("td",null,tr);
	td2.innerHTML=y;
	var clicks = {onclick:'showOtherData(\''+address+'\')',style:{cursor:'pointer'}};
	var td3 = dojo.create("td",clicks,tr);
	td3.innerHTML=address;
	var td32 = dojo.create("td",clicks,tr);
	td32.innerHTML=lastdate;
	var td31 = dojo.create("td",clicks,tr);
	td31.innerHTML=count;
	var td8 = dojo.create("td",null,tr);
	dojo.create('a',{href:'http://maps.google.com/maps?q='+address,innerHTML:'gmaps'},td8);
	
	
	var td4 = dojo.create("td",null,tr);
	var action2= dojo.create("div",{onClick:"deleteIt('"+id+"')"},td4);
	//dojo.connect(action,'onClick',null,selectIt);
	action2.innerHTML="Apagar";	
	
}
dojo.addOnLoad(function() {
	loaddata();
	loadNeighborhood()

});
function loadNeighborhood(){
	var stateStore = new dojo.data.ItemFileReadStore({
        url: "/listNeighborsItemFileReadStore.do"
    });
    dijit.byId("neighSelection").store = stateStore;
}
submitIt = function (){	
	dijit.byId("theForm").submit();	
}
deleteIt = function(id){
	var a  = confirm("quer mesmo apagar?");
	console.log(a);
	if(a==true){
		window.location='deleteLocation.jsp?key='+id;
	}
}
</script>
<body class="tundra">
<div id="section"></div>
<br/>
<form action="/addXYCoords.do" method="post" dojoType="dijit.form.Form" id="theForm">
id: <input type="text" name="id" dojoType="dijit.form.TextBox"></input><br/>
X:<input type="text" name="x" dojoType="dijit.form.TextBox"></input><br/>
Y:<input type="text" name="y" dojoType="dijit.form.TextBox"></input><br/>
AddressTxt:<input type="text" name="formattedAddress" dojoType="dijit.form.TextBox"></input><br/>
Bairro*:<select dojoType="dijit.form.FilteringSelect" id="neighSelection" name="neighborhood" autoComplete="true" invalidMessage="Invalid neigh name"></select><br/>
<button type="submit" dojoType="dijit.form.Button" id="submitButton" onclick="submitIt()">
Atualizar!</button>
</form>
<hr>
Test autolocate<br/>

<form id="autolocateForm" action="/autolocate.do" method="post" dojoType="dijit.form.Form">
X:<input type="text" name="x" dojoType="dijit.form.TextBox"></input><br/>
Y:<input type="text" name="y" dojoType="dijit.form.TextBox"></input><br/>
AddressTxt:<input type="text" name="formattedAddress" dojoType="dijit.form.TextBox"></input><br/>
<input type="submit">
</form>
</body>