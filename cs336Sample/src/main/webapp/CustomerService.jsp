<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Service</title>
</head>
<body style="background-color:#57A6BC;">
	<b>Unanswered Questions:</b>
	<br />
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		String replyqid = request.getParameter("replyqid");
		String reply = request.getParameter("response");
		
		if (replyqid != null && reply != null) {
			String str = "UPDATE customer_service SET answer = '" + reply + "' WHERE qid = " + replyqid;
			stmt.executeUpdate(str);
			out.println("Reply success!");
			%>
			<br />
			<br />
			<%
		}
		
		int qid;
		String user;
		String question;
		
		String str = "SELECT * FROM customer_service WHERE answer IS NULL";
		ResultSet result = stmt.executeQuery(str);
		if(result.next() == false) {
			out.println("No unanswered questions!");
			%>
			</br>
			<%
		} else {
			qid = result.getInt("qid");
			user = result.getString("user");
			question = result.getString("question");
			out.println("qid: " + qid + ", user: " + user + ", question: " + question + ".");
			while(result.next() != false) {
				%>
				</br>
				<%
				qid = result.getInt("qid");
				user = result.getString("user");
				question = result.getString("question");
				out.println("qid: " + qid + ", user: " + user + ", question: " + question + ".");
			}
			%>
			<br />
			<br />
			Reply to question:
			<br />
			<form method="get" action="CustomerService.jsp">
				<table>
					<tr>    
						<td>Question ID</td><td><input type="text" name="replyqid"></td>
					</tr>
					<tr>    
						<td>Reply</td><td><input type="text" name="response"></td>
					</tr>
				</table>
				<input type="submit" value="reply to user!">
			</form>
			<br />
			<%
		}
		
		
			
		%>
		</br>
		<form method="link" action="loginsuccessCR.jsp"> <input type="submit" value="Go back"/> </form>
		<br />
		<form method="link" action="logout.jsp"> <input type="submit" value="Logout"/> </form>
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
