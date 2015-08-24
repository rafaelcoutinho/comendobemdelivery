<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%><html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Hor&aacute;rios de abertura</title>

<cb:header />

<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dijit/themes/tundra/tundra.css">
<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="./styles/restaurant/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
	<link href="/styles/restaurant/profile_ie_8.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="/styles/restaurant/horarios.css" type="text/css"
	rel="stylesheet" />

<%@include file="/static/commonScript.html" %>
<style>

.timeChooser{
padding: 5px;
}
.odd{
background-color: #F7F7F7;
}

</style>
<script type="text/javascript">
dojo.require("dijit.form.TimeTextBox");
dojo.require("com.copacabana.RoundedButton");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser"); 
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.TitlePane");
dojo.require("dojo.date");

dojo.require("com.copacabana.TimeRangeChooser");

dojo.addOnLoad(function() {			
	
    prepareForm();
});
var submitForm =  function(event){
	  	if(event){
            //Stop the submit event since we want to control form submission.
            event.preventDefault();
            event.stopPropagation();
	  	}
	  	
	  	for(var i = 0; i<timeRanges.length;i++){
	  		var bool = timeRanges[i].validate();
	  		if(bool==false){
	  			alert(timeRanges[i].dayOfWeekLabel +" contem valor errado.");
	  			return false;
	  		}
	  	}
	  	   com.copacabana.util.showLoading();
            //The parameters to pass to xhrPost, the form, how to handle it, and the callbacks.
            //Note that there isn't a url passed.  xhrPost will extract the url to call from the form's
            //'action' attribute.  You could also leave off the action attribute and set the url of the xhrPost object
            //either should work.
            var xhrArgs = {
                form: dijit.byId("restform").domNode,
                handleAs: "text",
                load: function(data) {
                	com.copacabana.util.hideLoading();
                	console.log(data);
                	var entity= dojo.fromJson(data);
                	
                	
                	com.copacabana.util.showSuccessAction();
                	//var msg = new com.copacabana.MessageWidget();
                    //msg.showMsg("Dados salvos.");
                },
                error: function(error) {
                	com.copacabana.util.hideLoading();
                    
                    console.log("failed to post data.",error);
                    var msg = new com.copacabana.MessageWidget();
                    msg.showMsg("Erro ao salvar dados: "+error.message);
                }
            }
            
            var deferred = dojo.xhrPost(xhrArgs);
        
  }

    function prepareForm() {
        var button = dijit.byId("submitButton");

        dojo.connect(button, "onClick", submitForm);
        
       if(id){           
    	   loadFormEntiy("/getWOTimes.do?id="+id,"restform");
       }
    }
