<%-- 
    Document   : index
    Created on : Dec 23, 2024, 4:59:23 PM
    Author     : gdrad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Form Login</title>
        <link rel="stylesheet" href="css/index.css">
    </head>
    <body>
        <<form action="LoginServlet" method="post">
            <div id="menu"><center><h1>BIOSKOPTIX</h1></center></div>
            <table align="center">
                <tr>
                    <td width="100px">Username</td>
                    <td><input type="text" name="username"</td>
                </tr>
                <tr>
                    <td>Password</td>
                    <td><input type="password" name="password"</td>
                </tr>
                <tr>
                    <td><input type="submit" name="submit" value="login"</td>
                </tr>
            </table>
        </form>
    </body>
</html>