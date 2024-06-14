<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%!Connection connection;
	PreparedStatement preparedStatement;
	ResultSet resultSet;

	String driver = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String uid = "system";
	String upw = "manager";%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PreparedStatement 사용 예제</title>
</head>
<body>
	<%
	try {
		Class.forName(driver);
		connection = DriverManager.getConnection(url, uid, upw);
		int n;
		String query = "insert into memberpre(id, pw, name, phone) values (?, ?, ?, ?)";
		preparedStatement = connection.prepareStatement(query);

		preparedStatement.setString(1, "aa");
		preparedStatement.setString(2, "123");
		preparedStatement.setString(3, " 성유리 ");
		preparedStatement.setString(4, "010-1234-5678");
		n = preparedStatement.executeUpdate();

		preparedStatement.setString(1, "bb");
		preparedStatement.setString(2, "456");
		preparedStatement.setString(3, " 이효리 ");
		preparedStatement.setString(4, "010-9012-3456");
		n = preparedStatement.executeUpdate();

		preparedStatement.setString(1, "cc");
		preparedStatement.setString(2, "789");
		preparedStatement.setString(3, " 강호동 ");
		preparedStatement.setString(4, "010-7890-1234");
		n = preparedStatement.executeUpdate();
		preparedStatement.setString(1, "dd");
		preparedStatement.setString(2, "111");
		preparedStatement.setString(3, " 옥주현 ");
		preparedStatement.setString(4, "010-1234-1111");
		n = preparedStatement.executeUpdate();

		if (n == 1) {
			out.println("insert success");
		} else {
			out.println("insert fail");
		}

	} catch (Exception e) {
		out.println(" 오류 : " + e.getMessage());
	} finally {
		try {
			if (resultSet != null)
		resultSet.close();
			if (preparedStatement != null)
		preparedStatement.close();
			if (connection != null)
		connection.close();
		} catch (Exception e) {
		}
	}
	%>
</body>
</html>

