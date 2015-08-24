package br.copacabana;

import javax.servlet.http.HttpServletRequest;

import br.copacabana.spring.JsonException;

/**
 * @author Rafael Coutinho
 */
public class JsonAddAddressToUserPersistController extends JsonPersistController {
	// protected String objectClass;
	//
	// public String getObjectClass() {
	// return objectClass;
	// }
	//
	// public void setObjectClass(String objectClass) {
	// this.objectClass = objectClass;
	// }

	// reestabelecer o form
	@SuppressWarnings("unchecked")
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		try {

			return getCommandClass().getConstructor(new Class[0]).newInstance(new Object[0]);
		} catch (Exception e) {
			e.printStackTrace();
			throw new JsonException(e.getMessage());
		}

	}
	
	

}