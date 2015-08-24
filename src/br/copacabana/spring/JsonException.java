package br.copacabana.spring;

import br.copacabana.GsonBuilderFactory;
import br.copacabana.exception.JsonExceptionable;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.annotations.Expose;

public class JsonException extends Exception implements JsonExceptionable {
	@Expose
	private String error = "true";
	@Expose
	private ErrorCode errorCode = ErrorCode.UNKNOWN;

	public enum ErrorCode {
		UNKNOWN, EMPTYPWD, OLDPWDDOESNTMATCH, USERALREADYEXISTS, USERNOTFOUND, UNIQUEURLNAMEALREADYEXISTS, DATANOTFOUND, PAYPALEXPIRED, PAYPALERROR, PAYPALIOERROR, INCORRECTSTATUSWORKFLOW, UPLOADEDFILELARGERTHANMAX, INVALIDUNIQUEURL, UPLOADEDIMGFORMATUNKNWON, USERNOTLOGGEDIN, PAYPALAUTHORIZATIONREPEATED, PAYPAL_BLACKLIST
	};

	@Expose
	private String errorMsg = "";
	private String json;
	private Gson gson;
	private String errorCallback;

	public JsonException(String errorMsg) {
		super();
		this.errorMsg = errorMsg;
		GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
		gson = gsonBuilder.create();

	}

	public JsonException(String errorMsg, ErrorCode errorCode) {
		GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
		gson = gsonBuilder.create();
		this.errorMsg = errorMsg;
		this.errorCode = errorCode;

	}

	public String getJson() {
		JsonObject jsobj = new JsonObject();
		if (errorMsg == null) {
			jsobj.add("errorCode", new JsonPrimitive(errorCode.name()));
			jsobj.add("errorMsg", new JsonPrimitive("null"));
		} else {
			jsobj.add("errorCode", new JsonPrimitive(errorCode.name()));
			jsobj.add("errorMsg", new JsonPrimitive(errorMsg));
		}
		return jsobj.toString();
	}

	public void setJson(String json) {
		this.json = json;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public ErrorCode getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(ErrorCode errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	@Override
	public JsonException getJsonFormat() {
		return this;
	}

	public String getErrorCallback() {
		return errorCallback;
	}

	public void setErrorCallback(String errorCallback) {
		this.errorCallback = errorCallback;
	}
}
