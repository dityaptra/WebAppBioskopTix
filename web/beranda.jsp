<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="model.Film"%>
<%@page import="java.sql.*"%>
<%@page import="model.Config"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BioskopTix - Beranda</title>
        <link rel="stylesheet" href="css/beranda.css">
    </head>
    <body>
        <%
            User currentUser = (User)session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("index.jsp");
                return;
            }
            String nama = currentUser.getNama();
        %>
        <header>
            <h1>BioskopTix</h1>
            <h2>Selamat Datang, <%= nama %></h2>
        </header>
        
        <div class="content">
            <h2>Daftar Film</h2>
            <div class="films">
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = Config.getkoneksi();
                        if (conn == null) {
                            throw new Exception("Koneksi ke database gagal.");
                        }

                        String sql = "SELECT judul_film, poster_url, durasi, rating, jadwal_tayang, harga FROM film";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            String judulFilm = rs.getString("judul_film");
                            String posterUrl = rs.getString("poster_url");
                            int durasi = rs.getInt("durasi");
                            double rating = rs.getDouble("rating");
                            Timestamp jadwalTayang = rs.getTimestamp("jadwal_tayang");
                            int harga = rs.getInt("harga");
                %>
                <div class="film">
                    <img src="<%= posterUrl %>" alt="<%= judulFilm %>" class="film-image">
                    <div class="film-info">
                        <h3><%= judulFilm %></h3>
                        <p>Durasi: <%= durasi %> menit</p>
                        <p>Rating: <%= rating %>/10</p>
                        <p>Jadwal: <%= jadwalTayang %></p>
                        <p>Harga: Rp <%= harga %></p>
                    </div>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <p>Error: Tidak dapat memuat daftar film. <br> Detail error: <%= e.getMessage() %></p>
                <%
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                %>
            </div>
            
            <div class="button-container">
                <form action="pesantiket.jsp" method="get">
                    <button type="submit">Pesan Tiket Sekarang</button>
                </form>
            </div>
        </div>
    </body>
</html>