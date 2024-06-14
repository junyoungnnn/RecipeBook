<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
Class.forName("oracle.jdbc.driver.OracleDriver");
String url="jdbc:oracle:thin:@localhost:1521";
String user ="system";
String password ="manager";
Connection conn=DriverManager.getConnection(url,user,password);
out.print(" 데이타 베이스 연결 성공 했습니다 ");

%>
</body>
</html>