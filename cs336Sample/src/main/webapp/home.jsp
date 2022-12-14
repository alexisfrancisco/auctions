<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login</title>
	</head>

	<% 
	// set username to null (logged out)
	request.getSession().setAttribute("userName", null);
	request.getSession().setAttribute("passWord", null);
	%>

	
	<body style="background-color:#57A6BC;">
	
	<center><img id = "center" src='https://scarletknights.com/images/2020/6/23/R_S_B_W.png?width=1000' 
	height='200' 
	width='200' 
	></center>
	
	<h1 style="text-align:center">Welcome to the Group-34 Auction Page!</h1>
	<br>
	<div style="text-align:center">
	<h3>Login</h3>
		<form method="post" action="loginsuccess.jsp">
			<table style="border:0px ;margin-left:auto;margin-right:auto;">
				<tr>    
					<td>Username</td><td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password</td><td><input type="password" name="password"></td>
				</>
			</table>
			<br>
			<input type="submit" value="Login!">
		</form>
	<br>
	
	</br>
	<h3>Register</h3>
		<form method="get" action="register.jsp">
			<table style="border:0px ;margin-left:auto;margin-right:auto;">
				<tr>    
					<td>Username</td><td><input type="text" name="username"></td>
				</tr>
				<tr>    
					<td>Name</td><td><input type="text" name="name"></td>
				</tr>
				<tr>    
					<td>Password</td><td><input type="text" name="password"></td>
				</tr>
				<tr>
					<td>Address</td><td><input type="text" name="address"></td>
				</>
			</table>
			<br>
			<input type="submit" value="Create Account (please login after redirect)!">
		</form>
	<br>
</div>
</body>
</html>
