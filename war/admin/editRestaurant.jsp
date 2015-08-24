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
	
	     
	        
			dojo.addOnLoad(function() {			
				
				
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
		                	dojo.byId("response").innerHTML = "Ok Restaurant updated.";
		                        
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
		        	loadOtherRestaurants();
		        	dijit.byId('restSelection').onChange=loadRestData;
		        	
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
<h2>Edit Restaurant</h2>
Selecione um restaurante:<select dojoType="dijit.form.FilteringSelect" id="restSelection" name="restSelection" autoComplete="true" ></select><br/>
<hr/>
<form action="/admin/updateRestSiteStatus.do" id="restform" dojoType="dijit.form.Form" method="post">
	<input type="text" dojoType="dijit.form.TextBox" name="id" readonly="readonly"/> <br/>
	Nome*: <input type="text" dojoType="dijit.form.TextBox" name="name" readonly="readonly"/> <br/>
	Status:<select dojoType="dijit.form.FilteringSelect" id="siteStatus" name="siteStatus">
    <option value="ACTIVE">
        ACTIVE
    </option>
    <option value="NEW_RESTAURANT" >
        NEW_RESTAURANT
    </option>
    <option value="MUSTACCEPTTERMS">
        MUSTACCEPTTERMS
    </option><option value="BLOCKED">
        BLOCKED
    </option>
    <option value="SOON">
        SOON
    </option>
</select> 
	<hr></hr>	 
<button type="submit" dojoType="dijit.form.Button"
	id="submitButton">Atualizar</button>
</form>




<div id="response"></div>
</body>