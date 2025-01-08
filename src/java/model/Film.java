package model;

import java.sql.Timestamp;

public class Film {
    private String judul;
    private String posterUrl;
    private int durasi;
    private double rating;
    private Timestamp jadwalTayang;
    private int harga;

    public String getJudul() { return judul; }
    public void setJudul(String judul) { this.judul = judul; }

    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }

    public int getDurasi() { return durasi; }
    public void setDurasi(int durasi) { this.durasi = durasi; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public Timestamp getJadwalTayang() { return jadwalTayang; }
    public void setJadwalTayang(Timestamp jadwalTayang) { this.jadwalTayang = jadwalTayang; }

    public int getHarga() { return harga; }
    public void setHarga(int harga) { this.harga = harga; }
}
