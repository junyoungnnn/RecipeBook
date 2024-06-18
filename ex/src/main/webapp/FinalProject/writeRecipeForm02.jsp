<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
		request.setCharacterEncoding("UTF-8");
%>
<%! 
    Connection conn = null;
    PreparedStatement pstmtRecipe = null;
    PreparedStatement pstmtIngredient = null;
    PreparedStatement pstmtRecipeIngredient = null;
    ResultSet rs = null;
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String uid = "system";
    String pass = "manager";
    String sqlRecipe = "INSERT INTO Recipes (RecipeID, UserID, FoodName, Title, Description, image_path) VALUES (recipe_seq.NEXTVAL, ?, ?, ?, ?, ?)";
    String sqlIngredient = "SELECT IngredientID FROM Ingredients WHERE IngredientName = ?";
    String sqlInsertIngredient = "INSERT INTO Ingredients (IngredientID, IngredientName) VALUES (ingredient_seq.NEXTVAL, ?)";
    String sqlRecipeIngredient = "INSERT INTO RecipeIngredients (RecipeID, IngredientID, Quantity) VALUES (?, ?, ?)";
%>
<% 
    String directory = application.getRealPath("/images");
    int sizeLimit = 10*1024*1024; // 10MB 제한
    
    MultipartRequest multi = new MultipartRequest(
        request,
        directory,
        sizeLimit,
        "UTF-8",
        new DefaultFileRenamePolicy()
    );
    
    Enumeration enumeration = multi.getFileNames();
    String fileName = null;
    if (enumeration.hasMoreElements()) {
        fileName = (String) enumeration.nextElement();
    }
    
    String imagePath = null;
    if (fileName != null) {
        String uploadedFilePath = multi.getFilesystemName(fileName);
        imagePath = "images/" + uploadedFilePath;
    }

    String foodName = multi.getParameter("foodName");
    String title = multi.getParameter("title");
    String description = multi.getParameter("description");
    String[] ingredientNames = multi.getParameterValues("ingredientName");
    String[] quantities = multi.getParameterValues("quantity");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 저장</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        text-align: center;
    }
    .image-container {
        width: 300px;
        height: 300px;
        margin: 20px auto;
        overflow: hidden;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .image-container img {
        width: 100%;
        height: auto;
        object-fit: cover;
    }
    .button-container {
        margin: 20px;
    }
    .button-container a {
        display: inline-block;
        padding: 10px 20px;
        margin: 10px;
        color: white;
        background-color: #0073e6;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    .button-container a:hover {
        background-color: #005bb5;
    }
</style>
</head>
<body>
<%

    // 세션에서 userid 가져오기
    String userID = (String) session.getAttribute("sessionUserId");

    if (userID == null || userID.trim().isEmpty()) {
        out.println("<h3>사용자 ID를 찾을 수 없습니다. 다시 로그인해 주세요.</h3>");
    } else {
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
            pstmtRecipe.setString(5, imagePath);
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
            if (imagePath != null) {
%>
                <div class="image-container">
                    <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="업로드된 이미지">
                </div>
<%
            }
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
<div class="button-container">
    <a href="search.jsp">레시피 모두 보기</a>
    <a href="Main.jsp">홈으로 돌아가기</a>
</div>
</body>
</html>
