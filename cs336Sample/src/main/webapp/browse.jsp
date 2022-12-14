<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Browse Auctions</title>
	</head>

	<body style="background-color:#57A6BC;">
<br>
<br>
<br>
	<h1 style="text-align:center">Browse Items!</h1>
	<br>
<br>



		<form method="get" action="browse.jsp">
		<table style="border:0px ;margin-left:auto;margin-right:auto;">
		<tr>
			<td><b>Filter:</b></td>
			
			<td>
			<label for="type">Type</label><br>
			<select name="type">
				<option value="">All</option>
				<option value="tops">Tops</option>
				<option value="jeans">Jeans</option>
				<option value="shoes">Shoes</option>
			</select>&nbsp;<br> 
			</td>
			
			<td>
			<label for="size">Size</label><br>
			<input type="text" name="size"><br>
			</td>
			
			<td> 
			<label for="price">Max Price</label><br>
			<input type="text" name="price"><br>
			</td>
			
		</tr>
		<tr>
			<td><b>Sort:</b></td>
			<td></td>
			
			<td>
			
			<input type="radio" name="sizesort" value="asc">
			<label for="asc">Size: by smallest</label><br>
			
			<input type="radio" name="sizesort" value="desc">
			<label for="asc">Size: by largest</label><br>
			
			</td>
			<td> 
			
			<input type="radio" name="pricesort" value="asc">
			<label for="asc">Price: low to high</label><br>
			
			<input type="radio" name="pricesort" value="desc">
			<label for="asc">Price: high to low</label><br>
			
			</td>
			
			<td><br><input type="submit" value="submit"></td>
		</tr>
		</table>
		</form>
	
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement stmt = con.createStatement();
		Statement stmt2 = con.createStatement(); 
		Statement stmt3 = con.createStatement();
		Statement stmt4 = con.createStatement();
		
		//auction ending processing 
		String stri = "SELECT * from clothing WHERE close_date < CURRENT_TIMESTAMP AND is_available = 1";
		ResultSet resul = stmt.executeQuery(stri); 
		while(resul.next() != false) { 
			int cid = resul.getInt("cid");
			stri = "UPDATE clothing SET is_available = 0 WHERE cid=" + cid;
			stmt2.executeUpdate(stri);
			float current = resul.getFloat("current_bid");
			float minimum = resul.getFloat("minimum");
			String seller = resul.getString("seller");
			String type = resul.getString("type");
			int size = resul.getInt("size");
			if(current >= minimum) { 
				//send notification to seller that item sold
				stri = "INSERT INTO alert VALUES ('" + seller + "', 'Your item, the " + type + " in size " + size + " was successfully sold for " + current + "!')";
				stmt2.executeUpdate(stri);
				//send notification to highest bidder that they won
				String buyer = resul.getString("current_bidder");
				stri = "INSERT INTO alert VALUES ('" + buyer + "', 'You won the auction for the " + type + " in size " + size + " for " + current + "!')";
				stmt2.executeUpdate(stri);
				//send notification to other bidders that they were outbid
				stri = "SELECT b.buyer FROM bids_on b, clothing c WHERE c.cid = b.cid AND c.cid=" + cid;
				ResultSet innerResult = stmt2.executeQuery(stri);
				while (innerResult.next() != false) { 
					String bidder = innerResult.getString("buyer");
					stri = "INSERT INTO alert VALUES ('" + bidder + "', 'Sorry, you were outbid on the " + type + " in size " + size + ".')";
					stmt2.executeUpdate(stri);
				}
				innerResult.close();
			} 
			else {
				//send notification to seller that item did not sell
				stri = "INSERT INTO alert VALUES ('" + seller + "', 'Your item, the " + type + " in size " + size + " was unfortunately not sold.')";
				stmt2.executeUpdate(stri);
				//send notification to bidders that they did not reach reserve
				stri = "SELECT b.buyer FROM bids_on b, clothing c WHERE c.cid = b.cid AND c.cid=" + cid;
				ResultSet innerResult = stmt2.executeQuery(stri);
				while (innerResult.next() != false) { 
					String bidder = innerResult.getString("buyer");
					stri = "INSERT INTO alert VALUES ('" + bidder + "', 'Sorry, you did not win the " + type + " in size " + size + ".')";
					stmt2.executeUpdate(stri);
				} 
				innerResult.close();
			} 
		}
		
		// Get parameters
		String type = request.getParameter("type");
		String size = request.getParameter("size");
		String price = request.getParameter("price");
		
		String sizesort = request.getParameter("sizesort");
		String pricesort = request.getParameter("pricesort");

		
		// Convert empty strings to null
		if (type == "") type = null;
		if (size == "") size = null;
		if (price == "") price = null;
		
		// Base statement
		String str = "SELECT * FROM clothing WHERE is_available = 1";
		
		// Append type
  		if (type != null) str =  str.concat(" AND type = '" + type + "'");	
		
		//Append size
		if(size != null) str =  str.concat(" AND size = '" + size + "'");

		// Append price
		if(price != null ) str =  str.concat(" AND GREATEST(current_bid, initial_price) <= '" + price + "'");
		
	
		// Append ORDER BY	
		if(sizesort != null){
			if (sizesort.equals("asc")) str = str.concat(" ORDER BY size");
			if (sizesort.equals("desc")) str = str.concat(" ORDER BY size DESC");
		}
		
		if(sizesort != null && pricesort != null){
			if (pricesort.equals("asc")) str = str.concat(", GREATEST(current_bid, initial_price)");
			if (pricesort.equals("desc")) str = str.concat(", GREATEST(current_bid, initial_price) DESC");
		}
		
		if(sizesort == null && pricesort != null){
			if(pricesort.equals("asc")) str = str.concat(" ORDER BY GREATEST(current_bid, initial_price)");
			if(pricesort.equals("desc")) str = str.concat(" ORDER BY GREATEST(current_bid, initial_price) DESC");
		}
		
		ResultSet result = stmt3.executeQuery(str);
 		
		
 		out.print("<table style=\"border:0px ;margin-left:auto;margin-right:auto;\">");
		
		out.print("<tr>");
			
		out.print("<td>");
		out.print("<b> ID </b> ");
		out.print("</td>");
		
		out.print("<td>");
		out.print("<b> Category </b> ");
		out.print("</td>");

		out.print("<td>");
		out.print("<b> Size </b>");
		out.print("</td>");
		
		out.print("<td>");
		out.print("<b> Description </b>");
		out.print("</td>");
		
		out.print("<td>");
		out.print("<b> Current Price </b>");
		out.print("</td>");
		
 		while (result.next()) {

			out.print("<tr>");
			
			out.print("<td>");
			out.print(result.getInt("cid"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(result.getString("type"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(result.getInt("size"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(result.getString("description"));
			out.print("</td>");
			
			out.print("<td>");
			if(result.getFloat("current_bid") == 0) out.print("$" + result.getFloat("initial_price"));
			else out.print("$" + result.getFloat("current_bid"));
			out.print("</td>");

			out.print("</tr>");

		}
		out.print("</table>");  

	%>
	<br>
	<center><form method="get" action="viewitem.jsp">
		<label for="cid">View Bid History | Bid on Item</label><br>
		<input type="text" name="cid" placeholder="enter item ID">
		<input type="submit" value="view item">
	</form></center>
	
	
	<br> 
	
	<center><div title="Alerts will appear on your homescreen!">Can't find an item you want? Get an alert when it becomes available.</div></center>
	<center><form method="get" action="browse.jsp"></center>
		<table style="border:0px ;margin-left:auto;margin-right:auto;">
		<tr>
			<td>
			<label for="type_w">Type</label><br>
			<select name="type_w">
				<option value="tops">Tops</option>
				<option value="jeans">Jeans</option>
				<option value="shoes">Shoes</option>
			</select>&nbsp;<br> 
			</td>
			
			<td>
			<label for="size_w">Size</label><br>
			<input type="text" name="size_w" placeholder="enter an integer" pattern="[0-9]+"><br>
			</td>
			
			<td> <br> <input type="submit" value="Add to wishlist"> </td>
		</tr>
		</table>
	</form>
	
	<%	// Add to wishlist
		boolean insertSuccess = false;
		String type_w = request.getParameter("type_w");
		String size_w = request.getParameter("size_w");
		if (size_w == "") size_w = null;

		
		
 		try{
			if(size_w != null){
				
				String user = request.getSession().getAttribute("userName").toString();
				String str2 = "INSERT INTO wishlist VALUES ('" + user + "', '" + type_w + "', " + size_w + ")";
				stmt4.executeUpdate(str2);
				
				insertSuccess = true;
				
			}
		}catch (Exception ex) {
			out.print("This is already on your wishlist!");
		}
		
		if(insertSuccess) out.println("Item added to wishlist");  
		
		con.close();
	%>
	</br>
	<center> <form method="link" action="loginsuccess.jsp"> <input type="submit" value="Go back"/> </form> </center>
	</br>
	</body>
</html>
