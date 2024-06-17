<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.javalec.ex.RecipeBean.RecipeBean" %>
<%@ page import="com.javalec.ex.RecipeBean.IngredientBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>레시피 상세보기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
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
        .recipe-detail {
            max-width: 700px;
            margin: 40px auto;
            padding: 20px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            background-color: #fff;
            border-radius: 10px;
            position: relative;
        }
        .recipe-detail img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
        }
        .recipe-title {
            font-size: 28px;
            font-weight: bold;
            margin-top: 10px;
            color: #333;
        }
        .ingredient-links {
            margin-top: 5px;
        }
        .ingredient-links a {
            display: inline-block;
            margin: 5px 5px 5px 0;
            padding: 10px 15px;
            background-color: #0073e6;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.3s;
            font-size: 14px;
        }
        .ingredient-links a:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }
        .back-button {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background-color: #0073e6;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s, transform 0.3s;
        }
        .back-button:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<div class="menu">
    <div>
        <a href="Main.jsp">홈</a>
        <a href="search.jsp">레시피 찾기</a>
        <% 
        String username = (String) session.getAttribute("username");
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
    		out.println(username + "님 환영합니다");
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

<%
    String recipeID = request.getParameter("recipeID");
    if (recipeID != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String url = "jdbc:oracle:thin:@localhost:1521:XE";
        String uid = "system";
        String pass = "manager";

        RecipeBean recipe = null;
        List<IngredientBean> ingredients = new ArrayList<>();

        try {
            // (1 단계) JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // (2 단계) 데이터베이스 연결 객체 생성
            conn = DriverManager.getConnection(url, uid, pass);

            // (3 단계) 레시피 상세 정보를 가져오는 SQL 쿼리 작성
            String sql = "SELECT r.UserID, r.RecipeID, r.FoodName, r.Title, r.Description, r.Image_path, i.IngredientName, ri.Quantity " +
                         "FROM Recipes r " +
                         "JOIN RecipeIngredients ri ON r.RecipeID = ri.RecipeID " +
                         "JOIN Ingredients i ON ri.IngredientID = i.IngredientID " +
                         "WHERE r.RecipeID = ?";

            // (4 단계) PreparedStatement 생성 및 값 설정
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, recipeID);

            // (5 단계) SQL 실행
            rs = pstmt.executeQuery();

            while (rs.next()) {
                if (recipe == null) {
                    recipe = new RecipeBean();
                    recipe.setRecipeID(rs.getInt("RecipeID"));
                    recipe.setUserID(rs.getString("UserID"));
                    recipe.setFoodName(rs.getString("FoodName"));
                    recipe.setTitle(rs.getString("Title"));
                    recipe.setDescription(rs.getString("Description"));
                    recipe.setImage_path(rs.getString("Image_path"));
                }
                IngredientBean ingredient = new IngredientBean();
                ingredient.setIngredientName(rs.getString("IngredientName"));
                ingredient.setQuantity(rs.getString("Quantity"));
                ingredients.add(ingredient);
            }
            if (recipe != null) {
                recipe.setIngredients(ingredients);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>레시피를 가져오는 중 오류가 발생했습니다.</h3>");
        } finally {
            // (6 단계) 사용한 리소스 해제
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
%>


<%
if (recipe != null) {
%>
    <div class="recipe-detail">
        <div class="recipe-title"><%= recipe.getTitle() %></div>
        <p>작성자ID: <%= recipe.getUserID() %></p>
        <p>음식 이름: <%= recipe.getFoodName() %></p>
        <img src="<%= request.getContextPath() + "/" + recipe.getImage_path() %>" alt="업로드된 이미지">
        <h4>재료:</h4>
        <ul>
        <%
            for (IngredientBean ingredient : recipe.getIngredients()) {
        %>
            <li>
                <p><%= ingredient.getIngredientName() %> - <%= ingredient.getQuantity() %></p>
                <div class="ingredient-links">
                    <a href="https://www.coupang.com/np/search?component=&q=<%= ingredient.getIngredientName() %>&channel=user">쿠팡에서 구매하기</a>
                    <a href="https://search.shopping.naver.com/search/all?query=<%= ingredient.getIngredientName() %>">네이버에서 구매하기</a>
                </div>
            </li>
        <%
            }
        %>
        </ul>
        
        <h4>내용:</h4>
        <p><%= recipe.getDescription().replaceAll("\\n", "<br>") %></p>
        <a href="javascript:history.back()" class="back-button">목록</a>
    </div>
<%
} else {
    out.println("<h3>레시피를 찾을 수 없습니다.</h3>");
} 
} else {
    out.println("<h3>잘못된 접근입니다.</h3>");
}
%>
</body>
</html>
