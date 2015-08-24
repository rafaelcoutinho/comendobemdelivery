/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.RestPlateMenuWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.RestPlateMenuWidget"] = true;
dojo.provide("com.copacabana.RestPlateMenuWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.PlateOrderWidget");
dojo.require("com.copacabana.PlateOrderOptionsWidget");
dojo.require("com.copacabana.FractionPlateWidget");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana", "RestPlateMenuWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.RestPlateMenuWidget", [ dijit._Widget,
                                                     dijit._Templated ], {
	i18nStrings : null,
	templateString:"<div class=\"cardapio\" style=\"width: 650px\">\r\n<h2>Card&aacute;pio<img src=\"/resources/img/loader.gif\" class=\"loadingSection\" style=\"width:15px;\"/></h2>\r\n\r\n<ul id=\"categorias\" style=\"display:block\">\r\n\t\t<li></li>\r\n</ul>\r\n<div class=\"addFractionPlate\" dojoAttachEvent=\"onclick:addFractionPlate\"  ><button baseClass=\"orangeButton\" dojoType=\"dijit.form.Button\">Monte sua pizza meio a meio</button><br/></div>\r\n<table id=\"cardapio\"  style=\"margin: -15px 0px 0px 100px;\">\r\n\t<thead>\r\n\t\t<tr>\r\n\t\t\t<th>Descri&ccedil;&atilde;o</th>\r\n\t\t\t<th>Pre&ccedil;o Unit&aacute;rio</th>\r\n\t\t\t<th><span class=\"qtdLabel\">Quantidade</span></th>\r\n\t\t\t<th> </th>\r\n\t\t</tr>\r\n\t</thead>\r\n\t<tbody class=\"plateMenuList\">\t\t\r\n\t</tbody>\r\n</table>\r\n\r\n</div>\r\n",
	constructor : function() {
		this.id = "cardapio";
		console.log("Created RestPlateMenuWidget: id "+this.id);

	},
	postMixInProperties: function(){
		if (dijit.byId(this.id)) {
			dijit.byId(this.id).destroyRecursive();
		}
	},
	destroyRecursive: function(){
		console.log("destroying RestPlateMenuWidget");
		while(this.plateList.length>0){
			var v = this.plateList.pop();
			v.destroyRecursive(false);
		}
		dojo.forEach(this.getDescendants(), function(widget){
			console.log("RestPlateMenuWidget destroying "+widget.id);
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	rest:null,
	setRestaurant:function(rest){
		this.rest=rest;
	},
	

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana",
		"RestPlateMenuWidgetStrings");
	},
	resultsNode:null,
	isHighlight:function(id){
		for ( var i = 0; i < this.highlights.length; i++) {
			if(this.highlights[i]==id){
				return true;
			}
		}
		return false;
	},
	extensions:[],
	highlights:[],
	populatePlateList : function(entity,highlight) {

		this.resultsNode = dojo.query(".plateMenuList", this.domNode)[0];

		var results = entity.plates;

		this.catNodes=[];
		this.categoryList=[];
		this.highlights =entity.highlights;
		//this.createAllCategoriesNode();
		
		this.createHighlighCategoriesNode();
		
		var counter=0;

		if(results.length===0){
			this.resultsNode.innerHTML=this.i18nStrings.noPlatesInCategory;	
		}else{	
			var disable=false;
			if(this.rest.isOpen==false || (this.rest.siteStatus && this.rest.siteStatus!='ACTIVE')){
				disable=true;
			}
			var counter=0;
			this.extensions=[];
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];
				if(p.availableTurn!='ANY'){
					if(p.currentTurn!=p.availableTurn){
						results.splice(i,1);
						i--;
					}
				}
				if(p.isExtension==true){
					if(this.extensions[p.extendsPlate]==null){
						this.extensions[p.extendsPlate]=[];
					}
					this.extensions[p.extendsPlate].push(p);
					results.splice(i,1);
					i--;
				}
			}
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];
				if(p.status=='HIDDEN'){
					continue;
				}
				
				

				var wid = new com.copacabana.PlateOrderWidget(p,disable);
				wid.startup();
				

				
				if(this.extensions[p.id]!=null){					
					var wids = new com.copacabana.PlateOrderOptionsWidget(this.extensions[p.id],p.title,disable);
					wids.startup();
					wid.options=wids;
				}

				this.plateList.push(wid);
				if(this.isHighlight(p.id)==true){
					if(counter%2==0){
						dojo.style(wid.domNode,'backgroundColor','#E9E6E6');
					}
					this.resultsNode.appendChild(wid.domNode);
					if(wid.options){
						if(counter%2==0){
							dojo.style(wid.options.domNode,'backgroundColor','#E9E6E6');
						}
						this.resultsNode.appendChild(wid.options.domNode);
					}
					counter++;

				}
				
			
				
				if(!this.categoryList[p.foodCategory]){
					this.categoryList[p.foodCategory]=true;
					var args = {
							identity: p.foodCategory,  
							onItem :dojo.hitch(this,this.onFoodCatFound),
							onError : function(item, request) {
								console.error(item);
							}
					};
					foodCategoriesCache.fetchItemByIdentity(args);
				}
			}			
		}


	},
	hasProcessedFraction:false,
	fractionCategory:[],
	showFractionedOrder:function(show,catId){
		this.fractionCategory[catId]=true;
		if(this.hasProcessedFraction==true){
			return;
		}

		var fractionNode = dojo.query('.addFractionPlate',this.domNode)[0];
		var restNotAvailable = (this.rest.isOpen==false || (this.rest.siteStatus && this.rest.siteStatus!='ACTIVE'));
		if(restNotAvailable==false && show==true){
			dojo.style(fractionNode,'display','block');
		}else{
			dojo.style(fractionNode,'display','none');
		}
		this.hasProcessedFraction=true;
	},
	onFoodCatFound:function(item, request) {			        	
		var catDiv=dojo.create("li",{property:"commerce:cuisine"});

		//document.createElement("li");

		if(item.name.length==1){
			item.name=item.name[0];
		}
		if(item.name.length>=5 && item.name.substr(0,5)=='Pizza'){
			this.showFractionedOrder(true,item.id);
		}
		var maxlength=10;
		var catName= dojo.clone(item.name);
		if(item.name.length>maxlength){
			if(item.name.substr(0,maxlength).indexOf(' ')==-1 ){
				catName=item.name.substr(0,maxlength)+'- '+item.name.substr(maxlength);
			}
		}
		catDiv.innerHTML=catName;
		this.catNodes[item.id]=catDiv;
		dojo.byId("categorias").appendChild(catDiv);
		var fct=function(evt){
			this.updatePlateList(evt,item.id,item.name);									
		}
		dojo.connect(catDiv,"onclick",dojo.hitch(this,fct));
	},
	catNodes:[],
	currCategory:null,
	updatePlateList:function(evt,category,catName){
		this.currCategory=category;


		com.copacabana.util.cleanNode(this.resultsNode);
		var curr = dojo.query(".selecionado",this.domNode)[0];				
		dojo.removeClass(curr,"selecionado");		
		dojo.addClass(this.catNodes[category],"selecionado");
		var counter=0;
		for ( var i = 0; i < this.plateList.length; i++) {
			var wid = this.plateList[i];
			if(category=="highlights" && this.isHighlight(wid.plate.id)){
					if(counter%2==0){
						dojo.style(wid.domNode,'backgroundColor','#E9E6E6');
					}else{
						dojo.style(wid.domNode,'backgroundColor','#FFFFFF');
					}
					
					this.resultsNode.appendChild(wid.domNode);
					if(wid.options){
						if(counter%2==0){
							dojo.style(wid.options.domNode,'backgroundColor','#E9E6E6');
						}else{
							dojo.style(wid.options.domNode,'backgroundColor','#FFFFFF');
						}
						this.resultsNode.appendChild(wid.options.domNode);
					}
					counter++;
				
			}else{

				if(wid.plate.foodCategory==category || category=="all"){
					if(counter%2==0){
						dojo.style(wid.domNode,'backgroundColor','#E9E6E6');
					}else{
						dojo.style(wid.domNode,'backgroundColor','#FFFFFF');
					}
					
					this.resultsNode.appendChild(wid.domNode);
					
					if(wid.options){
						if(counter%2==0){
							dojo.style(wid.options.domNode,'backgroundColor','#E9E6E6');
						}else{
							dojo.style(wid.options.domNode,'backgroundColor','#FFFFFF');
						}
						this.resultsNode.appendChild(wid.options.domNode);
					}
					counter++;
					
				}
				
			}
		}			
	},
	hideloading:function(){
		dojo.style(dojo.query('.loadingSection',this.domNode)[0],'display','none'); 
	},
	categoryList:[],
	plateList:[],
	loadedPlates:function(data) {
		this.hideloading();
		try{
			var  response = dojo.fromJson(data);			
			this.populatePlateList(response);
		}catch(e){
			console.error("loaded plates but can't display it",e);
		}
	},

	createAllCategoriesNode:function(){		
		var catDiv=document.createElement("li");
		catDiv.innerHTML=this.i18nStrings.allCategories;
		this.catNodes["all"]=catDiv;		
		var fct=function(evt){
			this.updatePlateList(evt,"all");									
		};
		dojo.connect(catDiv,"onclick",dojo.hitch(this,fct));

		dojo.byId("categorias").appendChild(catDiv);
		dojo.addClass(catDiv,"selecionado");
	},
	createHighlighCategoriesNode:function(){		
		var catDiv=document.createElement("li");
		catDiv.innerHTML=this.i18nStrings.highlights;
		this.catNodes["highlights"]=catDiv;		
		var fct=function(evt){
			this.updatePlateList(evt,"highlights");									
		};
		dojo.connect(catDiv,"onclick",dojo.hitch(this,fct));

		dojo.byId("categorias").appendChild(catDiv);
		dojo.addClass(catDiv,"selecionado");
	},
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			if(this.rest.isOpen==false || (this.rest.siteStatus && this.rest.siteStatus!='ACTIVE')){
				dojo.query(".qtdLabel",this.domNode)[0].innerHTML='';	
			}
		} catch (e) {
			console.log(e);
		}
	},
	preFetched:null,
	loadedHighlights:function(data){
		this.populatePlateList(data);
	},
	loadHighlights:function(){		
		var xhrArgs = {
				url : "/destaquesRestaurante.do?key=" + this.rest.id,
				handleAs : "json",
				load : dojo.hitch(this, this.loadedHighlights),
				error : function(error) {
					console.error("cannot load rest. high plates ",error);
				}
		};
		var deferred = dojo.xhrPost(xhrArgs);	
	},
	show:function(){		
		if(this.preFetched==null){
			var xhrArgs = {
					url : "/destaquesRestaurante.do?key=" + this.rest.id,
					handleAs : "text",
					load : dojo.hitch(this, this.loadedPlates),
					error : function(error) {
						console.error("cannot load rest. plates ",error);
					}
			};
			var deferred = dojo.xhrPost(xhrArgs);	
		}else{
			this.populatePlateList(this.preFetched);
			this.hideloading();
		}
	},
	halfDialog:null,
	addFractionPlate:function(){
		var catplateList=[];
		for ( var i = 0; i < this.plateList.length; i++) {
			var wid = this.plateList[i];
			if(this.fractionCategory[wid.plate.foodCategory]==true && wid.plate.status=='AVAILABLE'){
				catplateList.push(wid.plate);
				
				if(wid.options){
					for(var id in wid.options.optionsList){
						var popt = wid.options.optionsList[id];
						var pp = dojo.clone(popt);
						pp.name=wid.plate.title+":"+pp.title;
						pp.mainPlateTitle=wid.plate.title;
						pp.mainPlateImageUrl=wid.plate.imageUrl;
						catplateList.push(pp);
					}
				}
			}			
		}
		var fdialog = new com.copacabana.FractionPlateWidget({catPlates:catplateList,rest:this.rest});
		fdialog.startup();

	},
	addHalfPlate:function(args){
		console.log(args)
	}

});

}
