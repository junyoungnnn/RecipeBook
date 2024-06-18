<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>레시피 삭제</title>
</head>
<body>
<%
    String recipeID = request.getParameter("recipeID");
    String userID = (String) session.getAttribute("sessionUserId");

    if (recipeID == null || userID == null) {
        out.println("<h3>잘못된 접근입니다.</h3>");
    } else {
        Connection conn = null;
        PreparedStatement pstmtRecipe = null;
        PreparedStatement pstmtRecipeIngredient = null;
        String url = "jdbc:oracle:thin:@localhost:1521:XE";
        String uid = "system";
        String pass = "manager";

        try {
            // (1 단계) JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // (2 단계) 데이터베이스 연결 객체 생성
            conn = DriverManager.getConnection(url, uid, pass);

            // (3 단계) 트랜잭션 시작
            conn.setAutoCommit(false);

            // (4 단계) RecipeIngredients 테이블에서 해당 레시피의 모든 행 삭제
            String sqlDeleteRecipeIngredients = "DELETE FROM RecipeIngredients WHERE RecipeID = ?";
            pstmtRecipeIngredient = conn.prepareStatement(sqlDeleteRecipeIngredients);
            pstmtRecipeIngredient.setString(1, recipeID);
            int rowsAffectedRecipeIngredients = pstmtRecipeIngredient.executeUpdate();

            // (5 단계) Recipes 테이블에서 해당 레시피 삭제
            String sqlDeleteRecipe = "DELETE FROM Recipes WHERE RecipeID = ? AND UserID = ?";
            pstmtRecipe = conn.prepareStatement(sqlDeleteRecipe);
            pstmtRecipe.setString(1, recipeID);
            pstmtRecipe.setString(2, userID);
            int rowsAffectedRecipe = pstmtRecipe.executeUpdate();

            if (rowsAffectedRecipe > 0) {
                // (6 단계) 트랜잭션 커밋
                conn.commit();
                out.println("<h3>레시피가 성공적으로 삭제되었습니다.</h3>");
            } else {
                out.println("<h3>레시피 삭제에 실패했습니다. 삭제할 레시피가 없거나, 권한이 없습니다.</h3>");
            }
        } catch (Exception e) {
            // (7 단계) 오류 발생 시 트랜잭션 롤백
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            out.println("<h3>레시피 삭제 중 오류가 발생했습니다: " + e.getMessage() + "</h3>");
        } finally {
            // (8 단계) 사용한 리소스 해제
            try {
                if (pstmtRecipeIngredient != null) pstmtRecipeIngredient.close();
                if (pstmtRecipe != null) pstmtRecipe.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<%
		response.sendRedirect("myRecipes.jsp");
%>

</body>
</html>