var timeRanges=[];
    function loadFormEntiy(url,content,formId){
    	timeRanges=[];
    	 var xhrArgs = {	
	        	    url:url,
	        	    content:content,		                    
                    handleAs: "text",
                    load: function(data) {			                    	
                    	var entity= dojo.fromJson(data);
                    	
                    			                    				                        
                    	try{
                        	var days = ["MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY","HOLIDAYS"];
                        	for(var i = 0;i<days.length;i++){    
                            	      
                            	
                            	
                        		if(entity[days[i]].startingHour==null){
                        			entity[days[i]].startingHour=0;
                        		}
                        		if(entity[days[i]].startingMinute==null){
                        			entity[days[i]].startingMinute=0;
                        		}
                        		if(entity[days[i]].closingHour==null){
                        			entity[days[i]].closingHour=0;
                        		}
                        		if(entity[days[i]].closingMinute==null){
                        			entity[days[i]].closingMinute=0;
                        		}        
                        		
                        		var startHour = entity[days[i]].startingHour;
                        		var startMinute = entity[days[i]].startingMinute;
                        		var closeHour = entity[days[i]].closingHour;
                        		var closeMinute = entity[days[i]].closingMinute;
                        		var secondTurn =[-1,-1,-1,-1];
                        		if(entity[days[i]].secondTurn && entity[days[i]].secondTurn.length>0){
                        			secondTurn=entity[days[i]].secondTurn;
                        		}
                        		
                        		var args = 
                        			{
                        				isClosed:entity[days[i]].closed,
                        				dayOfWeek:days[i],
                        				startHour:startHour,
                        				startMinute:startMinute,
                        				closeHour:closeHour,
                        				closeMinute:closeMinute,
                        				secondTurnStartHour: secondTurn[0],
                        				secondTurnCloseHour: secondTurn[2],
                        				secondTurnStartMinute: secondTurn[1],
                        				secondTurnCloseMinute: secondTurn[3]                        				
                        			};
                        		var trange = new com.copacabana.TimeRangeChooser(args);
                        		trange.startup();
                        		dojo.addClass(trange.domNode,'timeChooser');
                        		if(i%2==0){
                        			dojo.addClass(trange.domNode,'odd');	
                        		}
                        		dojo.byId('AllTimeSection').appendChild(trange.domNode);
                        		timeRanges.push(trange);
                        	/*	
                        		console.log("T"+entity[days[i]].startingHour+":"+entity[days[i]].startingMinute);
                        		try{
                        			var startTime = new Date(1970, 01, 01, entity[days[i]].startingHour, entity[days[i]].startingMinute, 00,00);
                        			dijit.byId(days[i]+".startingTime").attr("value",startTime);

                        			var closeTime = new Date(1970, 01, 01, entity[days[i]].closingHour, entity[days[i]].closingMinute, 00,00);
                        			dijit.byId(days[i]+".closingTime").attr("value",closeTime);
                        			
                        			dijit.byId(days[i]+".startingHour").attr('value',entity[days[i]].startingHour);
                            		dijit.byId(days[i]+".startingMinute").attr('value',entity[days[i]].startingMinute);

                            		dijit.byId(days[i]+".closingHour").attr('value',entity[days[i]].closingHour);
                            		dijit.byId(days[i]+".closingMinute").attr('value',entity[days[i]].closingMinute);
                            			                        			
                        		}catch(e){
                            			//if(days[i]=="MONDAY"||days[i]=="TUESDAY"){
										console.error(e);
                            			//}
                            	}*/
                        		                        		
                        	}
                    		           	
                    		
                    		
                    					                  					                    		
                    	}catch(e){
							console.error(e);
                    	}
                    	
                    },
                    error: function(error) {			                    
                        console.error("failed to get data.",error);
                    }
                }
    	 var deferred = dojo.xhrPost(xhrArgs);
    }
	function setValue(arg,day,status){
		console.log("chaing",arg);
		
		var val = dijit.byId(day+"."+status+'Time').attr('displayedValue');
		
		var hour= val.substr(0,2);
		if(hour.substr(0,1)=='0'){
			hour = hour.substr(1);
		}
		var minute= val.substr(3,5);
		if(minute.substr(0,1)=='0'){
			minute = minute.substr(1);
		}
		console.log("minute",minute);
		
		var cleanhour = parseInt(hour);
		var cleanminute = parseInt(minute);
		console.log("cleanhour",cleanhour);
		dijit.byId(day+"."+status+"Hour").attr("value",cleanhour);
		dijit.byId(day+"."+status+"Minute").attr("value",minute);
		
	}

	var addInterval = function(dayofweek){
		console.log('dayofweek',dayofweek);
	} 
	
</script>

</head>
<cb:body closedMenu="true">

	<jsp:include page="restheader.jsp" ><jsp:param name="isFunctions" value="true"></jsp:param></jsp:include>

	<div id="dadosFuncionalidades">
	<div id="funcionalidade">
	<p>Cadastre os hor&aacute;rios de atendimento:</p>

	<form action="/updateHorarios.do" method="post" id="restform"
		dojoType="dijit.form.Form" onsubmit="dojo.publish('onFormSubmit')">
	<div id="AllTimeSection"></div>
	
	</form>
	
	</p>
	<div id="barraEmbaixo" class="fundoCinza barraSalvar"><a
		href="#" onClick="submitForm()" id="submitButton"> <img
		src="/resources/img/btSalvar.png" alt="salvar" /> </a></div>
</div>
	<jsp:include page="profileSide.jsp" ><jsp:param name="isTime" value="true"></jsp:param></jsp:include>
	</div>

</cb:body>
</html>