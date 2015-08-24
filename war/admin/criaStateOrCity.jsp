<%@page import="br.com.copacabana.cb.entities.Neighborhood"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>Comendo Bem!</title>
<%@include file="/static/commonScript.html" %>
<script type="text/javascript">
        
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
	        function loadStates(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "/listStatesItemFileReadStore.do"
	            });
	            dijit.byId("stateSelection").store = stateStore;
	        }
			dojo.addOnLoad(function() {			
				loadStates();
	            sendFormState();
	            sendFormCity();
			});
		      
			function sendFormCity() {

	            var button = dijit.byId("submitCityButton");

	            dojo.connect(button, "onClick", function(event) {
	                //Stop the submit event since we want to control form submission.
	                event.preventDefault();
	                event.stopPropagation();

	                //The parameters to pass to xhrPost, the form, how to handle it, and the callbacks.
	                //Note that there isn't a url passed.  xhrPost will extract the url to call from the form's
	                //'action' attribute.  You could also leave off the action attribute and set the url of the xhrPost object
	                //either should work.
	                var xhrArgs = {
	                    form: dojo.byId("cityform"),
	                    handleAs: "text",
	                    load: function(data) {
	                    	console.log(data);
	                    	var entity= dojo.fromJson(data);
	                        dojo.byId("response").innerHTML = "Form posted.<br>Id:'<a href=\"getCity.do?id="+entity.id+"\" target=_blank>view</a>'";
	                    },
	                    error: function(error) {
	                        //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
	                        //docs server.
	                        dojo.byId("response").innerHTML = "failed to post data."+error;
	                    }
	                }
	                //Call the asynchronous xhrPost
	                dojo.byId("response").innerHTML = "Form being sent..."
	                var deferred = dojo.xhrPost(xhrArgs);
	            });
			}
		        function sendFormState() {
		            var button = dijit.byId("submitStateButton");

		            dojo.connect(button, "onClick", function(event) {
		                //Stop the submit event since we want to control form submission.
		                event.preventDefault();
		                event.stopPropagation();

		                //The parameters to pass to xhrPost, the form, how to handle it, and the callbacks.
		                //Note that there isn't a url passed.  xhrPost will extract the url to call from the form's
		                //'action' attribute.  You could also leave off the action attribute and set the url of the xhrPost object
		                //either should work.
		                var xhrArgs = {
		                    form: dojo.byId("stateform"),
		                    handleAs: "text",
		                    load: function(data) {
		                    	console.log(data);
		                    	var entity= dojo.fromJson(data);
		                        dojo.byId("response").innerHTML = "Form posted.<br><a href=\"getState.do?id="+entity.id+"\" target=_blank>view</a>";
		                        loadStates();
		                    },
		                    error: function(error) {
		                        //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
		                        //docs server.
		                        dojo.byId("response").innerHTML = "failed to post data."+error;
		                    }
		                }
		                //Call the asynchronous xhrPost
		                dojo.byId("response").innerHTML = "Form being sent..."
		                var deferred = dojo.xhrPost(xhrArgs);
		            });
		        }
		</script>
<body class="tundra"><jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<h2>Cria Estado</h2>
<form action="/admin/createStateJson.do" id="stateform">
Nome: <input
	type="text" name="name" dojoType="dijit.form.TextBox"> <br/>
	<button type="submit" dojoType="dijit.form.Button" id="submitStateButton">Cria Estado</button>
</form>
<hr></hr>
<form action="/admin/createCityJson.do" id="cityform">
Nome: <input
	type="text" name="name" dojoType="dijit.form.TextBox"> <br/>
	<select dojoType="dijit.form.FilteringSelect" id="stateSelection"
	name="state" autoComplete="true" invalidMessage="Invalid state name"></select><br>
	<button type="submit" dojoType="dijit.form.Button" id="submitCityButton">Cria Cidade</button>
</form>
<br/>
<div id="response"></div>
</body>