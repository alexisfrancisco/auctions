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
	<b>Customer Service:</b>
	<br />
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		int qid;
		String qidquery = "SELECT MAX(qid) as qid FROM customer_service";
		ResultSet qidresult = stmt.executeQuery(qidquery);
		if(qidresult.next() == false) {
			qid = 1;
		}
		else {
			qid = qidresult.getInt("qid") + 1;
		}
		
		
		String user = request.getParameter("user");
		String question = request.getParameter("question");
		String search = request.getParameter("search");
		if (search != null) {
			String str = "SELECT * FROM customer_service WHERE question LIKE '%" + search + "%'";
			ResultSet result = stmt.executeQuery(str);
			%>
			<br />
			<br />
			Search results:
			<br />
			<%
			int count = 0;
			while (result.next() != false) {
				count++;
				int allqid = result.getInt("qid");
				String alluser = result.getString("user");
				String allquestion = result.getString("question");
				String allanswer = result.getString("answer");
				if (allanswer == null) {
					out.println("qid: " + allqid + ", user: " + alluser + ", question: " + allquestion + ", answer: No answer yet.");
				}
				else {
					out.println("qid: " + allqid + ", user: " + alluser + ", question: " + allquestion + ", answer: " + allanswer +".");
				}
			}
			if (count==0) {
				out.println("There are no results for your query");
			}
			%>
			<br />
			<br />
			<%
		}
		else if (question != null && user.equals("")) {
			String str = "INSERT INTO customer_service VALUES (" + qid + ", 'anonymous', '" + question + "', NULL)";
			stmt.executeUpdate(str);
			out.println("Question successfully asked!");
			%>
			<br />
			<br />
			<%
		}
		else if (question != null) {
			String str = "INSERT INTO customer_service VALUES (" + qid + ", '" + user + "', '" + question + "', NULL)";
			stmt.executeUpdate(str);
			out.println("Question successfully asked!");
			%>
			<br />
			<br />
			<%
		}
		
		int allqid;
		String alluser;
		String allquestion;
		String allanswer;
		
		%>
		All questions:
		</br>
		<%
		String str = "SELECT * FROM customer_service";
		ResultSet result = stmt.executeQuery(str);
		if(result.next() == false) {
			out.println("No questions so far! Be the first one to ask one?");
			%>
			</br>
			<%
		} else {
			allqid = result.getInt("qid");
			alluser = result.getString("user");
			allquestion = result.getString("question");
			allanswer = result.getString("answer");
			if (allanswer == null) {
				out.println("qid: " + allqid + ", user: " + alluser + ", question: " + allquestion + ", answer: No answer yet.");
			}
			else {
				out.println("qid: " + allqid + ", user: " + alluser + ", question: " + allquestion + ", answer: " + allanswer +".");
			}
			while(result.next() != false) {
				%>
				</br>
				<%
				allqid = result.getInt("qid");
				alluser = result.getString("user");
				allquestion = result.getString("question");
				allanswer = result.getString("answer");
				if (allanswer == null) {
					out.println("qid: " + allqid + ", user: " + alluser + ", question: " + allquestion + ", answer: No answer yet.");
				}
				else {
					out.println("qid: " + allqid + ", user: " + alluser + ", question: " + allquestion + ", answer: " + allanswer +".");
				}
			}
		}
		
		
			
		%>
		<br />
		<br />
		Ask a question:
		<br />
		<form method="get" action="CustomerServiceUser.jsp">
			<table>
				<tr>    
					<td>Question</td><td><input type="text" name="question"></td>
				</tr>
				<tr>    
					<td>Name (blank for anonymous)</td><td><input type="text" name="user"></td>
				</tr>
			</table>
			<input type="submit" value="ask a question!">
		</form>
		<br />
		<br />
		Search for questions already asked:
		<br />
		<form method="get" action="CustomerServiceUser.jsp">
			<table>
				<tr>    
					<td>Search:</td><td><input type="text" name="search"></td>
				</tr>
			</table>
			<input type="submit" value="search for a question!">
		</form>
		<br />
		</br>
		<form method="link" action="loginsuccess.jsp"> <input type="submit" value="Go back"/> </form>
		</br>
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
