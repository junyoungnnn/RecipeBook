<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 업로드 및 DB 저장</title>
</head>
<body>
    <form action="DBfileupload_process.jsp" method="post" enctype="multipart/form-data">
        이미지 선택: <input type="file" name="file"><br>
        <input type="submit" value="업로드">
    </form>
    <img src="C:/Users/njo43/OneDrive/바탕 화면/ex/src/main/webapp/FinalProject/images/image.jpg">
</body>
</html>
