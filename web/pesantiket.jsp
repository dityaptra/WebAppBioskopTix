<%-- 
    Document   : pesantiket
    Created on : Dec 25, 2024, 5:02:02 PM
    Author     : gdrad
--%>

<%@page import="java.util.Arrays"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="App.User"%>
<%@page import="App.Config"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Pesan Tiket Film</title>
        <link rel="stylesheet" href="css/pesantiket.css"/>
        <script>
            function updatePoster() {
                const select = document.getElementById('filmSelect');
                const selectedOption = select.options[select.selectedIndex];
                const posterUrl = selectedOption.getAttribute('data-poster');
                const posterImage = document.getElementById('posterImage');
                const moviePoster = document.getElementById('moviePoster');

                if (posterUrl && posterUrl !== "") {
                    posterImage.src = posterUrl;
                    moviePoster.style.display = "block";
                } else {
                    posterImage.src = "";
                    moviePoster.style.display = "none";
                }
            }

            function decrease() {
                const jumlah = document.getElementById('jumlah');
                if (jumlah.value > 1) {
                    jumlah.value = parseInt(jumlah.value) - 1;
                    updateTotal();
                }
            }

            function increase() {
                const jumlah = document.getElementById('jumlah');
                if (parseInt(jumlah.value || 0) < 8) {
                    jumlah.value = parseInt(jumlah.value || 0) + 1;
                    updateTotal();
                }
            }

            function validateInput(input) {
                if (input.value === "") {
                    updateTotal(); // Izinkan kosong tanpa menetapkan nilai default.
                } else if (input.value < 1) {
                    input.value = 1; // Batasi nilai minimum.
                } else if (parseInt(input.value) > 8) {
                    input.value = 8; // Batasi nilai maksimum.
                }
                updateTotal();
            }


            function updateTotal() {
                const jumlah = document.getElementById('jumlah').value || 0;
                const harga = document.getElementById('harga').value;
                const totalHarga = document.getElementById('totalHarga');
                totalHarga.value = parseInt(jumlah) * parseInt(harga);
            }
            
            let selectedSeats = [];
            const maxSeats = 8;

            function toggleSeat(seatNumber) {
                const seatElement = document.getElementById('seat-' + seatNumber);
                const seatInput = document.getElementById('selected_seats');
                
                if (seatElement.classList.contains('booked')) {
                    return; // Kursi sudah dipesan
                }

                if (seatElement.classList.contains('selected')) {
                    // Hapus kursi dari seleksi
                    seatElement.classList.remove('selected');
                    selectedSeats = selectedSeats.filter(seat => seat !== seatNumber);
                } else {
                    // Tambah kursi ke seleksi jika belum mencapai batas
                    if (selectedSeats.length < parseInt(document.getElementById('jumlah').value)) {
                        seatElement.classList.add('selected');
                        selectedSeats.push(seatNumber);
                    } else {
                        alert('Anda hanya dapat memilih ' + document.getElementById('jumlah').value + ' kursi');
                        return;
                    }
                }

                // Update input hidden dengan kursi yang dipilih
                seatInput.value = selectedSeats.sort().join(',');
                
                // Update tampilan kursi yang dipilih
                document.getElementById('selected_seats_display').textContent = 
                    selectedSeats.length > 0 ? 'Kursi dipilih: ' + selectedSeats.sort().join(', ') : 'Belum memilih kursi';
            }

            function validateForm(e) {
                const jumlah = document.getElementById('jumlah').value || 0;
                const warning = document.getElementById('warning');
                const pelanggan = document.getElementById('pelanggan').value;
                const selectedSeatsInput = document.getElementById('selected_seats').value;
                const selectedSeatsCount = selectedSeatsInput ? selectedSeatsInput.split(',').length : 0;

                if (parseInt(jumlah) < 1) {
                    warning.style.display = "block";
                    e.preventDefault();
                    return false;
                }

                if (!pelanggan) {
                    alert('Harap pilih pelanggan terlebih dahulu!');
                    e.preventDefault();
                    return false;
                }
                
                 if (selectedSeatsCount !== parseInt(jumlah)) {
                    alert('Jumlah kursi yang dipilih harus sama dengan jumlah tiket!');
                    e.preventDefault();
                    return false;
                }

                return true;
            }

            document.addEventListener('DOMContentLoaded', () => {
                updatePoster();
                updateTotal();
            });
        </script>
    </head>
    <body>
        <%
            // Cek session dan otomatis set pelanggan yang login
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            // Simpan data user yang sedang login
            int loggedInUserId = currentUser.getId_pelanggan();
            String loggedInNama = currentUser.getNama();
        %>

        <div class="user-info">
    <span class="user-name">Login sebagai: <%= loggedInNama %></span>
    <a href="logout.jsp" class="logout-btn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
            <polyline points="16 17 21 12 16 7"></polyline>
            <line x1="21" y1="12" x2="9" y2="12"></line>
        </svg>
    </a>
