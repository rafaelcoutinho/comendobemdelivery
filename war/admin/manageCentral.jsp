<%@page import="java.util.ArrayList"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Central"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.com.copacabana.cb.entities.mgr.CentralManager"%>
<%@page import="br.com.copacabana.cb.entities.Neighborhood"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%
	CentralManager cm = new CentralManager();
	
	Central currCentral = new Central();
	String idstr = request.getParameter("id");
	if (idstr != null && idstr.length() > 0 && !idstr.equals("null")) {
		Key id = KeyFactory.stringToKey(request.getParameter("id"));
		currCentral = cm.get(id);
	}
	
	if ("test".equals(request.getParameter("action"))) {
		Key k = KeyFactory.stringToKey(request.getParameter("restId"));
		out.println(cm.isRestaurantManagedByCentral(k));
		return;
	}
	
	if ("load".equals(request.getParameter("action"))) {
		Key id = KeyFactory.stringToKey(request.getParameter("centralToLoad"));
		idstr=KeyFactory.keyToString(id);
		currCentral = cm.get(id);

	} else if ("create".equals(request.getParameter("action"))) {
		currCentral.setName(request.getParameter("name"));
		currCentral.setPersonInCharge(request.getParameter("personInCharge"));
		currCentral.setUrl(request.getParameter("url"));
		currCentral.setDirectAccess(request.getParameter("directAccess"));
		currCentral.getUser().setLogin(request.getParameter("user.login"));
		currCentral.getUser().setPassword(request.getParameter("user.password"));
		currCentral.getContact().setEmail(request.getParameter("contact.email"));
		currCentral.getContact().setPhone(request.getParameter("contact.phone"));
		
		String[] rests = request.getParameterValues("rests");		
		currCentral.setRestaurants(new ArrayList<Key>());
		if(rests!=null){
		for(int i=0;i<rests.length;i++){
			currCentral.getRestaurants().add(KeyFactory.stringToKey(rests[i]));
		}
		}
		
		cm.persist(currCentral);
	}
	List<Central> centrais = cm.list();
	RestaurantManager rman = new RestaurantManager();
	List<Restaurant> rlist = rman.list();
	
	
	request.setAttribute("currCentral",currCentral);
%>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>Comendo Bem!</title>
<script type="text/javascript">
 
            djConfig = {
            	baseUrl : './',                
                modulePaths: {
                    'com.copacabana' : '/scripts/com/copacabana'
                },
                parseOnLoad: true,
                isDebug: true,
                usePlainJson: true
                   
            };
        </script>
<%@include file="/static/commonScript.html" %>
</head>
<body class="tundra">
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<form action="manageCentral.jsp"><input type="hidden"
	name="action" value="load"> <select name="centralToLoad">

	<%
		for (Iterator<Central> iter = centrais.iterator(); iter.hasNext();) {
			Central central = iter.next();
	%><option value="<%=KeyFactory.keyToString(central.getId())%>"><%=central.getName()%></option>
	<%
		}
	%>
</select> <input type="submit" value="Load"></form>
<hr>
<%if(currCentral.getId()==null) {%>Criar Central:<%}else{ %>
Editar Central
<%} %>
<form action="manageCentral.jsp" onsubmit="selectall()"><input type="hidden" 
	name="action" value="create"> <input type="hidden" name="id"
	value="<%=idstr%>"> <br>
Nome: <input type="text" name="name" value="${currCentral.name }" dojoType="dijit.form.TextBox"><br>
Url: <input type="text" name="url" value="${currCentral.url}"><br>
Login: <input type="text" name="user.login"
	value="${currCentral.user.login}"><br>
Senha: <input type="text" name="user.password"
	value="${currCentral.user.password}"><br>
Responsável: <input type="text" name="personInCharge"
	value="${currCentral.personInCharge}"><br>
Contato Email: <input type="text" name="contact.email"
	value="${currCentral.contact.email}"><br>
Contato Phone: <input type="text" name="contact.phone"
	value="${currCentral.contact.phone}"><br>
Acesso direto: <input type="text" name="directAccess"
	value="${currCentral.directAccess}"><br>
<hr>
<%if(currCentral.getId()!=null) {%>
Manage restaurants:
<table>
<tr>
<td>
<select dojoType="dijit.form.MultiSelect" id="restToAdd" size="6">
<%for(Iterator<Restaurant> restIter = rlist.iterator();restIter.hasNext();){
		Restaurant r= restIter.next();
		if(!currCentral.getRestaurants().contains(r.getId())){
	%>

    <option value="<%=KeyFactory.keyToString(r.getId()) %>">
        <%=r.getName() %>
    </option>
  <%}
		}%>
</select>
</td><td><button onclick="addToList();return false;">Add</button><br><button onclick="removeFromList();return false;">Remove</button></td>

<td><select dojoType="dijit.form.MultiSelect" id="rests" name="rests" size="6" style="width: 120px">
    <%for(Iterator<Key> restIter = currCentral.getRestaurants().iterator();restIter.hasNext();){
		Restaurant r= rman.getRestaurant(restIter.next());
	%>

    <option value="<%=KeyFactory.keyToString(r.getId()) %>" selected="selected">
        <%=r.getName() %>
    </option>
  <%} %>
</select>
</td>
</tr>
</table>
<%}%>
	
<input type="submit" value="Salvar"></form>

</body>
<script>
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.MultiSelect");
function addToList(){
	dijit.byId('rests').addSelected(dijit.byId('restToAdd'));
	return false;
}
function removeFromList(){
	dijit.byId('restToAdd').addSelected(dijit.byId('rests'));
	return false;
}
function selectall(){	
	dijit.byId('rests').attr('value',[]);
	dijit.byId('rests').invertSelection();
}
dojo.addOnLoad(function() {	
	selectall()
});
</script>
</html>