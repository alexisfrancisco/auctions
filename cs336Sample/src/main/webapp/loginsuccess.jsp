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

	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		Statement stmt2 = con.createStatement();
		Statement stmt3 = con.createStatement();
		Statement stmt4 = con.createStatement();

		//Get parameters from the HTML form at the HelloWorld.jsp
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String str = "SELECT * FROM user WHERE username = '" + username + "' AND password = '" + password + "'";
		ResultSet result = stmt.executeQuery(str);
		if (session.getAttribute("userName") != null) {
			//do nothing (user already logged in)
		}
		else if(result.next() == false) {
			//not logged in & no credentials
			response.sendRedirect("home.jsp");
		}
		else if(username.equals("admin")) {
			//redirect to admin page
			response.sendRedirect("loginsuccessadmin.jsp");
		}
		else if(result.getByte("isCR") == 1) {
			//redirect to customer representative page
			response.sendRedirect("loginsuccessCR.jsp");
		}
		String userName;
		if (request.getParameter("username") != null) {
			userName = request.getParameter("username");
			userName = userName.substring(0,1).toUpperCase() + userName.substring(1);
			
			session.setAttribute("userName", userName);
		}
		else {
			userName = session.getAttribute("userName").toString();
		}
		result.close();
		
		//wishlist alerts
		str = "SELECT * from wishlist WHERE user = '" + userName + "'";
		result = stmt.executeQuery(str);
		while(result.next() != false) {
			String type = result.getString("type");
			int size = result.getInt("size");
			str = "SELECT * from clothing WHERE type = '" + type + "' AND size = '" + size + "'";
			ResultSet innerResult = stmt2.executeQuery(str);
			if(innerResult.next() != false) {
				out.println("<b>ALERT: The item you previously set an alert for, the " + type + " in size " + size + " are now available.</b>");
				%>
				<br />
				<%
				str = "DELETE from wishlist WHERE type = '" + type + "' AND size = '" + size + "' AND user = '" + userName + "'";
				stmt2.executeUpdate(str);
			}
		}
		result.close();
		
		//auction ending processing
		str = "SELECT * from clothing WHERE close_date < CURRENT_TIMESTAMP AND is_available = 1";
		result = stmt.executeQuery(str);
		while(result.next() != false) {
			int cid = result.getInt("cid");
			str = "UPDATE clothing SET is_available = 0 WHERE cid=" + cid;
			stmt2.executeUpdate(str);
			float current = result.getFloat("current_bid");
			float minimum = result.getFloat("minimum");
			String seller = result.getString("seller");
			String type = result.getString("type");
			int size = result.getInt("size");
			if(current >= minimum) {
				//send notification to seller that item sold
				str = "INSERT INTO alert VALUES ('" + seller + "', 'Your item, the " + type + " in size " + size + " was successfully sold for " + current + "!')";
				stmt2.executeUpdate(str);
						
				//send notification to highest bidder that they won
				String buyer = result.getString("current_bidder");
				str = "INSERT INTO alert VALUES ('" + buyer + "', 'You won the auction for the " + type + " in size " + size + " for " + current + "!')";
				stmt2.executeUpdate(str);
						
				//send notification to other bidders that they were outbid
				str = "SELECT b.buyer FROM bids_on b, clothing c WHERE c.cid = b.cid AND c.cid=" + cid;
				ResultSet innerResult = stmt2.executeQuery(str);
				while (innerResult.next() != false) {
					String bidder = innerResult.getString("buyer");
					if(!bidder.equals(buyer)) {
						str = "INSERT INTO alert VALUES ('" + bidder + "', 'Sorry, you were outbid and lost the auction on the " + type + " in size " + size + ".')";
						stmt3.executeUpdate(str);
					}
				}
				innerResult.close();
			}
			else {
				//send notification to seller that item did not sell
				str = "INSERT INTO alert VALUES ('" + seller + "', 'Your item, the " + type + " in size " + size + " was unfortunately not sold.')";
				stmt2.executeUpdate(str);
				
				//send notification to bidders that they did not reach reserve
				str = "SELECT b.buyer FROM bids_on b, clothing c WHERE c.cid = b.cid AND c.cid=" + cid;
				ResultSet innerResult = stmt2.executeQuery(str);
				while (innerResult.next() != false) {
					String bidder = innerResult.getString("buyer");
					str = "INSERT INTO alert VALUES ('" + bidder + "', 'Sorry, you did not win the " + type + " in size " + size + ".')";
					stmt3.executeUpdate(str);
				}
				innerResult.close();
			}
		}
		result.close();
		
		//Send user end-auction alerts
		str = "SELECT * FROM alert WHERE user = '" + username + "'";
		result = stmt.executeQuery(str);
		while(result.next() != false) {
			String description = result.getString("description");
			out.println("<b>ALERT: " + description + "</b>");
			%>
			<br />
			<%
			str = "DELETE from alert WHERE user = '" + username + "' AND description = '" + description +  "'";
			stmt3.executeUpdate(str);
		}
		
		%>
		<h1 style="text-align:center">Welcome to the Group-34 Auction Page!</h1>
		<br>
			
			<h3 style="text-align:center"> <%=session.getAttribute("userName")%> is logged in!</h3>
			  
			  <div style="text-align:center">
			  <form method="link" action="logout.jsp"> <input type="submit" value="Logout"/> </form>
			  </div>
			  <br>
			  <br>
			  <br>
			  <center>Please click on link below to start an auction for your item.</center>
			  <br>
			  <div style="text-align:center">
			  <form method="link" action="auctions.jsp"> <input type="submit" value="Start an auction!" /></form>
			  </div>
			  <br>
			  <br>
			  <center>Please click on link below to see auction items in the listing.</center>
			  <br>
			  <div style="text-align:center">
			   <form method="link" action="browse.jsp"> <input type="submit" value="Browse items!" /></form>
			  </div>
			  <br>
			  <br>
			  <center>Please click on link below to search all auctions a buyer or seller has participated in.</center>
			  <br>
			  <div style="text-align:center">
			   <form method="link" action="viewuser.jsp"> <input type="submit" value="Search users!" /></form>
			  </div>
			  <br>
			  <br>
			  <br>
			  <br>
			  <h3 style="text-align:center">Do you have any questions?</h3>
			  <div style="text-align:center">
		      <form method="link" action="CustomerServiceUser.jsp"> <input type="submit" value="Ask your questions!" /></form>
		      </div>
			  
			  <%
			  
			  %>
		
		
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
