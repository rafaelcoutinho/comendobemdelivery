package br.copacabana.exception;

import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;

public class NotUniqueUrlNameException extends Exception implements JsonExceptionable {

	public NotUniqueUrlNameException() {
		super();
		// TODO Auto-generated constructor stub
	}

	public NotUniqueUrlNameException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

	public NotUniqueUrlNameException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	public NotUniqueUrlNameException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public JsonException getJsonFormat() {
		// TODO Auto-generated method stub
		return new JsonException(this.getMessage(), ErrorCode.UNIQUEURLNAMEALREADYEXISTS);
	}

}
