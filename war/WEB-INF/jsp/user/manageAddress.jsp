<%@page import="br.copacabana.spring.NeighborhoodManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Endereços de entrega</title>

<cb:header />

<link href="/styles/user/profile.css" type="text/css"
	rel="stylesheet" />
<link
	href="/styles/user/manageOrders.css"
	type="text/css" rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/user/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html" %>
<style>
label{
 display: inline-block;
    text-align: right;
    width: 150px;
}
th{
background-color: #D9261C;
    color: white;
    font-weight: bold;
    }
</style>
<cb:body closedMenu="true">

	<jsp:include page="clientheader.jsp"><jsp:param
			name="isAddresses" value="true"></jsp:param></jsp:include>
			<br/>
			<h2>Meus endere&ccedil;os</h2>
			<div style="margin: 5px;">
	<button baseClass="orangeButton" dojoType="dijit.form.Button" onClick="createNewAddress"  >Novo Endere&ccedil;o</button>
	
	<div dojoType="dojo.data.ItemFileReadStore" jsId="nStore" url="/listNeighborsItemFileReadStore.do"></div>
	<div dojoType="dojo.data.ItemFileReadStore" jsId="cStore" url="/listCitiesItemFileReadStore.do"></div>
	<div id="newNeighSection" style="display: none;">
<form action="/editaEndereco.do" method="post" id="newAddressForm" style="text-align: left;" dojoType="dijit.form.Form" onsubmit="return validate('newAddressForm','msgSection');">
<div id="msgSection">&nbsp;</div>
<label>Rua*:</label> <input style="margin-left: 0px;" onchange="clearErrorMsg" dojoType="dijit.form.ValidationTextBox" type="text" name="address.street" required="true"  promptMessage="Campo obrigatório" /><br/>
<label>N&uacute;mero*:</label> <input type="text" style="margin-left: 0px;" onchange="clearErrorMsg" dojoType="dijit.form.ValidationTextBox" name="address.number"  required="true"  promptMessage="Campo obrigatório" /><br/>	
<label>Complemento:</label> <input type="text" style="margin-left: 0px;" dojoType="dijit.form.ValidationTextBox" name="address.additionalInfo" /><br/>
<label>Telefone*:</label> <input required="true" style="margin-left: 0px;" onchange="clearErrorMsg" type="text" dojoType="dijit.form.ValidationTextBox" name="address.phone" regExpGen="com.copacabana.util.phoneFormat"  promptMessage="Campo obrigatório"  invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN"/><br/>	
<label>Cidade*:</label> <input required="true" style="margin-left: 0px;" dojoType="dijit.form.FilteringSelect" value="Campinas" store="cStore"  promptMessage="Campo obrigatório"  searchAttr="name" onChange="cityChanged" name="city" id="cInput"/><br>	
<label>Bairro*:</label> <input required="true" style="margin-left: 0px;" onchange="clearErrorMsg" dojoType="dijit.form.FilteringSelect" value="" store="nStore" searchAttr="name"  promptMessage="Campo obrigatório"  name="neighId" id="nInput"/><br/>
<div style="margin-left:150px;" ><button type="submit" style="margin-left: 0px;" class="orangeButton"  onchange="clearErrorMsg" dojoType="dijit.form.Button"  >Criar</button></div>	
</form>
 

