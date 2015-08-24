package beyond;

import java.io.IOException;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SalvaUsuarioServlet
 */
public class SalvaUsuarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SalvaUsuarioServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		throw new ServletException("Não pode salvar usando GET!!!");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("------------------------------");
		System.out.println("Saving user.");
		System.out.println("Time: " + new Date());
		System.out.println("-- Parameters:");
		
		Enumeration names = request.getParameterNames();
		while (names.hasMoreElements()) {
			String name = (String) names.nextElement();
			String [] values = request.getParameterValues(name);
			System.out.print("\t'" + name + "' : ");
			for (int i = 0; i < values.length; i++) {
				String value = values[i];
				System.out.print("'" + value + "'" );
				if (i < values.length - 1) System.out.print(" | ");
			}
			System.out.println();
		}
		System.out.println("--");
		
		// pega o login do usuário, que é o email
		String usuario = request.getParameter("email");
		
		// loga o usuário
		HttpSession sessao = request.getSession();
		sessao.setAttribute("user", usuario);
		
		response.sendRedirect("http://localhost:8080/ComendoBem/jsp/user/profile.jsp");
	}

}