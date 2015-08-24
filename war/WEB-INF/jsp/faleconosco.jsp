<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>


<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta name="description"
	content="ComendoBem.com.br - Fale conosco. Entre em contato com nossa equipe." />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Comendo Bem - Fale conosco</title>

<link href="../../styles/main/main_restaurante.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/main/pedido.css" type="text/css"
	rel="stylesheet" />
	<link href="../../styles/user/login.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/main/pedido_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html"%>
<script>
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dojo.parser");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.SimpleTextarea");
dojo.require("dijit.InlineEditBox");
dojo.require("dojo.parser");
dojo.require("com.copacabana.util");
dojo.require("com.copacabana.MessageWidget");


var dlg;
dojo.addOnLoad(function() {
	
});
var submitForm = function(event) {
	if (!com.copacabana.util.checkValidForm()) {
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
			form : dojo.byId("msgForm"),
			handleAs : "text",
			load : function(data) {
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg("Mensagem enviada com sucesso. Logo retornaremos sua mensagem. Obrigado." );
			},
			error : function(error) {				
				com.copacabana.util.hideLoading();
					var msg = new com.copacabana.MessageWidget();
					msg.showMsg("Erro ao enviar mensagem. Por favor envie novamente.");
				
			}
		}
		// Call the asynchronous xhrPost
				
				//dlg.show();
		var deferred = dojo.xhrPost(xhrArgs);
	}
}
</script>
<cb:header />
</head>
<cb:body closedMenu="true">

	<div id="conteudo_main" class="fundoTelaEstatica">
	<div style="margin: 10px 10px 10px 10px; width: 440px;" >
	
	<h2>Fale conosco</h2>
	
	<p>Use o formul&aacute;rio abaixo para nos contactar ou envie uma
	mensagem direto para nosso e-mail  '<a
		href="mailto:contato@comendobem.com.br">contato@comendobem.com.br</a>'.</p>
	<form id="msgForm" method="post" dojoType="dijit.form.Form"
		action="/sendContact.do">
	
	Nome: <input type="text" 
				class="mandatory" name="name" style="text-align: left;margin-left:10px;margin-bottom: 4px;"
				dojoType="dijit.form.ValidationTextBox" required="true" /> <span
				class="required">*</span><br/>
				E-mail: <input type="text" 
				class="mandatory"  name="email" style="text-align: left;margin-left:6px;margin-bottom: 4px;" regExpGen="com.copacabana.util.emailFormat" trim="true"
				dojoType="dijit.form.ValidationTextBox" required="true" /> <span class="required">*</span><br/>
				Mensagem:<br/>
				<textarea style="margin-left:20px " dojoType="dijit.form.SimpleTextarea" name="msg" id="msg" rows=3 cols=30></textarea>
			 <span class="required">*</span>
			
	
	
	</form><br clear="all"/>
	<br clear="all"/><br clear="all"/>
	</div>
	<div id="barraEmbaixo" class="fundoCinza"><a
		href="javascript:submitForm()" id="submitButton"> <img
		src="/resources/img/btConfirmar.png" alt="Confirmar" /> </a></div>
	
</div>
</cb:body>
</html>