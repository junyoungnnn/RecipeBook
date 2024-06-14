<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%! 
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String uid = "system";
    String pass = "manager";
    String sql = "SELECT * FROM Users";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>
</head>
<body>
    <h2>회원 목록</h2>
    <table border='1'>
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>이메일</th>
            <th>가입 날짜</th>
        </tr>
        <%
        try {
            // (1 단계) JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // (2 단계) 데이터베이스 연결 객체 생성
            conn = DriverManager.getConnection(url, uid, pass);

            // (3 단계) Statement 객체 생성
            stmt = conn.createStatement();

            // (4 단계) SQL 문 실행 및 결과 처리
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("UserID") + "</td>");
                out.println("<td>" + rs.getString("Username") + "</td>");
                out.println("<td>" + rs.getString("Email") + "</td>");
                out.println("<td>" + rs.getTimestamp("CreateAt") + "</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // (5 단계) 사용한 리소스 해제
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        %>
    </table>
    <a href="registerForm01.jsp">회원 가입하기</a>
</body>
</html>
