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
 <p><strong><font size = '+1'>CHOOSE YOUR FILTER TO LIST EARNINGS FOR PER;</font></strong></p>
		<form action="earningper.jsp">
   			<input type="submit" name="button" value="item" />
		</form>
		<br>
		<br>
		<form action="earningper.jsp">
    	 	<input type="submit" name="button" value="item type" />
		</form>
		<br>
		<br>
		<form action="earningper.jsp">
    	 	<input type="submit" name="button" value="users" />
		</form>
		<br> 
		<br>
		
		
		 
	<%
	//List<String> ls = new ArrayList<String>();
	
	
	
		String qr = request.getParameter("button");
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String itemq = "select description, sum(current_bid) as total from clothing  where is_available = 0 and current_bidder IS NOT NULL  group by description order by total desc;";
		String typeq = "select type, sum(current_bid) as total from clothing  where is_available = 0 and current_bidder IS NOT NULL  group by type order by total desc;";
		String userq = "select seller, sum(current_bid) as total from clothing  where is_available = 0 and current_bidder IS NOT NULL  group by seller order by total desc;";

		Statement stmt = con.createStatement();
		if(qr.equals("item")){
			ResultSet rs = stmt.executeQuery(itemq);
			
			out.print("<table>");
			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Product");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Total Amount:");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (rs.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current email:
				out.print(rs.getString("description"));
				out.print("</td>");
				out.print("<td>");
				//Print out number of auctions that user won
				out.print(rs.getString("total"));
				out.print("</td>");
				out.print("</tr>");

			}
			out.print("</table>");
			%>
			<br>
			<br>
			<a href='loginsuccessadmin.jsp'> <font size = '+2'> Return to admin homepage! <font size = '+2'> </a>
			
			<%
		}else if(qr.equals("item type")){
			ResultSet rs = stmt.executeQuery(typeq);
			
			out.print("<table>");
			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Category");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Total Amount:");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (rs.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current email:
				out.print(rs.getString("type"));
				out.print("</td>");
				out.print("<td>");
				//Print out number of auctions that user won
				out.print(rs.getString("total"));
				out.print("</td>");
				out.print("</tr>");

			}
			out.print("</table>");
			%>
			<br>
			<br>
			<a href='loginsuccessadmin.jsp'> <font size = '+2'> Return to admin homepage! <font size = '+2'> </a>
			
			<%
		}else{
			ResultSet rs = stmt.executeQuery(userq);
			
			out.print("<table>");
			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Seller");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Total Amount:");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (rs.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current email:
				out.print(rs.getString("seller"));
				out.print("</td>");
				out.print("<td>");
				//Print out number of auctions that user won
				out.print(rs.getString("total"));
				out.print("</td>");
				out.print("</tr>");
			
			}
		
			out.print("</table>");
			%>
			<br>
			<br>
			<a href='loginsuccessadmin.jsp'> <font size = '+2'> Return to admin homepage! <font size = '+2'> </a>
			
			<%
		}
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
		
	} catch (Exception ex) {
		%>
		<br>
		<br>
		<a href='loginsuccessadmin.jsp'> <font size = '+2'> Return to admin homepage! <font size = '+2'> </a>
		
		<%
	}
%>
</body>
</html>