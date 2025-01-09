package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Config;
import java.sql.*;

@WebServlet("/TicketServlet")
public class TiketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("book".equals(action)) {
            bookTicket(request, response);
        } else if ("delete".equals(action)) {
            deleteTicket(request, response);
        }
    }

    private void bookTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = Config.getkoneksi();

            // Get parameters from request
            String film = request.getParameter("film");
            String jadwal = request.getParameter("jadwal");
            String id_pelanggan = request.getParameter("id_pelanggan");
            int jumlah = Integer.parseInt(request.getParameter("jumlah"));
            int harga = Integer.parseInt(request.getParameter("harga"));
            int total = jumlah * harga;
            String nomor_kursi = request.getParameter("nomor_kursi");

            // Get nama pelanggan
            String nama = "";
            PreparedStatement pstPelanggan = conn.prepareStatement(
                    "SELECT nama FROM akun WHERE id_pelanggan = ?");
            pstPelanggan.setString(1, id_pelanggan);
            ResultSet rsPelanggan = pstPelanggan.executeQuery();
            if (rsPelanggan.next()) {
                nama = rsPelanggan.getString("nama");
            }

            // Get film title
            String judul_film = "";
            PreparedStatement pstFilm = conn.prepareStatement(
                    "SELECT judul_film FROM film WHERE id_film = ?");
            pstFilm.setString(1, film);
            ResultSet rsFilm = pstFilm.executeQuery();
            if (rsFilm.next()) {
                judul_film = rsFilm.getString("judul_film");
            }

            // Insert ticket booking
            PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO pesan_tiket (id_pelanggan, nama, judul_film, "
                    + "jadwal_tayang, jumlah, harga, total, nomor_kursi) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

            pst.setString(1, id_pelanggan);
            pst.setString(2, nama);
            pst.setString(3, judul_film);
            pst.setString(4, jadwal);
            pst.setInt(5, jumlah);
            pst.setInt(6, harga);
            pst.setInt(7, total);
            pst.setString(8, nomor_kursi);

            pst.executeUpdate();

            // Close resources
            pst.close();
            pstFilm.close();
            rsFilm.close();
            pstPelanggan.close();
            rsPelanggan.close();
            conn.close();

            // Tampilkan SweetAlert sukses
            request.getSession().setAttribute("alertMessage", "Tiket berhasil dipesan");
            request.getSession().setAttribute("alertType", "success");
            response.sendRedirect("pesantiket.jsp");

        } catch (Exception e) {
            request.getSession().setAttribute("alertMessage", "Terjadi kesalahan: " + e.getMessage());
            request.getSession().setAttribute("alertType", "error");
            response.sendRedirect("pesantiket.jsp");
        }
    }

    private void deleteTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = Config.getkoneksi();
            String idTiket = request.getParameter("id_tiket");

            PreparedStatement pst = conn.prepareStatement(
                    "DELETE FROM pesan_tiket WHERE id_tiket = ?");
            pst.setString(1, idTiket);

            int rowsAffected = pst.executeUpdate();

            pst.close();
            conn.close();

            if (rowsAffected > 0) {
                request.getSession().setAttribute("alertMessage", "Tiket berhasil dihapus");
                request.getSession().setAttribute("alertType", "success");
            } else {
                request.getSession().setAttribute("alertMessage", "Tiket tidak ditemukan");
                request.getSession().setAttribute("alertType", "error");
            }
            response.sendRedirect("pesantiket.jsp");

        } catch (Exception e) {
            request.getSession().setAttribute("alertMessage", "Terjadi kesalahan: " + e.getMessage());
            request.getSession().setAttribute("alertType", "error");
            response.sendRedirect("pesantiket.jsp");
        }
    }
}
