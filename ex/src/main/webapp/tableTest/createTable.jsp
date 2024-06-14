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
	Connection conn = null;
	try {
	Class.forName("oracle.jdbc.driver.OracleDriver");
	String url="jdbc:oracle:thin:@localhost:1521";
	String user = "system";
	String password ="manager";
	conn=DriverManager.getConnection(url,user,password);
	Statement statement = conn.createStatement();
	String command = "CREATE TABLE EMPTEST(ID NUMBER(4),NAME VARCHAR2(50))";
	statement.executeUpdate(command);
	out.println(" 테이블 생성이 완료되었습니다 ");
	} catch(Exception e){
	out.println(e.getMessage());
	}
	%>
</body>
</html>