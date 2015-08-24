
dojo.provide("com.copacabana.lbs.FindUserLocation");



dojo.declare(
		"com.copacabana.lbs.FindUserLocation",
		[ dijit._Widget ],
		{
			constructor: function(/*Object*/ params) {

		},

		_initialized: false,

		postMixInProperties: function() {
			try {
				this.inherited(arguments);
			}
			catch (err) { console.error(err); }		
		},
		
		postCreate: function() {
			
		},
		tempSaveCookie:function(key,val){						
			dojo.cookie("FindUserLocation_"+key, dojo.toJson(val), { expires: 1 });
		},
		getCookieVal:function(key){
			var a = dojo.cookie("FindUserLocation_"+key);
			if(a){
				return dojo.fromJson(a);
			}else{
				return null;
			}
		},
		locationError:function(error) {
			switch (error.code) {
			case error.PERMISSION_DENIED:
				console.log("Location not provided");
				break;

			case error.POSITION_UNAVAILABLE:
				console.log("Current location not available");
				break;

			case error.TIMEOUT:
				console.log("Timeout");
				break;

			default:
				console.log("unknown error");
			break;
			}

		},
		dontConvertAddress:false,
		avoidAddressConversion:function(){
			this.dontConvertAddress=true;
		},
		gotLocation:function(location) {
			console.log(location.coords.latitude+","+location.coords.longitude);
			console.log("Accuracy "+location.coords.accuracy+" speed "+location.coords.speed);
			this.geoLocation=
				{
					coords:{
						latitude:location.coords.latitude,
						longitude:location.coords.longitude
					}
				};
			this.tempSaveCookie("geoLoc",this.geoLocation);
			if(this.dontConvertAddress!=true){
				this.getAddresss(location);
			}else{
				
				dojo.publish("onUserLocationCoords",[this.geoLocation]);	
			}
		},		
		geoLocation:null,
		getAddresss:function(location){
			 if(this.locationInfo!=null){
				 dojo.publish("onUserLocation",[this.locationInfo]);
			 }else{
				 var geocoder = new google.maps.Geocoder();

				 var latlng = new google.maps.LatLng(location.coords.latitude, location.coords.longitude);
				 geocoder.geocode({'latLng': latlng}, dojo.hitch(this,this.geocodeReturn));

				 /*

			dojo.require("dojo.io.script");

			 var jsonpArgs = {
					 url: "http://maps.google.com/maps/api/geocode/xml",
			            //callbackParamName: "status",
					    mimetype: "text/plain",
			            content: {
						 sensor:"false",
						 latlng:location.coords.latitude+","+location.coords.longitude			                
			            },
			            load: function(data) {
			                //Set the data from the search into the viewbox in nicely formatted JSON
			              console.log(data);
			            },
			            error: function(error) {
			                console.error(error);
			            }
			        };
			        dojo.io.script.get(jsonpArgs);
				  */

			 }
		},
		locationInfo:null,
		geocodeReturn:function(results, status) {

		      if (status == google.maps.GeocoderStatus.OK) {
		        for ( var j = 0; j < results.length; j++) {
				  if (results[j]) {
				  var item = results[j];
		          console.log(item.formatted_address,item);
		          var comps = item.address_components;
		          var neighbor;
		          var city;
		          var street;
		          var number;
		          var postal_code;
		          var formatted_address;
		          formatted_address=item.formatted_address;
		          for ( var i = 0; i < comps.length; i++) {
		        	 var entry = comps[i];
		        	 if(entry.types[0]=="neighborhood" || entry.types[0]=="sublocality"){
		        		 neighbor=entry;
		        	 }else{
		        		 if(entry.types[0]=="locality"){
		        			 city=entry;
		        		 }
		        		 if(entry.types[0]=="route"){
		        			 street=entry;
		        		 }
		        		 if(entry.types[0]=="street_number"){
		        			number=entry;
		        		 }
		        		 if(entry.types[0]=="postal_code"){
		        			 postal_code=entry;
			        	 }
		        		 if(entry.types[0]=="formatted_address"){
		        			 formatted_address=entry;
			        	 }		        		 
		        	 }
		          }	          
		          
		          if(city )
		          {
		        	  
		        	  console.log("cidade",city);
			          console.log("bairro",neighbor);
			          console.log("rua",street);
			          
			          console.log("number",number);
			          console.log("postal_code",postal_code);
			          var neighName=null;
			          if(neighbor){
			        	  neighName=neighbor.long_name;
			          }
		        	  this.locationInfo={
		        			  city:	city.long_name,
		        			  neighborhood: neighName,
		        			  street: street,
		        			  postal_code:postal_code,
		        			  formatted_address:formatted_address,
		        			  x:this.geoLocation.coords.longitude,
		        			  y:this.geoLocation.coords.latitude
		        	  }
		        	  this.tempSaveCookie("locInfo",this.locationInfo);
			          dojo.publish("onUserLocation",[this.locationInfo]);
		        	  break;
		          }
		         ;
		          
		          
		        } else {
		        	console.log("No results found");
		        }
		        }
		      } else {
		    	  console.log("Geocoder failed due to: " + status);
		      }
		    
		},
		findLocation:function(){
			if(this.locationInfo!=null){
				dojo.publish("onUserLocation",[this.locationInfo]);
			}else{
				if(this.geoLocation!=null){
					this.gotLocation(this.geoLocation);
				}else{
					try {
						if(navigator.geolocation){ 
							navigator.geolocation.getCurrentPosition(dojo.hitch(this,"gotLocation"), dojo.hitch(this,"locationError"));
							//navigator.geolocation.watchPosition(dojo.hitch(this,"showLocation"),  dojo.hitch(this,"locationError"));
						}
					}
					catch (err) {
						console.error(err);
					}
				}
			}
		},
		startup: function() {
			this.inherited(arguments);
			this.location=this.getCookieVal("locInfo");
			this.geoLocation=this.getCookieVal("geoLoc");

			
		},

		shutdown: function() {
			this.inherited(arguments);
		}
		}
);