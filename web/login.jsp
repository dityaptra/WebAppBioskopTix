<%@page import="App.Login"%>
<%@page import="App.User"%>
<jsp:useBean id="obj" class="App.User" scope="request"/>
<jsp:setProperty name="obj" property="*"/>
<%
    User user = Login.validate(obj);
    if (user != null) {
        // Simpan seluruh data user ke session
        session.setAttribute("user", user);
        session.setAttribute("id_pelanggan", user.getId_pelanggan());
        session.setAttribute("nama", user.getNama());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("session", "True");
        %>
        <jsp:forward page="beranda.jsp"/>
        <%
    } else {
        out.print("<center><b>Maaf username dan password yang anda masukkan salah!</b></center>");
        %>
        <jsp:include page="index.jsp"></jsp:include>
        <%
    }
%>