dojo.provide("com.copacabana.AddressPaneWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");

// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana", "AddressPaneWidgetStrings");

dojo.declare(
				"com.copacabana.AddressPaneWidget",
				[ dijit._Widget, dijit._Templated ],
				{
					i18nStrings : null,
					templatePath : dojo.moduleUrl("com.copacabana",
							"templates/AddressPaneWidget.html"),
					constructor : function(address, clientId) {
						this.address = address;
						this.address.name = address.street;
						if (!this.address.phone) {
							this.address.phone = "";
						}
						if (!this.address.zipCode) {
							this.address.zipCode = "";
						}
						this.clientId = clientId;

					},
					clientId : null,
					destroyRecursive : function() {
						dojo.forEach(this.getDescendants(), function(widget) {

							widget.destroyRecursive();
						});
						this.inherited(arguments);
					},
					address : null,

					postMixInProperties : function() {
						this.inherited(arguments);
					},

					postCreate : function() {
						this.inherited(arguments);
						this.i18nStrings=dojo.i18n.getLocalization("com.copacabana",
						"AddressPaneWidgetStrings");
					},

					startup : function() {
						try {
							dojo.parser.parse(this.domNode);

							this.loadCities();							
							
							dijit.byNode(dojo.query(".addressId", this.domNode)[0]).attr("value",this.address.id);
							dijit.byNode(dojo.query(".addressForm",this.domNode)[0]).attr('value', this.address);
							console.log(dijit.byNode(dojo.query(".apagar",this.domNode)[0]));
							dojo.connect(dijit.byNode(dojo.query(".apagar",this.domNode)[0]), "onClick", dojo.hitch(this,this.deleteAddress));
							
							dojo.connect(dijit.byNode(dojo.query(".persist",this.domNode)[0]), "onClick", dojo.hitch(this,this.createAddress));
							
							
						} catch (e) {
							console.error('error starting up address',e);
						}
					},
					allNeighbors:null,
					loadNeighborhood : function() {
						if(this.allNeighbors==null){
							this.allNeighbors = new dojo.data.ItemFileReadStore( {
								url : "/listNeighborsItemFileReadStore.do"
							});	
						}
						dijit.byNode(dojo
								.query(".neighSelection", this.domNode)[0]).store = this.allNeighbors;

					},
					allCitiesStore:null,
					loadCities : function() {
						
						try {
							if(this.allCitiesStore==null){
								this.allCitiesStore= new dojo.data.ItemFileReadStore( {
									url : "/listCitiesItemFileReadStore.do"
								});
							}
							dijit.byNode(dojo.query(".citySelection",this.domNode)[0]).store = this.allCitiesStore;
							dojo.connect(dijit.byNode(dojo.query(".citySelection", this.domNode)[0]),"onChange", dojo.hitch(this,this.onCityUpdate));
							console.log("setting city:" + this.address.neighborhood.city.id);
							dijit.byNode(dojo.query(".citySelection",this.domNode)[0]).attr("value", this.address.neighborhood.city.id);
							dijit.byNode(dojo.query(".neighSelection",this.domNode)[0]).attr("value", this.address.neighborhood.id);
						} catch (e) {
							console.error('error loading cities',e);
						}
					},
					onCityUpdate : function() {
						try {
							var citySelected=dijit.byNode(
									dojo.query(".citySelection",
											this.domNode)[0]).attr(
									"value");
							if(citySelected){
								var stateStore = new dojo.data.ItemFileReadStore( {
									url : "/listNeighborsByCity.do?key="
											+ citySelected
								});
	
								dijit
										.byNode(
												dojo.query(".neighSelection",
														this.domNode)[0]).reset();
								dijit.byNode(dojo.query(".neighSelection",
										this.domNode)[0]).store = stateStore;
								if (this.startingYet === true) {
									dijit.byNode(
											dojo.query(".neighSelection",
													this.domNode)[0]).attr("value",
											this.address.neighborhood.id);
									this.startingYet = false;
								}
							}
						} catch (e) {
							console.error('Error on city update',e);
						}
					},
					startingYet : true,
					updateData : function(data) {
						this.address.name = data.street;
						this.address.id = data.id;
						dojo.query(".addressTitle", this.domNode)[0].innerHTML = this.address.name;
						dijit.byNode(dojo.query(".addressId", this.domNode)[0]).attr("value", data.id);
					},
					createAddress : function() {
						if(!com.copacabana.util.checkValidForm(".required")){				
			    	  		return;
			    	  	}
						com.copacabana.util.showLoading();
						var fct = function(data) {
							com.copacabana.util.hideLoading();
							var entity = data;							
							this.updateData(data);
						}
						if (this.address.id && this.address.id != "") {							
							fct = function(data) {
								com.copacabana.util.hideLoading();
								var entity = data;								
								this.updateData(data);

							}
						}

						var xhrArgs = {
							form : dojo.query(".addressForm", this.domNode)[0],
							handleAs : "json",
							load : dojo.hitch(this, fct),
							error : function(error) {
								com.copacabana.util.hideLoading();
								var msg = new com.copacabana.MessageWidget();
		                     	msg.showMsg("Erro ao salvar endere&ccedil;o. Por favor tente novamente");
								console.log("Form error ", error);
							}
						};
						// Call the asynchronous xhrPost
						console.log("sending");
						var deferred = dojo.xhrPost(xhrArgs);
					},
					updateUser : function(data) {
						var form = dojo.query(".updateUserForm", this.domNode)[0];// dojo.byId("updateUserForm")
						if (this.userNode != null) {
							form.removeChild(this.userNode);
						}
						if (this.addressIdNode != null) {
							form.removeChild(this.addressIdNode);
						}
						com.copacabana.util.showLoading();
						this.userNode = document.createElement("input");
						this.userNode.setAttribute("name", "id");
						this.userNode.setAttribute("value", this.clientId);
						this.userNode.setAttribute("type", "hidden");
						form.appendChild(this.userNode);
						this.addressIdNode = document.createElement("input");
						this.addressIdNode.setAttribute("name",
								"addresses[0].k");
						this.addressIdNode.setAttribute("value", data.id);
						this.addressIdNode.setAttribute("type", "hidden");
						form.appendChild(this.addressIdNode);

						var xhrArgs = {
							form : form,
							handleAs : "text",
							load : dojo.hitch(this, function(data) {
								console.log('updated');
								com.copacabana.util.hideLoading();
								var entity = data;

							}),
							error : function(error) {
								// We'll 404 in the demo, but that's okay. We
							// don't have a 'postIt' service on the
							// docs server.
							com.copacabana.util.hideLoading();
							console.log("Form error ", error);
						}
						};
						// Call the asynchronous xhrPost
						console.log("sending");
						var deferred = dojo.xhrPost(xhrArgs);
					},
					deleteNode : null,
					deleteAddress : function(event){
						if (event) {
							// Stop the submit event since we want to control form submission.
							event.preventDefault();
							event.stopPropagation();
							dojo.stopEvent(event);
						}
						if(this.address.id==null || this.address.id==""){
							this.domNode.innerHTML = "";
							return;
						}
						com.copacabana.util.showLoading();
						var form = dojo
								.query(".deleteAddresForm", this.domNode)[0];// dojo.byId("updateUserForm")
						if (this.deleteNode != null) {
							form.removeChild(this.deleteNode);
						}
						this.deleteNode = document.createElement("input");
						this.deleteNode.setAttribute("name", "id");
						this.deleteNode.setAttribute("value", this.address.id);
						this.deleteNode.setAttribute("type", "hidden");
						form.appendChild(this.deleteNode);

						var xhrArgs = {
							form : form,
							handleAs : "text",
							load : dojo.hitch(this, function(data) {
								com.copacabana.util.hideLoading();
								var entity = data;
								this.domNode.innerHTML = "";
							}),
							error : function(error) {
								com.copacabana.util.hideLoading();
								// We'll 404 in the demo, but that's okay. We
							// don't have a 'postIt' service on the
							// docs server.
							console.log("Form error ", error);
						}
						};
						// Call the asynchronous xhrPost
						console.log("sending");
						var deferred = dojo.xhrPost(xhrArgs);
					}

				});
