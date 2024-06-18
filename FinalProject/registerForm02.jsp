<%@ page import="com.javalec.ex.MemberBean.MemberBean" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.javalec.ex.PasswordUtil.PasswordUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
		request.setCharacterEncoding("UTF-8");
%>
<%! 
    Connection conn = null;
    PreparedStatement pstmt = null;
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String uid = "system";
    String pass = "manager";
    String sql = "INSERT INTO Users (UserID, Username, Email, Password, CreateAt) VALUES (?, ?, ?, ?, ?)";
%>
<jsp:useBean id="member" class="com.javalec.ex.MemberBean.MemberBean" scope="request" />
<jsp:setProperty name="member" property="*" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 처리</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        background-color: #f0f0f0;
        text-align: center;
    }
    h3 {
        color: #0073e6;
    }
    h2 {
        margin-top: 20px;
        color: #333;
    }
    table {
        width: 50%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    td {
        padding: 10px;
        border: 1px solid #ccc;
    }
    .button-container {
        margin: 20px;
    }
    .button-container a {
        display: inline-block;
        padding: 10px 20px;
        margin: 10px;
        color: white;
        background-color: #0073e6;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    .button-container a:hover {
        background-color: #005bb5;
    }
</style>
</head>
<body>
<%

    // 자바빈즈 객체에 폼 데이터 설정
    member.setCreateAt(new Timestamp(System.currentTimeMillis()));
    
    // 비밀번호 암호화
    String hashedPassword = PasswordUtil.hashPassword(member.getPassword());
    member.setPassword(hashedPassword);

    try {
        // (1 단계) JDBC 드라이버 로드
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // (2 단계) 데이터베이스 연결 객체 생성
        conn = DriverManager.getConnection(url, uid, pass);

        // (3 단계) PreparedStatement 객체 생성 및 값 설정
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, member.getUserid());
        pstmt.setString(2, member.getUsername());
        pstmt.setString(3, member.getEmail());
        pstmt.setString(4, member.getPassword());
        pstmt.setTimestamp(5, member.getCreateAt());

        // (4 단계) SQL 문을 실행하여 결과 처리
        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.println("<h3>회원가입이 성공적으로 완료되었습니다!</h3>");
        } else {
            out.println("<h3>회원가입에 실패하였습니다.</h3>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>회원가입 중 오류가 발생했습니다.</h3>");
    } finally {
        // (5 단계) 사용한 리소스 해제
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<h2>입력 완료된 회원 정보</h2>
<table>
<tr>
    <td>아이디</td>
    <td><jsp:getProperty name="member" property="userid" /></td>
</tr>
<tr>
    <td>이름</td>
    <td><jsp:getProperty name="member" property="username" /></td>
</tr>
<tr>
    <td>이메일</td>
    <td><jsp:getProperty name="member" property="email" /></td>
</tr>
<tr>
    <td>비밀번호</td>
    <td>********</td> <!-- 암호화된 비밀번호는 출력하지 않음 -->
</tr>
<tr>
    <td>가입시간</td>
    <td><jsp:getProperty name="member" property="createAt" /></td>
</tr>
</table>
<div class="button-container">
    <a href="Main.jsp">홈으로 돌아가기</a>
</div>
</body>
</html>
