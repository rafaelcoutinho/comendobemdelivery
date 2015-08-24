dojo.provide("com.copacabana.HighLightWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");

dojo.declare("com.copacabana.HighLightWidget", [ dijit._Widget,
		dijit._Templated ],
		{
			i18nString : null,
			title : "",
			url : null,
			templatePath : dojo.moduleUrl("com.copacabana",
					"templates/HighLight.html"),
			constructor : function() {
			},

			postMixInProperties : function() {
				this.inherited(arguments);
			},
			textNode : null,
			imageNode : null,
			postCreate : function() {				
				this.inherited(arguments);
				dojo.parser.parse(this.domNode);
				try{
				console.log('high');
				this.imageNode = dojo.query(".imgNode", this.domNode)[0];
				this.imageNode.src = dojo.moduleUrl("com.copacabana",
						"images/loader.gif");
				this.textNode = dojo.query(".textNode", this.domNode)[0];
				
				this.textNode.innerHTML = this.title;
				this.linkNode = dojo.query(".linkNode", this.domNode)[0];
				}catch (e) {
console.error('ee',e);
				}

			},
			failedToLoadHighlight:function(response){
				try{
					var errorData =dojo.fromJson(response.responseText);
					console.log(errorData);
					this.imageNode.style.display='none';
				}catch(e){}
			},
			linkNode:null,
			object:null,
			setContent:function(obj){
				this.object=obj;
			},
			createSection:function(objeto){
				this.imageNode.width=240;
				this.imageNode.src='';							
				this.imageNode.src = objeto.imageUrl;							
				this.imageNode.alt=objeto.imageAlt;
				this.imageNode.title=objeto.imageAlt;	
				this.linkNode.href=objeto.url;
				this.linkNode.target='_blank';
				if(objeto.title && objeto.title!=''){
					this.textNode.innerHTML =objeto.title; 
				}
				if(objeto.description && objeto.description!=''){
					dojo.query(".description", this.domNode)[0].innerHTML=objeto.description;
				}
			},
			startup : function() {
				try {
					
					if(!this.object || this.object==null){
						dojo.xhr("GET", {
							url : this.url,
							handle : 'json',
							load : dojo.hitch(this,function(response) {
								try{
									var objeto = dojo.fromJson(response);
									this.createSection(objeto);
								}catch (e) {
									// TODO: handle exception
									console.error("highlightnode",e);
									
								}
								
							}),
							error:dojo.hitch(this,"failedToLoadHighlight")
								
						});
					}
					else{
						this.createSection(this.object);
					}
				} catch (e) {
					console.error("highlight start ",e);
				}
			}
		});