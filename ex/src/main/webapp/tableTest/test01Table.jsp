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
	Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521", "system", "manager");
	Statement statement = connection.createStatement();
	ResultSet resultset = statement.executeQuery("select * from TEST02");
	%>
	<h2>test02 table 의 내용을 출력해 보자</h2>
	<TABLE BORDER="1">
		<TR>
			<TH>NO</TH>
			<TH>NAME</TH>
			<TH>HDATE</TH>
		</TR>
		<%
		while (resultset.next()) {
		%>
		<TR>
			<TD><%=resultset.getInt(1)%></TD>
			<TD><%=resultset.getString(2)%></TD>
			<TD><%=resultset.getString(3)%></TD>
		</TR>
		<%
		}
		%>
	</TABLE>

</body>
</html>