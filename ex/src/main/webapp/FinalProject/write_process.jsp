<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // 세션에서 사용자 이름 가져오기
    //HttpSession session = request.getSession(false);
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    
    if (username == null) {
        // 사용자가 로그인하지 않은 경우 로그인 페이지로 리다이렉트
        response.sendRedirect("login.jsp");
        return;
    }

    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (title == null || content == null || title.trim().isEmpty() || content.trim().isEmpty()) {
        // 제목이나 내용이 비어 있는 경우 에러 페이지로 리다이렉트
        response.sendRedirect("error.jsp?msg=제목과 내용을 모두 입력하세요.");
        return;
    }

    Connection connection = null;
    PreparedStatement statement = null;

    try {
        // 데이터베이스 연결 설정
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String uid = "system";
        String upw = "1234";

        Class.forName(driver);
        connection = DriverManager.getConnection(url, uid, upw);

        // SQL 삽입문 작성
        String sql = "INSERT INTO POSTS (username, title, content) VALUES (?, ?, ?)";
        statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        statement.setString(2, title);
        statement.setString(3, content);

        // SQL 실행
        int rows = statement.executeUpdate();

        if (rows > 0) {
            // 글이 성공적으로 작성된 경우 메인 페이지로 리다이렉트
            response.sendRedirect("Main.jsp");
        } else {
            // 글 작성에 실패한 경우 에러 페이지로 리다이렉트
            response.sendRedirect("error.jsp?msg=글 작성에 실패했습니다.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        // 예외가 발생한 경우 에러 페이지로 리다이렉트
        response.sendRedirect("error.jsp?msg=오류가 발생했습니다.");
    } finally {
        try {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
