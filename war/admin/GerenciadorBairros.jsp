<%@page import="br.copacabana.raw.filter.Datastore"%>
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
<script
	src="http://maps.google.com/maps?file=api&v=2&key=ABQIAAAA6m0W-uA_vumjsKFUXGNNahT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQ25xxNclp9MJYKtCSY_yQtMtVkFg"
	type="text/javascript"></script>
<style>
table {
	font-size: x-small;
}
</style>
<%!
String removeLineFeed(String name){
if (((int) name.charAt(name.length() - 1)) == 13) {
	name = name.substring(0, name.length() - 1);
} 
return name;
}

%>
<%!String normalizeName(String name) {

		

		return name.toLowerCase().replace('í', 'i').replace('ã', 'a')
				.replace('ç', 'c').replace('õ', 'o').replace('ú', 'u');

	}%>
<%
StringBuilder toCreateArray = new StringBuilder("[");
StringBuilder pastedArray = new StringBuilder("[ ");
	
	CityManager cm = new CityManager();
	NeighborhoodManager nm = new NeighborhoodManager();
	List<Neighborhood> neighs = new ArrayList<Neighborhood>();
	Key currCity = null;
	Map<String, Neighborhood> map = new HashMap<String, Neighborhood>(0);
	if (request.getParameter("city") != null) {
		currCity = KeyFactory.stringToKey(request.getParameter("city"));
		neighs = nm.getOrderedNeighborByCity(cm.getCity(currCity));

		Set<Neighborhood> set = cm.getCity(currCity).getNeighborhoods();

		for (Iterator<Neighborhood> iter = set.iterator(); iter.hasNext();) {
			Neighborhood n = iter.next();
			map.put(normalizeName(n.getName()), n);
		}

	}

	if (request.getParameter("action") != null) {
		if (request.getParameter("action").equals("showOnMap")) {
			String[] names = request.getParameterValues("nlist");
			City c = Datastore.getPersistanceManager().find(City.class, KeyFactory.stringToKey(request.getParameter("fromCity")));
			
			StringBuilder sb = new StringBuilder("http://maps.google.com/maps/api/staticmap?center=Cambui,Campinas&zoom=11&size=512x512&maptype=roadmap&sensor=false&markers=");
			try {
				int i = 0;
				for (i = 0; i < names.length; i++) {
					sb.append(names[i]).append(",").append(c.getName()).append("|");
					if(sb.length()>220){
						break;
					}
				}
				
				
				out.print("<br>Link : <a target='_blank' href='"+sb.toString()+"'>"+sb.toString()+"</a><hr>");
				
			} catch (Exception e) {
				e.printStackTrace();
				
			}
		}
		if (request.getParameter("action").equals("delete")) {
			Neighborhood n = nm.getEntityManagerBean().getEntityManager().find(Neighborhood.class, KeyFactory.stringToKey(request.getParameter("id")));
			try {
				Datastore.getPersistanceManager().getTransaction().begin();
				nm.getEntityManagerBean().getEntityManager().remove(n);
				Datastore.getPersistanceManager().getTransaction().commit();
			} catch (Exception e) {
				e.printStackTrace();
				Datastore.getPersistanceManager().getTransaction().rollback();
			}
		}
		if (request.getParameter("action").equals("createNeighs")) {
			String[] names = request.getParameterValues("neighbors");
			City c = Datastore.getPersistanceManager().find(City.class, KeyFactory.stringToKey(request.getParameter("fromCity")));
			try {
				Datastore.getPersistanceManager().getTransaction().begin();
				int i = 0;
				for (i = 0; i < names.length; i++) {
					Neighborhood n = new Neighborhood(names[i], "", c);
					Datastore.getPersistanceManager().persist(n);
				}

				Datastore.getPersistanceManager().getTransaction().commit();
				out.print("<br>Created " + i + " neighs for " + c.getName() + "<bR><hr>");
			} catch (Exception e) {
				e.printStackTrace();
				Datastore.getPersistanceManager().getTransaction().rollback();
			}
		}

	}

	request.setAttribute("neighs", neighs);
