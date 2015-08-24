/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.HighLightWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.HighLightWidget"] = true;
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
			templateString:"<div class=\"quadrado\" \r\n\tstyle=\"overflow: hidden; color: #605D5D; font-family: verdana, arial, sans-serif; font-size: small;\">\r\n<h2><div class=\"textNode\" style=\"margin: 5px; font-size: 1em; font-weight: normal; font-family: verdana,arial,sans-serif; color: rgb(96, 93, 93);\"></div></h2>\r\n<a href=\"\" border=0 class=\"linkNode\"><img alt=\"loading...\" src=\"\" class=\"imgNode\" border=\"0\" width=\"50\"></a>\r\n<div class=\"description\"></div>\r\n</div>\r\n",
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

}
