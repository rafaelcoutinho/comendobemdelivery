/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.search.SearchRestaurantsWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.search.SearchRestaurantsWidget"] = true;
dojo.provide("com.copacabana.search.SearchRestaurantsWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("com.copacabana.lbs.FindUserLocation");
dojo.require("dojo.cookie");

dojo.declare("com.copacabana.search.SearchRestaurantsWidget", [ dijit._Widget,
		dijit._Templated ],
		{

			templateString:"<div ><img id=\"filtrosBuscaImg\"\r\n\tsrc=\"/resources/img/opt/filtrosDeBusca.png\" alt=\"Filtros de Busca\" /> <img\r\n\tid=\"cantoFormularioImg\" src=\"/resources/img/opt/bordaFormulario.png\" />\r\n\r\n\r\n<div dojoType=\"dijit.form.Form\" class=\"buscaForm\" jsId=\"busca\"\r\n\tid=\"searchForm\" action=\"\" method=\"\"\r\n\tstyle=\"position: absolute; margin-left: 45px; margin-top: 10px; top: 50px;\">\r\n\t\r\n <label for=\"city\" \r\n\tstyle=\"color: #605D5D; font-family: verdana, arial, sans-serif; font-size: small; padding: 5px 2px;\">Cidade</label><br><img alt=\"Sua localiza��o atual\" src=\"/resources/img/locPin.png\" id=\"autoLocImg\" style=\"display: none\"><span style=\"margin-left:5px;font-weight:bold; width: 175px;margin-bottom:5px;margin-top: 5px;\" id=\"cityName\">${selectedCity.name}</span><span style=\"cursor: pointer;\" id=\"changeCity\" dojoAttachEvent=\"onclick:changeCity\"> trocar...<br/></span>\r\n\t <select dojoType=\"dijit.form.FilteringSelect\" id=\"citySelection\" dojoAttachPoint=\"citySelection\"\r\n\t\t name=\"criteria.city\"  autoComplete=\"true\" style=\"background-color: white;width: 175px;margin-bottom:5px;margin-top: 5px; display:none;\"\r\n\t\tinvalidMessage=\"Cidade inv&aacute;lida\"></select>\r\n<label for=\"neighbor\"\r\n\tstyle=\"color: #605D5D; font-family: verdana, arial, sans-serif; font-size: small; padding: 5px 2px;\">Bairro</label><br>\r\n\t <select dojoType=\"dijit.form.FilteringSelect\" id=\"neighSelection\" \r\n\t\tname=\"criteria.neighbor\" autoComplete=\"false\" selectOnClick=\"true\" hasDownArrow=\"false\"\r\n\t\tinvalidMessage=\"Bairro inv&aacute;lido\" promptMessage=\"Digite o nome de seu bairro\" style=\"background-color: white;width: 175px;margin-bottom:5px;margin-top: 5px;\"></select>\r\n\t\t<div style=\"text-align: right;\"><a style=\"font-size: xx-small; font-family: verdana,arial,sans-serif; text-decoration: underline;\" href=\"/sugerirBairro.do\">Outro bairro?</a></div>\r\n\r\n\t<br/>\r\n<input id=\"openStatus\" name=\"criteria.openStatus\" dojoType=\"dijit.form.CheckBox\" type=\"checkbox\" checked=\"false\"  style=\"filter:none\"><label\r\n\tfor=\"onlyOpen\"> S&oacute; abertos </label>\r\n<button dojoType=\"dijit.form.Button\" baseClass=\"orangeButton\" id=\"searchBtn\">\r\n            Buscar\r\n</button>\r\n\r\n</div>\r\n</div>\r\n",
			constructor : function() {
				
			},
			selectedCity:null,
			postMixInProperties : function() {
				this.inherited(arguments);
			},

			postCreate : function() {
				this.inherited(arguments);
				dojo.parser.parse(this.domNode);
				try{
					this.selectedCity=identifiedCity;
					dojo.byId('cityName').innerHTML=this.selectedCity.name;
				}catch (e) {
					console.log(e);
					this.selectedCity="";
				}
				dojo.subscribe("onUserLocation",dojo.hitch(this,this.updateDefaultComboValues));
				dojo.connect(dijit.byId('searchBtn'), "onClick", this,	"executeSearch");
				dojo.connect(dojo.query('changeCity',this.domNode)[0], "onClick", this,	"changeCity");
				
				// IE does not render the dijit checkbox properly. Rip out the
				// dojoType
				// before it's parsed
				if (dojo.isIE) {
					
					dojo
							.query('[dojoType="dijit.form.CheckBox"]',
									this.domNode).forEach(function(x) {
								x.removeAttribute("dojoType");
							});
				}
				
				
				if(defaultCityKey!=null){
					this.neighborCache[defaultCityKey]=new dojo.data.ItemFileReadStore({data:defaultNeighborList});
				}
			},
			searchDeferred:null,
			executeSearch : function(event) {
				if(this.searchDeferred!=null){
					this.searchDeferred.cancel();
				}
				if (event) {
					// Stop the submit event since we want to control form submission.
					event.preventDefault();
					event.stopPropagation();
					dojo.stopEvent(event);
				}
				this.searchCriteria.value = '';
				if(dijit.byId('openStatus').attr("value")=="on"){
					this.searchCriteria.openStatus = true;
				}else{
					this.searchCriteria.openStatus = false;
				}
				
				this.saveLastSearchSelection();
				
				this.searchCriteria.neighbor = dijit.byId('neighSelection').value;
				this.searchCriteria.neighborName= dijit.byId('neighSelection').attr("displayedValue");
				this.searchCriteria.city=dijit.byId("citySelection").attr("value");
				var xhrParams = {
						error : dojo.hitch(this, "searchFailed"),
						form : dijit.byId('searchForm').domNode,
						handleAs : 'json',
						load : dojo.hitch(this, "searchResults"),
						url : '/searchRestaurants.do'
				};
				this.searchDeferred = dojo.xhrGet(xhrParams);
				dojo.publish("onSearchBeingExecuted");
				return false;
			},
			getCitySelection:function(){
				
				return dijit.byId("citySelection").attr("value");
			},
		saveLastSearchSelection:function(){
				var cityKey = dijit.byId("citySelection").attr("value");
				var cityName = dijit.byId("citySelection").attr('displayedValue');
				var neighKey = dijit.byId("neighSelection").attr("value");
				var searchSelectionCookie = {
						cityKey:cityKey,
						neighKey:neighKey,
						cityName:cityName
				};
				dojo.cookie("lastSelectedNeighborhood", dojo.toJson(searchSelectionCookie), {
		            expires: 30
		        });
		},
		loadCities:function (){
			var stateStore = null;
			if(cachedCityList!=null){				
				stateStore=new dojo.data.ItemFileReadStore({
					data:cachedCityList
				});
				
			}else{
				stateStore=new dojo.data.ItemFileReadStore({
	                url: "/listCitiesItemFileReadStore.do"
	            });	
			}
			
			if(dijit.byId("citySelection") && dijit.byId("citySelection")!=null){
				dijit.byId("citySelection").store = stateStore;
            	dijit.byId("citySelection").attr("value",this.initialCity);
			}
            
            
        },
        changeCity:function(){
        	dojo.style(dojo.byId('autoLocImg'),'display','none');
        	dojo.style(dojo.byId("changeCity"),"display","none");
        	dojo.style(dojo.byId("cityName"),"display","none");
        	dojo.style(dijit.byId("citySelection").domNode,"display","block");        	
        	this.loadCities();
        	
        },
        autolocationData:null,
        updateDefaultComboValues:function(data){
        	try{
        		
        		this.selectedCity=data.city;
        		this.autolocationData=data;        	
        		console.log("autolocData",this.autolocationData);
        		console.log("cityname",data.city);
        		dojo.byId('cityName').innerHTML=data.city;
        		dijit.byId("citySelection").store.fetch({
        			query: {
        			name: data.city
        		},
        		onBegin: dojo.hitch(this,this.clearOldCList),
        		onComplete: dojo.hitch(this,this.gotCity),
        		onError: dojo.hitch(this,this.fetchFailed), 
        		queryOptions: {
        			deep: true
        		}
        		});
        	}catch(e){
        		console.error("failed to updateDefaultComboValues",e);
        	}

        },
        clearOldCList:function(size, request){
        	console.log('onbegin',size);
        },
        hideToolTip:function(){
        	dijit.hideTooltip( dojo.byId("cityName"));
        },
              
        gotCity:function(items, request){        	
        	dojo.style(dojo.byId('autoLocImg'),'display','inline');

        	dijit.showTooltip("Localiza&ccedil;&atilde;o autom&aacute;tica", dojo.byId("cityName"),['before','above']);
        	setTimeout(dojo.hitch(this, this.hideToolTip), 2000);
        	if(items.length==0){
        		this.autoLocating=true;
        		this.saveXYCoordsForFutureAnalysis();
        		
        	}
        	var i;
        	for (i = 0; i < items.length; i++) {
        		var item = items[i];
        		dijit.byId("citySelection").attr('value',item.id);                    
        	}
        	this.autoLocating=true;
        	        	
        	this.autoLocating=false;
        	if(this.autolocationData.neighborhood){
        		this.changeNeighborhood(this.autolocationData);
        	}
        },
        autoLocating:false,
        fetchFailed:function(error, request){
        	console.error("fetchFailed",error);
        	
        },
        savedXY:function(data){
        	console.log("XY saved");
        },
        saveXYCoordsForFutureAnalysisOld:function(){
        	try{
        		var x=this.autolocationData.x;
        		var y=this.autolocationData.y;
        		var formattedAddress = this.autolocationData.formatted_address;
        		var form = dojo.create('form', { action:"/addXYCoords.do", method: "post"});        	
        		var xInput = dojo.create('input',{ type:"text", value: x, name:"x"},form);
        		var yInput = dojo.create('input',{ type:"text", value: y, name:"y"},form);
        		var formattedAddressInput = dojo.create('input',{ type:"text", value: formattedAddress, name:"formattedAddress"},form);
		        var xhrParams = {
		        		error : function(error){
		        			console.log('failed to save coords ',error);
		        			},
		        		form : form,
		        		handleAs : 'text',
		        		load : dojo.hitch(this, "savedXY")        			
		        		};
        		dojo.xhrPost(xhrParams);
        	}catch(e){}
        },
        
        fetchNeigFailed:function(error, request){
        	console.error("fetchFailed to find neighborhood",error);
        },
        saveXYCoordsForFutureAnalysis:function(){
        	console.warn("handling unknwon location to find neighborhood");
        	if(this.getCookieVal("candidateLoaded")!=null){
    			this.loadedCandidates(this.getCookieVal("candidateLoaded"));
        	}else{
        		try{
        			var x=this.autolocationData.x;
        			var y=this.autolocationData.y;
        			var formattedAddress = this.autolocationData.formatted_address;
        			var form = dojo.create('form', { action:"/autolocate.do", method: "post"});        	
        			var xInput = dojo.create('input',{ type:"text", value: x, name:"x"},form);
        			var yInput = dojo.create('input',{ type:"text", value: y, name:"y"},form);
        			var formattedAddressInput = dojo.create('input',{ type:"text", value: formattedAddress, name:"formattedAddress"},form);
        			var xhrParams = {
        					error : dojo.hitch(this,function(error){
        						console.log('failed to save coords ',error);	
        						this.fetchNeigFailed(error, null);
        					}),
        					form : form,
        					handleAs : 'json',
        					load :dojo.hitch(this,this.loadedCandidates)

        			};
        			dojo.xhrPost(xhrParams);
        		}catch(e){}
        	}
        	//this.saveXYCoordsForFutureAnalysis();

        },        
        neighborCache:{},
        onCityUpdate:function(){
	        try {
	        	
				var cityKey = dijit.byId("citySelection").attr("value");
				if(cityKey==null||cityKey==''){
					cityKey=this.initialCity;
				}
				
				var stateStore;
				
				if(this.neighborCache[cityKey]!=null){
					stateStore=this.neighborCache[cityKey];
				}else{
					stateStore=new dojo.data.ItemFileReadStore( {
						url : "/listNeighborsByCity.do?key=" + cityKey
					});
				}
					
				dijit.byId("neighSelection").reset();
				dijit.byId("neighSelection").queryExpr="*${0}*";
				dijit.byId("neighSelection").store = stateStore;
				this.neighborCache[cityKey]=stateStore;
				console.log('isautolocation? ',this.autoLocating);
				if(this.autoLocating==true){
					console.log("should set neighborhood:",this.autolocationData );
					this.autoLocating=false;
					if(this.autolocationData.neighborhood){
						this.changeNeighborhood(this.autolocationData);
					}
				}else{
					try{
						dijit.byId("neighSelection").attr("value",this.initialNeighborhood);
					}catch(e){
						console.log('cannot set initial neighborhood');
					}
				}
				dojo.publish('onCityChanged');
			} catch (e) {
				console.error("Getting city key", e);
			}
        },        
        changeNeighborhood:function(locationData){
        	dijit.byId("neighSelection").store.fetch({
                query: {
                    name: locationData.neighborhood
                },
                onBegin: dojo.hitch(this,this.clearOldCList),
                onComplete: dojo.hitch(this,this.gotAutoNeighbor),
                onError: dojo.hitch(this,this.fetchNeigFailed), 
                queryOptions: {
                    deep: true
                }
            });
        },
        loadedCandidates:function(data){
        	console.log(data);
        	if(data.length==0){        		
        		this.fetchNeigFailed(null, null);
        	}else{
        		console.log("found a neighborhood based on X/Y");
        		dijit.byId("neighSelection").attr('value',data[0].id);
        		this.tempSaveCookie("candidateLoaded", data);
        		
        	}
        },
        tempSaveCookie:function(key,val){						
			dojo.cookie("SearchRestaurantsWidget_"+key, dojo.toJson(val), { expires: 1 });
		},
		getCookieVal:function(key){
			var a = dojo.cookie("SearchRestaurantsWidget_"+key);
			if(a){
				return dojo.fromJson(a);
			}else{
				return null;
			}
		},
        gotAutoNeighbor:function(items, request){
        	console.log(items)            
            var i;
        	if(items.length==0){
        		this.saveXYCoordsForFutureAnalysis();
        		
        	}else{
	            for (i = 0; i < items.length; i++) {
	                var item = items[i];
	                dijit.byId("neighSelection").attr('value',item.id);
	                
	            }
        	}
        },
		searchCriteria : {
			value : null,
			neighbor:null,
			city:null,
			neighborName:null,
			openStatus:false
		},
		searchFailed : function(response) {
			this.searchDeferred=null;
			if(response.message!='xhr cancelled'){
				var errorData = dojo.fromJson(response.responseText);
				
			}
		},
		searchResults : function(response) {
			this.searchDeferred=null;
			var searchManager = dijit.byId("searchResultsManager");
			searchManager.updateResults(response, this.searchCriteria);
		},
		startup : function() {
			dojo.parser.parse(this.domNode);
			this.initialCity=this.selectedCity.id;
			dijit.byId("neighSelection").queryExpr="*${0}*";
			dojo.connect(dijit.byId("citySelection"), "onChange", dojo.hitch(this,this.onCityUpdate));
			if(this.hasLastSelection()==true){	
				this.initialCity=this.lastSelection.cityKey;
				this.initialNeighborhood=this.lastSelection.neighKey;
				this.updateCityFromCookie(this.lastSelection.cityKey,this.lastSelection.cityName);				
			}else{
				
				this.onCityUpdate();
				this.geolocateUserLocation();
			}
			
			
			console.log('loadingCities');
			
			this.loadCities();
			
		},		
		updateCityFromCookie:function(cityKey,cityName){
			console.log("city from cookie",cityKey);
			this.selectedCity={	
					id:cityKey,
					name:cityName
			};
			
						
			dojo.byId('cityName').innerHTML=cityName;
			
		},
		getSelectedNeighborhood:function(){
			var n=null;
			try{
				n={id:dijit.byId("neighSelection").attr("value"),name:dijit.byId("neighSelection").attr("displayedValue")}
			}catch(e){
				console.error(e);
			}
			return n;
		},
		initialCity:null,
		initialNeighborhood:null,
		lastSelection:null,
		hasLastSelection:function(){
			this.lastSelection = dojo.cookie("lastSelectedNeighborhood");
			if(this.lastSelection!=null){
				this.lastSelection=dojo.fromJson(this.lastSelection);
				return true;	
			}
			console.log("has already selected.",this.lastSelection);
			return false;
		},	
		geoLocator:null,
		geolocateUserLocation:function(){
			if(this.geoLocator==null){
				this.geoLocator = new com.copacabana.lbs.FindUserLocation();
				this.geoLocator.startup();
			}
			this.geoLocator.findLocation();
		}

});

}
