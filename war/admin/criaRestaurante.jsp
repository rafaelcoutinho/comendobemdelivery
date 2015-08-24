<%@page import="br.com.copacabana.cb.entities.Neighborhood"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
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
<script type="text/javascript">
        
	        dojo.require("com.copacabana.search.SearchRestaurantsWidget");
	        dojo.require("com.copacabana.HighLightWidget");
	        dojo.require("com.copacabana.UserProfileWidget");
	        dojo.require("com.copacabana.RestaurantTypeOptionWidget");
	        
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        function loadFoodCat(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "/listFoodCategoriesItemFileReadStore.do"
	            });
	            dijit.byId("foodCategoriesSelection").store = stateStore;
	        }
	        function loadNeighborhood(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "/listNeighborsItemFileReadStore.do"
	            });
	            dijit.byId("neighSelection").store = stateStore;
	        }
	        
			dojo.addOnLoad(function() {			
				loadNeighborhood();
				
	            sendForm();
	            initRests();
			});
		      

		        function sendForm() {
		            var button = dijit.byId("submitButton");

		            dojo.connect(button, "onClick", function(event) {
		                //Stop the submit event since we want to control form submission.
		                event.preventDefault();
		                event.stopPropagation();

		                //The parameters to pass to xhrPost, the form, how to handle it, and the callbacks.
		                //Note that there isn't a url passed.  xhrPost will extract the url to call from the form's
		                //'action' attribute.  You could also leave off the action attribute and set the url of the xhrPost object
		                //either should work.
		                var xhrArgs = {
		                    form: dojo.byId("restform"),
		                    handleAs: "text",
		                    load: function(data) {
		                    	console.log(data);
		                    	var entity= dojo.fromJson(data);
		                        dojo.byId("response").innerHTML = "Form posted.<br><a href=\"getRestaurant.do?id="+entity.id+"\" target=_blank>view</a>";
		                        
		                    },
		                    error: function(error) {
		                    	                        
		                        dojo.byId("response").innerHTML = "failed to post data."+error.errorMsg;
		                    }
		                }
		                //Call the asynchronous xhrPost
		                dojo.byId("response").innerHTML = "Form being sent..."
		                var deferred = dojo.xhrPost(xhrArgs);
		            });
		        }

		        function initRests(){
		        	//loadOtherRestaurants();
		        	//dijit.byId('restSelection').onChange=loadRestData;
		        	
		        }
		        var loadRestData = function(){
		        	var restId = dijit.byId('restSelection').attr('value');
		        	console.log(restId);

		    		var xhrParams = {
		    				error : function(error){alert(error);},
		    				handleAs : 'json',
		    				load :loadedRest,
		    				url : '/getRestaurant.do?id='+restId
		    		};
		    		dojo.xhrGet(xhrParams);
		        	
		        }
		        var loadedRest=function(data){
					console.log(data);
					data = {
						restaurant:data,
						user:data.user
						
					}
					dijit.byId('restform').attr('value',data);
		        }
		        function loadOtherRestaurants(){
		        	var stateStore = new dojo.data.ItemFileReadStore({
		                url: "/admin/listRestaurants.do"
		            });
		            dijit.byId("restSelection").store = stateStore;		            
		        }
		</script>
		<body class="tundra"><jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<h2>Cria Restaurante</h2>
<form action="/createRestJson.do" id="restform" dojoType="dijit.form.Form">	
	Nome*: <input type="text" dojoType="dijit.form.TextBox" name="restaurant.name" trim="true"> <br/>
	Description: <input type="text" dojoType="dijit.form.TextBox" name="restaurant.description"> <br/>	
	<hr></hr>
	Endereco*:<br/>
	Rua: <input type="text" dojoType="dijit.form.TextBox" name="address.street" trim="true"> <br/>
	No.: <input type="text" dojoType="dijit.form.TextBox" name="address.number" trim="true"> <br/>
	Adicional: <input type="text" dojoType="dijit.form.TextBox" name="address.additionalInfo"> <br/>	
	Bairro*:<select dojoType="dijit.form.FilteringSelect" id="neighSelection" name="neighborhood" autoComplete="true" invalidMessage="Invalid neigh name"></select><br>
	<hr></hr>	
	UserBean:<br/>
	Login: <input type="text" dojoType="dijit.form.TextBox" id="user.login" name="user.login" trim="true"> <br/>
	password: <input type="password"  dojoType="dijit.form.TextBox"  name="user.password" trim="true"> <br/> 
	<hr></hr>
	<input type="hidden" name="acceptablePayments" value="INCASH"> 
<button type="submit" dojoType="dijit.form.Button"
	id="submitButton">Criar</button>
</form>




<div id="response"></div>
</body>