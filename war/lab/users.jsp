<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<link
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<script>
	$(document).ready(
			function() {
				$("input#autocomplete").autocomplete(
						{
							minLength: 2,
							search: function(event, ui) { 
								console.log("evet",event);
								console.log("ui",ui);
							},
							 select: function(event, ui) {
								 console.log("event",event);
									console.log("ui",ui.item);
									if(ui.item.value){
										console.log("aa",ui.item.value)
										var byphone=jQuery.grep(users, function (a) { return a.phone==ui.item.value; });
										console.log(byphone)
										var byemail=jQuery.grep(users, function (a) { return a.email==ui.item.value; });
										console.log(byemail)
										
									}
								 
							 },
							source : function(arg0,arg1){
								console.log(arg0);
								console.log(arg1);
								var byphone=jQuery.grep(users, function (a) {  return a.phone.indexOf(arg0.term)>-1; });
								var byemail=jQuery.grep(users, function (a) {  return a.email.indexOf(arg0.term)>-1; });
								
								
								var finalarr=byphone.concat(byemail);
								var show=[];
								for(var i=0;i<finalarr.length;i++){
									show.push(finalarr[i].name)
								}
								console.log(show.length)
								arg1(show)
								}
						});
			});
	
	<%
		ClientManager cm = new ClientManager();
		List<Client> clients = cm.list();
		request.setAttribute("clients",clients);
		
	%>
	
	//var phones = [<c:forEach var="client" items="${clients}" begin="0" varStatus="status">"${client.contact.phone}"<c:if test="${status.last==false}">,</c:if></c:forEach>]
	//var emails = [<c:forEach var="client" items="${clients}" begin="0" varStatus="status">"${client.user.login}"<c:if test="${status.last==false}">,</c:if></c:forEach>]
	var users = [<c:forEach var="client" items="${clients}" begin="0" varStatus="status">{email:"${client.user.login}",phone:"${client.contact.phone}",name:"${client.name}"}<c:if test="${status.last==false}">,</c:if></c:forEach>]
	

</script>
</head>
<body style="font-size: 62.5%;">

	<input id="autocomplete" />

</body>
</html>