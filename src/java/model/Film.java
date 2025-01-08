package model;

import java.sql.Timestamp;

public class Film {
    private String judulFilm;
    private String posterUrl;
    private int durasi;
    private double rating;
    private Timestamp jadwalTayang;
    private int harga;
    
    // Constructor
    public Film(String judulFilm, String posterUrl, int durasi, double rating, Timestamp jadwalTayang, int harga) {
        this.judulFilm = judulFilm;
        this.posterUrl = posterUrl;
        this.durasi = durasi;
        this.rating = rating;
        this.jadwalTayang = jadwalTayang;
        this.harga = harga;
    }
    
    // Getters and Setters
    public String getJudulFilm() {
        return judulFilm;
    }
    
    public void setJudulFilm(String judulFilm) {
        this.judulFilm = judulFilm;
    }
    
    public String getPosterUrl() {
        return posterUrl;
    }
    
    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
    
    public int getDurasi() {
        return durasi;
    }
    
    public void setDurasi(int durasi) {
        this.durasi = durasi;
    }
    
    public double getRating() {
        return rating;
    }
    
    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public Timestamp getJadwalTayang() {
        return jadwalTayang;
    }
    
    public void setJadwalTayang(Timestamp jadwalTayang) {
        this.jadwalTayang = jadwalTayang;
    }
    
    public int getHarga() {
        return harga;
    }
    
    public void setHarga(int harga) {
        this.harga = harga;
    }
}