</div>

	<br/><br/>
	<c:if test="${fn:length(entity.addresses)==0 }">Voc&ecirc; ainda n&atilde;o possui nenhum endere&ccedil;o cadastrado.<br/></c:if>
	<c:if test="${fn:length(entity.addresses)>0 }">
	<table border="0">
	<tr><th>Rua</th><th>Bairro</th><th>Cidade</th><th></th></tr>
	<c:forEach var="bean"  items="${entity.addresses}">
	<c:set var="address" value="${bean.address}"></c:set>
	<tr><td style="width: 320px;text-align:left;">${address.street},${address.number}</td><td style="width: 200px;text-align:left;">${address.neighborhood.name }</td><td>${address.neighborhood.city.name }</td>
	<td><button baseClass="orangeButton" dojoType="dijit.form.Button" onClick="editarEndereco('${bean.addressKey}')" class="persist">Editar</button>&nbsp;
	<button baseClass="orangeButton" dojoType="dijit.form.Button" onClick="apagaEndereco('${bean.addressKey}')" class="apagar" >Apagar</button></td>
	</tr>
	<tr ><td colspan="4" style="border-bottom: 0px;"><div style="display: none;" id="edit_${bean.addressKey}">
	<form action="/editaEndereco.do" method="post" style="text-align: left;" dojoType="dijit.form.Form"  id="editForm_${bean.addressKey}" onsubmit="return validate('editForm_${bean.addressKey}','msgSection_${bean.addressKey}');">
	<input type="hidden" name="address.id" value="${bean.addressKey}"/>
	<label>Rua*:</label> <input dojoType="dijit.form.ValidationTextBox" type="text" name="address.street" value="${address.street}" required="true"  promptMessage="Campo obrigatório" /><br/>
	<label>N&uacute;mero*:</label> <input type="text" dojoType="dijit.form.ValidationTextBox" name="address.number" value="${address.number}" required="true"  promptMessage="Campo obrigatório" /><br/>	
	<label>Complemento:</label> <input type="text" dojoType="dijit.form.ValidationTextBox" name="address.additionalInfo" value="${address.additionalInfo}"/><br/>
	<label>Telefone*:</label> <input type="text" dojoType="dijit.form.ValidationTextBox" name="address.phone" value="${address.phone}" regExpGen="com.copacabana.util.phoneFormat" invalidMessage="Telefone inv&aacute;lido. Utilize o seguinte formato (DDD) NNNN-NNNN" required="true"  promptMessage="Campo obrigatório" /><br/>	
	<label>Bairro*:</label> <select name="neighId" dojoType="dijit.form.FilteringSelect" selectOnClick="true" required="true"  promptMessage="Campo obrigatório" >
		<c:forEach items="${bean.neighborhoodList}" var="neigh">
			   <option value="${neigh.idStr}" 
			   <c:if test="${neigh.id eq address.neighborhood.id}">selected="selected"</c:if> 
			   >${neigh.name}</option>
	</c:forEach>
	</select><br/>
	
	<label>Cidade:</label> ${address.neighborhood.city.name }<br/>
	
	
	<button style="margin-left:150px;" type="submit" class="orangeButton" dojoType="dijit.form.Button" >Salvar</button>
	<div id="msgSection_${bean.addressKey}"></div>
	</form>
	<hr>
	</div></td></tr>
	</c:forEach>
	</table>
	</c:if>
	
	
	</div>
</cb:body>
<script>
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.Form");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Form");
dojo.require("com.copacabana.util");



function createNewAddress(){
	var id="newNeighSection";
	var display = dojo.style(dojo.byId(id),'display');
	if(display=='block'){
		 dojo.style(dojo.byId(id),'display','none');
	}else{
		 dojo.style(dojo.byId(id),'display','block');
	}
}
function apagaEndereco(id){
	if(confirm("Tem certeza que quer apagar este endereço?")){
		window.location="/apagaEndereco.do?addKey="+id;
	}
}
function editarEndereco(id){
	
	var display = dojo.style(dojo.byId("edit_"+id),'display');
	if(display=='block'){
		 dojo.style(dojo.byId("edit_"+id),'display','none');
	}else{
		 dojo.style(dojo.byId("edit_"+id),'display','block');
	}
	
}

var validate=function(formId,errorSectionId){
	try{
	 var form = dijit.byId(formId);
     // set initial state
     if(!form.isValid()){
    	 var nodes=dojo.query('input',dojo.byId(formId));
    	 for(var id in nodes){
    		 var node = nodes[id];
    		 var input = dijit.byId(node.id);
    		 
    		 if(input && !input.isValid()){
    			 var msg = "Campo inválido";
    			 if(input.promptMessage && input.promptMessage.length>0){
    				 msg=input.promptMessage;
    			 }
    			 input.displayMessage(msg);
    			 return false;
    		 }
    	 }
    	 
    	 
    	 
     }else{
    	 //form.submit();
    	 return true;
     }    
     }catch(e){
    	 console.error(e)
     }
     return false;
}
function clearErrorMsg(){
		
}

function cityChanged(id){
	
	nStore = new dojo.data.ItemFileReadStore( {
			url : "/listNeighborsByCity.do?key="+ id
		});
	dijit.byId("nInput").reset();
	dijit.byId("nInput").store=nStore;
		
}
</script>
</html>