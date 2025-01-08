package model;

import model.Film;
import model.Config;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FilmDAO {
    public List<Film> getAllFilm() throws SQLException {
        List<Film> daftarFilm = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = Config.getkoneksi();
            String sql = "SELECT judul_film, poster_url, durasi, rating, jadwal_tayang, harga FROM film";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Film film = new Film(
                    rs.getString("judul_film"),
                    rs.getString("poster_url"),
                    rs.getInt("durasi"),
                    rs.getDouble("rating"),
                    rs.getTimestamp("jadwal_tayang"),
                    rs.getInt("harga")
                );
                daftarFilm.add(film);
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        
        return daftarFilm;
    }
}