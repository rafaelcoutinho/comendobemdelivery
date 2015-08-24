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
<title>Comendo Bem - Pesquisa de satisfação</title>

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
dojo.require("dijit.form.CheckBox");
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
}
</script>
<cb:header />
</head>
<cb:body closedMenu="true">

	<div id="conteudo_main" class="fundoTelaEstatica" style="height: inherit;">
	<div style="margin: 10px 10px 10px 10px;">
	
	<h2>Obrigado ${entity.mealOrder.clientName}!</h2>
	<span>A sua avaliação sobre o pedido ${entity.mealOrder.client.id.id}.${entity.mealOrder.id.id} foi registrada.</span><br/>
	<span>A sua opinião é nossa principal forma de avaliar onde e como nosso serviço deve melhorar!</span>
	<h2>Mais detalhes de sua opinião</h2>
	<p>Se desejar opine sobre pontos específicos de seu pedido respondendo às perguntas abaixo.</p>
	<form  method="post" id="form" dojoType="dijit.form.Form"	action="/pesquisaCompleta.do">
	<input type="hidden" name="feedbackId" value="${entity.f.id}">	
	Avalie o seu pedidos quanto à:<br/>
	<style>
	tbody td, tbody td input {
    text-align: right;
    vertical-align: middle;
}
	</style>
	<div style="width: 500px;">
	<table cellspacing="0" border="0">
	<tr><td>Prazo de entrega:</td><td>	
	<input type="radio" dojoType="dijit.form.RadioButton" value="5" name="deliveryTime"/><label for="statusUpdate">&oacute;timo</label>
	<input type="radio" dojoType="dijit.form.RadioButton" value="4" name="deliveryTime"/><label for="statusUpdate">bom</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="2" name="deliveryTime"/><label for="statusUpdate">ruim</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="1" name="deliveryTime"/><label for="statusUpdate">p&eacute;ssimo</label>	
	</td></tr> 
	
	<tr><td>Qualidade do prato:</td><td>
	<input type="radio" dojoType="dijit.form.RadioButton" value="5" name="foodQuality"/><label for="statusUpdate">&oacute;timo</label>
	<input type="radio" dojoType="dijit.form.RadioButton" value="4" name="foodQuality"/><label for="statusUpdate">bom</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="2" name="foodQuality"/><label for="statusUpdate">ruim</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="1" name="foodQuality"/><label for="statusUpdate">p&eacute;ssimo</label>
	
	</td></tr>
	
	<tr><td>Clareza das informações no site:</td><td>
	
	<input type="radio" dojoType="dijit.form.RadioButton" value="5" name="restaurantInfo"/><label for="statusUpdate">&oacute;timo</label>
	<input type="radio" dojoType="dijit.form.RadioButton" value="4" name="restaurantInfo"/><label for="statusUpdate">bom</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="2" name="restaurantInfo"/><label for="statusUpdate">ruim</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="1" name="restaurantInfo"/><label for="statusUpdate">p&eacute;ssimo</label>	
	
	</td></tr>
	
	<tr><td>Acompanhamento do pedido:
		</td><td>
	<input type="radio" dojoType="dijit.form.RadioButton" value="5" name="statusUpdate"/><label for="statusUpdate">&oacute;timo</label>
	<input type="radio" dojoType="dijit.form.RadioButton" value="4" name="statusUpdate"/><label for="statusUpdate">bom</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="2" name="statusUpdate"/><label for="statusUpdate">ruim</label>
	<input dojoType="dijit.form.RadioButton" type="radio" value="1" name="statusUpdate"/><label for="statusUpdate">p&eacute;ssimo</label>	
	
	</td></tr>
	<tr><td valign="top">Coment&aacute;rios:</td><td style="text-align: left;"><input dojoType="dijit.form.SimpleTextarea" name="comments"></td></tr>
	</table>

	
	
	
			
	</div>
	
	</form><br clear="all"/>
	<br clear="all"/><br clear="all"/>
	</div>
	<div id="barraEmbaixo" class="fundoCinza"><a
		href="javascript:dojo.byId('form').submit()" id="submitButton"> <img
		src="/resources/img/btSalvar.png" alt="Confirmar" /> </a></div>
	
</div>
</cb:body>
</html>