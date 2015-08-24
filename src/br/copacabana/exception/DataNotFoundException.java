package br.copacabana.exception;

import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;

public class DataNotFoundException extends Exception implements JsonExceptionable {

	public DataNotFoundException() {
		super();
		// TODO Auto-generated constructor stub
	}

	public DataNotFoundException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

	public DataNotFoundException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	public DataNotFoundException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	@Override
	public JsonException getJsonFormat() {

		return new JsonException(this.getMessage(), ErrorCode.DATANOTFOUND);
	}

}
