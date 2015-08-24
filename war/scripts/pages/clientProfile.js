dojo.require("dijit.form.ValidationTextBox");
dojo.require("dojox.validate.regexp");
dojo.require("dojo.parser");
dojo.require("dojox.form.PasswordValidator");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.MessageWidget");
dojo.require("com.copacabana.util");
dojo.addOnLoad(function() {
	prepareForm();
});

function prepareForm() {
	var button = dijit.byId("submitButton");

	dojo.connect(button, "onClick", submitForm);	
	if (id) {

		loadFormEntiy("/getClient.do?id=" + id, "dadosUsuario");
	}
}
var submitForm = function(event) {
	if (!com.copacabana.util.checkValidForm()) {
		return;
	} else {
		if (event) {
			// Stop the submit event since we want to control form submission.
			event.preventDefault();
			event.stopPropagation();
		}
		com.copacabana.util.showLoading();
		// The parameters to pass to xhrPost, the form, how to handle it, and
		// the callbacks.
		// Note that there isn't a url passed. xhrPost will extract the url to
		// call from the form's
		// 'action' attribute. You could also leave off the action attribute and
		// set the url of the xhrPost object
		// either should work.
		console.log(dijit.byId('receiveNewsletter').attr('value'));
		if(dijit.byId('receiveNewsletter').attr('value')==false){
			dojo.byId('receiveNewsletter').value='off';
		}
		
		var xhrArgs = {
			form : dijit.byId("dadosUsuario").domNode,
			handleAs : "text",
			load : function(data) {
				
				var entity = dojo.fromJson(data);
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg("Dados salvos.");
			},
			error : function(error) {
				// We'll 404 in the demo, but that's okay. We don't have a
				// 'postIt' service on the
			// docs server.
			console.log("failed to post data." + error);
			com.copacabana.util.hideLoading();
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Erro ao salvar dados: " + error.responseText);
		}
		}
		// Call the asynchronous xhrPost
		
		var deferred = dojo.xhrPost(xhrArgs);
	}
}
function loadFormEntiy(url, content, formId) {
	com.copacabana.util.showLoading();
	var xhrArgs = {
		url : url,
		content : content,
		handleAs : "text",
		load : function(data) {
			var entity = dojo.fromJson(data);
			try {
				if (entity.birthday) {
					var d = new Date();
					d.setYear(parseInt(entity.birthday.split('/')[2]));
					d.setMonth(parseInt(entity.birthday.split('/')[1]) - 1);
					d.setDate(entity.birthday.split('/')[0]);
					entity.birthday = d;
				}
				if(entity.receiveNewsletter){
					dijit.byId("receiveNewslettercb").attr('value', entity.receiveNewsletter);
				}
				console.log("Rceives sim!!",entity.receiveNewsletter );
				if (entity.receiveNewsletter == true) {
					entity.receiveNewsletter = "on";
				}
				dijit.byId("dadosUsuario").attr('value', entity);
			} catch (e) {
				console.error(e);
				dijit.byId("id").attr("value", entity.id);
				dojo.byId("id").value = entity.id;
			}
			com.copacabana.util.hideLoading();

		},
		error : function(error) {
			console.error("failed to get data." + error);
			com.copacabana.util.hideLoading();
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);
}

var submitPwdChange = function() {

	var xhrArgs = {
		form : dojo.byId("changePwd"),
		handleAs : "json",
		load : function(data) {
			var entity = data;
			console.log("Form created ", data);
			// dijit.byId("pwdDialog").hide();
		dojo.byId("changePwd").reset();
		var msg = new com.copacabana.MessageWidget();
		msg.showMsg("Senha trocada.");
	},
	error : function(error) {
		// We'll 404 in the demo, but that's okay. We don't have a 'postIt'
		// service on the
		// docs server.
		console.log("Form error ", error);
		try {
			var msg = new com.copacabana.MessageWidget();
			var appError = dojo.fromJson(error.responseText);
			if (appError.errorCode == "EMPTYPWD") {
				msg.showMsg("Nova senha não deve ser em branco.");
			} else {
				if (appError.errorCode == "OLDPWDDOESNTMATCH") {
					msg.showMsg("Senha atual incorreta.");
				} else {
					msg.showMsg("Erro ao trocar senha.");
				}
			}
		} catch (e) {
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg("Erro ao trocar senha.");
		}

	}
	}
	// Call the asynchronous xhrPost
	console.log("sending");
	var deferred = dojo.xhrPost(xhrArgs);

}
var phoneChecker =function(){
	
	return "\d?\d{2} \d{3}\-\d{4}";

}
function checkCpf(){
	var cpf = dijit.byId('cpf');	
	var cpfval =dojo.string.trim(cpf.attr('value'));
	cpfval=cpfval.replace(/\s/g,'');
	cpf.attr('value',cpfval);
	if(com.copacabana.util.isCpfValid(cpf.attr('value'))==false){
		dijit.showTooltip('CPF inv&aacute;lido.', cpf.domNode);
	}else{
		dijit.hideTooltip( cpf.domNode);
	}
}