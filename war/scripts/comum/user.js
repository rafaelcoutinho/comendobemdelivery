dojo.provide('comum.user');

////////////////////////////
//------ Variáveis ------//
////////////////////////////

//Usado para armazenar o ID do usuário
var usuario = null;

//////////////////////////
//------ Funções ------//
//////////////////////////

/**
 * Checar se o objeto de retorno informa que o usuário não está logado.
 * 
 * @param objeto
 *            {Object} Um objeto que pode conter uma mensagem informando que o
 *            usuário não está logado.
 * @return {Boolean} True se o usuário não estiver logado.
 */
comum.user.checaLogado=function  (objeto) {
	if (objeto.failure) {
		window.location = contexto + '/jsp/user/login.jsp'
	}
	
	return true;
}

/**
 * Retorna as informações do usuário.
 * 
 * @return {Object} Os dados do usuário num objeto.
 */
function getUsuario() {
	dojo.xhr('GET', {
		sync : true,
		url : contexto + "/getUser.do",
		load : function(response) {
			usuario = dojo.fromJson(response);
		}
	});
}

/**
 * Verifica se o usuário está logado.
 * 
 * @return {Boolean} True se o usuário estiver logado.
 */
function usuarioLogado() {
	return !usuario.failure;
}

/**
 * Verifica se o usuário tentou logar.
 * 
 * @return {Boolean} True se ele já tentou logar.
 */
comum.user.usuarioTentouLogar=function() {
	return !usuario.failure || usuario.failure != 'USER_NOT_AUTHENTICATED';
}

//////////////////////////
//------ Estáticos -----//
//////////////////////////
getUsuario();


///////////////////////////////
//------ Inicialização ------//
///////////////////////////////
dojo.addOnLoad(function () {
	/* Se o usuário estiver logado, troca o link de
	* "Cadastre-se" para "Meus Dados".
	*/ 
	if (usuarioLogado()) {
		var link = dojo.byId('cadastreSe');
		if (link) {
			dojo.attr(link, 'href', contexto + '/jsp/user/profile.jsp');
			
			var imagemLink = dojo.query('img', link)[0];
			dojo.attr(imagemLink, {
				src : contexto + '/resources/img/meusDados.png',
				alt : 'Meus dados'
			});
		}
	}
});