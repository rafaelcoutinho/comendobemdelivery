package br.copacabana.exception;

import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;

public class NotUniqueLoginException extends Exception implements JsonExceptionable {

	public NotUniqueLoginException() {
		super();
		// TODO Auto-generated constructor stub
	}

	public NotUniqueLoginException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

	public NotUniqueLoginException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	public NotUniqueLoginException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	@Override
	public JsonException getJsonFormat() {
		// TODO Auto-generated method stub
		return new JsonException(this.getMessage(), ErrorCode.USERALREADYEXISTS);
	}

}
