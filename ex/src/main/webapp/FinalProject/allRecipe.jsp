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
<html>
<head>
<meta charset="UTF-8">
<title>모든 레시피 보기</title>
</head>
<body>
<h2>저장된 모든 레시피</h2>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String uid = "system";
    String pass = "manager";

    List<RecipeBean> recipes = new ArrayList<>();

    try {
        // (1 단계) JDBC 드라이버 로드
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // (2 단계) 데이터베이스 연결 객체 생성
        conn = DriverManager.getConnection(url, uid, pass);

        // (3 단계) 모든 레시피와 재료를 가져오는 SQL 쿼리 작성
        String sql = "SELECT r.UserID, r.RecipeID, r.FoodName, r.Title, r.Description, i.IngredientName, ri.Quantity " +
                     "FROM Recipes r " +
                     "JOIN RecipeIngredients ri ON r.RecipeID = ri.RecipeID " +
                     "JOIN Ingredients i ON ri.IngredientID = i.IngredientID " +
                     "ORDER BY r.RecipeID";

        // (4 단계) PreparedStatement 생성
        pstmt = conn.prepareStatement(sql);

        // (5 단계) SQL 실행
        rs = pstmt.executeQuery();

        RecipeBean currentRecipe = null;
        int currentRecipeID = -1;
        List<IngredientBean> ingredients = null;

        while (rs.next()) {
            int recipeID = rs.getInt("RecipeID");
            if (recipeID != currentRecipeID) {
                if (currentRecipe != null) {
                    currentRecipe.setIngredients(ingredients);
                    recipes.add(currentRecipe);
                }
                currentRecipeID = recipeID;
                currentRecipe = new RecipeBean();
                ingredients = new ArrayList<>();
                currentRecipe.setRecipeID(recipeID);
                currentRecipe.setUserID(rs.getString("UserID"));
                currentRecipe.setFoodName(rs.getString("FoodName"));
                currentRecipe.setTitle(rs.getString("Title"));
                currentRecipe.setDescription(rs.getString("Description"));
            }
            IngredientBean ingredient = new IngredientBean();
            ingredient.setIngredientName(rs.getString("IngredientName"));
            ingredient.setQuantity(rs.getString("Quantity"));
            ingredients.add(ingredient);
        }
        if (currentRecipe != null) {
            currentRecipe.setIngredients(ingredients);
            recipes.add(currentRecipe);
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>데이터를 가져오는 중 오류가 발생했습니다.</h3>");
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
    for (RecipeBean recipe : recipes) { 
%>
    <h3>레시피 ID: <%= recipe.getRecipeID() %></h3>
    <p>작성자ID: <%= recipe.getUserID() %></p>
    <p>음식 이름: <%= recipe.getFoodName() %></p>
    <p>제목: <%= recipe.getTitle() %></p>
    <p>내용: <%= recipe.getDescription() %></p>
    <h4>재료:</h4>
    
    <ul>
    <% 
        for (IngredientBean ingredient : recipe.getIngredients()) { 
    %>
        <li><%= ingredient.getIngredientName() %> - <%= ingredient.getQuantity() %></li>
    <% 
        } 
    %>
    </ul>
    
<%  for(int i =0; i<150; i++) out.print("-");
	

    } 
%>
<br>
<a href="Main.jsp">메인</a>
</body>
</html>
