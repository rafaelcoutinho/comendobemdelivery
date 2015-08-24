package beyond;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class GetUserServlet
 */
public class GetUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private boolean checaLogado = true;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetUserServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/x-json");
		PrintWriter out = response.getWriter();
		
		// Se não for para checar, volta o padrão
		if (! checaLogado) {
			File file = new File(getServletContext().getRealPath("mocData/users/viniciusisola@gmail.com.js"));
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));
			String line = null;
			while( (line = in.readLine()) != null) {
				out.write(line);
			}
			out.flush();
			return;
		}
		
		// Usuário nunca tentou logar
		HttpSession session = request.getSession();
		if (session.isNew()) {
			out.write("{failure : 'USER_NOT_AUTHENTICATED'}");
			return;
		}
		
		String usuario = (String) session.getAttribute("user");
		
		// Usuário nunca tentou logar
		if (usuario == null) {
			out.write("{failure : 'USER_NOT_AUTHENTICATED' }");
		} else {
			// Usuário já tentou logar, pode não ter conseguido (retorna 0)
			if (usuario.equals("0")) {
				// Usuário ou senha inválido
				out.write("{failure : 'USER_CREDENTIALS_NOT_VALID'}");
			} else {
				
				// Carrega o usuário e envia
				File file = new File(getServletContext().getRealPath("mocData/users/" + usuario + ".js"));
				if (file.exists() && file.isFile()) {
					BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));
					String line = null;
					while( (line = in.readLine()) != null) {
						out.write(line);
					}
				} else {
					
					// Não encontrou o usuário com o ID especificado
					out.write("{login: " + usuario + "}");
				}
			}
		}
		
		out.flush();
	}

}