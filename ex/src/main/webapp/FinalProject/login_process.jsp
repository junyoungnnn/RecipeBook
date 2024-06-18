<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.javalec.ex.PasswordUtil.PasswordUtil" %>
<%
		request.setCharacterEncoding("UTF-8");

    String userid = request.getParameter("userid");
    String password = request.getParameter("password");
    boolean isValidUser = false;

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String uid = "system";
        String upw = "manager";
        
        connection = DriverManager.getConnection(url, uid, upw);
        
        String sql = "SELECT * FROM USERS WHERE USERID = ?";
        statement = connection.prepareStatement(sql);
        statement.setString(1, userid);
        
        resultSet = statement.executeQuery();
        
        if (resultSet.next()) {
            String dbPassword = resultSet.getString("PASSWORD");
            String hashedPassword = PasswordUtil.hashPassword(password);
            if (dbPassword.equals(hashedPassword)) {
                isValidUser = true;
                String username = resultSet.getString("USERNAME");
                session.setAttribute("username", username);
                String sessionUserId = resultSet.getString("USERID");
                session.setAttribute("sessionUserId", sessionUserId);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (isValidUser) {
        response.sendRedirect("Main.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>
