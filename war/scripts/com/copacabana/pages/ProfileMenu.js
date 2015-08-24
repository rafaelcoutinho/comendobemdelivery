dojo.provide("com.copacabana.pages.ProfileMenu");

dojo.require("com.copacabana.PlateEntryWidget");
dojo.require("dijit.form.Textarea");
dojo.require("com.copacabana.RoundedButton");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("com.copacabana.PlatesListWidget");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser"); 
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.Dialog");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.TimeTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.DateTextBox");
dojo.require("com.copacabana.util");
com.copacabana.pages.ProfileMenu.foodCategories = null;
com.copacabana.pages.ProfileMenu.filterCategories=function(filter){
	com.copacabana.pages.ProfileMenu.foodCategories=com.copacabana.util.loadFoodCats();
	var sortAttributes = [{attribute: "name", descending: false}];
	var completed =function (items, findResult){
		try{
			var newFilteredList = [];
			for ( var i = 0; i < items.length; i++) {
				var id =com.copacabana.pages.ProfileMenu.foodCategories.getValue(items[i],"id");;
				if(filter[id]==true){
					var name =com.copacabana.pages.ProfileMenu.foodCategories.getValue(items[i],"name");;
					newFilteredList.push({id:id,name:name});
				}
			}
			var store = new dojo.data.ItemFileReadStore({data: { identifier: "id",
				items:newFilteredList
			}});
			dijit.byId("foodCategoriesSelection").store = store;
			if(com.copacabana.pages.ProfileMenu.currCat!=null){
				dijit.byId("foodCategoriesSelection").attr('value',com.copacabana.pages.ProfileMenu.currCat);	
			}
		}catch (e) {
			console.error('failed to update cat list ',e);
		}

	}
	var error = function (errData, request){
		console.log("Failed filtering data.",errData);
	}
	com.copacabana.pages.ProfileMenu.foodCategories.fetch({onComplete: completed, onError: error, sort: sortAttributes});
};
com.copacabana.pages.ProfileMenu.loadFoodCat=function(){
	dojo.subscribe('categoriesAvailable',com.copacabana.pages.ProfileMenu.filterCategories);
	
	
	if(!com.copacabana.pages.ProfileMenu.foodCategories && com.copacabana.pages.ProfileMenu.foodCategories==null){
		com.copacabana.pages.ProfileMenu.foodCategories=com.copacabana.util.loadFoodCats();
	}

	var sortAttributes = [{attribute: "name", descending: false}];

	var completed =function (items, findResult){
		var store = new dojo.data.ItemFileReadStore({data: { identifier: "id",
			items:items
		}});

		dijit.byId("foodCategoriesSelectionForPlates").store = store;
		dijit.byId("foodCategoriesSelection").store = store;
		dojo.connect(dijit.byId("foodCategoriesSelection"),"onChange",com.copacabana.pages.ProfileMenu.categoryChanged);

	}
	var error = function (errData, request){
		console.log("Failed in sorting data.",errData);
		dijit.byId("foodCategoriesSelectionForPlates").store = com.copacabana.pages.ProfileMenu.foodCategories;
		dijit.byId("foodCategoriesSelection").store = com.copacabana.pages.ProfileMenu.foodCategories;
	}
	//com.copacabana.pages.ProfileMenu.foodCategories.fetch({onComplete: completed, onError: error, sort: sortAttributes});
	com.copacabana.pages.ProfileMenu.foodCategories.fetch({onComplete: completed, onError: error, sort: sortAttributes});


}

com.copacabana.pages.ProfileMenu.categoryChanged = function(){
	var cat = dijit.byId("foodCategoriesSelection").attr("value");
	com.copacabana.util.showLoading();
	var args = { 
        identity: cat,  
        onItem : function(item, request) {	
			com.copacabana.util.hideLoading();	        
			if(!item){
				dojo.publish("onCategoryChanged",[{"catId":'all',"catName":'Todas categorias'}]);
			}	else{	
				dojo.publish("onCategoryChanged",[{"catId":cat,"catName":item.name[0]}]);
			}
		},
	    onError : function(item, request) {
    		console.error(item);
    		com.copacabana.util.hideLoading();
    		var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Erro ao carregar categoria. Por favor tente novamente.",msg.errorType);
    		
    	    
    	}
	}
	dijit.byId("foodCategoriesSelection").store.fetchItemByIdentity(args);
};

