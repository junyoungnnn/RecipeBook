<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2 style="position: relative; left: 200px">게시판 글쓰기</h2>

	<form method="post" action="boardWrite.jsp"
		style="position: absolute; left: 200px">

		<fieldset style="width: 500px">
			<table>
				<tr>
					<td style="background-color: lightgray">작성자</td>
					<td><input type="text" name="name" size="20"></td>
				</tr>
				<tr>
					<td style="background-color: lightgray">비밀번호</td>
					<td><input type="password" name="pass" size="20"></td>
				</tr>
				<tr>
					<td style="background-color: lightgray">이메일</td>
					<td><input type="text" name="email" size="30"></td>
				</tr>
				<tr>
					<td style="background-color: lightgray">글 제목</td>
					<td><input type="text" name="title" size="45"></td>
				</tr>
				<tr>
					<td style="background-color: lightgray">글 내용</td>
					<td><textarea name="content" cols="50" rows="10" wrap="soft"
							style="overflow: visible"></textarea></td>
				</tr>
			</table>
		</fieldset>

		<input type="submit" value="등록"
			style="position: absolute; left: 200px"> <input type="reset"
			value="다시작성" style="position: absolute; left: 250px">
	</form>
</body>
</html>