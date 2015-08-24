dojo.provide("com.copacabana.RestaurantWheelWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.Menu");
dojo.require("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("com.copacabana.FoodCategoryRestaurantResultWidget");
dojo.declare("com.copacabana.RestaurantWheelWidget", [ dijit._Widget ], {
	i18nString : null,
	title : "",
	url : null,
	//templatePath : ,//dojo.moduleUrl("com.copacabana",		"templates/RestaurantWheel.html"),
	constructor : function() {
	},
	loadedObject:null,
	postMixInProperties : function() {
		this.inherited(arguments);
	},
	imageNode:null,
	statusTextNode:null,
	postCreate : function() {
		this.inherited(arguments);
		this.domNode=dojo.byId('menuRestaurantesCategorias');
		
		this.imageNode =  document.createElement('img');
		this.imageNode.src = dojo.moduleUrl("com.copacabana", "images/smallOrangeGrayLoader.gif");
		this.imageNode.alt="carregando";
		this.imageNode.title="carregando";
		this.statusNode = document.createElement('div');
		this.statusNode .appendChild(this.imageNode);
		dojo.addClass(this.statusNode,'restItem');
		dojo.style(this.statusNode ,'backgroundColor','white');
		this.statusTextNode=document.createTextNode(' Carregando');
		this.statusNode.appendChild(this.statusTextNode);
		this.emptyResultsNode = document.createElement('div');
		
		dojo.addClass(this.emptyResultsNode,'restItem');
		dojo.style(this.emptyResultsNode ,'backgroundColor','white');
		
		this.emptyResultsNode.appendChild(document.createTextNode('Nenhum restaurante'));
		
		
	},
	emptyResultsNode:null,
	addListeners:function(){
		

	    var pMenu;
	    
	        pMenu = new dijit.Menu({
	            targetNodeIds: ["massas"],
	            leftClickToOpen:true,
	            popupDelay:300
	        });
	        
	        pMenu.addChild(new dijit.MenuItem({
	            label: "Teste"
	        }));
	        

	        pMenu.startup();
	    
	},
	updateCache:function(response,cat,cityId){
		if(!this.loadedCatRestListCache[cat.id]){
			this.loadedCatRestListCache[cat.id]=[];
		}
		this.loadedCatRestListCache[cat.id][cityId]=response;
	},
	getFoodCategoryCached:function(cat,cityId){
		if(this.loadedCatRestListCache[cat.id]){
			return this.loadedCatRestListCache[cat.id][cityId]; 
		}
		return undefined;
		
	},
	loadedCatRestListCache:[],
	loadedRestaurants:function(response,cat,cityId){
		this.updateCache(response,cat,cityId);
		
		//var restPane=dojo.query(".restSuggestions", this.domNode)[0];
		
		//this.restSuggestionPane.innerHTML="";
		com.copacabana.util.cleanNode(this.restSuggestionPane);
		
		
		
		
		if(response.length==0){
			dojo.style(this.noResultsPane,"display","block");
			//restPane.innerHTML="Nenhum restaurante encontrado";
			//com.copacabana.util.cleanNode(this.statusNode);
			
			this.restSuggestionPane.appendChild(this.emptyResultsNode);
		}		
		for ( var i = 0; i < response.length; i++) {
			var rest = new com.copacabana.FoodCategoryRestaurantResultWidget({rest:response[i]});
			rest.startup();
			this.restSuggestionPane.appendChild(rest.domNode);
		}
	},
	catBackground:null,
	noResultsPane:null,
	statusNode:null,
	lastCategoryClicked:null,
	showRestaurants:function(cat){
		dojo.style(this.noResultsPane,"display","none");
		
		if(cat.imgUrl){
			dojo.style(this.catBackground,"backgroundImage","url('"+cat.imgUrl+"')");
			dojo.style(this.catBackground,"backgroundRepeat","no repeat");
		}else{
			dojo.style(this.catBackground, "backgroundImage",
			"url('/resources/img/bgMenu/telaVermelha.jpg')");
		}
		this.lastCategoryClicked=cat;
		var cityId = dijit.byId('formularioBusca').getCitySelection();
		dojo.style(this.restSuggestionPane,"display","block");
		if(!this.getFoodCategoryCached(cat.id,cityId)){
				
			com.copacabana.util.cleanNode(this.restSuggestionPane);			
			this.restSuggestionPane.appendChild(this.statusNode);			
			
			var fct=function(response){
				this.loadedRestaurants(response,cat,cityId);
			}
			var xhrArgs = {
					url : "/getRestaurantByFoodCategory.do",
					content: {cityId:cityId,id:cat.id},
					handleAs : "json",
					load : dojo.hitch(this, fct),
					error : function(error) {
						com.copacabana.util.cleanNode(this.restSuggestionPane);
						console.error("cannot load rest by category",error);
					}
				};
			var deferred = dojo.xhrGet(xhrArgs);
		}else{
			this.loadedRestaurants(this.getFoodCategoryCached(cat.id,cityId));
		}
		// /getRestaurantByFoodCategory.do?id=ahByY291dG9jb3BhY2FiYW5hchILEgxGb29kQ2F0ZWdvcnkYCQw
	},	
	loadedCategories:function(data){
		var i;		
		for ( i = 0; i < data.length && i<12; i++) {	
			var fc=data[i];
			if(i%2){
				fc.index=i/2 -0.5;
				fc.type="direita";
			}else{
				fc.index=i/2;
				fc.type="esquerda";
				
			}
			var d = new com.copacabana.RestaurantTypeOptionWidget(fc);
			d.delegateFctToDisplayRestaurants=dojo.hitch(this,this.showRestaurants);//dojo.query(".restSuggestions", this.domNode)[0];
			dojo.byId('menuRestaurantes').appendChild(d.domNode);
			
		}
	},
	onShowRequest:function(id){
		for ( var i = 0; i < this.loadedObject.length; i++) {
			if(this.loadedObject[i].id==id){
				return this.showRestaurants(this.loadedObject[i]);				
			}
		}
		
	},
	restSuggestionPane:null,
	startup : function() {
		try{
			dojo.subscribe('onShowRestSelection',dojo.hitch(this,this.onShowRequest));
			this.restSuggestionPane=dojo.query(".restSuggestions")[0];
			this.catBackground=dojo.query(".categoryBackground")[0];
			this.noResultsPane=dojo.query(".noRestItem")[0];
			dojo.subscribe('onCityChanged',dojo.hitch(this,this.onCityChanged));
			/*if(!this.loadedObject || this.loadedObject==null){
					var xhrArgs = {
						url : "/listMainFoodCategories.do",
						handleAs : "json",
						load : dojo.hitch(this, this.loadedCategories),
						error : function(error) {
							console.error("cannot list main food cats",error);
						}
					};
				var deferred = dojo.xhrGet(xhrArgs);
			}else{
				
				this.loadedCategories(this.loadedObject);
			}*/
		}catch(e){
			console.log('failed to load wheel:'+e.message,e);
			
		}
	},
	onCityChanged:function(evt){
		if(this.lastCategoryClicked && this.lastCategoryClicked.id){
			//reload options
			this.showRestaurants(this.lastCategoryClicked);
		}
	},
	hideRestaurants:function(evt){
		//dojo.style(dojo.query(".restSuggestions", this.domNode)[0],"display","none");
		//dojo.style(dojo.query(".categoryBackground", this.domNode)[0],"backgroundImage","url('/resources/img/bgMenu/fundo.jpg')");
		
	}
});