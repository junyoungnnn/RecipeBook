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
            background-color: #333;
            padding: 10px 20px;
            border-bottom: 2px solid #0073e6;
        }
        .menu a {
            text-decoration: none;
            color: white;
            margin: 0 10px;
            font-size: 16px;
        }
        .menu a:hover {
            color: #0073e6;
        }
        .content {
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
        }
        .recipe {
            width: 45%; /* 한 행에 두 개의 레시피를 보여주기 위해 width를 45%로 설정 */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 10px; /* 마진을 설정하여 간격을 조정 */
            padding: 10px;
            text-align: center;
            transition: transform 0.2s;
            cursor: pointer;
        }
        .recipe:hover {
            transform: scale(1.05);
        }
        .recipe .image-container {
            width: 100%;
            height: 300px;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .recipe img {
            width: 100%;
            height: auto;
            object-fit: cover; /* 이미지가 컨테이너를 채우도록 설정 */
        }
        .recipe-title {
            margin-top: 10px;
            font-size: 16px;
            font-weight: bold;
        }
        .delete-button {
            background-color: #ff4d4d; /* 빨간색 배경 */
            color: white; /* 흰색 글자 */
            border: none;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
            margin-top: 10px;
            border-radius: 5px; /* 둥근 모서리 */
        }
        .delete-button:hover {
            background-color: #ff1a1a; /* 더 진한 빨간색 배경 */
            transform: scale(1.1);
        }
        .delete-button:active {
            background-color: #e60000; /* 눌렸을 때 진한 빨간색 배경 */
        }
    </style>
    <script>
        function redirectToRecipe(recipeID) {
            window.location.href = 'recipeDetails.jsp?recipeID=' + recipeID;
        }
    </script>
</head>
<body>

<div class="menu">
    <div>
        <a href="Main.jsp">홈</a>
        <a href="search.jsp">레시피 찾기</a>
        <% 
        String username = (String)session.getAttribute("username");
        String userID = (String) session.getAttribute("sessionUserId");
        if(username != null) { %>
            <a href="writeRecipeForm01.jsp">글 쓰기</a>
        <% 
        }
        %>
    </div>
    <div>
    <%        
        if(username != null){
        	 out.println("<span style='color: white;'>" + username + "님 환영합니다</span>");
        %>
        <a href="myRecipes.jsp">내 레시피</a>
        <a href="logout.jsp">로그아웃</a>
        <%    
        }
        else{
    %>
        <a href="login.jsp">로그인</a>
        <a href="registerForm01.jsp">회원가입</a>
        <%}
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
                String imagePath = rs.getString("image_path");
%>
                <div class="recipe" onclick="redirectToRecipe(<%= recipeID %>)">
                    <div class="image-container">
                        <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="업로드된 이미지">
                    </div>
                    <div class="recipe-title"><%= title %></div>
                    <p><%= description %></p>
                    <p>음식 이름: <%= foodName %></p>
                    <form method="post" action="deleteRecipe.jsp" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="recipeID" value="<%= recipeID %>">
                        <button type="submit" class="delete-button">삭제</button>
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
