<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%! 
    Connection conn = null;
    PreparedStatement pstmtRecipe = null;
    PreparedStatement pstmtIngredient = null;
    PreparedStatement pstmtRecipeIngredient = null;
    ResultSet rs = null;
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String uid = "system";
    String pass = "manager";
    String sqlRecipe = "INSERT INTO Recipes (RecipeID, UserID, FoodName, Title, Description) VALUES (recipe_seq.NEXTVAL, ?, ?, ?, ?)";
    String sqlIngredient = "SELECT IngredientID FROM Ingredients WHERE IngredientName = ?";
    String sqlInsertIngredient = "INSERT INTO Ingredients (IngredientID, IngredientName) VALUES (ingredient_seq.NEXTVAL, ?)";
    String sqlRecipeIngredient = "INSERT INTO RecipeIngredients (RecipeID, IngredientID, Quantity) VALUES (?, ?, ?)";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 저장</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    // 세션에서 userid 가져오기
    String userID = (String) session.getAttribute("sessionUserId");

    if (userID == null || userID.trim().isEmpty()) {
        out.println("<h3>사용자 ID를 찾을 수 없습니다. 다시 로그인해 주세요.</h3>");
    } else {
        String foodName = request.getParameter("foodName");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String[] ingredientNames = request.getParameterValues("ingredientName");
        String[] quantities = request.getParameterValues("quantity");

        int recipeID = 0;

        try {
            // (1 단계) JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // (2 단계) 데이터베이스 연결 객체 생성
            conn = DriverManager.getConnection(url, uid, pass);

            // (3 단계) 레시피 데이터 삽입
            pstmtRecipe = conn.prepareStatement(sqlRecipe, new String[] { "RecipeID" });
            pstmtRecipe.setString(1, userID);
            pstmtRecipe.setString(2, foodName);
            pstmtRecipe.setString(3, title);
            pstmtRecipe.setString(4, description);
            pstmtRecipe.executeUpdate();

            // 생성된 레시피 ID 가져오기
            rs = pstmtRecipe.getGeneratedKeys();
            if (rs.next()) {
                recipeID = rs.getInt(1);
            }

            // (4 단계) 재료 삽입 또는 기존 재료 ID 가져오기 및 RecipeIngredients 테이블에 데이터 삽입
            for (int i = 0; i < ingredientNames.length; i++) {
                if (ingredientNames[i] != null && !ingredientNames[i].trim().isEmpty()) {
                    int ingredientID = 0;
                    // 기존 재료 ID 가져오기
                    pstmtIngredient = conn.prepareStatement(sqlIngredient);
                    pstmtIngredient.setString(1, ingredientNames[i].trim());
                    rs = pstmtIngredient.executeQuery();
                    if (rs.next()) {
                        ingredientID = rs.getInt("IngredientID");
                    } else {
                        // 재료 삽입
                        pstmtIngredient = conn.prepareStatement(sqlInsertIngredient, new String[] { "IngredientID" });
                        pstmtIngredient.setString(1, ingredientNames[i].trim());
                        pstmtIngredient.executeUpdate();
                        rs = pstmtIngredient.getGeneratedKeys();
                        if (rs.next()) {
                            ingredientID = rs.getInt(1);
                        }
                    }

                    // RecipeIngredients 테이블에 데이터 삽입
                    pstmtRecipeIngredient = conn.prepareStatement(sqlRecipeIngredient);
                    pstmtRecipeIngredient.setInt(1, recipeID);
                    pstmtRecipeIngredient.setInt(2, ingredientID);
                    pstmtRecipeIngredient.setString(3, quantities[i].trim());
                    pstmtRecipeIngredient.executeUpdate();
                }
            }

            out.println("<h3>레시피가 성공적으로 저장되었습니다!</h3>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>레시피 저장 중 오류가 발생했습니다.</h3>");
        } finally {
            // (7 단계) 사용한 리소스 해제
            try {
                if (rs != null) rs.close();
                if (pstmtRecipe != null) pstmtRecipe.close();
                if (pstmtIngredient != null) pstmtIngredient.close();
                if (pstmtRecipeIngredient != null) pstmtRecipeIngredient.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<a href="allRecipe.jsp">레시피 모두 보기</a>
</body>
</html>
