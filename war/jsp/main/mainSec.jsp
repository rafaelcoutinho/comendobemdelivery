<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Comendo Bem</title>
	
	
 <script type="text/javascript">
 
            djConfig = {
            	baseUrl : './',                
                modulePaths: {
                    'com.copacabana' : 'https://rcoutocopacabana.appspot.com/scripts/com/copacabana'
                },
                parseOnLoad: true,
                isDebug: false,
                usePlainJson: true,
                locale: 'pt' <%-- DO NOT change this locale for now. --%>
                   
            };
        </script>
<SCRIPT TYPE="text/javascript"
	SRC="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dojo/dojo.xd.js.uncompressed.js"></SCRIPT>
<script type="text/javascript">
        
	        dojo.require("com.copacabana.search.SearchRestaurantsWidget");
	        dojo.require("com.copacabana.search.SearchResultsManagerWidget");
	        dojo.require("com.copacabana.HighLightWidget");
	        dojo.require("com.copacabana.UserProfileWidget");
	        dojo.require("com.copacabana.RestaurantTypeOptionWidget");
	        dojo.require("com.copacabana.RestaurantWheelWidget");
	        dojo.require("dijit.form.Form");

	        function removeDicas(){
				var main = document.getElementById("conteudo_main");
				main.style.display='none';
				var search = document.getElementById("conteudo_search");
				search.style.display='block';
		    }
			dojo.addOnLoad(function() {			
				dojo.subscribe("onSearchBeingExecuted",removeDicas);
			});

			
				var loggedUser<c:if test="${not empty sessionScope.loggedUser}">= ${sessionScope.loggedUser}</c:if>;
			
			
		</script>
        
        
        <cb:header />
        
	<link href="../../styles/main/main.css" type="text/css" rel="stylesheet" />
	<link href="../../styles/main/main_busca.css" type="text/css" rel="stylesheet" />
	<link href="../../styles/main/pedido.css" type="text/css" rel="stylesheet" />
		
</head>
<cb:body>

	<div id="mensagem">&nbsp;</div>
	
	<div  id="conteudo_main">
		<div id="dica_do_dia" baseClass="quadrado" dojoType="com.copacabana.HighLightWidget" title="Dica do Dia" url="'/getDailyHighlight.do'" ></div>
	
		<div id="novidade_da_semana" baseClass="quadrado" dojoType="com.copacabana.HighLightWidget" title="Novidade da Semana" url="'/getWeeklyHighlight.do'" ></div>
		
		<div id="login" baseClass="quadrado" dojoType="com.copacabana.UserProfileWidget" ></div>		
		
		<div id="empty">
		</div>
	</div>
	<div  id="conteudo_search" style="display:none">
		<div id="searchResultsManager" dojoType="com.copacabana.search.SearchResultsManagerWidget" ></div>
	</div>
	
</cb:body>
<script type="text/javascript">
dojo.addOnLoad(function() {
	//criaNovidades();
	//preencheMensagem();
	});
</script>
</html>