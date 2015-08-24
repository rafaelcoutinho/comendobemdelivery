/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.central.OrderDetailsWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.central.OrderDetailsWidget"] = true;
dojo.provide("com.copacabana.central.OrderDetailsWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");

//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana.central", "OrderDetailsStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.central.OrderDetailsWidget", [
		dijit._Widget, dijit._Templated ], {
	i18nStrings: null,
	templateString:"\r\n<div>\r\n<div style=\"float: right\">Tempo decorrido:<b>??:??</b> H:M</div>\r\n<div>Pedido Número: <span dojoAttachPoint=\"orderNumber\"></span>100.110</div>\r\n<div style=\"border-top: 1px solid black;\">Cliente: Rafael Coutinho\r\n(3/4)<br />\r\nTelefone: 2121-0788 - CPF: 045432966-05</div>\r\n<div style=\"border-top: 1px solid black;\">Endereço de entrega:<br />\r\nRua Tiradentes, 426, apto 92, Campinas<br>\r\nTelefone: 19 8111-1172</div>\r\n<div style=\"border-top: 1px solid black;\">Pagamento: Dinheiro -\r\nTroco para R$ 45,00</div>\r\n<div style=\"border-top: 1px solid black;\">Pedido:<br />\r\n<table>\r\n\t<tr>\r\n\t\t<th>Nome</th>\r\n\t\t<th>Qtd</th>\r\n\t\t<th>Valor</th>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td>Filet ao molho madeira</td>\r\n\t\t<td>1</td>\r\n\t\t<td>R$ 25,00</td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td>Coco cola 2lts</td>\r\n\t\t<td>1</td>\r\n\t\t<td>R$ 5,00</td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td colspan=\"2\" style=\"text-align: right;\">Taxa entrega</td>\r\n\t\t<td>R$ 6,00</td>\r\n\t</tr>\r\n\t<tr>\r\n\t\t<td colspan=\"2\" style=\"text-align: right;\">Total</td>\r\n\t\t<td>R$ 36,00</td>\r\n\t</tr>\r\n</table>\r\n<br>\r\n<div>Observação: 'Filet ao ponto'</div>\r\n</div>\r\n<div style=\"margin: 12px; text-align: right;\">\r\n<button class=\"changeToNextStatus\" dojoType=\"dijit.form.Button\"\r\n\tbaseClass=\"orangeButton\">Confirmar</button>\r\n<button class=\"changeToNextStatus\" dojoType=\"dijit.form.Button\"\r\n\tbaseClass=\"orangeButton\">Cancelar</button>\r\n</div>\r\n</div>\r\n",
	constructor : function() {		
	},
	 destroyRecursive: function(){
        dojo.forEach(this.getDescendants(), function(widget){
         
        	widget.destroyRecursive();
        });
        this.inherited(arguments);
    },
   
	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.central", "OrderDetailsStrings");
	},
	getLabel:function(){
		return "Pedido número 1231231";
		
	},
	
	startup : function() {
		try {
			dojo.parser.parse(this.domNode);
			this.orderNumber="aaa"+this.id;
		} catch (e) {
			console.error(e);
		}
	}

});

}
