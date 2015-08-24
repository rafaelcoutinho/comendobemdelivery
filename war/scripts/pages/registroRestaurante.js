dojo.require("dojox.form.PasswordValidator");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.MessageWidget");

var registeringPage = true;
var userCity = "${sessionScope.identifiedCity}";;

var submitForm = function(event) {
	if (!com.copacabana.util.checkValidForm(".mandatoryf")) {
		return;
	} else {
		if (event) {
			// Stop the submit event since we want to control form
			// submission.
			event.preventDefault();
			event.stopPropagation();
		}
		com.copacabana.util.showLoading();
		var xhrArgs = {
			form : dojo.byId("dadosUsuario"),
			handleAs : "text",
			load : function(data) {

				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg("Obrigado, logo entraremos em contato. ");
			},
			error : function(error) {
				try {
					var errorjson = dojo.fromJson(error.responseText);
					var msg = new com.copacabana.MessageWidget();
					msg.showMsg("Erro: Por favor tente novamente.");

				} catch (e) {
					var msg = new com.copacabana.MessageWidget();
					msg.showMsg("Erro ao salvar dados: " + error.responseText);
				}
				com.copacabana.util.hideLoading();
			}
		}
		// Call the asynchronous xhrPost

		var deferred = dojo.xhrPost(xhrArgs);
	}
}
