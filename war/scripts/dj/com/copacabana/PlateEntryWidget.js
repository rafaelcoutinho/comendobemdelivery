/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.PlateEntryWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.PlateEntryWidget"] = true;
dojo.provide("com.copacabana.PlateEntryWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");
dojo.require("dijit.InlineEditBox");
dojo.require("dijit.form.Textarea");
dojo.require("dojox.form.FileUploader");

//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
//dojo.requireLocalization("com.copacabana", "PlatesListWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.PlateEntryWidget", [
		dijit._Widget, dijit._Templated ], {
	//i18nStrings: dojo.i18n.getLocalization("com.copacabana", "PlatesListWidgetStrings"),
	templateString:"<div >\r\n<div class=\"panel\" dojoAttachEvent=\"onclick:onClick\" >\t\r\n\t<h2>${plate.title} <span class=\"statusPlate\">${statusMsg}</span></h2>\r\n\t<span class=\"preco\">${priceFormated}</span>\t\r\n\t<p class=\"pcardapiodesc\">${plate.description}</p>\t\r\n</div>\r\n<div class=\"acompanhamentos\">\r\n<div dojoAttachPoint=\"showExtensionsBtn\" ></div> <div dojoAttachPoint=\"btn0\" ></div> \r\n<div dojoAttachPoint=\"extensionsSection\" class=\"optionsSection\">\r\nAdicione opções para '${plate.title}'. <br>\r\n<span style=\"font-style: italic;font-size: small;\">Por exemplo tamanhos (Pequeno/Médio/Grande) ou variações como \"Com batata salsa\". O valor deve ser o valor total com a opção.</span><br/>\r\n<div dojoAttachPoint=\"addNewExtensionsBtn\" ></div>\r\n<div dojoAttachPoint=\"extensionsList\" >Nenhuma opção cadastrada para '${plate.title}'</div>\r\n</div>\r\n\r\n</div>\r\n\r\n<iframe width=\"0\" height=\"0\" name=\"${plate.id}_frame\" style=\"display: none;\" ></iframe>\t\r\n<br>\r\n\r\n<div dojoAttachPoint=\"imageForm\" style=\"display: none; padding: 4px; margin: 3px; border: 1px solid black; background-color: rgb(255, 223, 143);\">\r\n\r\n<div dojoAttachPoint=\"imageSection\"  style=\"border: 1px solid gray; max-height: 300px; max-width: 300px;\"></div>\t\r\n\t<form action=\"\"\r\n\t\tmethod=\"post\" enctype=\"multipart/form-data\" dojoAttachPoint=\"photoForm\" target=\"${plate.id}_frame\">\t\t\r\n\t\t<div><input type=\"file\" dojoAttachPoint=\"filePath\" name=\"myFile\" title=\"Selecionar foto\" class=\"testando\">\r\n\t\t<input type=\"hidden\" name=\"pid\" value=\"${plate.id}\"></div>\r\n\t\t<div dojoAttachPoint=\"sendImageBtn\" ></div>\r\n\t</form>\r\n</div>\r\n<br/>\r\n\r\n</div>\r\n",
	options:[],
	constructor : function(args) {
		this.plate=args.plate;
		this.options=args.options;
		this.priceFormated=com.copacabana.util.moneyFormatter(this.plate.price);
		if(this.plate.status!='AVAILABLE'){
			this.statusMsg='INDISPONÍVEL';
		}
		if(this.plate.status=='HIDDEN'){
			this.statusMsg='OCULTO';
		}
		console.log("Created PlateEntryWidget: id"+this.id);
	},
	statusMsg:'',
	priceFormated:'R$ 0,00',
	postMixInProperties: function(){
        if (dijit.byId(this.id)) {
            dijit.byId(this.id).destroyRecursive();
        }
    },

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);		

	},
	destroyRecursive : function() {
		dojo.forEach(this.getDescendants(), function(widget) {

			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	plate:null,
	headerNode:null,
	resultsNode:null,
	uploader:null,
	fileMask :[
	        	["Jpeg File", 	"*.jpg;*.jpeg"],
	        	["GIF File", 	"*.gif"],
	        	["PNG File", 	"*.png"],
	        	["All Images", 	"*.jpg;*.jpeg;*.gif;*.png"]
	        ],
	f0:null,
	doUpload:function(){
		console.log("doUpload")		
		this.f0.upload();
	},
	
	button:null,
	sendImage:null,
	uploaded:function(pid,imgUrl,newFormAction){
		com.copacabana.util.hideLoading();
		if(this.plate.id==pid){
			this.plate.imageUrl=imgUrl;
			dojo.empty(this.imageSection);
			dojo.create('img',{src:this.plate.imageUrl,style:{maxHeight:'300px',maxWidth:'300px'}},this.imageSection);
			
		}
		formAction=newFormAction;
		this.updateUIforExistingImage();
	},
	submitXhr:function(){
		com.copacabana.util.showLoading();
		this.photoForm.action=formAction;
		dojo.subscribe('imageUploaded',dojo.hitch(this,this.uploaded));
    	this.photoForm.submit();
//		var xhrArgs = {
//				form: this.photoForm,			
//				handleAs : "text",
//				sync:true,
//				
//				load : dojo.hitch(this, this.returnData),
//				error : function(error) {
//					console.error(error)
//				}
//			}
//			var deferred = dojo.xhrPost(xhrArgs);
	},
	returnData:function(data){
		console.log(data);
	},
	deleteImageAction:function(){
		var xhrArgs = {
				url:'/deletePlateImage?pid='+this.plate.id,	
				handleAs : "text",				
				load : dojo.hitch(this, this.deleteImage),
				error : function(error) {
					console.error(error)
				}
		}
	var deferred = dojo.xhrGet(xhrArgs);
		
	},
	deleteImage:function(data){
		this.updateUIforNonExistingImage();
		
	},
	deleteImgBtn:null,
	updateUIforExistingImage:function(){
		this.button.setLabel("Editar imagem");
		if(this.deleteImgBtn==null){
		this.deleteImgBtn = new dijit.form.Button({
			label: "Remover Imagem",
			baseClass:"orangeButton",
			onClick:dojo.hitch(this,this.deleteImageAction)
		},
		dojo.create('div',{},this.imageForm,'first'));
		}else{
			dojo.style(this.deleteImgBtn.domNode,'display','block');
		}
		dojo.empty(this.imageSection);
		dojo.create('img',{src:this.plate.imageUrl,style:{maxHeight:'300px',maxWidth:'300px'}},this.imageSection);
		

	},
	updateUIforNonExistingImage:function(){
		this.button.setLabel("Adicionar imagem");
		console.log(this.deleteImgBtn);
		if(this.deleteImgBtn!=null){
			dojo.style(this.deleteImgBtn.domNode,'display','none');
			console.log('destruindo o delete btn');
			//this.deleteImgBtn.destroy();
		}
		dojo.empty(this.imageSection);

	},
	startup : function() {
		try {
			
			dojo.parser.parse(this.domNode);
			
			
			this.button = new dijit.form.Button({
	            label: "",
	            baseClass:"orangeButton",
	            onClick:dojo.hitch(this,function(){
	            	dojo.style(this.imageForm,'display','block');
	            	dojo.style(this.button,'display','none');
	            })
	        },
	        this.btn0);
			
			
			
			this.sendImage = new dijit.form.Button({
	            label: "Enviar",
	            baseClass:"orangeButton",
	            onClick:dojo.hitch(this,function(){
	            	this.submitXhr();
	            	//dojo.style(this.imageForm,'display','block');
	            })
	        },
	        this.sendImageBtn);

			if(this.plate.imageUrl!=null && this.plate.imageUrl!=''){
				this.updateUIforExistingImage();
			}else{
				this.updateUIforNonExistingImage();
			}
			
			
			var showExtensions = new dijit.form.Button({
	            label: "Editar opções",
	            baseClass:"orangeButton",
	            onClick:dojo.hitch(this,function(){
	            	var state = dojo.style(this.extensionsSection,'display');
	            	if(state=='block'){
	            		dojo.style(this.extensionsSection,'display','none');
	            	}else{
	            		dojo.style(this.extensionsSection,'display','block');
	            	}
	            		            	
	            })
	        },
	        this.showExtensionsBtn);
			
			var addNewExtensionsBtn = new dijit.form.Button({
	            label: "+ adicionar",
	            baseClass:"orangeButton",
	            onClick:dojo.hitch(this,function(){
	            	dojo.publish('addNewPlateOption',[this.plate.id,this.plate.name,{foodCategory:this.plate.foodCategory}]);
	            		            	
	            })
	        },
	        this.addNewExtensionsBtn);
			
			if(this.options){
				dojo.empty(this.extensionsList);
				dojo.subscribe('onEditPlateOption',dojo.hitch(this,this.onEditPlateOption));
				var table= dojo.create('table',{style:{width: '90%',border:'1px solid',margin:'5px',padding:'5px'}},this.extensionsList);
				var th = dojo.create('tr',{},table);
				dojo.create('th',{innerHTML:'Nome'},th);
				dojo.create('th',{innerHTML:'Preço'},th);
				dojo.create('th',{innerHTML:''},th);
				for ( var i = 0; i < this.options.length; i++) {
					var opt = this.options[i];
					var tr = dojo.create('tr',{},table);
					
					var priceFmted=com.copacabana.util.moneyFormatter(opt.price);
					dojo.create('td',{innerHTML:opt.title},tr);
					dojo.create('td',{innerHTML:priceFmted},tr);
					var td = dojo.create('td',{},tr);
					
					
					var editOptBtn = new dijit.form.Button({
			            label: "Editar",
			            baseClass:"orangeButton",
			            plateId:opt.id,
			            onClick:function(){
			            	console.log('this '+this.plateId)
			            	dojo.publish("onEditPlateOption",[this.plateId]);			            		            	
			            }
			        },
			        dojo.create('div',{},td));
					dojo.create('span',{innerHTML:' '},td)
					var deleteOptBtn = new dijit.form.Button({
			            label: "Apagar",
			            baseClass:"orangeButton",
			            plateId:opt.id,
			            onClick:function(){			            	
			            	dojo.publish("onDeletePlateOption",[this.plateId]);			            		            	
			            }
			        },
			        dojo.create('div',{},td));
					
					//dojo.create('div',{style:{cursor:'pointer'},onclick:'dojo.publish("onEditPlateOption",[\''+opt.id+'\'])',innerHTML:'Editar'},td)
					
					
					
				}				
			}
			
//			if(this.plate.sideDishes && this.plate.sideDishes.length>0){
//				var div = dojo.query(".acompanhamentos",this.domNode)[0];
//				var title = document.createElement("h3");
//				title.innerHTML="Acompanhamentos";
//				div.appendChild(title);
//				var table = document.createElement("table");
//				var tr = document.createElement("tr");
//				var th1 = document.createElement("th");
//				th1.innerHTML="Tipo";
//				var th2 = document.createElement("th");
//				th2.innerHTML="Quantidade";
//				var th3 = document.createElement("th");
//				th3.innerHTML="Descri&ccedil;&atilde;";
//				
//				tr.appendChild(th1);
//				tr.appendChild(th2);
//				tr.appendChild(th3);
//				table.appendChild(tr);
//				for ( var i = 0; i < this.plate.sideDishes.length; i++) {
//					var sd = this.plate.sideDishes[i];
//					var tri = document.createElement("tr");
//					var td1 = document.createElement("td");
//					var td2 = document.createElement("td");
//					var td3 = document.createElement("td");
//					td1.innerHTML="aaa";
//					td2.innerHTML="bbb";
//					td3.innerHTML="c";
//					tri.appendChild(td1);
//					tri.appendChild(td2);
//					tri.appendChild(td3);
//					table.appendChild(tri);
//					
//				}
//				div.appendChild(table);
//			}
			
//			this.headerNode = dojo.query(".resultadoMensagem",this.domNode)[0];
//			this.resultsNode = dojo.query(".resultsList",this.domNode)[0];
//			this.imageNode =  document.createElement('img');
//			this.imageNode.src = dojo.moduleUrl("com.copacabana", "images/loader.gif");
//			this.imageNode.alt="executing search";
//			this.imageNode.title="executing search";
			
		} catch (e) {
			console.error("plateEntry 01 ",e);
		}
	},
	onEditPlateOption:function(id){
		for ( var i = 0; i < this.options.length; i++) {
			var opt = this.options[i];
			if(opt.id==id){
				dojo.publish("addNewPlateOption",[this.plate.id,this.plate.title,opt]);
			}
		}
	},
	onClick:function(evt){		
		dojo.publish("editPlate",[this.plate]);
		dojo.parser.parse(this.domNode);			

	}
	/*onMouseEnter:function(evt){
		console.log("enter");
		var panel = dojo.query(".panel",this.domNode)[0];
		dojo.style(panel,"backgroundColor","silver");
		
		dojo.parser.parse(this.domNode);			

	},
	onMouseOut:function(evt){
		console.log("ount");
		var panel = dojo.query(".panel",this.domNode)[0];
		dojo.style(panel,"backgroundColor","white");
	}*/
});

}
