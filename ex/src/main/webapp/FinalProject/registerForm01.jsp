<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"], button {
            background-color: #0073e6;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        input[type="submit"]:hover, button:hover {
            background-color: #005bb5;
        }
    </style>
    <script>
        function redirectToMain() {
            window.location.href = 'Main.jsp';
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>회원가입</h2>
        <form method="post" action="registerForm02.jsp" accept-charset="UTF-8">
            <table>
                <tr>
                    <td>아이디</td>
                    <td><input type="text" name="userid" size="20" required></td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td><input type="text" name="username" size="50" required></td>
                </tr>
                <tr>
                    <td>이메일</td>
                    <td><input type="email" name="email" size="50" required></td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                    <td><input type="password" name="password" size="20" required></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <input type="submit" value="회원가입">
                        <button type="button" onclick="redirectToMain()">취소</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
