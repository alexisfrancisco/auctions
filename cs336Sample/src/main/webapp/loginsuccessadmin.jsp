<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Login Success</title>
</head>
<body style="background-color:#57A6BC;">
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		String CRusername = request.getParameter("CRusername");
		String name = request.getParameter("name");
		String CRpassword = request.getParameter("CRpassword");
		String address = request.getParameter("address");
		if(CRusername == null) {
			//no parameters passed
		}
		else {
			String str = "INSERT INTO user VALUES ('" + CRusername + "', '" + name + "', '" + CRpassword + "', '"  + address + "', 1)";
			stmt.executeUpdate(str);
			out.println("Insert success!");
			%>
			<br />
			<br />
			<%
		}
		%>
		
		
		<br />
		<%
		out.println("<center><p style = \"color:black; font-size:30px; font-weight:bold; \" >You are logged in as Admin!</p></center>");		
		%>
		
		<% 
				out.println("<center><p style = \"color:black; font-size:22px; \" >Create new customer representative account:</p></center>");	
		%>
		<br />
		<center><form method="get" action="loginsuccessadmin.jsp">
			<table>
				<tr>    
					<td>Rep. username</td><td><input type="text" name="CRusername"></td>
				</tr>
				<tr>    
					<td>Rep. name</td><td><input type="text" name="name"></td>
				</tr>
				<tr>    
					<td>Rep. password</td><td><input type="text" name="CRpassword"></td>
				</tr>
				<tr>
					<td>Rep. address</td><td><input type="text" name="address"></td>
				</>
			</table>
			<input type="submit" value="create account!">
		</form></center>
		<br />
		<br />
		<center><b>Click here to see the total earnings!<b></center>
		<br />
		<br />
		<center><form method="link" action="totalearnings.jsp"> <input type="submit" value="Total Earnings"/> </form></center>
		<br />
		<br />
		<br />
		<center><b>Click here to see the best buyers!<b></center>
		
		<br />
		<br />
		<center><form method="link" action="bestbuyers.jsp"> <input type="submit" value="Best Buyers"/> </form></center>
		<br />
		<br />
		<br />
		<center><b>Click here to see the best selling items!<b></center>
		
		<br />
		<br />
		<center><form method="link" action="bestselling.jsp"> <input type="submit" value="Best Selling Items"/> </form></center>
		<br />
		<br />
		<br />
		<center><b>Click here to see the earnings for per item, item type, and user!<b></center>
		<br />
		<br />
		<center><form method="link" action="earningper.jsp"> <input type="submit" value="Earnings for per item, item type, and user"/> </form></center>
		<br />
		<br />
		<br />
		
		<center><form method="link" action="logout.jsp"> <input type="submit" value="Logout"/> </form></center>
		<%

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
	} catch (Exception ex) {
		out.println(ex);
		out.print("Insert failed!");
	}
%>
</body>
</html>
