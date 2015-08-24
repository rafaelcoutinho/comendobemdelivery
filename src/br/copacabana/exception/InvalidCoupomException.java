package br.copacabana.exception;

public class InvalidCoupomException extends Exception {
	public enum InvalidCause {
		USER_IS_WRONG, VALUE_IS_WRONG, UNKNOWN, COUPOM_USED, COUPOM_FOR_OTHER_RESTAURANT
	};

	private InvalidCause causeCode = InvalidCause.UNKNOWN;

	public InvalidCoupomException() {
		super();
		// TODO Auto-generated constructor stub
	}

	public InvalidCoupomException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

	public InvalidCoupomException(String message, InvalidCause cause) {
		super(message);
		this.causeCode = cause;
		// TODO Auto-generated constructor stub
	}

	public InvalidCoupomException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = -1195025698428803835L;

	public InvalidCause getCauseCode() {
		return causeCode;
	}

	public void setCauseCode(InvalidCause causeCode) {
		this.causeCode = causeCode;
	}

}
