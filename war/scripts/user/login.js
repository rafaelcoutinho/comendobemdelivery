/* ------ Requires ------ */
dojo.require("dojo.fx");
dojo.require("dojo.fx.easing");
dojo.require("comum.user");

/* ------ Funções ------ */
/**
 * Pega o CEP do campo 'zip' e busca o endereço no servidor, preenchendo os
 * campos recebidos no formulário e habilitando os campos de endereço para
 * terminar de serem preenchidos.
 */
function encontrarCEP() {
	var camposEndereco = dojo.formToObject('dadosUsuario');
	var cep = camposEndereco.zip;
	if (!cep || cep == '') {
		alert('CEP inválido: "' + cep + '"');
		return;
	}

	bloquear(dojo.byId('camposEndereco'));

	if (cep.indexOf('-') != -1)
		cep = cep.replace('-', '');

	dojo.xhr('GET', {
		url : contexto + "/getAddressByZip.do",
		load : function(response) {
			var endereco = dojo.fromJson(response);
			preencheEndereco(endereco);
			desbloquear();
		}
	});
}

/**
 * Habilita ou desabilita os campos relacionados ao endereço.
 * 
 * @param habilita
 *            {Boolean} True para habilitar, false para desabilitar.
 */
function habilitaEndereco(habilita) {
	habilitaCampo('street', habilita);
	habilitaCampo('addressNumber', habilita);
	habilitaCampo('additionalInfo', habilita);
	habilitaCampo('neighborhood', habilita);
	habilitaCampo('city', habilita);
	habilitaCampo('state', habilita);
}

function limpaCampos() {
	dojo.byId('email').value = '';
	dojo.byId('newPassword').value = '';
	dojo.byId('confirmPassword').value = '';
	dojo.byId('name').value = '';
	dojo.byId('regionCode').value = '';
	dojo.byId('phone').value = '';

	dojo.attr('receiveNewsLetter', 'checked', 'checked');

	dojo.byId('zip').value = '';
	dojo.byId('addressNumber').value = '';
	dojo.byId('additionalInfo').value = '';

	dojo.byId('street').value = '';
	dojo.byId('state').value = '';
	dojo.byId('city').value = '';
	dojo.byId('neighborhood').value = '';
}

/**
 * Preenche os campos do endereço que vieram de uma busca por CEP.
 * 
 * @param endereco
 *            {Object} O objeto com os dados.
 */
function preencheEndereco(endereco) {
	habilitaEndereco(true);

	dojo.byId('street').value = endereco.street;
	dojo.byId('state').value = endereco.state;
	dojo.byId('city').value = endereco.city;
	dojo.byId('neighborhood').value = endereco.neighborhood;
}

/* ------ Inicialização ------ */
dojo.addOnLoad(function() {
	limpaCampos();
	habilitaEndereco(false);

	dojo.connect(dojo.byId('acharCEP'), 'onclick', function(evt) {
		evt.preventDefault();
		encontrarCEP();
	});

	dojo.connect(dojo.byId('cadastrarUsuario'), 'onclick', function(evt) {
		evt.preventDefault();
		if (validaDados('dadosUsuario', 'titulo', 'after')) {
			dojo.byId('dadosUsuario').submit();
		}
	});
});