package beyond;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class FileServlet
 */
public class FileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FileServlet() {
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
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Create the file name to open
		String url = request.getRequestURL().toString();
		String sFile = url.substring(url.lastIndexOf("/") + 1, url.length());
		sFile = sFile.replace(".do", "");
		
		String id = request.getParameter("id");
		if (id != null && !id.trim().equals("")) sFile += id;
		
		String user = request.getParameter("user");
		if (user != null && !user.trim().equals("")) sFile += user;
		
		System.out.println("------------------------------");
		System.out.println("Processing request.");
		System.out.println("File requested: " + sFile);
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

		// Open the output stream to client 
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(response.getOutputStream()));
		
		// Open file
		File file = new File(getServletContext().getRealPath("mocData/" + sFile + ".js"));
		if (file.exists() && file.isFile()) {
			// Simula uma demora na rede
			int dormirPor = (int) (Math.random() * (double) 2000);
			System.out.println("Dormindo por: " + dormirPor + "ms");
			try {
				Thread.sleep(dormirPor);
			} catch (InterruptedException ie) {}
			
			response.setContentType("text/x-json");
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));
			
			System.out.println("Sending file: " + file.getPath());
			
			
			System.out.println("Sending response -----------");
			String line = null;
			while( (line = in.readLine()) != null) {
				System.out.println(line);
				out.write(line);
				out.newLine();
			}
			
			in.close();
		} else {
			response.setContentType("text/x-json");
			out.write("{");
			out.write("failure : 'File not found.'");
			out.write("}");
		}
		
		out.flush();
		
		System.out.println("Processing finished.");
		System.out.println("------------------------------");
	}

}