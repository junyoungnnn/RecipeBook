<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
        }
        .login-container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
            width: 300px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background: white;
        }
        .login-container h2 {
            margin: 0 0 30px 0;
            text-align: center;
            color: #333;
            font-size: 24px;
        }
        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 2px solid #ddd;
            border-radius: 3px;
            box-sizing: border-box;
        }
        .login-container input[type="submit"],
        .login-container button {
            width: 100%;
            padding: 12px;
            background-color: #0073e6;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px; /* 버튼 간의 간격 추가 */
        }
        .login-container input[type="submit"]:hover,
        .login-container button:hover {
            background-color: #003d80;
        }
        .error-message {
            color: #d8000c;
            background-color: #ffbaba;
            border-radius: 4px;
            padding: 10px;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
    <script>
        function redirectToMain() {
            window.location.href = 'Main.jsp';
        }
    </script>
</head>
<body>

<div class="login-container">
    <h2>로그인</h2>
    <% if (request.getParameter("error") != null) { %>
        <div class="error-message">잘못된 사용자 이름 또는 비밀번호입니다.</div>
    <% } %>
    <form action="login_process.jsp" method="post">
        <input type="text" name="userid" placeholder="사용자 ID" required>
        <input type="password" name="password" placeholder="비밀번호" required>
        <input type="submit" value="로그인">
    </form>
    <button type="button" onclick="redirectToMain()">Home</button>
</div>

</body>
</html>
