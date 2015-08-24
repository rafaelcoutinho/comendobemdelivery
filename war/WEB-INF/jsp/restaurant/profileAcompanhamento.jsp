<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%><html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ComendoBem - Cadastro Restaurante</title>
	
	<cb:header />
	
	<link href="/styles/restaurant/profile.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="/styles/restaurant/profile_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
		<link href="/styles/restaurant/profile_ie_8.css" type="text/css" rel="stylesheet" />
	</c:if>
	
	<link href="/styles/restaurant/menu.css" type="text/css" rel="stylesheet" />

<%@include file="/static/commonScript.html" %>
<script type="text/javascript">
dojo.require("com.copacabana.PlateEntryWidget");
	        dojo.require("dijit.form.Textarea");
	       dojo.require("com.copacabana.RoundedButton");
	        dojo.require("com.copacabana.UserProfileWidget");
	        dojo.require("com.copacabana.RestaurantTypeOptionWidget");
	        dojo.require("com.copacabana.RestaurantWheelWidget");
	        dojo.require("com.copacabana.SideDishesListWidget");
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        dojo.require("dijit.Dialog");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.TimeTextBox");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.DateTextBox");
	      	        
	        
			dojo.addOnLoad(function() {			
				dojo.subscribe("editSideDish",editSideDish);
				
			});
			var showDialog =function(){
				dijit.byId('dialog1').show();
				dojo.byId('restaurant.k').value=loggedRestaurant.id;
				
			}
			

			var editSideDish =function(data){
				
				
				data.restaurant={k:data.restaurant};
				
				dijit.byId('plateForm').attr('value', data);
				showDialog();
				
			}
			var saveSideDish = function(){
				console.log("saving.");
				var xhrArgs = {
	                    form: dojo.byId("plateForm"),
	                    handleAs: "json",
	                    load: function(data) {
	                    	;
	                    	var entity= data;
	                        console.log("Form created ",data);
	                        dijit.byId("dialog1").hide();
	                        dojo.byId("plateForm").reset();
	                        dijit.byId("sideDishesListWidget").addSideDish(data);
	                        
	                    },
	                    error: function(error) {
	                        //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
	                        //docs server.
	                        console.log("Form error ",error);
	                        alert("error");
	                        
	                    }
	                }
	                //Call the asynchronous xhrPost
	                console.log("sending");
	                var deferred = dojo.xhrPost(xhrArgs);

				
				
			}
			
		  </script>
</head>
<cb:body closedMenu="true">

	
	<jsp:include page="restheader.jsp" ><jsp:param name="isMenu" value="true"></jsp:param></jsp:include>
	
	<div id="dadosCardapio">
	
	<div id="cardapio">
	<div dojoType="com.copacabana.RoundedButton" inputType="button" inputValue="Novo item" clickAction="showDialog" topCss="-5px" leftCss="-105px"></div>
	 
	<div  dojoType="com.copacabana.SideDishesListWidget" baseClass="cardapio" key="id" id="sideDishesListWidget"></div>
	</div>
	<div id="categoria">
		
	</div>
	
	<ul class="menu">
			<li  ><a href="profileCardapio.jsp">Pratos</a></li>
			<li class="selecionado"><a href="profileAcompanhamento.jsp">Acompanhamentos</a></li>
			
		</ul>
		</div>
	<div dojoType="dijit.Dialog" id="dialog1" title="Novo prato"  style="display: none;border:1px solid black;" execute="">
	<form action="/createSideDishJson.do" method="post" id="plateForm" name="plateForm"  dojoType="dijit.form.Form">
	<input type="hidden" dojoType="dijit.form.TextBox" name="id" id="id" />
	<input type="hidden" dojoType="dijit.form.TextBox" name="restaurant.k" id="restaurant.k" />
	  <table>
	    <tr>
	      <td><label for="name">Nome do acompanhamento: </label></td>
	      <td><input dojoType="dijit.form.TextBox" type="text" name="name" id="name"></td>
	    </tr>
	    <tr>
	      <td><label for="loc">Descri&ccedil;&atilde;o: </label></td>
	      <td><input dojoType="dijit.form.Textarea" type="text" name="description" id="description"></td>
	    </tr>
	    <tr>
	      <td><label for="date">Valor: </label></td>
	      <td><input dojoType="dijit.form.TextBox" type="text" name="price" id="price" value="0.0"></td>
	    </tr>    
	    <tr>
	      <td colspan="2" align="center">	        
	        		<img src="/resources/img/btOk.png" alt="salvar"  onclick="saveSideDish()"  dojoattachpoint="closeButtonNode"/>		
	        </td>
	    </tr>
	  </table>
	  </form>
</div>
	
</cb:body>
</html>