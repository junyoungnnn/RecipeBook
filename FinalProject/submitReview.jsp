<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
		request.setCharacterEncoding("UTF-8");

    String recipeID = request.getParameter("recipeID");
    String userID = request.getParameter("userID");
    String rating = request.getParameter("rating");
    String ReviewText = request.getParameter("ReviewText");

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

        // (3 단계) 리뷰를 저장하는 SQL 쿼리 작성
        String sql = "INSERT INTO Reviews (ReviewID, RecipeID, UserID, Rating, ReviewText, CreateAt) " +
                     "VALUES (review_seq.NEXTVAL, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        // (4 단계) PreparedStatement 생성 및 값 설정
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, recipeID);
        pstmt.setString(2, userID);
        pstmt.setInt(3, Integer.parseInt(rating));
        pstmt.setString(4, ReviewText);

        // (5 단계) SQL 실행
        int result = pstmt.executeUpdate();

        if (result > 0) {
            response.sendRedirect("recipeDetails.jsp?recipeID=" + recipeID);
        } else {
            out.println("<h3>리뷰를 저장하는 중 오류가 발생했습니다.</h3>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>리뷰를 저장하는 중 오류가 발생했습니다.</h3>");
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
