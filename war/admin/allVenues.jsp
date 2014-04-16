<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Venues"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Muzafar Umarov
   
   Version 2 - Spring 2014
-->

<html>
<head>

<title>All Venues</title>
<!-- CSS -->
  <link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">


<script>
function makeEditable(key)
{
	console.log("edit"+key+"Input" + " is being worked on");
	var readOnlyStatus = document.getElementById('edit'+key+'Input').readOnly;
	
	if (readOnlyStatus)
	{
		document.getElementById('edit'+key+'Input').readOnly = false;
		console.log("edit"+key+"Input" + " is editable");
	}
	else
	{
		document.getElementById('edit'+key+'Input').readOnly = true;
		console.log("edit"+key+"Input" + " is not editable");
	}
}


</script>

</head>
<body>
	<%
		List<Entity> allVenues = Venues.getFirstVenues(20);
		if (allVenues.isEmpty()) {
	%>
	<h1>No Event Defined</h1>
	<div class="menu" align="center">
			<div class="menu_item">
				<a href="/index.jsp">Home</a>
			</div>
			<div class="menu_item">
				<a href="/admin/adminHome.jsp">Admin Home</a>
			</div>
			<div class="menu_item">
				<a href="/admin/allVenues.jsp">Venues</a>
			</div>
			<div class="menu_item">
				<a href="/admin/allGenres.jsp">Genres</a>
			</div>
			<div class="menu_item">
				<a href="/admin/allEvents.jsp">Events</a>
			</div>
			<div class="menu_item">
				<a href="/logout">Log Out</a>
			</div>
		</div>
	<%
		} else {
	%>
	<h1>All Events</h1>
	<div class="menu" align="center">
			<div class="menu_item">
				<a href="/index.jsp">Home</a>
			</div>
			<div class="menu_item">
				<a href="/admin/adminHome.jsp">Admin Home</a>
			</div>
			<div class="menu_item">
				<a href="/admin/allVenues.jsp">Venues</a>
			</div>
			<div class="menu_item">
				<a href="/admin/allGenres.jsp">Genres</a>
			</div>
			<div class="menu_item">
				<a href="/admin/allEvents.jsp">Events</a>
			</div>
			<div class="menu_item">
				<a href="/admin/logout">Log Out</a>
			</div>
		</div>

	<table id="main">
		<tr>
			<th>Venue Name</th>
			<th>Description</th>
			<th>Address</th>
			<th>Age</th>
			<th>Hours</th>
		</tr>
		<%
		int i = 0;	
		for (Entity venue : allVenues) {
					String venueName = Venues.getName(venue);
					String venueDescription = Venues.getDescription(venue);
					String venueAddress = Venues.getAddress(venue);
					int ageReq = Venues.getAgeRequirement(venue);
					String hours = Venues.getVenueHours(venue);
		%>
		
		
		<tr>
			
			<td><form action="/updateVenueCommand" method="get"><input id="edit<%=i%>Input" value="<%=venueName%>" ondblclick="makeEditable(<%=i++ %>)" readonly="true" name="venueName"/>
				<input type="hidden" value="<%=venueName%>" name="oldVenueName"/>
				<input type="hidden" value="<%=venueDescription%>" name="venueDescription"/>
				<input type="hidden" value="<%=venueAddress%>" name="venueAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="venueHours"/></form>
			</td>
			<td><form action="/updateVenueCommand" method="get"><input id="edit<%=i%>Input" value="<%=venueDescription%>" ondblclick="makeEditable(<%=i++ %>)" readonly="true" name="venueDescription"/>
			<input type="hidden" value="<%=venueName%>" name="venueName"/>
			<input type="hidden" value="<%=venueName%>" name="oldVenueName"/>
				<input type="hidden" value="<%=venueAddress%>" name="venueAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="venueHours"/></form>
				
			</td>
			<td><form action="/updateVenueCommand" method="get"><input id="edit<%=i%>Input" value="<%=venueAddress%>" ondblclick="makeEditable(<%=i++ %>)" readonly="true" name="venueAddress"/>
			<input type="hidden" value="<%=venueName%>" name="venueName"/>
			<input type="hidden" value="<%=venueName%>" name="oldVenueName"/>
				<input type="hidden" value="<%=venueDescription%>" name="venueDescription"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="venueHours"/></form>
				
			</td>
			<td><form action="/updateVenueCommand" method="get"><input id="edit<%=i%>Input" value="<%=ageReq%>" ondblclick="makeEditable(<%=i++ %>)" readonly="true" name="ageRequirement"/>
			<input type="hidden" value="<%=venueName%>" name="venueName"/>
			<input type="hidden" value="<%=venueName%>" name="oldVenueName"/>
				<input type="hidden" value="<%=venueDescription%>" name="venueDescription"/>
				<input type="hidden" value="<%=venueAddress%>" name="venueAddress"/>
				<input type="hidden" value="<%=hours%>" name="venueHours"/></form>
				
			</td>
			<td><form action="/updateVenueCommand" method="get"><input id="edit<%=i%>Input" value="<%=hours%>" ondblclick="makeEditable(<%=i %>)" readonly="true" name="venueHours"/>
			<input type="hidden" value="<%=venueName%>" name="venueName"/>
			<input type="hidden" value="<%=venueName%>" name="oldVenueName"/>
				<input type="hidden" value="<%=venueDescription%>" name="venueDescription"/>
				<input type="hidden" value="<%=venueAddress%>" name="venueAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/></form>
				
			</td>
						
		</tr>
		</form>	
		
		<%
			i++;	
		}
%>
</table>
<%
			}
		%>
		

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addVenueForm" action="/addVenueCommand" method="get">
						<p>New Venue:</p>
						Name: <input id="addVenueInput" type="text" name="venueName" size="50" /><br>
						Description: <input id="addVenueInput" type="text" name="venueDescription" size="50" /><br>
						Address: <input id="addVenueInput" type="text" name="venueAddress" size="50" /><br>
						Age Requirement: <input id="addVenueInput" type="text" name="ageRequirement" size="50" /><br>
						Venue Hours: <input id="addVenueInput" type="text" name="venueHours" size="50" /><br>
						<input id="addVenueButton" type="submit" value="Add" />
					</form>
					<div id="addVenueError" class="error" style="display: none">Invalid venue name (minimum 3 characters:
						letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	

</body>
</html>
