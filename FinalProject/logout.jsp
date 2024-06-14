<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    session.invalidate();
    response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
%>