%>
<form action="GerenciadorBairros.jsp">Ver todos os bairros de: <select
	name="city">
	<%
		for (Iterator<City> iter = cm.list().iterator(); iter.hasNext();) {
			City c = iter.next();
			String selected = "";
			if (c.getId().equals(currCity)) {
				selected = "selected='selected'";
			}
	%><option value="<%=KeyFactory.keyToString(c.getId())%>" <%=selected%>><%=c.getName()%></option>
	<%
		}
	%>
</select><input type="submit" value="carregar"></form>

<form action="GerenciadorBairros.jsp" method="post"><input
	type="hidden" name="action" value="showOnMap"><input
	type="hidden" name="fromCity"
	value="<%=request.getParameter("city") %>" /> Bairros Carregadis: <%=neighs.size()%><div
	onclick="document.getElementById('neighsTable').style.display='block'">ver</div>
<br />
<div id="neighsTable" style="display: none">
<table>
	<tr>
		<%
	int j = 0;
		StringBuilder nnamesstr = new StringBuilder();
	for (Iterator<Neighborhood> iter = neighs.iterator(); iter.hasNext();) {
		Neighborhood n = iter.next();
		nnamesstr.append(n.getName()).append("\n");
		if (j++ % 4 == 0) {
%>
	</tr>
	<tr>
		<%
	}
%>
		<td>
		<div><input type="hidden" name="nlist" value="<%=n.getName()%>"><%=n.getName()%>
		<a
			href="GerenciadorBairros.jsp?id=<%=KeyFactory.keyToString(n.getId())%>&action=delete"
			onclick="return confirm('quermesmo?');">apagar</a> <a href=""
			onclick="showAddress('<%=n.getName()%>,Campinas');return false;">add
		to map</a></div>
		</td>
		<%
	}
%>
	
</table><br>
to copy:<textarea rows="3" cols="80"><%=nnamesstr.toString() %></textarea><br/>
<hr>
</div>
<!--<input type="submit" value="Mapa">--></form>
<%
int counterA=0;
int counterB=0;
	String str = request.getParameter("neighList");
	if (str != null) {

		String[] ns = str.split(new String(new char[] { 10 }));

		int i = 0;
%>
<form action="GerenciadorBairros.jsp" method="post" id="mainform"><input
	type="hidden" name="action" id="faction" value="createNeighs">
Cidade:<select name="fromCity">
	<%
		for (Iterator<City> iter = cm.list().iterator(); iter.hasNext();) {
				City c = iter.next();
				String selected = "";
				if (c.getId().equals(currCity)) {
					selected = "selected='selected'";
				}
	%><option value="<%=KeyFactory.keyToString(c.getId())%>" <%=selected%>><%=c.getName()%></option>
	<%
		}
	%>
</select> <input type="submit" value="criar selecionados"><!-- <button onclick="showOnMap()">Mapa</button> -->
<table>
	<tr>
		<%
		
		StringBuilder later = new StringBuilder("<table><tr>");
			
			for (i = 0; i < ns.length; i++) {
				if(ns[i].trim().length()==0){
					continue;
				}
				ns[i]=removeLineFeed(ns[i]);
			Neighborhood existing = map.get(normalizeName(ns[i]));
	
	if (existing != null) {
		pastedArray.append("\"").append(ns[i]).append(", Campinas\",");
		if (counterA % 4 == 0) {%>
		</tr>
		<tr>
			<%}
		later.append("<td style='color: red;' ><input type=\"hidden\" name=\"nlist\" value=\"").append(existing.getName()).append("\">").append(existing.getName()).append("</td>");
		if(counterB%4==0){
			later.append("</tr><tr>");
		}
		counterB++;
	} else {
		counterA++;
		
		if (((int) ns[i].charAt(ns[i].length() - 1)) == 13) {
			ns[i] = ns[i].substring(0, ns[i].length() - 1);
		}
		toCreateArray.append("\"").append(ns[i]).append(", Campinas\",");
		pastedArray.append("\"").append(ns[i]).append(", Campinas\",");
%>
		<td>
		<div onclick="toggle('p_<%=i%>')"><input type="hidden"
			name="nlist" value="<%=ns[i]%>"> <input type="checkbox"
			checked="checked" name="neighbors" value="<%=ns[i]%>"> <%=ns[i]%></div>
		</td>
		<%
		}
	}
		%>
	</tr>
</table>
<br>
<a href="#"
	onclick="document.getElementById('existingTable').style.display='block'">Mostrar
existentes(<%=counterB %>)</a><br>
<div id="existingTable" style="display: none;">
<%
	out.print(later.toString()+"</table></div>");

	}
	if(toCreateArray.length()>2){
		toCreateArray.setLength(toCreateArray.length()-1);			
	}
	if(pastedArray.length()>2){
		pastedArray.setLength(pastedArray.length()-1);			
	}
	pastedArray.append("]");
	toCreateArray.append("]");
	%>

