<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    	String username = (String)session.getAttribute("username");
    	
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

<div class="content">
    <div class="recipe">
    	<a href="https://www.10000recipe.com/">
        <img src="images/image1.png" alt="레시피 이미지">
        </a>
        <div class="recipe-title">레시피 제목 1</div>
    </div>
    <div class="recipe">
        <img src="path/to/your/image2.jpg" alt="레시피 이미지">
        <div class="recipe-title">레시피 제목 2</div>
    </div>
    <div class="recipe">
        <img src="path/to/your/image3.jpg" alt="레시피 이미지">
        <div class="recipe-title">레시피 제목 3</div>
    </div>
</div>

</body>
</html>
