<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.City"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.CityManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<head>
<%
String list = "";
if(request.getParameter("list")!=null){
	list=request.getParameter("list");
}
String[] ranges = new String[]{"0","500","1000","1500"};
if(request.getParameter("ranges")!=null){
	ranges=request.getParameterValues("ranges");
}

%>
</head>

<script
	src="http://maps.google.com/maps?file=api&v=2&key=ABQIAAAA6m0W-uA_vumjsKFUXGNNahT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQ25xxNclp9MJYKtCSY_yQtMtVkFg"
	type="text/javascript"></script>
<style>
table {
	font-size: x-small;
}
</style>
Cidade:<input type="text" id="city" value="Campinas"/><br/>
<textarea rows="4" cols="60" id="list"><%=list%></textarea> <div onclick="toggleRanges()">Ranges</div>
<div id="ranges" style="display: none;">
<input type="text" id="blue.low" readonly="readonly" value="<%=ranges[0] %>"/>&lt;= blue &lt;<input type="text" id="blue.high" value="<%=ranges[1] %>"/><br>
<input type="text" id="green.low" value="<%=ranges[1] %>"/>&lt; green &lt;<input type="text" id="green.high" value="<%=ranges[2] %>"/><br>
<input type="text" id="orange.low" value="<%=ranges[2] %>"/>&lt;= orange &lt;<input type="text" id="orange.high" value="<%=ranges[3] %>"/><br>
<input type="text" id="red.low"  value="<%=ranges[3] %>"/>&lt;= red &lt; INF<input type="hidden" id="red.high" value="11111111111"/><br>
<br>
</div>
<button onclick="showAllOnMap()">Show all on map</button>
<div ><span id="msgSec"></span><span id="totais"></span> <span id="errorMsgs"></span></div>
<div id="map_canvas" style="width: 100%; height: 600px"></div>
<script>
	function toggle(id) {
		document.getElementById(id).style.display = 'block';
	}
	function showOnMap(){
		document.getElementById("faction").value="showOnMap";
		document.getElementById("mainform").submit();
		
	}
</script>
<script type="text/javascript">
var toggleRanges=function(){
	var rangesDom = document.getElementById("ranges");
	if(ranges.style.display=='block'){
		ranges.style.display='none';
	}else{
		ranges.style.display='block';
	}
}
    var map = null;
    var geocoder = null;
	var cityCenter = new GLatLng(-22.9071048,-47.0632391);
    function initialize() {
      if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("map_canvas"));
        map.setCenter(cityCenter, 11);
        alreadyCentered=true;
        map.setUIToDefault();
        geocoder = new GClientGeocoder();
      }
    }
	var alreadyCentered=false;
    function showAddress(address,makerOptions,cost) {
      if (geocoder) {
        geocoder.getLatLng(
          address,
          function(point) {
            if (!point) {
              console.warn(address + " not found");
            } else {
              if(alreadyCentered==false){
              	map.setCenter(point, 11);
              	console.log("alreadyCentered",alreadyCentered);
              }
              
              if(point.lng()==cityCenter.lng() && point.lat()==cityCenter.lat()){
            	  console.warn("Setou como centro da cidade",address);
            	  var total=document.getElementById('errorMsgs').innerHTML;
            	  if(!total){
            		  total=0;
            	  }
            	  document.getElementById('errorMsgs').innerHTML=++total;
              }
              alreadyCentered=true;
              makerOptions.draggable=false;
              var marker = new GMarker(point, makerOptions);
              map.addOverlay(marker);
              GEvent.addListener(marker, "dragend", function() {
                marker.openInfoWindowHtml(address+" "+marker.getLatLng().toUrlValue(6)+"<br>cost:"+cost);
              });
              GEvent.addListener(marker, "click", function() {
                marker.openInfoWindowHtml(address+" "+marker.getLatLng().toUrlValue(6)+"<br>cost:"+cost);
              });
	     // GEvent.trigger(marker, "click");
            }
          }
        );
      }
    }
    initialize();
   
    var i = 0;
    var getNeighName=function(line){
    	var arr = line.split("|");
    	return arr[0];
    }
    var lower=function(name){
    	return parseFloat(document.getElementById(name+".low").value);
    }
    var high=function(name){
    	return parseFloat(document.getElementById(name+".high").value);
    }
    var getCost = function(line){
    	var arr = line.split("|");
    	var cost = "none";
    	if(arr.length>=2){
			cost=arr[1];
    	}
    	return cost;
    }
    var getNeighColor=function(line){
    	var arr = line.split("|");
    	var blueIcon = new GIcon(G_DEFAULT_ICON);
        
		if(arr.length>=2){
			var cost =arr[1];
			try{
			if(cost>=lower("blue") &&  cost<high("blue")){
				blueIcon.image = "http://gmaps-samples.googlecode.com/svn/trunk/markers/blue/blank.png";
			}else if(cost>=lower("orange") &&  cost<high("orange")){
				console.log("orange")
				blueIcon.image = "http://gmaps-samples.googlecode.com/svn/trunk/markers/orange/blank.png";
			}else if(cost>=lower("green") &&  cost<high("green")){
				blueIcon.image = "http://gmaps-samples.googlecode.com/svn/trunk/markers/green/blank.png";
			}else if(cost>=lower("red") &&  cost<high("red")){
				console.log("red")
				blueIcon.image = "http://gmaps-samples.googlecode.com/svn/trunk/markers/red/blank.png";
			} 
			}catch(e){
				console.warn(e);
			}
    	}
    	
    	// Set up our GMarkerOptions object
		var markerOptions = { icon:blueIcon };
    	return markerOptions;
    }
    var executeForOne=function(){
    	var line = nnames[i];    	
    	console.log(i+":line",line);
    	if(!line || line.length==0){
    		return;
    	}
    	var neigName=getNeighName(line);
    	var makerOptions=getNeighColor(line);
    	if(i<nnames.length){
    		showAddress(neigName+","+document.getElementById("city").value,makerOptions,getCost(line));
    	}
    	document.getElementById('msgSec').innerHTML='adicionados ';
    	document.getElementById('totais').innerHTML=(i+1)+' '+nnames.length;
    	
    	i++;
    	if(i<nnames.length){    		
    		setTimeout(executeForOne,250);
    	}
    }
    
    var nnames=[];
    function showAllOnMap(){
    	map.clearOverlays();
    	nnames=document.getElementById("list").value.split("\n");
    	if(nnames.length==1){
    		if(document.getElementById("list").value.split("#").length>0){
    			nnames=document.getElementById("list").value.split("#");
    		}	
    	}
    	i = 0;
    	executeForOne();
    }
    
    
    
    
    </script>
