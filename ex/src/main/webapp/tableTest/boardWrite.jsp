<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="member" class="BoardBean.boardMember" />
<jsp:setProperty name="member" property="*" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>입력 완료된 정보</h2>
	<table>
		<tr>
			<td>작성자</td>
			<td><jsp:getProperty name="member" property="name" /></td>
		</tr>
		<tr>
			<td>비밀번호</td>
			<td><jsp:getProperty name="member" property="pass" /></td>
		</tr>
		<tr>
			<td>이메일</td>
			<td><jsp:getProperty name="member" property="email" /></td>
		</tr>
		<tr>
			<td>글제목</td>
			<td><jsp:getProperty name="member" property="title" /></td>
		</tr>
		<tr>
			<td>글내용</td>
			<td><jsp:getProperty name="member" property="content" /></td>
		</tr>
	</table>
</body>
</html>