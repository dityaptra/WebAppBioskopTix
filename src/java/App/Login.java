/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package App;
import java.sql.*;

public class Login {

    /**
     *
     * @param gt
     * @return
     */
    public static User validate(User gt) {
        User user = null;
        try {
            Connection conn;
            conn = Config.getkoneksi();
            PreparedStatement ps = conn.prepareStatement(
                "select * from akun where username=? AND password=?"
            );
            ps.setString(1, gt.getUsername());
            ps.setString(2, gt.getPassword());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setId_pelanggan(rs.getInt("id_pelanggan"));
                user.setNama(rs.getString("nama"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return user;
    }
}