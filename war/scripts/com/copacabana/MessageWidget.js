dojo.provide("com.copacabana.MessageWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.Dialog");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.RoundedButton");

dojo.declare("com.copacabana.MessageWidget",
		[ dijit._Widget, dijit._Templated ], {
			errorType:1,
			i18nString : null,
			title : "",
			url : null,
			templatePath : dojo.moduleUrl("com.copacabana",
					"templates/MessageWidget.html"),
			constructor : function() {
			},

			postMixInProperties : function() {
				this.inherited(arguments);
			},
			textNode : null,
			dialog:null,
			postCreate : function() {
				this.inherited(arguments);
				dojo.parser.parse(this.domNode);
				//this.dialog = dijit.byId('msgDialog');				
				//this.textNode=dojo.query(".msgPlace",this.dialog.domNode)[0];
			},

			startup : function() {
			},
			callback:function(val,e){
				console.log(val,e);
			},
			
			
			promptInputCallback:function(mouseEvent,errorDialog,inputText,callbackFn) {
				var text = inputText.attr('value');				
				errorDialog.hide();
				errorDialog.destroyRecursive();
				if (window.event){
					e = window.event;
				}else{
					e=mouseEvent;
				}

				var srcEl = mouseEvent.srcElement? mouseEvent.srcElement : mouseEvent.target; //IE or Firefox
				console.log(srcEl.id,callbackFn);				
				callbackFn(text);				
			},
			
			promptInputMsg:function(question,callbackFn,title,initialValue){
				var errorDialog = this.createDialog(title);
				
				var questionDiv = dojo.create('div', { innerHTML: question });
				errorDialog.containerNode.appendChild(questionDiv);
				if(!initialValue){
					initialValue='';	
				}
				var inputText = new dijit.form.TextBox({ name: 'input' ,className:'textInput',value:initialValue});
				errorDialog.containerNode.appendChild(inputText.domNode);
				var fct = dojo.hitch(this,function(mouseEvent){
					this.promptInputCallback(mouseEvent,errorDialog,inputText,callbackFn);
				});
				var yesButton = new dijit.form.Button({ label: "Ok", id: 'ok', onClick:  fct});
				errorDialog.containerNode.appendChild(yesButton.domNode);
				errorDialog.show();
			},	
			
			promptMsg:function(question,possibleVals,callbackFn,title){
				//var errorDialog = new dijit.Dialog({ id: 'queryDialog', title: title });
				var errorDialog = this.createDialog(title);
				var callback = function(mouseEvent) {
					errorDialog.hide();
					errorDialog.destroyRecursive();
					if (window.event){
						e = window.event;
					}else{
						e=mouseEvent;
					}
					var srcEl = mouseEvent.srcElement? mouseEvent.srcElement : mouseEvent.target; //IE or Firefox
					console.log(srcEl);
					var id=srcEl.id;
					if(id=='yes_label'){
						id='yes';
					}else{
						if(id=='no_label'){
							id='no';
						}	
					}
					callbackFn( id, e);
				};
				var questionDiv = dojo.create('div', { innerHTML: question });
				errorDialog.containerNode.appendChild(questionDiv);
				for ( var i = 0; i < possibleVals.length; i++) {
					var questionItem = possibleVals[i];
					var yesButton = new dijit.form.Button({ label: questionItem.label, id: questionItem.id, onClick: callback });
					errorDialog.containerNode.appendChild(yesButton.domNode);
				}
				errorDialog.show();
			},		
			counter:0,
			createDialog:function(title){
				
				var errorDialog = new dijit.Dialog({ id: 'showMsgDialog'+(this.id), title: '',onHide:function(){this.destroyRecursive();}});

				
				return errorDialog;
			},
			showMsg:function(text,type){
				
				var errorDialog = this.createDialog('');
				var closeCallback = function(mouseEvent) {
					console.log('close',mouseEvent);
					errorDialog.hide();
					errorDialog.destroyRecursive();
				};
				var questionDiv = dojo.create('div', { innerHTML: text });
				var yesButton = new dijit.form.Button({ label: 'Ok', id: 'ok', onClick: closeCallback });
				errorDialog.containerNode.appendChild(questionDiv);
				errorDialog.containerNode.appendChild(yesButton.domNode);				
				errorDialog.show();
			

					
			},
			destroyRecursive : function() {
				try{
				console.log("destroying");
				dojo.forEach(this.getDescendants(), function(widget) {
					console.log("destroying . ",widget);
					widget.destroyRecursive();
				});
				this.inherited(arguments);
				
					this.dialog.destroy();
				}catch(e){
					
					console.error("messageW",e);
				}
			}
			

		});