com.copacabana.pages.ProfileMenu.editPlateOption =function(mainPlateId,mainPlateName,plateOption){
	dijit.byId("plateOptionForm").reset();
	var d={
		plate:{
			extendsPlate:mainPlateId,
			id:plateOption.id,
			title:plateOption.title,
			description:plateOption.description,
			price:plateOption.price,			
			foodCategory:plateOption.foodCategory,
			imageUrl:plateOption.imageUrl,
			status:plateOption.status,
			
			plateSize:plateOption.plateSize
		},
		restaurant:loggedRestaurant.id
	
		
	};
	if(plateOption.id==null || plateOption.id==''){
		d.plate.status='AVAILABLE';
		d.plate.price='0,00';
		d.plate.plateSize='NONE';
	}
	dijit.byId('plateOptionDialog').attr('value', d);
	dijit.byId('plateOptionDialog').show();
	
	
	
}

com.copacabana.pages.ProfileMenu.editPlate =function(data){
	
	var d={
		plate:{
			id:data.id,
			title:data.title,
			description:data.description,
			price:data.price,
			foodCategory:data.foodCategory,
			imageUrl:data.imageUrl,
			status:data.status
		},
		restaurant:data.restaurant
	
		
	};
	
	
	dijit.byId('plateForm').attr('value', d);
	com.copacabana.pages.ProfileMenu.showDialog(null,d.plate.title);
	dojo.byId('restaurant').value=loggedRestaurant.id;
	
	
}

com.copacabana.pages.ProfileMenu.showDialog =function(evt,title){
	if(title){
		dijit.byId('dialog1').attr("title",title);
		dojo.style(dijit.byId('deletebutton').domNode,'visibility','visible');
	}else{
		dijit.byId('dialog1').attr("title","Novo prato");
		dojo.style(dijit.byId('deletebutton').domNode,'visibility','hidden');
	}
	dijit.byId('dialog1').show();
	dojo.byId('restaurant').value=loggedRestaurant.id;	
}
com.copacabana.pages.ProfileMenu.deletePlate = function(){
	var idToDelete = dijit.byId("id").attr('value');
	var msg = new com.copacabana.MessageWidget();
	var options=[
	             {
	            	id:"yes",
	            	label:"Sim"		            	
	             },
	             {
		            	id:"no",
		            	label:"N&atilde;o"		            	
	             }				         
	];
	var completeFct = function(response){
		com.copacabana.pages.ProfileMenu.confirmDelete(response,idToDelete);
	};				             
	msg.promptMsg("Voc&ecirc; tem certeza que deseja apagar este produto? <br/><span style='font-size:x-small'>* qualquer op&ccedil;&atilde;o deste produto tamb&eacute;m ser&aacute; apagada.</span>",options,completeFct,"Confirmar");
	
};

com.copacabana.pages.ProfileMenu.deleteOptionPlate=function(idToDelete){	
	var msg = new com.copacabana.MessageWidget();
	var options=[
	             {
	            	id:"yes",
	            	label:"Sim"		            	
	             },
	             {
		            	id:"no",
		            	label:"N&atilde;o"		            	
	             }				         
	];
	var completeFct = function(response){
		if(response=='yes'){			
			var form = dojo.create('form',{action:'/deletePlate.do',method:'post'},dojo.body());
			dojo.create('input',{type:'hidden',name:'id',value:idToDelete},form);
			
			var xhrArgs = {
	                form:form,//dojo.byId("plateForm"),
	                handleAs: "json",
	                load: function(data) {	                    	
						dijit.byId("plateListWidget").refreshPlateList();
	                },
	                error: function(error) {
	                    //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
	                    //docs server.	                    
	                    var msg = new com.copacabana.MessageWidget();
	    				msg.showMsg("Erro ao apagar registro. Por favor tente novamente.",msg.errorType);
	                                 
	                }
	            }
	            //Call the asynchronous xhrPost	                
	            var deferred = dojo.xhrPost(xhrArgs);
		  		
		}
	};				             
	msg.promptMsg("Voc&ecirc; tem certeza que deseja apagar esta op&ccedil;&atilde;o de produto?",options,completeFct,"Confirmar");
}

