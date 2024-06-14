package com.test.servlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.jdbc.util.DBUtil;

/**
 * Servlet implementation class doMemAdd
 */
@WebServlet("/memAdd.do")
public class MemAdd extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MemAdd() {
		super();
		// TODO Auto-generated constructor stub
	}
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		String memId=request.getParameter("memId");
		String memName=request.getParameter("memName");
		String memEmail=request.getParameter("memEmail");
		try{
			Connection conn=DBUtil.getConnection();
			String strSql="insert into member values(?,?,?)";
			PreparedStatement pstmt=conn.prepareStatement(strSql);
			pstmt.setString(1,memId);
			pstmt.setString(2,memName);
			pstmt.setString(3,memEmail);
			pstmt.executeUpdate();
		}catch(SQLException e){
			//TODOAuto-generatedcatchblock
			e.printStackTrace();
		}
		response.sendRedirect("index.jsp");
	}
	/**
	 *@seeHttpServlet#doPost(HttpServletRequestrequest,HttpServletResponseresponse)
	 */
	protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException,
	IOException{
		//TODOAuto-generatedmethodstub
		doGet(request,response);
	}
}

