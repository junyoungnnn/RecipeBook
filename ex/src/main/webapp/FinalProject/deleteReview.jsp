<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String reviewID = request.getParameter("reviewID");
String recipeID = request.getParameter("recipeID");
String userID = (String) session.getAttribute("sessionUserId");

Connection conn = null;
PreparedStatement pstmt = null;
String url = "jdbc:oracle:thin:@localhost:1521:XE";
String uid = "system";
String pass = "manager";

try {
    // (1 단계) JDBC 드라이버 로드
    Class.forName("oracle.jdbc.driver.OracleDriver");

    // (2 단계) 데이터베이스 연결 객체 생성
    conn = DriverManager.getConnection(url, uid, pass);

    // (3 단계) 리뷰를 삭제하는 SQL 쿼리 작성
    String sql = "DELETE FROM Reviews WHERE ReviewID = ? AND UserID = ?";

    // (4 단계) PreparedStatement 생성 및 값 설정
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, reviewID);
    pstmt.setString(2, userID);

    // (5 단계) SQL 실행
    int rowsAffected = pstmt.executeUpdate();

    if (rowsAffected > 0) {
        // 삭제 성공 시
        response.sendRedirect("recipeDetails.jsp?recipeID=" + recipeID);
    } else {
        out.println("<script>alert('리뷰를 삭제하는 데 실패했습니다.');history.back();</script>");
    }

} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다.');history.back();</script>");
} finally {
    // (6 단계) 사용한 리소스 해제
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>
