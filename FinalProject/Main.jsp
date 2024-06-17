<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>레시피 북 메인 화면</title>
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
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .recipe {
            width: 30%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 10px;
            text-align: center;
            transition: transform 0.2s;
            cursor: pointer;
        }
        .recipe:hover {
            transform: scale(1.05);
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
        .latest-recipes-title {
    display: block;
    width: fit-content; /* 요소의 너비를 내용에 맞게 설정 */
    margin: 0 auto; /* 가운데 정렬을 위한 margin 설정 */
    padding: 8px 12px; /* 위아래 8px, 좌우 12px 여백 */
    font-size: 24px;
    font-weight: bold;
    color: #0073e6;
    background-color: #f0f0f0; /* 배경색 */
    border: 2px solid #0073e6; /* 테두리 */
    border-radius: 8px; /* 모서리 둥글기 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 약간의 그림자 효과 */
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

<br>
<div class="latest-recipes-title">최신 레시피</div>
    

<div class="content">
    <%
        // DB 연결 정보
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:XE";
        String uid = "system";
        String pass = "manager";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // JDBC 드라이버 로드
            Class.forName(driver);

            // DB 연결
            conn = DriverManager.getConnection(url, uid, pass);

            // 쿼리 작성
            String sql = "SELECT RecipeID, FoodName, Title, image_path " +
                         "FROM (SELECT RecipeID, FoodName, Title, image_path " +
                               "FROM Recipes " +
                               "ORDER BY RecipeID DESC) " +
                         "WHERE ROWNUM <= 3";

            // 쿼리 실행
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // 결과 출력
            while (rs.next()) {
                int recipeID = rs.getInt("RecipeID");
                String foodName = rs.getString("FoodName");
                String title = rs.getString("Title");
                String imagePath = rs.getString("image_path");

                // 레시피 출력
    %>
                <div class="recipe" onclick="redirectToRecipe(<%= recipeID %>)">
                    <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="업로드된 이미지">
                    <div class="recipe-title"><%= title %></div>
                </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
</div>

</body>
</html>
