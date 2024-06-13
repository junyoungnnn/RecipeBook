<%@ page import="com.javalec.ex.MemberBean.MemberBean" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.javalec.ex.PasswordUtil.PasswordUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

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
<a href="registerForm01.jsp">다시 시도하기</a>
<a href="allMembers.jsp">회원 목록 보기</a>
</body>
</html>
