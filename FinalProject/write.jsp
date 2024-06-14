<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    /* HttpSession session = request.getSession(false);
     if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return; 
    } */
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글 쓰기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .form-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .write-form {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }
        .write-form input, .write-form textarea {
            display: block;
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
        }
        .write-form input[type="submit"] {
            background-color: #0073e6;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="form-container">
    <form class="write-form" action="write_process.jsp" method="post">
        <input type="text" name="title" placeholder="제목" required>
        <textarea name="content" placeholder="내용" required></textarea>
        <input type="submit" value="작성">
    </form>
</div>

</body>
</html>
