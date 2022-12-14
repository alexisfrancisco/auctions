<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login Success</title>
</head>
<body style="background-color:#57A6BC;">
<br>
<br>
	<%
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String str = "select sum(current_bid) from clothing where is_available=0";
		ResultSet result = stmt.executeQuery(str);
		
		out.print("<p><strong><font size = '+3'>Total earnings</font></strong></p>");
		
		while(result.next()){
		
			out.print("<font size = '+2'> Total earnings for all concluded auctions: $ " + result.getString(1) + "</font>");
		}
		
		%>
		<br>
		<br>
		<a href='loginsuccessadmin.jsp'> <font size = '+2'> Return to admin homepage! <font size = '+2'> </a>
		
		<%
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
	} catch (Exception ex) {
		out.println(ex);
		out.print("No total earnings found!");
	}
%>
</body>
</html>