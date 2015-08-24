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
 dojo.require("dijit.form.MultiSelect");
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
	        function loadFoodCat(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "listFoodCategoriesItemFileReadStore.do"
	            });
	        	
	            dijit.byId("foodCategoriesSelection").store = stateStore;
	        }
	        function loadRests(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "listRestaurantsItemFileReadStore.do"
	            });
	            dijit.byId("restaurantSelection").store = stateStore;
	            dijit.byId("restaurantSelection2").store = stateStore;
	            dijit.byId("restaurantSelection3").store = stateStore;
	        }

	        function loadNeighborhood(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "listNeighborsItemFileReadStore.do"
	            });
	            dijit.byId("neighSelection").store = stateStore;
	        }
			dojo.addOnLoad(function() {			
				loadRests();
				loadFoodCat();
				loadNeighborhood();
	            sendForm("submitButton");
	            sendForm("submitButton2");
			});
		      

		        function sendForm(btnName) {
		            var button = dijit.byId(btnName);

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
		                    console.log('What??');
		                    	console.log(data);
		                    	var entity= dojo.fromJson(data);
		                        dojo.byId("response").innerHTML = "Form posted.<br><a href=\"getRestaurant.do?id="+entity.id+"\" target=_blank>view</a>";
		                        
		                    },
		                    error: function(error) {
		                        //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
		                        //docs server.
		                        console.log(error);
		                        dojo.byId("response").innerHTML = "failed to post data."+error;
		                    }
		                }
		                //Call the asynchronous xhrPost
		                dojo.byId("response").innerHTML = "Form being sent..."
		                var deferred = dojo.xhrPost(xhrArgs);
		            });
		        }
		</script>
<h2>Cria Estado</h2>
<form action="updateRest.do" id="restform" method="post">
Restaurant:<select dojoType="dijit.form.FilteringSelect"
	id="restaurantSelection" name="id" autoComplete="true"
	invalidMessage="Invalid rest name"></select><br>
Food category:<select dojoType="dijit.form.FilteringSelect"
	id="foodCategoriesSelection" name="addFoodCategories2" autoComplete="true"
	invalidMessage="Invalid foodcategory name"></select><br>
<button type="submit" dojoType="dijit.form.Button" id="submitButton">Add</button>
</form>

<form action="updateRest.do" id="restform" method="post">
Restaurant:<select dojoType="dijit.form.FilteringSelect"
	id="restaurantSelection2" name="id" autoComplete="true"
	invalidMessage="Invalid rest name"></select><br>

Restaurant:<select dojoType="dijit.form.FilteringSelect"
	id="restaurantSelection3" name="deliveryRange.restaurant" autoComplete="true"
	invalidMessage="Invalid rest name"></select><br>
Neighbor:<select dojoType="dijit.form.FilteringSelect" id="neighSelection" name="deliveryRange.neighborhood" autoComplete="true" invalidMessage="Invalid neigh name"></select><br>
Cost: <input type="text" name="deliveryRange.cost.cost"> <br/>
minimumOrderValue: <input type="text" name="deliveryRange.cost.minimumOrderValue"> <br/>	
<button type="submit" dojoType="dijit.form.Button" id="submitButton2">Add</button>
</form>



<div id="response"></div>