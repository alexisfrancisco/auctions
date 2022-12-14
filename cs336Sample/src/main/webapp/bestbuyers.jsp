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
<style>
	
	table, td {
  		border: 1px solid black;
  		font-size: 20px;
  		padding: 5px;
  		border-collapse: collapse;
	}
</style>
<body style="background-color:#57A6BC;">
<br>
<br>
	<%
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		out.print("<p><strong><font size = '+3'>Best Buyers</font></strong></p>");

		String str1 = "select current_bidder, count(current_bidder) as count from clothing  where is_available = 0 and current_bidder IS NOT NULL  group by current_bidder order by count desc;";
		ResultSet rs = stmt.executeQuery(str1);
		
		out.print("<p><strong><font size = '+3'>");
		//Make an HTML table to show the results in:
		out.print("<table>");
		
		//make a row
		out.print("<tr>");
		//make a column
		out.print("<td>");
		//print out column header
		out.print("<p><font size = '+2'> Username: </font></p>");
		out.print("</td>");
		//make a column
		out.print("<td>");
		out.print("<p><font size = '+2'> # of auctions won: </font></p>");
		out.print("</td>");
		out.print("</tr>");

		//parse out the results
		while (rs.next()) {
			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//Print out current username:
			out.print(rs.getString("current_bidder"));
			out.print("</td>");
			out.print("<td>");
			//Print out number of auctions that user won
			out.print(rs.getString("count"));
			out.print("</td>");
			out.print("</tr>");

		}
		out.print("</table>");
		
		
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