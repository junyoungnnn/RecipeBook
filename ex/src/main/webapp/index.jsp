<%@page import="java.sql.*"%>
<%@page import="com.jdbc.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<p>Welcom to Member Managerment System!</p>
	<%
	Connection conn = DBUtil.getConnection();
	Statement stmt = conn.createStatement();
	String strSql = "SELECT MEM_ID FROM MEMBER";
	ResultSet rs = stmt.executeQuery(strSql);
	%>
	<table border="1" style="width: 100%">
		<thead>
			<th>Member Id</th>
			<th>Member Name</th>
			<th>Member Email</th>
		</thead>
		<tbody>
			<%
			String memId;
			String memName;
			String memEmail;
			while (rs.next()) {
				memId = rs.getString("mem_id");
				memName = rs.getString("mem_name");
				memEmail = rs.getString("mem_email");
			%>
			<tr align="center">
				<td><%=memId%></td>
				<td><%=memName%></td>
				<td><%=memEmail%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<br />
	<a href="<%=request.getContextPath()%>/mem_add.jsp">Add New</a>
	<br />
</body>
</html>
