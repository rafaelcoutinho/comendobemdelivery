dojo.provide('comum.format');

/**
 * Formata o CEP para um formato legível.
 * 
 * @param cep
 *            {String} O cep com 8 dígitos, sem traços ou espaços.
 * @return {String} O cep com o seguinte formato: ddddd-ddd.
 */
function formataCEP (cep) {
	if (cep.length == 8) {
		return cep.substring(0, 5) + '-' + cep.substring(5, 8);
	}
	
	// Formato desconhecido
	return cep;
}

/**
 * Formata data para o padrão brasileiro: dd/mm/yyyy.
 * 
 * @param data
 *            {Date|String} A data para ser formatada. Se for uma String, deve
 *            ser passada com o formato YYYY-MM-DD.
 *            							01234567890
 * @return {String} A data formatada.
 */
function formataData(data) {
	if (dojo.isString(data)) {
		if (data.length != 10) throw new Error('Data inválida: ' + data);
		data = new Date(data.substring(0, 4), data.substring(5, 7), data.substring(8, 10));
	}
	
	var d = data.getDate() + '';
	if (d.length < 2) d = "0" + d;
	
	var m = (data.getMonth() + 1) + '';
	if (m.length < 2) m = "0" + m;
	
	var y = data.getFullYear();
	
	return d + "/" + m + "/" + y;
}

/**
 * Formata um número para o padrão brasileiro de moedas.
 * 
 * @param numero
 *            {String|Number} O número a ser formatado.
 * @return O número formatado.
 */
function formataMoeda (numero) {
	numero = formataNumero(numero);
	
	// Se não tiver vírgula, era um número inteiro
	if (numero.indexOf(',') == -1) numero += ',00';
	
	// Se não tiver dois dígitos no final, coloca zeros
	while (numero.length - numero.indexOf(',') <= 2 ) {
		numero += '0';
	}
	
	// Se tiver mais que dois digitos, apaga os últimos
	if (numero.length - numero.indexOf(',') > 2) {
		numero = numero.substring(0, numero.indexOf(',') + 3);
	}
	
	return 'R$ ' + numero;
}

/**
 * Formata um decimal padrão javascript para português, substituindo pontos por
 * vírgulas.
 * 
 * @param numero
 *            {String|Number} O número que será formatado.
 * @return O número com pontos substituídos por vírgulas.
 */
function formataNumero(numero) {
	numero = numero + '';
	return numero.replace('.', ',');
}

/**
 * Formata um telefone para que fique apresentável para o usuário. O telefone
 * pode vir com 10 ou 8 dígitos. 10 dígitos inclui o DDD e será retornado no
 * formato (dd) dddd-dddd. 8 dígitos não inclui o DDD e retornará o formato
 * dddd-dddd. Qualquer outro quantidade de dígitos diferente de 10 ou 8 será
 * retornada como foi passado, sem alteração.
 * 
 * @param telefone
 *            {String} O telefone que será formatado com 8 ou 10 dígitos.
 * @return {String} O telefone formatado.
 */
function formataTelefone(telefone) {
	// Formato com DDD
	if (telefone.length == 10) {
		var ddd = telefone.substring(0, 2);
		telefone = telefone.substring(2, 6) + "-" + telefone.substring(6, telefone.length);
		
		return "(" + ddd + ") " + telefone;
	}
	
	// Formato sem DDD
	if (telefone.length == 8) {
		return telefone.substring(0, 4) + "-" + telefone.substring(4, telefone.length);
	}
	
	// Formato desconhecido
	return telefone;
}

/**
 * Devolve o DDD de um número de telefone se tiver.
 * 
 * @param telefone
 *            {String} O número de telefone.
 * @return {String} O DDD se o telefone tiver 10 caracteres, uma string vazia em
 *         qualquer outro caso.
 */
function getDDD(telefone) {
	if (telefone.length == 10) return telefone.substring(0, 2);
	return '';
}

/**
 * Devolve o número de um telefone.
 * 
 * @param telefone
 *            {String} Um telefone com ou sem DDD>
 * @return {String} O telefone sem DDD.
 */
function getTelefone(telefone) {
	if (telefone.length == 10) {
		return telefone.substring(2, 10);
	}
	
	return telefone;
}

function limpaCEP(cep) {
	while (cep.indexOf('-') != -1) cep = cep.replace('-', '');
	while (cep.indexOf(' ') != -1) cep = cep.replace(' ', '');
	return cep;
}

function limpaTelefone(telefone) {
	while (telefone.indexOf('-') != -1) telefone = telefone.replace('-', '');
	while (telefone.indexOf(' ') != -1) telefone = telefone.replace(' ', '');
	return telefone;
}