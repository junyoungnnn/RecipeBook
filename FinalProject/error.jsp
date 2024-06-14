<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>에러</title>
</head>
<body>
    <h1>에러가 발생했습니다</h1>
    <p><%= request.getParameter("msg") %></p>
    <a href="javascript:history.back()">이전 페이지로 돌아가기</a>
</body>
</html>
