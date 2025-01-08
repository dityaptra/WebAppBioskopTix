package model;

public class Tiket {
    private int id_tiket;
    private int id_pelanggan;
    private String nama;
    private String judul_film;
    private String jadwal_tayang;
    private int jumlah;
    private double harga;
    private double total;
    private String nomor_kursi;

    // Constructors
    public Tiket() {}

    public Tiket(int id_tiket, int id_pelanggan, String nama, String judul_film, 
                 String jadwal_tayang, int jumlah, double harga, double total, 
                 String nomor_kursi) {
        this.id_tiket = id_tiket;
        this.id_pelanggan = id_pelanggan;
        this.nama = nama;
        this.judul_film = judul_film;
        this.jadwal_tayang = jadwal_tayang;
        this.jumlah = jumlah;
        this.harga = harga;
        this.total = total;
        this.nomor_kursi = nomor_kursi;
    }

    // Getters and Setters
    public int getId_tiket() {
        return id_tiket;
    }

    public void setId_tiket(int id_tiket) {
        this.id_tiket = id_tiket;
    }

    public int getId_pelanggan() {
        return id_pelanggan;
    }

    public void setId_pelanggan(int id_pelanggan) {
        this.id_pelanggan = id_pelanggan;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getJudul_film() {
        return judul_film;
    }

    public void setJudul_film(String judul_film) {
        this.judul_film = judul_film;
    }

    public String getJadwal_tayang() {
        return jadwal_tayang;
    }

    public void setJadwal_tayang(String jadwal_tayang) {
        this.jadwal_tayang = jadwal_tayang;
    }

    public int getJumlah() {
        return jumlah;
    }

    public void setJumlah(int jumlah) {
        this.jumlah = jumlah;
    }

    public double getHarga() {
        return harga;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getNomor_kursi() {
        return nomor_kursi;
    }

    public void setNomor_kursi(String nomor_kursi) {
        this.nomor_kursi = nomor_kursi;
    }
}