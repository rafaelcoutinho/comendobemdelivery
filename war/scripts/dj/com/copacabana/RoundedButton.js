/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.RoundedButton"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.RoundedButton"] = true;
dojo.provide("com.copacabana.RoundedButton");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit._Container");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
//dojo.requireLocalization("com.copacabana", "PlatesListWidgetStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.RoundedButton", 	
		[dijit._Widget, dijit._Templated, dijit._Container], {
	//i18nStrings: dojo.i18n.getLocalization("com.copacabana", "PlatesListWidgetStrings"),
	templateString:"<div class=\"roundedInputDojo ${inputType}\" style=\"display:inline;cursor:pointer; height:${height}px;width:${width}px;\" dojoAttachEvent=\"onclick:onToolButtonClick\">\t\r\n\t<img src=\"${backgroundImage}\" height=\"${height}\" width=\"${width}\" style=\"cursor: pointer;\"/>\r\n\t<input  type=\"${inputType}\" \r\n\t\tstyle=\"height:${height}px;width:${width}px;cursor: pointer;left:${leftCss};top:${topCss}\"\r\n\t\tname=\"${inputName}\"\r\n\t\tclass=\"${cssClass}\"\r\n\t\tvalue=\"${inputValue}\" />\r\n</div>\r\n",
	constructor : function() {
	
	},
	onClickUp:function(evt){
		console.log("asdfasf");
	},
	height:20,
	leftCss:"-110px" ,
	topCss:"-5px;",
	height:20,
	width:100,
	inputType:"text",
	cssClass:"",
	inputName:"",
	inputValue:"",
	clickAction:null,
	//backgroundImage:"/resources/img/campo250px.png",
	backgroundImage:"/resources/img/botao100px.png",
	

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);	
		this.panels = dojo.query(".widgetPanel", this.domNode);
		this.panels.forEach(function(item,idx,arr){
			item.buttonIcon = dojo.attr(item, "buttonIcon");
			item.buttonText = dojo.attr(item, "buttonText");
		});

	},
	onToolButtonClick:function(evt){
		this.clickAction(evt);
	},
	
	headerNode:null,
	resultsNode:null,
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			
//			this.headerNode = dojo.query(".resultadoMensagem",this.domNode)[0];
//			this.resultsNode = dojo.query(".resultsList",this.domNode)[0];
//			this.imageNode =  document.createElement('img');
//			this.imageNode.src = dojo.moduleUrl("com.copacabana", "images/loader.gif");
//			this.imageNode.alt="executing search";
//			this.imageNode.title="executing search";
			
		} catch (e) {
console.error("rounded button start",e);
		}
	}
	
});

}
