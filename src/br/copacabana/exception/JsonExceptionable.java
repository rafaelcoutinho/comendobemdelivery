package br.copacabana.exception;

import br.copacabana.spring.JsonException;

public interface JsonExceptionable {
	JsonException getJsonFormat();
}
