<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>driver test</title>
</head>
<body>
	<h2>jdbc드라이버 테스트</h2>
	<%
	Class.forName("oracle.jdbc.driver.OracleDriver");
	out.println("드라이버 로딩 성공");
	%>
</body>
</html>