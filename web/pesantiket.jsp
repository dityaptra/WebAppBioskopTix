<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="model.User"%>
<%@ page import="model.Config"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pesan Tiket Film</title>
        <link rel="stylesheet" href="css/pesantiket.css"/>
        <script src="js/pesantiket.js"></script>
    </head>
    <body>
        <%
            // Cek session
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            int loggedInUserId = currentUser.getId_pelanggan();
            String loggedInNama = currentUser.getNama();

            // Inisialisasi variabel di awal
            String jadwalTayang = "";
            int hargaTiket = 0;
            String idFilm = request.getParameter("film");
            String posterUrl = "";

            if (idFilm != null && !idFilm.isEmpty()) {
                try (Connection conn = Config.getkoneksi(); PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT poster_url, jadwal_tayang, harga FROM film WHERE id_film = ?")) {

                    pstmt.setString(1, idFilm);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            jadwalTayang = rs.getString("jadwal_tayang");
                            hargaTiket = rs.getInt("harga");
                            posterUrl = rs.getString("poster_url");
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>

        <div class="user-info">
            <span class="user-name">Login sebagai: <%= loggedInNama%></span>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>

        <div class="container">
            <h2>Form Pemesanan Tiket Film</h2>

            <!-- Form Pemilihan Film -->
            <form action="pesantiket.jsp" method="GET" class="film-selection-form">
                <div class="form-group">
                    <label>Pilih Film:</label>
                    <select name="film" id="filmSelect" required onchange="this.form.submit(); updatePoster(this);">
                        <option value="">-- Pilih Film --</option>
                        <%
                            try (Connection conn = Config.getkoneksi(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM film")) {

                                while (rs.next()) {
                                    String selected = idFilm != null
                                            && idFilm.equals(rs.getString("id_film"))
                                            ? "selected" : "";
                        %>
                        <option value="<%= rs.getString("id_film")%>" 
                                data-poster="<%= rs.getString("poster_url")%>" 
                                <%= selected%>>
                            <%= rs.getString("judul_film")%>
                        </option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option value=''>Error: " + e.getMessage() + "</option>");
                            }
                        %>
                    </select>
                </div>
            </form>

            <!-- Tampilan Poster Film -->
            <div id="moviePoster" style="<%= posterUrl.isEmpty() ? "display: none;" : ""%>">
                <img src="<%= posterUrl%>" alt="Movie Poster" id="posterImage">
            </div>

            <!-- Form Pemesanan Tiket -->
            <form action="TicketServlet" method="POST" onsubmit="return validateForm()" class="booking-form">
                <input type="hidden" name="action" value="book">
                <input type="hidden" name="id_pelanggan" value="<%= loggedInUserId%>">

                <div class="form-group">
                    <label>Jadwal Tayang:</label>
                    <input type="text" name="jadwal" value="<%= jadwalTayang%>" readonly required>
                </div>

                <div class="form-group">
                    <label>Harga Tiket:</label>
                    <input type="number" id="harga" name="harga" value="<%= hargaTiket%>" readonly>
                </div>

                <div class="form-group">
                    <label>Jumlah Tiket: (Maksimal 8)</label>
                    <div class="quantity-input">
                        <button type="button" onclick="decrease()">-</button>
                        <input type="number" 
                               name="jumlah" 
                               id="jumlah"
                               value="1"
                               min="1"
                               max="8"
                               oninput="validateInput(this)"
                               required>
                        <button type="button" onclick="increase()">+</button>
                    </div>
                </div>

                <!-- Pemilihan Kursi -->
                <div class="seat-selection">
                    <h3>Pilih Kursi</h3>
                    <div class="screen">LAYAR</div>

                    <div class="seat-legend">
                        <div class="legend-item">
                            <div class="legend-box available"></div>
                            <span>Tersedia</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-box selected"></div>
                            <span>Dipilih</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-box booked"></div>
                            <span>Sudah Dipesan</span>
                        </div>
                    </div>

                    <div class="seats-container">
                        <%
                            Set<String> bookedSeats = new HashSet<>();
                            if (idFilm != null && jadwalTayang != null) {
                                try (Connection conn = Config.getkoneksi(); PreparedStatement pst = conn.prepareStatement(
                                        "SELECT nomor_kursi FROM pesan_tiket WHERE judul_film = ? AND jadwal_tayang = ?")) {

                                    pst.setString(1, idFilm);
                                    pst.setString(2, jadwalTayang);

                                    try (ResultSet rs = pst.executeQuery()) {
                                        while (rs.next()) {
                                            String[] seats = rs.getString("nomor_kursi").split(",");
                                            bookedSeats.addAll(Arrays.asList(seats));
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                                }
                            }

                            char[] rows = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
                            for (char row : rows) {
                        %>
                        <div class="seat-row">
                            <div class="row-label"><%= row%></div>
                            <div class="seats">
                                <% for (int col = 1; col <= 8; col++) {
                                        String seatId = row + String.valueOf(col);
                                        String seatClass = bookedSeats.contains(seatId) ? "seat booked" : "seat";
                                %>
                                <div id="seat-<%= seatId%>" 
                                     class="<%= seatClass%>"
                                     onclick="toggleSeat('<%= seatId%>')"
                                     <%= bookedSeats.contains(seatId) ? "title='Sudah dipesan'" : ""%>>
                                    <%= seatId%>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <% }%>
                    </div>

                    <p id="selected_seats_display">Belum memilih kursi</p>
                    <input type="hidden" id="selected_seats" name="nomor_kursi" required>
                </div>

                <div class="form-group">
                    <label>Total Harga:</label>
                    <input type="number" id="totalHarga" name="total_harga" readonly>
                </div>

                <input type="hidden" name="film" value="<%= idFilm%>">
                <button type="submit" class="btn">Pesan Tiket</button>
            </form>

            <!-- Tabel Data Pemesanan -->
            <section class="booking-data">
                <h2>Data Pemesanan Tiket</h2>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID Tiket</th>
                                <th>ID Pelanggan</th>
                                <th>Nama Pelanggan</th>
                                <th>Judul Film</th>
                                <th>Jadwal</th>
                                <th>Jumlah</th>
                                <th>Total</th>
                                <th>Nomor Kursi</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection conn = Config.getkoneksi(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(
                                        "SELECT * FROM pesan_tiket WHERE id_pelanggan = " + loggedInUserId
                                        + " ORDER BY id_tiket DESC")) {

                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("id_tiket")%></td>
                                <td><%= rs.getString("id_pelanggan")%></td>
                                <td><%= rs.getString("nama")%></td>
                                <td><%= rs.getString("judul_film")%></td>
                                <td><%= rs.getString("jadwal_tayang")%></td>
                                <td><%= rs.getString("jumlah")%></td>
                                <td>Rp <%= rs.getString("total")%></td>
                                <td><%= rs.getString("nomor_kursi")%></td>
                                <td>
                                    <form action="TicketServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id_tiket" value="<%= rs.getString("id_tiket")%>">
                                        <button type="submit" class="btn-delete" 
                                                onclick="return confirm('Apakah Anda yakin ingin menghapus tiket ini?')">
                                            Hapus
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </body>
</html>