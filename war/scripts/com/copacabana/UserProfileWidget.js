dojo.provide("com.copacabana.UserProfileWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.TooltipDialog");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.Cripter");
dojo.require("dojo.cookie");

dojo.declare("com.copacabana.UserProfileWidget", [ dijit._Widget,
		dijit._Templated ],
			{
		i18nString : null,
		title : "",
		url : null,
		templatePath : dojo.moduleUrl("com.copacabana",
		"templates/login.html"),
		constructor : function() {
		try{
			if(loggedUser){
				this.templatePath= dojo.moduleUrl("com.copacabana",	"templates/logged.html");
			}
			if(undefined != registeringPage && registeringPage===true){
				this.templatePath= dojo.moduleUrl("com.copacabana",	"templates/registerLogin.html");
				this.isRegistering=true;
			}
		}catch(e){}
	},
	isRegistering:false,
	checktoremember:function(evt){
		if (evt.keyCode == dojo.keys.ENTER) {				
			dijit.byId('lembrete').onExecute(evt);
		}
		return false;
	},
	
	checktosubmit:function(evt){
		if (evt) {
			// Stop the submit event since we want to control form submission.
			evt.preventDefault();
			evt.stopPropagation();
			dojo.stopEvent(evt);
		}
		if (evt.keyCode == dojo.keys.ENTER) {				
			this.executeLogin(evt);
		}
		return false;
	
	},
	
	successLogin: function(response) {		
		this.logging=false;

		var panel = dojo.query(".loginMsgs",this.domNode)[0];
		com.copacabana.util.cleanNode(panel);
		
		if(response.status==true){
			panel.innerHTML="Ok! Aguarde...";
			dojo.cookie("lastCBUser",dijit.byId('username').attr('value'), {
	            expires: 30
	        });
			if(this.forwardPage!=null && this.forwardPage!=""){
				window.location=this.forwardPage;
			}else{
				if (response.sessionBean.userType == "restaurant") {
					dojo.publish('onLoggedIn',['Restaurant']);
					window.location = "/restaurantPortal.jsp";
				} else if(response.sessionBean.userType == "central"){
					window.location = "/centralPortal.jsp";
				}else{					
					if(this.isRegistering==true){
						window.location = "/clientPortal.jsp";
					}else{
						dojo.publish('onLoggedIn',['Client',response.sessionBean.entity]);
						dojo.empty(this.domNode);
						if(response.moreInfo.pendingOrders>0 ){
							dojo.create("p",{innerHTML:'Bem vindo '+response.sessionBean.entity.name},this.domNode);
							dojo.create("div",{innerHTML:"Voc&ecirc; possui pedidos em execu&ccedil;&atilde;o."},this.domNode);
							dojo.create("a",{href:"/meusPedidos.do",innerHTML:"Veja aqui"},this.domNode);

						}else{
							//just replace the login template
							
													
							dojo.create("p",{innerHTML:'Bem vindo '+response.sessionBean.entity.name},this.domNode);
							dojo.create("div",{innerHTML:response.moreInfo.cbNews},this.domNode)

						}
					}
				}
			}
		}else{			
			if(response.authStatus=='OAUTH_FB'){
				var res = confirm("Sua conta está associada ao Facebook.\nUtilize o acesso via Facebook.\nVocê deseja definir uma senha para acessar sem sua conta do Facebook?");
				console.log(res);
				if(res=='YES' || res==true){				
					var uname = dijit.byNode(dojo.query(".username",this.domNode)[0]).attr('value');
					uname=dojo.string.trim(uname);				
					var success= function(response) {				
						alert("Um email foi enviado para você com as instruções para gerar sua senha.");
					};
					var err = function(response) {
						alert("Usuário não encontrado. Por favor, verifique seu email cadastrado.");
					}
					
					com.copacabana.util.startPasswordRegen(uname,success,err);
				}
				
			}else{
				if(!response.sessionId || response.sessionId==sessionId){
					panel.innerHTML="Por favor, verifique seu usu&aacute;rio e senha.";
				}else{				
					panel.innerHTML="Sess&atilde;o expirada recarregando...";
					sessionId = response.sessionId;
					this.executeLogin(null);
				}
			}
			
			
		}
	},
	postMixInProperties : function() {
		this.inherited(arguments);
	},
	textNode : null,
	imageNode : null,
	postCreate : function() {
		this.inherited(arguments);
		dojo.parser.parse(this.domNode);
	
	},
	linkNode:null,
	startup : function() {
		
		if(loggedUser){
			var dom = dojo.query(".loggedContent",this.domNode)[0];
			var text = document.createTextNode("Bem vindo "+loggedUser.entity.name);
			dom.appendChild(text);
	
			//this.loadInterestingInfo();
	
		}else{
			dojo.connect(dijit.byId('loginbtn'), "onClick", this, "executeLogin");
			var lembrete = dijit.byId('lembrete');
			dojo.connect(lembrete, "onExecute", this, "executeReminder");
			dojo.connect(dijit.byId('passwordFake'), "onKeyUp", this, "checktosubmit");
			dojo.connect(dijit.byId('username'), "onKeyUp", this, "checktosubmit");
	
			dojo.connect(dijit.byId('email'), "onKeyUp", this, "checktoremember");
	
	
			this.imageNode =  document.createElement('img');
			this.imageNode.src = dojo.moduleUrl("com.copacabana", "images/smallOrangeGrayLoader.gif");
			this.imageNode.alt="autenticando";
			this.imageNode.title="autenticando";
			var cbLogin = dojo.cookie("lastCBUser");
			if(cbLogin && cbLogin!=""){
				dijit.byId('username').attr('value',cbLogin);
			}
		}
	
	
	},
	imageNode:null,
	addInfo:function(response){
		var dom = dojo.query(".loggedContent",this.domNode)[0];
		dom.appendChild(document.createElement("br"));
		var p = document.createElement("p");
		p.appendChild(document.createTextNode("Pedidos recentes:"));
		dom.appendChild(p);
		var ul = document.createElement("ul");
		for ( var i = 0; i < response.latestOrders.length; i++) {
			var order = response.latestOrders[i];
			var li = document.createElement("li");
			li.appendChild(document.createTextNode(order.status+": "+order.orderedTime));
			ul.appendChild(li);
		}				
		dom.appendChild(ul);
	
	},
	loadInterestingInfo:function(){
		var xhrArgs = {
				url: 'retrieveUserNews.do',
				handleAs: "json",
				load : dojo.hitch(this,this.addInfo),
				error: dojo.hitch(this,function(response) {
					console.log(response);
				})
		};
		//
		var deferred = dojo.xhrPost(xhrArgs);
	},
	forwardPage:null,
	logging:false,
	counter:0,
	MAXTRIES:3,
	executeLogin:function(event){
		if (event) {
			// Stop the submit event since we want to control form submission.
			event.preventDefault();
			event.stopPropagation();
			dojo.stopEvent(event);
		}
		if (!com.copacabana.util.checkValidFormAdv(".mandatory",this.domNode)) {
			return false;
		} else {
			var panel = dojo.query(".loginMsgs",this.domNode)[0];
			com.copacabana.util.cleanNode(panel);				
			panel.appendChild(this.imageNode);
			if(this.logging===false){
				this.logging=true;
				//this is not perfect but good
				var pwdDijit = dijit.byNode(dojo.query(".password",this.domNode)[0]);
				var pwd=pwdDijit.attr('value')+"|"+sessionId;
				
				
				dijit.byNode(dojo.query(".passwordHidden",this.domNode)[0]).attr('value',new com.copacabana.Cripter().encode(pwd));
				var uname = dijit.byNode(dojo.query(".username",this.domNode)[0]).attr('value');
				uname=dojo.string.trim(uname);
				dijit.byNode(dojo.query(".username",this.domNode)[0]).attr('value',uname);
				dijit.byNode(dojo.query(".usernameHidden",this.domNode)[0]).attr('value',uname);
				var panel = dojo.query(".loginMsgs",this.domNode)[0];
				var err = function(response){
					panel.innerHTML="Problemas no servidor, por favor tente novamente.";
				}
				com.copacabana.util.executeLogin(uname,pwd,false,null,dojo.hitch(this,this.successLogin),err);
				
			}
			return false;
		}
	
	},
	executeReminder:function(event){
	
		var xhrArgs = {
				form: dojo.byId("lembreteForm"),
				handleAs: "text",
				load : dojo.hitch(this,function(response) {
					var panel = dojo.query(".loginMsgs",this.domNode)[0];
					panel.innerHTML="Um email foi enviado para voc&ecirc; com sua senha.";
				}),
				error: dojo.hitch(this,function(response) {
					console.error('error to execute remider.',response);
					var panel = dojo.query(".loginMsgs",this.domNode)[0];
					panel.innerHTML="Usu&aacute;rio n&atilde;o encontrado. Por favor, verifique seu email cadastrado.";
				})
		};
		//
		var deferred = dojo.xhrPost(xhrArgs);
		return false;
	}
			
});