com.copacabana.pages.ProfileMenu.confirmDelete=function(response,id){
	if(response=='yes'){
		dijit.byId("dialog1").hide();
		dijit.byId("plateForm").reset();
		
		var form = dojo.create('form',{action:'/deletePlate.do',method:'post'},dojo.body());
		dojo.create('input',{type:'hidden',name:'id',value:id},form);
		
		var xhrArgs = {
                form:form,//dojo.byId("plateForm"),
                handleAs: "json",
                load: function(data) {	                    	
					dijit.byId("plateListWidget").refreshPlateList();
                },
                error: function(error) {
                    //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
                    //docs server.
                    console.log("Form error ",error);
                    var msg = new com.copacabana.MessageWidget();
    				msg.showMsg("Erro ao apagar registro. Por favor tente novamente.",msg.errorType);
                                 
                }
            }
            //Call the asynchronous xhrPost	                
            var deferred = dojo.xhrPost(xhrArgs);
	  		
	}
};
com.copacabana.pages.ProfileMenu.currCat=null;

com.copacabana.pages.ProfileMenu.savePlate = function(){
	if(!com.copacabana.util.checkValidForm(null,dijit.byId("plateForm").domNode)){				
		return;
	}else{
		
		
		com.copacabana.util.showLoading();
		var xhrArgs = {
				form:dijit.byId("plateForm").domNode,
				handleAs: "json",
				load: function(data) {	                    	
					var entity= data;
					com.copacabana.util.hideLoading();
					dijit.byId("dialog1").hide();
					dijit.byId("plateForm").reset();
					dijit.byId("plateListWidget").addPlate(data);
					com.copacabana.pages.ProfileMenu.currCat=data.foodCategory;
					
				},
				error: function(error) {
					//We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
					//docs server.
					com.copacabana.util.hideLoading();
					console.log("Form error ",error);	
					var msg = new com.copacabana.MessageWidget();
					msg.showMsg("Erro ao salvar prato. Por favor tente novamente.",msg.errorType);


				}
		}
		//Call the asynchronous xhrPost	                
		var deferred = dojo.xhrPost(xhrArgs);
	}	
};

com.copacabana.pages.ProfileMenu.createNewPlate=function(){
	dijit.byId("plateForm").reset();
	
	var cat = dijit.byId("foodCategoriesSelection").attr("value");
	
	if(cat){
		dijit.byId("foodCategoriesSelectionForPlates").attr("value",cat);
	}
	dijit.byId("price").attr("value",'0,00');
	dijit.byId('plateStatus').attr('value','AVAILABLE');	
	
	com.copacabana.pages.ProfileMenu.showDialog();
};

com.copacabana.pages.ProfileMenu.savePlateOption = function(){
	if(!com.copacabana.util.checkValidForm(null,dijit.byId("plateOptionForm").domNode)){				
		return;
	}else{
		com.copacabana.util.showLoading();
		var xhrArgs = {
				form:dijit.byId("plateOptionForm").domNode,
				handleAs: "json",
				load: function(data) {	                    	
					var entity= data;
					com.copacabana.util.hideLoading();
					dijit.byId("plateOptionDialog").hide();
					dijit.byId("plateOptionForm").reset();
					//dijit.byId("plateListWidget").addPlate(data);
					com.copacabana.pages.ProfileMenu.currCat=data.foodCategory;
					dijit.byId("plateListWidget").refreshPlateList();
					
				},
				error: function(error) {
					//We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
					//docs server.
					com.copacabana.util.hideLoading();
					console.log("Form error ",error);	
					var msg = new com.copacabana.MessageWidget();
					msg.showMsg("Erro ao salvar prato. Por favor tente novamente.",msg.errorType);


				}
		}
		//Call the asynchronous xhrPost	                
		var deferred = dojo.xhrPost(xhrArgs);
	}	
};