</form>
<hr>
<form action="GerenciadorBairros.jsp" method="post">Criar em lot
bairros para cidade de:<select name="city">
	<%
		for (Iterator<City> iter = cm.list().iterator(); iter.hasNext();) {
			City c = iter.next();
			String selected = "";
			if (c.getId().equals(currCity)) {
				selected = "selected='selected'";
			}
	%><option value="<%=KeyFactory.keyToString(c.getId())%>" <%=selected%>><%=c.getName()%></option>
	<%
		}
	%>
</select><Br />
Bairros (1 por linha)<br>
<textarea rows="5" cols="100" name="neighList">${param.neighList }</textarea>
<input type="submit" value="checar"></form>
<hr>
<br>
<button onclick="showAllOnMap()">Show all on map (<%=neighs.size() %>)</button>
<button onclick="showNewOnMap()">Show NEW on map (<%=counterA %>)</button>
<button onclick="showPastedOnMap()">Show Pasted on map (<%=(counterA+counterB) %>)</button> <button onclick="limpar()">limpa</button>
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
	
	
	
	
    function showAddress(address) {
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
              var marker = new GMarker(point, markerOptions);
              map.addOverlay(marker);
              GEvent.addListener(marker, "dragend", function() {
                marker.openInfoWindowHtml(address+" "+marker.getLatLng().toUrlValue(6));
              });
              GEvent.addListener(marker, "click", function() {
                marker.openInfoWindowHtml(address+" "+marker.getLatLng().toUrlValue(6));
              });
	     // GEvent.trigger(marker, "click");
            }
          }
        );
      }
    }
    initialize();
    var existingNeighs = [<%	for (Iterator<Neighborhood> iter = neighs.iterator(); iter.hasNext();) {
		Neighborhood n = iter.next();
		%>"<%=n.getName()%>,Campinas"<%
		if(iter.hasNext()){
			%>,
			<%
		}
    }%>];
    var i = 0;
    var executeForOne=function(){
    	if(i<nnames.length){
    		showAddress(nnames[i]);
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
    	nnames=existingNeighs;
    	markerOptions = {draggable: true};
    	executeForOne();
    }
    var markerOptions = {draggable: true};
    
    
    var newNeighs = <%=toCreateArray%>;
    var pastedNeighs = <%=pastedArray%>;
    function limpar(){
    	map.clearOverlays();    	
    }
    function showNewOnMap(){
    	nnames=newNeighs;    	
    	var blueIcon = new GIcon(G_DEFAULT_ICON);
    	blueIcon.image = "http://gmaps-samples.googlecode.com/svn/trunk/markers/blue/blank.png";
    	markerOptions = { icon:blueIcon };
    	executeForOne();
    }
    function showPastedOnMap(){
    	nnames=pastedNeighs;
    	var blueIcon = new GIcon(G_DEFAULT_ICON);
    	blueIcon.image = "http://gmaps-samples.googlecode.com/svn/trunk/markers/orange/blank.png";
    	markerOptions = { icon:blueIcon };
    	executeForOne();
    }
    </script>
