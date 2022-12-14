<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Auction Item</title>
	</head>

	<body style="background-color:#57A6BC;">
	
		<%
		boolean insertSuccess = false;
		
		try {
			
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			String type = request.getParameter("type");
			String size = request.getParameter("size");
			String description = request.getParameter("description");
			String initPrice = request.getParameter("init_price");
			String minPrice = request.getParameter("minimum");
			String closeDate = request.getParameter("close_date");
			String increment = request.getParameter("increment");
			
			
			// checks if logged in or if no attributes were submitted
			if(request.getSession().getAttribute("userName")== null || description == null) {
				//no parameters passed
			}
			else {
				String seller = request.getSession().getAttribute("userName").toString();
				
				String str = "INSERT INTO clothing VALUES ('" + seller + "', 0, '" + 
				type + "', '" + size + "', '" + initPrice + "', 0.00, '" + 
				closeDate + "', '" + increment + "', '" + 
				minPrice +"', '" + description + "', 1, default)";
				
				stmt.executeUpdate(str);
				insertSuccess= true;

				}
			} catch (Exception ex) {
				out.println(ex);
				out.print("Insert failed!");
			}
			
		%>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<h1 style="text-align:center">Create a New Auction!</h1>
	<br>
		<h3 style="text-align:center"> <%=session.getAttribute("userName")%>'s New Item Information</h3>
		<div style="text-align:center">
		<form method="get" action="auctions.jsp">
			
			<table style="border:0px ;margin-left:auto;margin-right:auto;">
				<tr>
					<td>Type</td><td>
					<select name="type" size=1>
						<option value="tops">Tops</option>
						<option value="jeans">Jeans</option>
						<option value="shoes">Shoes</option>
					</select>&nbsp;<br> 
					
					
					</td>
				</tr>
				
				<tr>
					<td>Size</td><td><input type="text" name="size"></td>
					
				</tr>
				<tr>
				
					<td>Description</td><td><input type="text" name="description"></td>
				</tr>
				<tr>
					<td>Initial Price</td><td><input type="text" name="init_price"></td>
				</tr>
				<tr>
				
					<td>Minimum Price</td><td><input type="text" name="minimum"></td>
				</tr>
				<tr>    
					<td>Close Date</td><td><input type="datetime-local" name="close_date"></td>
				</tr>
				<tr>    
					<td>Increment</td><td><input type="text" name="increment"></td>
				</tr>
			</table>
			<br>
			<br>
			<br>
			<input type="submit" value="Auction Item!">
			<br>
			<br>
			<br>
		</form>
		<form method="link" action="loginsuccess.jsp"> <input type="submit" value="Go back"/> </form>
		<br>
		<br>
		<form method="link" action="logout.jsp"> <input type="submit" value="Log Out"/> </form>
		</div>
	<br>
	<div style="text-align:center">
	<% 
	if(insertSuccess)
		out.println("Thank you for submitting an auction, " + session.getAttribute("userName") + "!"); 
	%>
	</div>

</body>
</html>
