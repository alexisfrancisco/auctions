<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View User</title>
</head>
<body style="background-color:#57A6BC;">
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		String username = request.getParameter("username");
		  %>
		  <br>
		   <br>
		    <br>
		    <br>
		     <br>
		      <br>
		       <br>
		        <br>
		         <br>
		          <br>
		           <br>
		  <% 
		if (username != null) {
			out.println("<center><b>User " + username + ":</b></center>");
			%>
			<br />
			<br>
			<%
			String str = "SELECT type, size, description, current_bid FROM clothing WHERE seller = '" + username + "' AND is_available = 0";
			ResultSet result = stmt.executeQuery(str);
			while(result.next() != false) {
				String type = result.getString("type");
				int size = result.getInt("size");
				String description = result.getString("description");
				float current_bid = result.getFloat("current_bid");
				if (current_bid != 0) {
					out.println("<center>Sold: " + type + ", size: " + size + ", description: " + description + ", price: $" + current_bid + "</center>");
				}
			}
			str = "SELECT c.type, c.size, c.description, b.amount FROM bid_history b, clothing c WHERE c.cid = b.cid AND b.user = '" + username + "' ORDER BY b.amount DESC";
			result = stmt.executeQuery(str);
			out.println("<br>");
			out.println("<br>");
			
			
			while(result.next() != false) {
				String type = result.getString("c.type");
				int size = result.getInt("c.size");
				String description = result.getString("c.description");
				float current_bid = result.getFloat("b.amount");
				out.println("<center>Bid on: " + type + ", size: " + size + ", description: " + description + ", bid: $" + current_bid + "</center");
				break;
			}
			%>
			<br />
			<br />
			<%
		}	
		%>
		<br />
		<br />
		<% 
				out.println("<center><p style = \"color:black; font-size:30px; font-weight:bold; \" >Search a user:</p></center>");		
		%>
		<br />
		<center><form method="get" action="viewuser.jsp">
			<table>
				<tr>    
					<td>Username: </td><td><input type="text" name="username"></td>
				</tr>
			</table>
			<br>
			<br>
			<input type="submit" value="search a user!">
		</form></center>
		<br />
		<center><form method="link" action="loginsuccess.jsp"> <input type="submit" value="Go back"/> </form></center>
		<%

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
	} catch (Exception ex) {
		out.println(ex);
		out.print("User not found!");
	}
%>
</body>
</html>
