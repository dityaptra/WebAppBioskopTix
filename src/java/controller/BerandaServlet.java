/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import model.Film;
import model.User;
import model.Config;
import model.FilmDAO;


/**
 *
 * @author Microsoft
 */
@WebServlet("/beranda")
public class BerandaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Cek apakah user sudah login
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        try {
            FilmDAO filmDAO = new FilmDAO();
            List<Film> daftarFilm = filmDAO.getAllFilm();
            request.setAttribute("daftarFilm", daftarFilm);
            request.getRequestDispatcher("/WEB-INF/beranda.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Terjadi kesalahan saat memuat data film: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }
}