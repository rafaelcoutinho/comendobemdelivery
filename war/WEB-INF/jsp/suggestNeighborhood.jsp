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
<title>Comendo Bem - Sugerir novo bairro</title>


<link href="/styles/main/pedido.css" type="text/css" rel="stylesheet" />
<link href="/styles/user/login.css" type="text/css" rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/main/pedido_ie_7.css" type="text/css"
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

var sendSuggestion = function(event) {
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
		dojo.byId('nameForm').value=dijit.byId('name').attr('value');
		dojo.byId('emailForm').value=dijit.byId('email').attr('value');
		dojo.byId('msgForm').value='\ncity:'+dijit.byId('city').attr('value')+'\n<br> neigh:'+dijit.byId('neigh').attr('value')
										+'\n<br> rest:'+dijit.byId('restName').attr('value')
										+'\n<br> receiveEmail:'+dijit.byId('receiveNewsletter').attr('value');
		
		var xhrArgs = {
			form : dojo.byId("messageForm"),
			handleAs : "text",
			load : function(data) {
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg("Obrigado. Iremos procurar restaurantes parceiros que atendam o seu bairro." );
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
	

	<h2>N&atilde;o encontrou seu bairro ou restaurante de
	prefer&ecirc;ncia no ComendoBem?</h2>

	<p>N&oacute;s do ComendoBem estamos sempre procurando aumentar a
	nossa &aacute;rea de atua&ccedil;&atilde;o. Para isso procuramos
	parcerias com restaurantes que atendam os bairros de nossos clientes.<br />
	Se voc&ecirc; n&atilde;o encontrou o restaurante de sua
	prefer&ecirc;ncia ou o seu bairro no nosso site nos informe e iremos
	prontamente procurar restaurantes que atuem em sua &aacute;rea.</p>
	<br />
	Por favor preencha o formul&aacute;rio abaixo para podermos melhorar
	ainda mais nosso servi&ccedil;o:<br />
	<br />
	<table align="center">
		<tr>

			<td>Nome:</td>
			<td><input type="text" class="mandatory" name="name"
				
				dojoType="dijit.form.ValidationTextBox" required="true" id="name" />
			</td><td><span class="required">*</span></td>
		</tr>
		<tr>

			<td>E-mail:</td>
			<td><input type="text" class="mandatory" name="email"
				
				dojoType="dijit.form.ValidationTextBox" required="true" id="email" regExpGen="com.copacabana.util.emailFormat" trim="true" />
			</td><td><span class="required">*</span></td>
		</tr>
		<tr>

			<td>Cidade:</td>
			<td><input type="text" class="mandatory" name="city"
				
				dojoType="dijit.form.ValidationTextBox" required="true" id="city" />
			</td><td><span class="required">*</span></td>
		</tr>
		<tr>

			<td>Nome do bairro onde mora:</td>
			<td><input type="text" class="mandatory" name="neigh"				
				dojoType="dijit.form.ValidationTextBox"  id="neigh" />
			</td><td><span class="required">*</span></td>
		</tr>
		<tr><td>
			Nome do restaurante de sua prefer&ecirc;ncia:
			</td>
			<td><input type="text" class="mandatory" name="neigh"
				
				dojoType="dijit.form.ValidationTextBox" 
				id="restName" /> </td><td><span class="required"></span></td>

		</tr>
		<tr>
			<td colspan="3"><input type="checkbox" name="receiveNewsletter"
				id="receiveNewsletter" dojoType="dijit.form.CheckBox" value="on"
				checked="checked" /> Desejo receber por e-mail informações sobre o
			Comendo Bem</td>
		</tr>
		<tr>
			<td colspan="3">
			<button dojoType="dijit.form.Button" type="submit"
				baseClass="orangeButton" dojoAttachEvent="onclick:sendSuggestion"
				onclick="sendSuggestion()">Enviar</button>
			</td>
		</tr>
	</table>
	<form id="messageForm" method="post" action="/sendContact.do"><input
		type="hidden" name="name" id="nameForm" /> <input type="hidden"
		name="email" id="emailForm" /> <input type="hidden" name="msg"
		id="msgForm" /></form>
	<br clear="all" />
	<br clear="all" />
	<br clear="all" />
	</div>


</cb:body>
</html>