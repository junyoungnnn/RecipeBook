<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 웹 서버의 실제 디렉토리를 가져옵니다.
    String directory = application.getRealPath("/images");
    int sizeLimit = 10 * 1024 * 1024; // 10MB 제한

    // 디렉토리가 존재하지 않으면 생성
    File uploadDir = new File(directory);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }

    MultipartRequest multi = new MultipartRequest(
        request,
        directory,
        sizeLimit,
        "UTF-8",
        new DefaultFileRenamePolicy()
    );

    Enumeration enumeration = multi.getFileNames();
    String fileName = null;
    if (enumeration.hasMoreElements()) {
        fileName = (String) enumeration.nextElement();
    }

    String imagePath = null;
    if (fileName != null) {
        String uploadedFileName = multi.getFilesystemName(fileName);
        imagePath = "images/" + uploadedFileName; // 웹 경로로 설정
    }
%>
<html>
<head>
    <title>사진 받아옴</title>
</head>
<body>
    <h1>업로드된 이미지</h1>
    <% if (imagePath != null) { %>
        <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="업로드된 이미지"><br>
        <p>경로: <%= imagePath %></p>
    <% } %>
    
    <%-- 데이터베이스에 이미지 경로 저장 --%>
    <%
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "manager");

            // 이미지 경로를 데이터베이스에 저장
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO IMAGES (image_path) VALUES (?)");
            pstmt.setString(1, imagePath);
            pstmt.executeUpdate();
            pstmt.close();

            // 데이터베이스에서 이미지 경로를 조회하여 이미지 표시
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT image_path FROM IMAGES");

            while (rs.next()) {
                String dbImagePath = rs.getString("image_path");
    %>
    <h1>데이터베이스에서 불러온 이미지</h1>
    <img src="<%= request.getContextPath() + "/" + dbImagePath %>" alt="데이터베이스에서 불러온 이미지"><br>
    <p>경로: <%= dbImagePath %></p>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("이미지 로드 실패: " + e);
        }
    %>
</body>
</html>
