<%-- 
    Document   : logout
    Created on : Jan 1, 2025, 9:59:42 AM
    Author     : gdrad
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.removeAttribute("user");
    session.invalidate();
    response.sendRedirect("index.jsp");
%>