</div>
        <h2>Form Pemesanan Tiket Film</h2>

        <%
            String jadwalTayang = "";
            int hargaTiket = 0;
            String idFilm = request.getParameter("film");
            String posterUrl = "";

            if (idFilm != null && !idFilm.isEmpty()) {
                try {
                    Connection conn = Config.getkoneksi();
                    String sql = "SELECT poster_url, jadwal_tayang, harga FROM film WHERE id_film = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, idFilm);
                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        jadwalTayang = rs.getString("jadwal_tayang");
                        hargaTiket = rs.getInt("harga");
                        posterUrl = rs.getString("poster_url");
                    }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            }
        %>

        <!-- Form for film selection -->
        <form action="" method="GET">
            <div class="form-group">
                <label>Pilih Film:</label>
                <select name="film" id="filmSelect" required onchange="this.form.submit();">
                    <option value="">-- Pilih Film --</option>
                    <%
                        try {
                            Connection conn = Config.getkoneksi();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM film");
                            while (rs.next()) {
                                String selected = request.getParameter("film") != null
                                        && request.getParameter("film").equals(rs.getString("id_film"))
                                        ? "selected" : "";
                                out.println("<option value='" + rs.getString("id_film") + "' "
                                        + "data-poster='" + rs.getString("poster_url") + "' "
                                        + selected + ">"
                                        + rs.getString("judul_film") + "</option>");
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        }
                    %>
                </select>
            </div>
        </form>

        <!-- Movie poster display -->
        <div id="moviePoster" style="display: none;">
            <img id="posterImage" src="<%= posterUrl%>" alt="Movie Poster">
        </div>

        <!-- Ticket booking form -->
        <form action="" method="POST" onsubmit="return validateForm(event)">
            <!-- Ganti select pelanggan dengan hidden input -->
<input type="hidden" name="id_pelanggan" id="pelanggan" value="<%= loggedInUserId %>">

            <div class="form-group">
                <label>Jadwal Tayang:</label>
                <input type="text" name="jadwal" value="<%= jadwalTayang%>" readonly required>
            </div>

            <div class="form-group">
                <label>Harga Tiket:</label>
                <input type="number" id="harga" name="harga" value="<%= hargaTiket%>" readonly>
            </div>

            <div class="form-group">
                <label>Jumlah Tiket: (Jumlah maksimal adalah 8)</label>
                <div class="quantity-input">
                    <button type="button" onclick="decrease()">-</button>
                    <input type="number" 
                           name="jumlah" 
                           id="jumlah"
                           value="1"
                           oninput="validateInput(this)"
                           onkeypress="return event.charCode >= 48"
                           min="1"
                           max="8">
                    <button type="button" onclick="increase()">+</button>
                </div>
            </div>
            
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
            </div>

            <div class="seats-container">
                <%
                    // Ambil kursi yang sudah dipesan untuk film dan jadwal yang dipilih
                    Set<String> bookedSeats = new HashSet<>();
                    if (request.getParameter("film") != null && jadwalTayang != null) {
                        try {
                            Connection conn = Config.getkoneksi();
                            PreparedStatement pst = conn.prepareStatement(
                                "SELECT nomor_kursi FROM pesan_tiket WHERE judul_film = ? AND jadwal_tayang = ?"
                            );
                            pst.setString(1, request.getParameter("film"));
                            pst.setString(2, jadwalTayang);
                            ResultSet rs = pst.executeQuery();
                            while (rs.next()) {
                                String[] seats = rs.getString("nomor_kursi").split(",");
                                bookedSeats.addAll(Arrays.asList(seats));
                            }
                            rs.close();
                            pst.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        }
                    }

                     // Generate kursi dengan format huruf dan angka
                    char[] rows = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
                    for (char row : rows) {
                %>
                    <div class="seat-row">
                        <div class="row-label"><%= row %></div>
                        <div class="seats">
                            <% for (int col = 1; col <= 8; col++) {
                                String seatId = row + String.valueOf(col);
                                String seatClass = bookedSeats.contains(seatId) ? "seat booked" : "seat";
                            %>
                                <div id="seat-<%= seatId %>" class="<%= seatClass %>"
                                     onclick="toggleSeat('<%= seatId %>')"
                                     <%= bookedSeats.contains(seatId) ? "title='Sudah dipesan'" : "" %>>
                                    <%= seatId %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
            
            <p id="selected_seats_display">Belum memilih kursi</p>
            <input type="hidden" id="selected_seats" name="nomor_kursi" required>
        </div>


            <div class="form-group">
                <label>Total Harga:</label>
                <input type="number" id="totalHarga" name="total_harga" readonly>
            </div>

            <input type="hidden" name="film" value="<%= request.getParameter("film")%>">
            <input type="submit" name="pesan" value="Pesan Tiket" class="btn">
        </form>

        <!-- Booking data processing -->
        <%
            if (request.getMethod().equals("POST") && request.getParameter("pesan") != null) {
                try {
                    Connection conn = Config.getkoneksi();
                    String film = request.getParameter("film");
                    String jadwal = request.getParameter("jadwal");
                    String id_pelanggan = request.getParameter("id_pelanggan");

                    if (id_pelanggan == null || id_pelanggan.isEmpty()) {
                        throw new Exception("Harap pilih pelanggan terlebih dahulu!");
                    }

                    int jumlah = Integer.parseInt(request.getParameter("jumlah"));
                    int harga = Integer.parseInt(request.getParameter("harga"));
                    int total = jumlah * harga;

                    // Get nama pelanggan
                    PreparedStatement pstPelanggan = conn.prepareStatement(
                            "SELECT nama FROM akun WHERE id_pelanggan = ?"
                    );
                    pstPelanggan.setString(1, id_pelanggan);
                    ResultSet rsPelanggan = pstPelanggan.executeQuery();
                    String nama = "";
                    if (rsPelanggan.next()) {
                        nama = rsPelanggan.getString("nama");
                    }

                    PreparedStatement pst = conn.prepareStatement(
                            "INSERT INTO pesan_tiket (id_pelanggan, nama, judul_film, jadwal_tayang, jumlah, harga, total, nomor_kursi) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                    );

                    pst.setString(1, id_pelanggan);
                    pst.setString(2, nama);

                    PreparedStatement pstFilm = conn.prepareStatement("SELECT judul_film FROM film WHERE id_film = ?");
                    pstFilm.setString(1, film);
                    ResultSet rs = pstFilm.executeQuery();
                    if (rs.next()) {
                        pst.setString(3, rs.getString("judul_film"));
                    }

                    pst.setString(4, jadwal);
                    pst.setInt(5, jumlah);
                    pst.setInt(6, harga);
                    pst.setInt(7, total);
                    pst.setString(8, request.getParameter("nomor_kursi"));

                    pst.executeUpdate();
                    out.println("<script>alert('Pemesanan tiket berhasil!');</script>");

                    rs.close();
                    pstFilm.close();
                    rsPelanggan.close();
                    pstPelanggan.close();
                    pst.close();
                    conn.close();

                } catch (Exception e) {
                    out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
                }
            }
        %>

        <!-- Booking data display -->
        <h2>Data Pemesanan Tiket</h2>
        <table>
            <tr>
                <th>ID Tiket</th>
                <th>ID Pelanggan</th>
                <th>Nama Pelanggan</th>
                <th>Judul Film</th>
                <th>Jadwal</th>
                <th>Jumlah</th>
                <th>Harga</th>
                <th>Total</th>
                <th>Nomor Kursi</th>
                <th>Aksi</th>
            </tr>
            <%
                try {
                    Connection conn = Config.getkoneksi();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(
                            "SELECT pt.*, a.nama as nama_pelanggan "
                            + "FROM pesan_tiket pt "
                            + "LEFT JOIN akun a ON pt.id_pelanggan = a.id_pelanggan "
                            + "ORDER BY pt.id_tiket DESC"
                    );
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("id_tiket")%></td>
                <td><%= rs.getString("id_pelanggan")%></td>
                <td><%= rs.getString("nama_pelanggan")%></td>
                <td><%= rs.getString("judul_film")%></td>
                <td><%= rs.getString("jadwal_tayang")%></td>
                <td><%= rs.getString("jumlah")%></td>
                <td>Rp <%= rs.getString("harga")%></td>
                <td>Rp <%= rs.getString("total")%></td>
                <td><%= rs.getString("nomor_kursi") %></td>
                <td>
                    <form action="" method="POST" style="display:inline;">
                        <input type="hidden" name="id_tiket" value="<%= rs.getString("id_tiket")%>">
                        <input type="submit" name="hapus" value="Hapus" 
                               onclick="return confirm('Apakah Anda yakin ingin menghapus data ini?')">
                    </form>
                </td>
            </tr>
            <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println(e);
                }
            %>
        </table>

        <!-- Delete processing -->
        <%
            if (request.getParameter("hapus") != null) {
                try {
                    String idTiket = request.getParameter("id_tiket");
                    Connection conn = Config.getkoneksi();
                    PreparedStatement pst = conn.prepareStatement("DELETE FROM pesan_tiket WHERE id_tiket = ?");
                    pst.setString(1, idTiket);
                    int rowsAffected = pst.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<script>alert('Data berhasil dihapus!');</script>");
                    } else {
                        out.println("<script>alert('Gagal menghapus data!');</script>");
                    }
                } catch (Exception e) {
                    out.println(e);
                }
            }
        %>
    </body>
</html>