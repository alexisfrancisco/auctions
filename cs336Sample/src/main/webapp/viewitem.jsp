<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="ISO-8859-1">
	<title>Item Bidding/History</title>
	</head>
	
	<body style="background-color:#57A6BC;">
	<br>
<br>
<br>
	<h1 style="text-align:center">Place a Bid!</h1>
	<br>
	<% 
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement stmt = con.createStatement();
		
		String cid = request.getParameter("cid");
		
		if (cid == null) {
			cid = request.getSession().getAttribute("cid").toString();
		}
		else {
			request.getSession().setAttribute("cid", cid);
		}
		String anon = request.getParameter("anon");
		if (anon == null) anon = "0";
		
		// Get info from cid
 		String str2 = "SELECT * FROM clothing WHERE cid = " + cid;
		ResultSet result2 = stmt.executeQuery(str2);
		result2.next();
		String type = result2.getString("type");
		int size = result2.getInt("size"); 
		String desc = result2.getString("description"); 
		String starting = result2.getString("initial_price");
		String increment = result2.getString("increment");
		String prevBidder = result2.getString("current_bidder");
		// float values
		float initPrice = result2.getFloat("initial_price");
		float currentBid = result2.getFloat("current_bid");
		float inc = result2.getFloat("increment");
		
		String bidField = request.getParameter("bid");
		
		
		if (bidField != null && !(bidField.trim().isEmpty())) {
			String buyer = request.getSession().getAttribute("userName").toString();
			String cidSession = request.getSession().getAttribute("cid").toString();
			String bid = request.getParameter("bid");
			
			// check if buyer had previously chosen to remain anonymous
						String isAnonStr = "SELECT * FROM bid_history WHERE user = '" + buyer + "'";
						ResultSet isAnon = stmt.executeQuery(isAnonStr);
						if (isAnon.next()){
							if (isAnon.getByte("anon") == 1) anon = "1";
						}
			
			// check if buyer == seller
			String sellBuyCheck = "SELECT * FROM clothing WHERE cid = " + cidSession + " AND seller = '" + buyer + "'"; 
			ResultSet resultSellBuy = stmt.executeQuery(sellBuyCheck);
			
			if (resultSellBuy.next() == false) {
				// check if current bidder == buyer
				String currBidCheck = "SELECT * FROM clothing WHERE cid = " + cidSession + " AND current_bidder = '" + buyer + "'"; 
				ResultSet resCurrBidCheck = stmt.executeQuery(currBidCheck);
				if (resCurrBidCheck.next() != false) {
					%>
					<center><img id = "center" src='https://i.pinimg.com/originals/13/9a/19/139a190b930b8efdecfdd5445cae7754.png' 
					height='120' 
					width='120' 
					></center>
					<%
					out.println("<center><p style = \"color:red; font-size:30px; \" >Bid Unsuccessful: You already have the highest bid!</p></center>");	
					//out.println("Bid Unsuccessful: You already have the highest bid!");
					out.println("<br>");
					//out.println("<br>");
				}
				else {
					float bidSToF = Float.parseFloat(bid);
					
					String bidAmt= "SELECT * FROM clothing WHERE cid = " + cidSession + " "; 
					ResultSet resBidAmt = stmt.executeQuery(bidAmt);
					
					if (currentBid == 0.0 && bidSToF < initPrice) {
						// if no other bids and bids do not meet bid amount
						%>
						<center><img id = "center" src='https://i.pinimg.com/originals/13/9a/19/139a190b930b8efdecfdd5445cae7754.png' 
						height='120' 
						width='120' 
						></center>
						<%
						out.println("<center><p style = \"color:red; font-size:30px; \" >Bid Unsuccessful: Please bid greater than or equal to the initial price $" + initPrice + "!</p></center>");	
						//out.println("<br>");
						out.println("<br>");
						
						//out.println("Bid Unsuccessful: Please bid greater than or equal to the initial price $" + initPrice + "!");
						//out.println("<br>");
						//out.println("<br>");
					}
					else if (bidSToF < (currentBid + inc)){
						// if bids, and bids less than current + inc
						float neededBid = currentBid + inc;
						%>
						<center><img id = "center" src='https://i.pinimg.com/originals/13/9a/19/139a190b930b8efdecfdd5445cae7754.png' 
						height='120' 
						width='120' 
						></center>
						<%
						out.println("<center><p style = \"color:red; font-size:30px; \" >Bid Unsuccessful: Please bid at least $" + neededBid +"!</p></center>");	
						//out.println("Bid Unsuccessful: Please bid at least $" + neededBid +"!");
						out.println("<br>");
						//out.println("<br>");
					}
					else {
						// check if user is already in bids_on table
						String prevBid = "SELECT * FROM bids_on WHERE cid = " + cidSession + " AND buyer = '" + buyer + "'";
						ResultSet resultBidsOn = stmt.executeQuery(prevBid);
						%>
						<center><img id = "center" src='https://i.gifer.com/WS2k.gif'
						height='200' 
						width='200' 
						></center>
						<%
						
						out.print("<center><p style = \"color:green; font-size:30px; \" >Bid Successful: You now have the highest bid!</p></center>");
						out.println("<br>");
						if (resultBidsOn.next() == false) {
							// FIRST TIME BIDDERS
							// checks if max_bid was placed in new bid
							
							String maxBidField = request.getParameter("max_bid");
							if (maxBidField.trim().isEmpty()){
								String in_bids_on = "INSERT INTO bids_on VALUES ('" + buyer + "', " + cidSession + ", null)";
								stmt.executeUpdate(in_bids_on);
								
							}
							else {
								String in_bids_on = "INSERT INTO bids_on VALUES ('" + buyer + "', " + cidSession + ", " + request.getParameter("max_bid") + ")";
								stmt.executeUpdate(in_bids_on);
								
							}
						}
						else {
							// updates maximum for non first time bids
							String maxBidField = request.getParameter("max_bid");
							if (!(maxBidField.trim().isEmpty())) {
								String updateBidsOn = "UPDATE bids_on SET maximum = " + request.getParameter("max_bid") + " WHERE buyer = '" + buyer + "' AND cid = " + cidSession + " ";
								stmt.executeUpdate(updateBidsOn);
								
							}
						}
						
						resultBidsOn.close();
						
						// insert into bid history
						//String in_bid_history = "INSERT INTO bid_history VALUES (0, '" + buyer + "', " + cidSession + ", " + bid +", 0)";
						String in_bid_history = "INSERT INTO bid_history VALUES (0, '" + buyer + "', " + cidSession + ", " + bid + ", " + anon + ")";

						stmt.executeUpdate(in_bid_history);
						
						String updateCurrBid = "UPDATE clothing SET current_bid = " + bid + ", current_bidder = '" + buyer + "' WHERE cid = " + cidSession + " ";
						stmt.executeUpdate(updateCurrBid);
						
						// checks for autobidding after this^ manual bid	
						String prevAutoBidder = "SELECT * FROM bids_on WHERE cid = " + cidSession + " AND buyer = '" + prevBidder + "' AND maximum >= 0.0";
						ResultSet resPrevAutoBidder = stmt.executeQuery(prevAutoBidder);
						
						// TEST PrevBIdder : out.println(prevBidder + "<br>");
						if (resPrevAutoBidder.next()){
							// TEST out.println("test checks if prev was autobidder <br>");
							// if prev bidder was an autobidder
							float prevMax = resPrevAutoBidder.getFloat("maximum");
							
							// checks if current bidder is an autobidder
							String noAutoBid = "SELECT * FROM bids_on WHERE buyer = '" + buyer + "' AND cid = " + cidSession + " AND maximum >= 0.0"; 
							ResultSet resultNoAutoBid = stmt.executeQuery(noAutoBid);
							
							// storing last manual bid
							float newBidAmt = Float.parseFloat(bid);
						
							// CASE 1: current_bid does not have autobidding set up bid prev bidder have autobidding
							if (!resultNoAutoBid.next()) {
								// if newest buyer has no maximum aka no autobidding
								
								// checks if if previous autobidder's max is over
								if (prevMax >= (newBidAmt + inc)) {
									float newBid = newBidAmt + inc;
									
									in_bid_history = "INSERT INTO bid_history VALUES (0, '" + prevBidder + "', " + cidSession + ", " + newBid + ", " + anon + ")";

									stmt.executeUpdate(in_bid_history);
									updateCurrBid = "UPDATE clothing SET current_bid = " + newBid + ", current_bidder = '" + prevBidder + "' WHERE cid = " + cidSession + " ";
									stmt.executeUpdate(updateCurrBid);
									
									String alertuser = "INSERT INTO alert VALUES ('" + buyer + "', 'You have been outbid on the " + type + " in size " + size + ".')";
									stmt.executeUpdate(alertuser);
									//TEST out.println("TEST: you have been outbid by the previous bidder <br>");
								}
								else {
									String alertuser = "INSERT INTO alert VALUES ('" + prevBidder + "', 'Your autobidder on the " + type + " in size " + size + " has been outbid.')";
									stmt.executeUpdate(alertuser);
									
								}
							}
							// CASE 2: current_bid does have autobidding-- autobid + autobid scenario
							else {
								String newAutoBidder = resultNoAutoBid.getString("buyer"); // bidder B
								// newBidAmt is bidder B
								float newAutoMax = resultNoAutoBid.getFloat("maximum");
								
								while (prevMax >= newBidAmt + inc) {
									float winAutoBid = newBidAmt + inc; // win AutoBid is bidder A first iteration
									
									float holdMax = newAutoMax;
									String holdBidder = newAutoBidder;
									
									in_bid_history = "INSERT INTO bid_history VALUES (0, '" + prevBidder + "', " + cidSession + ", " + winAutoBid + ", " + anon + ")";									stmt.executeUpdate(in_bid_history);
									
									updateCurrBid = "UPDATE clothing SET current_bid = " + winAutoBid + ", current_bidder = '" + prevBidder + "' WHERE cid = " + cidSession + " ";
									stmt.executeUpdate(updateCurrBid);
									
									newBidAmt = winAutoBid; // swap bids;
									newAutoMax = prevMax;
									prevMax = holdMax;
									
									newAutoBidder = prevBidder;
									prevBidder = holdBidder;
								}
								
								String alertuser = "INSERT INTO alert VALUES ('" + prevBidder + "', 'Your autobidder on the on the " + type + " in size " + size + " has reached its maximum value and has been outbid.')";
								stmt.executeUpdate(alertuser);
							}
							
							resultNoAutoBid.close();
							
						}
						else if (prevBidder != null) {
							String alertuser = "INSERT INTO alert VALUES ('" + prevBidder + "', 'Your bid on the " + type + " in size " + size + " has been outbid.')";
							stmt.executeUpdate(alertuser);
						}
						
						resPrevAutoBidder.close();
						
					}
				}
				resCurrBidCheck.close();
				
				// After a manual bid, 
			}
			else{
				%>
				<center><img id = "center" src='https://i.pinimg.com/originals/13/9a/19/139a190b930b8efdecfdd5445cae7754.png' 
				height='120' 
				width='120' 
				></center>
				<%
			out.println("<center><p style = \"color:red; font-size:30px; \" >Bid Unsuccessful: You cant bid on your own listing! Please select a different item to bid on.</p></center>");	
			out.println("<br>");
				out.println("<br>");
			}
			resultSellBuy.close();
		}
		
		// display item
		out.println("<center> <b>Currently viewing: </b>" + desc + " (size " + size + " " + type + ") </center>");
		out.println("<br>");
		out.println("<center><b>Starting bid: </b>$" + starting + "</center>");
		out.println("<br>");
		out.println("<center><b>Bid Increment:</b> $" + increment + "</center>");
		
		// Bid History
		
		String str = "SELECT * FROM bid_history WHERE cid = " + cid;
		
		ResultSet result = stmt.executeQuery(str);
 		
		out.println("<br>");
		out.println("<center><b> Bid History </b></center>");
 		out.print("<table style=\"border:0px ;margin-left:auto;margin-right:auto;\">");
		
		out.print("<tr>");
		
		
		out.print("<td>");
		out.print("<b> User </b> ");
		out.print("</td>");
		
		out.print("<td>");
		out.print("<b> Item ID </b> ");
		out.print("</td>");
		out.print("<td>");
		out.print("<b> Amount </b>");
		out.print("</td>");
		
		
 		while (result.next()) {
			out.print("<tr>");
			
			out.print("<td>");
			
			if (result.getByte("anon") == 1) out.print("Anonymous");
			else out.print(result.getString("user"));
			
			out.print("</td>");
			
			out.print("<td>");
			out.print(result.getInt("cid"));
			out.print("</td>");
			
			out.print("<td>");
			out.print("$" + result.getFloat("amount"));
			out.print("</td>");
			
			out.print("</tr>");
		}
		out.print("</table>");  
		
		%>
		<center><form method="get" action="viewuser.jsp">
			<input type="text" name="username" placeholder="enter username">
			<input type="submit" value="search user history">
		</form></center>
		<% 
		
		// Similar Items
		
		// Query clothing of same type
		String str3 = "SELECT * FROM clothing WHERE is_available = 1 AND type = '" + type + 
		"' AND (size = " + (size - 1) + " OR size = " + (size) + " OR size = " + (size + 1) + ")";
		
		ResultSet result3 = stmt.executeQuery(str3);
		
		out.println("<br>");
		out.print("<center><b> View similar " + type +  "</b></center>");
		
		out.print("<br>");
		out.print("<table style=\"border:0px ;margin-left:auto;margin-right:auto;\">");
		
		out.print("<tr>");
		
		out.print("<td>");
		out.print("<b> Item ID </b> ");
		out.print("</td>");
		
		out.print("<td>");
		out.print("<b> Size </b> ");
		out.print("</td>");
		
		out.print("<td>");
		out.print("<b> Description </b> ");
		out.print("</td>");
		out.print("<td>");
		out.print("<b> Current bid </b>");
		out.print("</td>");
		
		
 		while (result3.next()) {
			
 			if(result3.getInt("cid") == Integer.parseInt(cid)) continue;
			out.print("<tr>");
			
			out.print("<td>");
			out.print(result3.getInt("cid"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(result3.getInt("size"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(result3.getString("description"));
			out.print("</td>");
			
			out.print("<td>");
			if(result3.getFloat("current_bid") == 0) out.print("$" + result3.getFloat("initial_price"));
			else out.print("$" + result3.getFloat("current_bid"));
			out.print("</td>");
			
			out.print("</tr>");
		}
		out.print("</table>");  
		
		result2.close();
		result3.close();
		result.close();
	%>
	
		<br>
		<center><form method="get" action="viewitem.jsp">
			<label for="cid">View Item</label><br>
			<input type="text" name="cid" placeholder="enter item ID">
			<input type="submit" value="view item">
		</form></center>

<%//new bid %>
<br>
<form method="get" action="viewitem.jsp">
	<center><table>
		<tr>
		<td><b>Make a Bid!</b></td>
		</tr>
		<tr>
			<td><b>Bid Amount: </b></td><td><input type="text" name="bid"></td>
		</tr>
	</table></center>
	<center><table>
		<tr>
			<td><b>Max Bid (For Auto Bids Only): </b></td><td><input type="text" name="max_bid"></td>
		</tr>
	</table></center>
	<br>
	<center><b>Hide your name from Bid History:</b>
	<input type="checkbox" name="anon" value="1">
	<label for="anon"> Be anonymous!</label><br>
	Note: you will remain anonymous for all future bids after selecting.</center>
	<br>
	<center><input type="submit" value="Place Bid!"></center>
</form>
	
</body>
</html>
