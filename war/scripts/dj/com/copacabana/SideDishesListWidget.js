/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.SideDishesListWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.SideDishesListWidget"] = true;
dojo.provide("com.copacabana.SideDishesListWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.SideDishEntryWidget");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana", "SideDishesListWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.SideDishesListWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templateString:"<div>\r\n<p>Atualmente seu restaurante possui <span class=\"totalPlates\">0</span> itens.</p>\r\n\r\n<div id=\"plateList\" class=\"plateList\">\r\n</div>\r\n</div>\r\n",
	constructor : function() {
		
	},
	
	
	key:null,
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana", "SideDishesListWidgetStrings");
	},
	headerNode:null,
	resultsNode:null,
	imageNode:null,
	totalPlates:null,
	
	
	cleanResultsNWait:function(){
		//this.resultsNode.innerHTML="";
		com.copacabana.util.cleanNode(this.resultsNode);
		this.resultsNode.appendChild(this.imageNode);
	},
	entity:null,
	categoryId:null,
	addSideDish:function(plateItem){
		
		this.cleanResultsNWait();

		while(this.plateList.length>0) {
			var plate = this.plateList.pop();
			plate.destroy(false);			
		}
		var list=[];
		for ( var i = 0; i < this.entity.items.length; i++) {
			if(this.entity.items[i].id==plateItem.id){
				list.push(plateItem);		
			}else{
				list.push(this.entity.items[i]);
			}
		}
		this.entity.items=list;
		this.updatePlateList();
	},
	loadedPlates: function(data) {
		this.entity = dojo.fromJson(data);
		this.updatePlateList();
	},
	plateList:[],
	updatePlateList:function(){
		//this.resultsNode.innerHTML="";
		com.copacabana.util.cleanNode(this.resultsNode);

		
		var results = this.entity.items;
		//{title:"X-Burdog",price:"12,00",description:"Hamb�rguer, alface, tomate, maionse Burdog, 5 tiras de bacon, 4 fatias de pepino em conserva e 1 rodela de cebola crua. "}
		var counter=0;
		if(results.length===0){
			this.resultsNode.innerHTML="Nenhum acompanhamento.";	
		}else{
			var ul = document.createElement("ul");
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];				
				counter++;
				var plate = new com.copacabana.SideDishEntryWidget(p);
				plate.startup();
				this.plateList.push(plate);
				var item = document.createElement("li");
				item.appendChild(plate.domNode);
				ul.appendChild(item);
			}
			this.resultsNode.appendChild(ul);
		}
		this.totalPlates.innerHTML =counter;
		
		
	},
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.totalPlates = dojo.query(".totalPlates",this.domNode)[0];
			
			
			this.totalPlates.innerHTML = 0;
			
			this.resultsNode = dojo.query(".plateList",this.domNode)[0];
			this.imageNode =  document.createElement('img');
			this.imageNode.src = dojo.moduleUrl("com.copacabana", "images/loader.gif");
			this.imageNode.alt="executing search";
			this.imageNode.title="executing search";
			 this.cleanResultsNWait();
			        
		        	 var xhrArgs = {
								url : "/listRestaurantSideDishes.do?key="+this.key,								
								handleAs : "text",
								load : dojo.hitch(this, "loadedPlates"),
								error : function(error) {
									console.error("cannot list rest sidedishes",error);
								}
							};
							var deferred = dojo.xhrPost(xhrArgs);
		        
		
			
		} catch (e) {
			console.error("sideDish start",e);
		}
	}
	
});

}
