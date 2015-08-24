package br.copacabana;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import br.copacabana.spring.JsonException;

public class JsonDeleteController extends JsonPersistController {
	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {
		try {
			logger.debug("calling onSubmit");			
			if(object instanceof Collection){
				Collection c = (Collection)object;
				for (Iterator iterator = c.iterator(); iterator.hasNext();) {
					Object obj = (Object) iterator.next();
					JsonDeleteCommand persistCommand = new JsonDeleteCommand(obj);
					persistCommand.execute(manager);
				}			
			}else{
				JsonDeleteCommand persistCommand = new JsonDeleteCommand(object);
				persistCommand.execute(manager);	
			}

			Map<String, Object> model = new HashMap<String, Object>();

			
			model.put("mode", "view");
			
			
			return new ModelAndView(getSuccessView(), model);
		} catch (Exception e) {
			e.printStackTrace();
			throw new JsonException(e.getMessage());
		}
	}
}
