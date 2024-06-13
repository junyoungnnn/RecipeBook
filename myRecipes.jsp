<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내가 작성한 레시피</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .menu {
            display: flex;
            justify-content: space-between;
            background-color: #f8f8f8;
            padding: 10px 20px;
            border-bottom: 2px solid #0073e6;
        }
        .menu a {
            text-decoration: none;
            color: #333;
            margin: 0 10px;
        }
        .content {
            padding: 20px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .recipe {
            width: 30%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 10px;
            text-align: center;
        }
        .recipe img {
            max-width: 100%;
            height: auto;
        }
        .recipe-title {
            margin-top: 10px;
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="menu">
    <div>
        <a href="Main.jsp">홈</a>
        <a href="search.jsp">레시피 찾기</a>
        <a href="writeRecipeForm01.jsp">글 쓰기</a>
    </div>
    <div>
    <%
        String username = (String) session.getAttribute("username");
        String userID = (String) session.getAttribute("sessionUserId");
        
        if (username != null) {
            out.println(username + "님 환영합니다");
    %>
        <a href="logout.jsp">로그아웃</a>
    <%
        } else {
    %>
        <a href="login.jsp">로그인</a>
        <a href="registerForm01.jsp">회원가입</a>
    <% 
        } 
    %>
    </div>
</div>

<div class="content">
<%
    if (userID != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String url = "jdbc:oracle:thin:@localhost:1521:XE";
        String uid = "system";
        String pass = "manager";

        try {
            // (1 단계) JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // (2 단계) 데이터베이스 연결 객체 생성
            conn = DriverManager.getConnection(url, uid, pass);

            // (3 단계) PreparedStatement 객체 생성 및 값 설정
            String sql = "SELECT * FROM Recipes WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userID);

            // (4 단계) SQL 문을 실행하여 결과 처리
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String recipeID = rs.getString("RecipeID");
                String foodName = rs.getString("FoodName");
                String title = rs.getString("Title");
                String description = rs.getString("Description");
%>
                <div class="recipe">
                    <img src="images/default-recipe-image.png" alt="레시피 이미지">
                    <div class="recipe-title"><%= title %></div>
                    <p><%= description %></p>
                    <p>음식 이름: <%= foodName %></p>
                    <a href="recipeDetails.jsp?recipeID=<%= recipeID %>">자세히 보기</a>
                    <form method="post" action="deleteRecipe.jsp" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="recipeID" value="<%= recipeID %>">
                        <button type="submit">삭제</button>
                    </form>
                </div>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>레시피를 가져오는 중 오류가 발생했습니다.</h3>");
        } finally {
            // (5 단계) 사용한 리소스 해제
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    } else {
        out.println("<h3>로그인 후에 이용해 주세요.</h3>");
    }
%>
</div>

</body>
</html>
