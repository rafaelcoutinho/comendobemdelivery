package br.copacabana.exception;

import br.copacabana.spring.JsonException;

public class PasswordDontMatchException extends JsonException {

	public PasswordDontMatchException(String errorMsg) {
		super(errorMsg);

	}

}
