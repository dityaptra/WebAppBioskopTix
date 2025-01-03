package model;

public class User {
    private int id_pelanggan;
    private String nama;
    private String username;
    private String password;
    
    // Getter dan Setter
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
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
}