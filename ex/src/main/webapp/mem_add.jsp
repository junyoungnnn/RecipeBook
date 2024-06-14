<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<p>Add a new member!</p>
	<form action="<%=request.getContextPath()%>/memAdd.do" method="post">
		Member ID: <input type="text" name="memId" /><br /> Member Name: <input
			type="text" name="memName" /><br /> Member Email: <input type="text"
			name="memEmail" /><br /> <input type="submit" value="Add" />
	</form>
</body>
</html>