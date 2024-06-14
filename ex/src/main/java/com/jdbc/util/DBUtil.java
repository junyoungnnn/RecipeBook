package com.jdbc.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil{
	private static final String URL="jdbc:oracle:thin:@localhost:1521:xe";
	private static final String USER="system";
	private static final String PASSWORD="manager";
	
	private static Connection conn=null;
	
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn=DriverManager.getConnection(URL, USER, PASSWORD);
		}catch(ClassNotFoundException e) {
			e.printStackTrace();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static Connection getConnection() {
		return conn;
	}
}