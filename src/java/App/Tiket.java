/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package App;

public class Tiket {
    private int id;
    private String film;
    private String jadwal_tayang;
    private int jumlah;
    private int harga;
    private int totalHarga;

    // Constructor
    public Tiket() {}

    public Tiket(int id, String film, String jadwal_tayang, int jumlah, int harga, int totalHarga) {
        this.id = id;
        this.film = film;
        this.jadwal_tayang = jadwal_tayang;
        this.jumlah = jumlah;
        this.harga = harga;
        this.totalHarga = totalHarga;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFilm() {
        return film;
    }

    public void setFilm(String film) {
        this.film = film;
    }

    public String jadwal_tayang() {
        return jadwal_tayang;
    }

    public void jadwal_tayang(String jadwal_tayang) {
        this.jadwal_tayang = jadwal_tayang;
    }

    public int getJumlah() {
        return jumlah;
    }

    public void setJumlah(int jumlah) {
        this.jumlah = jumlah;
    }

    public int getHarga() {
        return harga;
    }

    public void setHarga(int harga) {
        this.harga = harga;
    }

    public int getTotalHarga() {
        return totalHarga;
    }

    public void setTotalHarga(int totalHarga) {
        this.totalHarga = totalHarga;
    }

    @Override
    public String toString() {
        return "Tiket [id=" + id + ", film=" + film + ", jadwal_tayang=" + jadwal_tayang + ", jumlah=" + jumlah + ", harga=" + harga + ", totalHarga=" + totalHarga + "]";
    }
}