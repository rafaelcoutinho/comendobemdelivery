/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.PlatesListWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.PlatesListWidget"] = true;
dojo.provide("com.copacabana.PlatesListWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.PlateEntryWidget");
dojo.require("com.copacabana.util");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana", "PlatesListWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.PlatesListWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings:null,
	templateString:"<div>\r\n<p>Atualmente seu estabelecimento possui <span class=\"totalPlates\">0</span> itens na\r\ncategoria <span class=\"categoriaPlates\">Todas</span></p>\r\n\r\n<div id=\"plateList\" class=\"plateList\">\r\n</div>\r\n</div>\r\n",
	constructor : function() {
		
	},
	periodToFilter:null,
	isFilterByPeriod:function(){
		if(this.periodToFilter==null){
			return false;
		}else{
			return true
		}
	},
	
	key:null,
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings= dojo.i18n.getLocalization("com.copacabana", "PlatesListWidgetStrings");
	},
	headerNode:null,
	resultsNode:null,
	imageNode:null,
	totalPlates:null,
	categoryOfPlates:null,
	
	cleanResultsNWait:function(){
		//this.resultsNode.innerHTML="";
		com.copacabana.util.cleanNode(this.resultsNode);
		this.resultsNode.appendChild(this.imageNode);
	},
	entity:null,
	categoryId:null,
	destroyRecursive : function() {
		dojo.forEach(this.getDescendants(), function(widget) {

			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	addPlate:function(plateItem){
		while(this.plateList.length>0) {
			var plate = this.plateList.pop();
			plate.destroy(false);			
		}
		var list=[];
		var found=false;
		for ( var i = 0; i < this.entity.items.length; i++) {
			if(this.entity.items[i].id==plateItem.id){
				list.push(plateItem);	
				found=true;
			}else{
				list.push(this.entity.items[i]);
			}
		}
		
		this.entity.items=list;
		if(found==false){
			this.entity.items.push(plateItem);
		}
		this.updatePlateList();
	},
	hashPlateExtensions:[],
	loadedPlates: function(data) {
		var plist = dojo.fromJson(data);
		this.entity = dojo.clone(plist);
		this.entity.items=[];
		this.hashPlateExtensions=[];
		for ( var i = 0; i < plist.items.length; i++) {
			var plate = plist.items[i];
			if(plate.isExtension==true){
				if(!this.hashPlateExtensions[plate.extendsPlate]){
					this.hashPlateExtensions[plate.extendsPlate]=[];
				}
				this.hashPlateExtensions[plate.extendsPlate].push(plate);
			}else{
				this.entity.items.push(plate);
			}
		}
		this.updatePlateList();
	},
	plateList:[],
	allCats:[],
	updatePlateList : function(shouldNotify) {
		// this.resultsNode.innerHTML="";
		dojo.empty(this.resultsNode);
		this.allCats = [];
		var results = this.entity.items;

		var counter = 0;
		if (results.length === 0) {
			this.resultsNode.innerHTML = "Nenhum produto nesta categoria.";
		} else {
			var ul = document.createElement("ul");
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];
				this.allCats[p.foodCategory] = true;
				if (this.categoryId != null) {
					if (this.categoryId != p.foodCategory && this.categoryId != "all") {
						continue;
					}
				}
				counter++;
				var plate = new com.copacabana.PlateEntryWidget({
					plate : p,
					options:dojo.clone(this.hashPlateExtensions[p.id])
				});
				plate.startup();
				this.plateList.push(plate);
				var item = document.createElement("li");
				item.appendChild(plate.domNode);
				ul.appendChild(item);
			}
			this.resultsNode.appendChild(ul);
		}
		this.totalPlates.innerHTML = counter;
		if(shouldNotify!=false){
			dojo.publish("categoriesAvailable", [ this.allCats ]);
		}

	},
	refreshPlateList:function(){
		this.cleanResultsNWait();

		var xhrArgs = {
				url : "/listAdminRestaurantPlates.do?&filterByPeriod="+this.isFilterByPeriod()+"&periodToFilter="+this.periodToFilter,								
				handleAs : "text",
				load : dojo.hitch(this, "loadedPlates"),
				error : function(error) {
					console.error("cannot load plates.",error)
				}
		}
		var deferred = dojo.xhrPost(xhrArgs);

	},
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.totalPlates = dojo.query(".totalPlates",this.domNode)[0];
			
			this.categoryOfPlates = dojo.query(".categoriaPlates",this.domNode)[0];
			this.totalPlates.innerHTML = 0;
			this.categoryOfPlates.innerHTML = "Todas";
			this.resultsNode = dojo.query(".plateList",this.domNode)[0];
			this.imageNode = document.createElement('img');
			this.imageNode.src = dojo.moduleUrl("com.copacabana", "images/loader.gif");
			this.imageNode.alt="executing search";
			this.imageNode.title="executing search";
			this.refreshPlateList();		        
			dojo.subscribe("onCategoryChanged",dojo.hitch(this, "changedCategory"));			
		} catch (e) {
			console.error("PlateList 01 ",e);
		}
	},
	changedCategory:function(data){
		this.cleanResultsNWait();
		while(this.plateList.length>0) {
			var plate = this.plateList.pop();
			plate.destroy(false);			
		}
		this.totalPlates.innerHTML = 0;
		this.categoryId=data.catId;
		this.categoryOfPlates.innerHTML=data.catName;		
		this.updatePlateList(false);
	}
	
});

}
