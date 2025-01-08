package controller;

import model.User;
import model.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet untuk menangani proses login pengguna
 * @author Microsoft
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ambil input dari form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validasi input
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username dan Password harus diisi!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // Proses validasi dengan model
        User obj = new User();
        obj.setUsername(username);
        obj.setPassword(password);

        User user = UserDAO.validate(obj);

        if (user != null) {
            // Simpan data pengguna di session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("id_pelanggan", user.getId_pelanggan());
            session.setAttribute("nama", user.getNama());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("session", "True");

            // Redirect ke halaman beranda
            response.sendRedirect("beranda.jsp");
        } else {
            // UserDAO gagal, kembali ke halaman login dengan pesan error
            request.setAttribute("errorMessage", "Username atau Password salah!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet untuk menangani proses login pengguna";
    }
}
