<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Representative Login Success</title>
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

		String OGusername = request.getParameter("OGusername");
		String username = request.getParameter("username");
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String address = request.getParameter("address");
		String bidCID = request.getParameter("bidCID");
		String auctionCID = request.getParameter("auctionCID");
		String bidUSER = request.getParameter("bidUSER");
		if (bidCID != null && bidUSER != null) {
			String str = "DELETE from bids_on WHERE buyer = '" + bidUSER + "' AND cid ='" + bidCID + "'";
			int tot = stmt.executeUpdate(str);
			if (tot == 1) {
				out.println("Bid successfully removed!");
			}
			else if (tot == 0) {
				out.println("Bid removal unsuccessful...");
			}
			else if (tot > 1) {
				out.println("More than one deleted, oh no!");
			}
			str = "SELECT user FROM bid_history WHERE cid = " + bidCID + " ORDER BY amount DESC";
			ResultSet result = stmt.executeQuery(str);
			result.next();
			if(result.getString("user").equals(bidUSER)) {
				if (result.next() == false) {
					str = "UPDATE clothing SET current_bidder=null WHERE cid = " + bidCID;
					stmt2.executeUpdate(str);
				}
				else {
					String prevbidder = result.getString("user");
					str = "UPDATE clothing SET current_bidder='" + prevbidder + "' WHERE cid = " + bidCID;
					stmt2.executeUpdate(str);
				}
			}
			
			%>
			<br />
			<br />
			<%
		}
		else if (auctionCID != null) {
			String str = "DELETE from bid_history WHERE cid =" + auctionCID;
			stmt.executeUpdate(str);
			str = "DELETE from bids_on WHERE cid =" + auctionCID;
			stmt.executeUpdate(str);
			str = "DELETE from clothing WHERE cid =" + auctionCID;
			int tot = stmt.executeUpdate(str);
			if (tot == 1) {
				out.println("Auction successfully removed!");
			}
			else if (tot == 0) {
				out.println("Auction removal unsuccessful...");
			}
			else if (tot > 1) {
				out.println("More than one deleted, oh no!");
			}
			%>
			<br />
			<br />
			<%
		}
		else if(OGusername == null) {
			//no parameters passed
		}
		else {
			if(username != null) {
				String str = "UPDATE user SET username = '" + username + "' WHERE username = '" + OGusername + "'";
				int tot = stmt.executeUpdate(str);
				if (tot == 1) {
					out.println("Account successfully updated!");
				}
				else if (tot == 0) {
					out.println("Account not found!");
				}
				else if (tot > 1) {
					out.println("More than one updated, oh no!");
				}
			}
			else if(name != null) {
				String str = "UPDATE user SET name = '" + name + "' WHERE username = '" + OGusername + "'";
				int tot = stmt.executeUpdate(str);
				if (tot == 1) {
					out.println("Account successfully updated!");
				}
				else if (tot == 0) {
					out.println("Account not found!");
				}
				else if (tot > 1) {
					out.println("More than one updated, oh no!");
				}
			}
			else if(password != null) {
				String str = "UPDATE user SET password = '" + password + "' WHERE username = '" + OGusername + "'";
				int tot = stmt.executeUpdate(str);
				if (tot == 1) {
					out.println("Account successfully updated!");
				}
				else if (tot == 0) {
					out.println("Account not found!");
				}
				else if (tot > 1) {
					out.println("More than one updated, oh no!");
				}
			}
			else if(address != null) {
				String str = "UPDATE user SET address = '" + address + "' WHERE username = '" + OGusername + "'";
				int tot = stmt.executeUpdate(str);
				if (tot == 1) {
					out.println("Account successfully updated!");
				}
				else if (tot == 0) {
					out.println("Account not found!");
				}
				else if (tot > 1) {
					out.println("More than one updated, oh no!");
				}
			}
			else if (username == null && name == null && password == null && address == null) {
				String str = "DELETE from user WHERE username = '" + OGusername + "'";
				int tot = stmt.executeUpdate(str);
				if (tot == 1) {
					out.println("Account successfully deleted!");
				}
				else if (tot == 0) {
					out.println("Account not found!");
				}
				else if (tot > 1) {
					out.println("More than one deleted, oh no!");
				}
			}
			%>
			<br />
			<br />
			<%
		}
		out.println("<b><i>Hello: Customer Representative</b></i>");
			
		%>
		<br />
		<br />
		<strong>Delete bids/auctions:</strong>
		<br />
		<br />
		Delete bid:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Bidder username: </td><td><input type="text" name="bidUSER"></td>
				</tr>
				<tr>    
					<td>Auction cid: </td><td><input type="text" name="bidCID"></td>
				</tr>
			</table>
			<input type="submit" value="delete bid!">
		</form>
		<br />
		Delete auction:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Auction cid: </td><td><input type="text" name="auctionCID"></td>
				</tr>
			</table>
			<input type="submit" value="delete auction!">
		</form>
		<br />
		<br />
		<strong>Edit user info:</strong>
		<br />
		<br />
		Edit user username:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Account username (cannot be blank)</td><td><input type="text" name="OGusername"></td>
				</tr>
				<tr>    
					<td>Updated username</td><td><input type="text" name="username"></td>
				</tr>
			</table>
			<input type="submit" value="edit username!">
		</form>
		<br />
		Edit user's name:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Account username (cannot be blank)</td><td><input type="text" name="OGusername"></td>
				</tr>
				<tr>    
					<td>Updated name</td><td><input type="text" name="name"></td>
				</tr>
			</table>
			<input type="submit" value="edit name!">
		</form>
		<br />
		Edit user's password:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Account username (cannot be blank)</td><td><input type="text" name="OGusername"></td>
				</tr>
				<tr>    
					<td>Updated password</td><td><input type="text" name="password"></td>
				</tr>
			</table>
			<input type="submit" value="edit password!">
		</form>
		<br />
		Edit user address:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Account username (cannot be blank)</td><td><input type="text" name="OGusername"></td>
				</tr>
				<tr>    
					<td>Updated address</td><td><input type="text" name="address"></td>
				</tr>
			</table>
			<input type="submit" value="edit address!">
		</form>
		<br />
		Delete user:
		<br />
		<form method="get" action="loginsuccessCR.jsp">
			<table>
				<tr>    
					<td>Account username (cannot be blank)</td><td><input type="text" name="OGusername"></td>
				</tr>
			</table>
			<input type="submit" value="delete user!">
		</form>
		<br />
		<form method="link" action="CustomerService.jsp"> <input type="submit" value="Go to Customer Service page!"/> </form>
		<br />
		<form method="link" action="logout.jsp"> <input type="submit" value="Logout"/> </form>
		<%

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
	} catch (Exception ex) {
		out.println(ex);
		out.print("Edit failed!");
	}
%>
</body>
</html>
