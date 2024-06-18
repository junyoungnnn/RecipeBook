<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="com.javalec.ex.RecipeBean.RecipeBean"%>
<%@ page import="com.javalec.ex.RecipeBean.IngredientBean"%>
<%@ page import="com.javalec.ex.RecipeBean.ReviewBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

.review-form {
	margin-top: 40px;
	padding: 20px;
	background-color: #f9f9f9;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.review-form h3 {
	margin-bottom: 20px;
}

.review-form textarea {
	width: 100%;
	height: 100px;
	padding: 10px;
	border-radius: 5px;
	border: 1px solid #ccc;
	margin-bottom: 10px;
}

.review-form input[type="number"] {
	width: 100px;
	padding: 10px;
	border-radius: 5px;
	border: 1px solid #ccc;
	margin-bottom: 10px;
}

.review-form input[type="submit"] {
	background-color: #0073e6;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.review-form input[type="submit"]:hover {
	background-color: #005bb5;
}

.review-item {
	border: 1px solid #ccc;
	padding: 10px;
	margin-bottom: 10px;
	border-radius: 5px;
	background-color: #fff;
}

.review-item p {
	margin: 5px 0;
}

.review-item form {
	display: inline;
}

.delete-button {
	background-color: #e74c3c;
	color: white;
	padding: 5px 10px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	float: right;
}

.delete-button:hover {
	background-color: #c0392b;
}

.stars {
	color: #FFD700;
	font-size: 16px;
}
</style>
</head>
<body>
	<div class="menu">
		<div>
			<a href="Main.jsp">홈</a> <a href="search.jsp">레시피 찾기</a>
			<%
			String username = (String) session.getAttribute("username");
			String userID = (String) session.getAttribute("sessionUserId");
			if (username != null) {
			%>
			<a href="writeRecipeForm01.jsp">글 쓰기</a>
			<%
			}
			%>
		</div>
		<div>
			<%
			if (username != null) {
				out.println("<span style='color: white;'>" + username + "님 환영합니다</span>");
			%>
			<a href="myRecipes.jsp">내 레시피</a> <a href="logout.jsp">로그아웃</a>
			<%
			} else {
			%>
			<a href="login.jsp">로그인</a> <a href="registerForm01.jsp">회원가입</a>
			<%
			}
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
		List<ReviewBean> reviews = new ArrayList<>();

		try {
			// (1 단계) JDBC 드라이버 로드
			Class.forName("oracle.jdbc.driver.OracleDriver");

			// (2 단계) 데이터베이스 연결 객체 생성
			conn = DriverManager.getConnection(url, uid, pass);

			// (3 단계) 레시피 상세 정보를 가져오는 SQL 쿼리 작성
			String sql = "SELECT r.UserID, r.RecipeID, r.FoodName, r.Title, r.Description, r.Image_path, i.IngredientName, ri.Quantity "
			+ "FROM Recipes r " + "JOIN RecipeIngredients ri ON r.RecipeID = ri.RecipeID "
			+ "JOIN Ingredients i ON ri.IngredientID = i.IngredientID " + "WHERE r.RecipeID = ?";

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

			// (6 단계) 리뷰 가져오기
			sql = "SELECT ReviewID, UserID, Rating, ReviewText, CreateAt FROM Reviews WHERE RecipeID = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, recipeID);
			rs = pstmt.executeQuery();

			while (rs.next()) {
		ReviewBean review = new ReviewBean();
		review.setReviewID(rs.getInt("ReviewID"));
		review.setUserID(rs.getString("UserID"));
		review.setRating(rs.getInt("Rating"));
		review.setReviewText(rs.getString("ReviewText"));
		review.setCreateAt(rs.getTimestamp("CreateAt"));
		reviews.add(review);
			}

		} catch (Exception e) {
			e.printStackTrace();
			out.println("<h3>레시피를 가져오는 중 오류가 발생했습니다.</h3>");
		} finally {
			// (7 단계) 사용한 리소스 해제
			try {
		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();
		if (conn != null)
			conn.close();
			} catch (Exception e) {
		e.printStackTrace();
			}
		}
	%>

	<%
	if (recipe != null) {
	%>
	<div class="recipe-detail">
		<div class="recipe-title"><%=recipe.getTitle()%></div>
		<p>
			작성자ID:
			<%=recipe.getUserID()%></p>
		<p>
			음식 이름:
			<%=recipe.getFoodName()%></p>
		<img
			src="<%=request.getContextPath() + "/" + recipe.getImage_path()%>"
			alt="업로드된 이미지">
		<h4>재료:</h4>
		<ul>
			<%
			for (IngredientBean ingredient : recipe.getIngredients()) {
			%>
			<li>
				<p><%=ingredient.getIngredientName()%>
					-
					<%=ingredient.getQuantity()%></p>
				<div class="ingredient-links">
					<a
						href="https://www.coupang.com/np/search?component=&q=<%=ingredient.getIngredientName()%>&channel=user">쿠팡에서
						구매하기</a> <a
						href="https://search.shopping.naver.com/search/all?query=<%=ingredient.getIngredientName()%>">네이버에서
						구매하기</a>
				</div>
			</li>
			<%
			}
			%>
		</ul>

		<h4>내용:</h4>
		<p><%=recipe.getDescription().replaceAll("\\n", "<br>")%></p>

		<h4>리뷰:</h4>
		<%
		if (reviews.isEmpty()) {
			out.println("<p>리뷰가 없습니다.</p>");
		} else {
			for (ReviewBean review : reviews) {
		%>
		<div class="review-item">
			<p>
				작성자ID: <%=review.getUserID()%> | 작성일: <%=review.getCreateAt()%>
			<p class="stars">
				<strong style="color: black;">평점:</strong>
				<% for (int i = 0; i < review.getRating(); i++) {	%>
				★
				<% } for (int i = review.getRating(); i < 5; i++) {	%>
				☆
				<% } %>
			</p>
			<% if(username != null && userID.equals(review.getUserID())) { %>
			<form action="deleteReview.jsp" method="post"	onsubmit="return confirm('정말로 삭제하시겠습니까?');">
				<input type="hidden" name="reviewID" value="<%=review.getReviewID()%>"> 
					<input type="hidden" name="recipeID" value="<%=recipeID%>">
				<button type="submit" class="delete-button">삭제</button>
			</form>
			<%
			}
			%>
			<p><%=review.getReviewText().replaceAll("\\n", "<br>")%></p>


		</div>
		<%
		}
		}
		%>

		<%
		if (username != null) {
		%>
		<div class="review-form">
			<h3>리뷰 작성하기</h3>
			<form action="submitReview.jsp" method="post" accept-charset="UTF-8">
				<input type="hidden" name="recipeID" value="<%=recipeID%>">
				<input type="hidden" name="userID" value="<%=userID%>"> <label
					for="rating">평점 (1-5):</label> <input type="number" id="rating"
					name="rating" min="1" max="5" required> <br> <label
					for="ReviewText">댓글:</label>
				<textarea id="ReviewText" name="ReviewText" required></textarea>
				<br> <input type="submit" value="제출">
			</form>
		</div>
		<%
		}
		%>

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
