<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    String currentUrl = request.getRequestURL().toString();
    if (request.getQueryString() != null) {
        currentUrl += "?" + request.getQueryString();
    }
    session.setAttribute("lastVisitedPage", currentUrl);

    String username = (session != null) ? (String) session.getAttribute("username") : null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>레시피 찾기</title>
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
        .search-bar {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        .search-bar input[type="text"] {
            width: 300px;
            padding: 10px;
            font-size: 16px;
        }
        .search-bar input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #0073e6;
            color: white;
            border: none;
            cursor: pointer;
        }
        .results {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            margin: 20px;
        }
        .results .recipe {
            width: 45%;
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            text-align: center;
            transition: transform 0.3s;
        }
        .results .recipe:hover {
            transform: scale(1.05);
        }
        .recipe .image-container {
            width: 100%;
            height: 400px;
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
    </style>
    <script>
        function navigateToDetail(recipeID) {
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
        } else {
        %>
            <a href="login.jsp">로그인</a>
            <a href="registerForm01.jsp">회원가입</a>
        <% 
        }
        %>
    </div>
</div>

<div class="search-bar">
    <form action="search.jsp" method="get">
        <input type="text" name="query" placeholder="검색 바">
        <input type="submit" value="찾기">
    </form>
</div>

<div class="results">
<%
    String query = request.getParameter("query");
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String uid = "system";
        String upw = "manager";
        
        connection = DriverManager.getConnection(url, uid, upw);
        
        String sql;
        if (query != null && !query.trim().isEmpty()) {
            sql = "SELECT * FROM RECIPES WHERE FOODNAME LIKE ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, "%" + query + "%");
        } else {
            sql = "SELECT * FROM RECIPES";
            statement = connection.prepareStatement(sql);
        }
        
        resultSet = statement.executeQuery();
        
        while (resultSet.next()) {
            String recipeID = resultSet.getString("RECIPEID");
            String foodName = resultSet.getString("FOODNAME");
            String title = resultSet.getString("TITLE");
            String imagePath = resultSet.getString("image_path");
%>
            <div class="recipe" onclick="navigateToDetail('<%= recipeID %>')">
                <h3><%= foodName %></h3>
                <div class="image-container">
                    <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="업로드된 이미지">
                </div>
                <p><%= title %></p>
            </div>
<%
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
%>
</div>

</body>
</html>
