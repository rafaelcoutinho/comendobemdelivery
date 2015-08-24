package beyond;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Um servlet dummy para simular um login no Sistema.
 * 
 * O servlet de login deve sempre direcionar o usuário de volta para
 * a página que estava, que é passada via o form de login, numa variável
 * chamada redirect.
 */
public class DummyLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DummyLoginServlet() {
        super();
    }

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Para não esquecer
		throw new ServletException("Não pode fazer login via GET!!!");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// pega o login do usuário, que é o email
		String usuario = request.getParameter("user");
		
		// Verifica se existe um arquivo para este usuário
		File f = new File(getServletContext().getRealPath("mocData/users/" + usuario + ".js"));
		if (!f.exists()) usuario = "0";
		
		// Cria a sessão
		HttpSession sessao = request.getSession();
		sessao.setAttribute("user", usuario);
		
		String redirecionarPara = request.getParameter("redirect");
		redirecionarPara = "http://" + request.getServerName() + ":8080" + 
			request.getContextPath() + redirecionarPara;
		
		System.out.println("Redirecionando para: " + redirecionarPara);
		
		response.sendRedirect(redirecionarPara);
	}
}