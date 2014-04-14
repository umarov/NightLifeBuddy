<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Events,nightlifebuddy.Venues, nightlifebuddy.Genres"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="com.google.appengine.api.datastore.Key, com.google.appengine.api.datastore.KeyFactory" %>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alfredo Loris
   
   Version 2 - Spring 2014
-->

<html>
<head>

<title>All Events</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.9.1.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>


<script>
<%List<Entity> venues = Venues.getFirstVenues(20);%>
<%List<Entity> genres = Genres.getFirstGenres(20);%>
$(function(){var venues = new Array();
<%for (Entity venue : venues)
{%>
venues.push("<%=Venues.getName(venue)%>");
<%}%>
$( "#addEventInputVenue" ).autocomplete({
    	
      source: venues
    });
});
    
$(function(){var genres = new Array();
<%for (Entity genre : genres)
{%>
genres.push("<%=Genres.getName(genre)%>");
<%}%> 
    $( "#addEventInputGenre" ).autocomplete({
    	
      source: genres
    });

});

</script>

</head>
<body>
	<%
		List<Entity> allEvents = Events.getFirstEvents(20);
		if (allEvents.isEmpty()) {
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
			<th class="adminOperationsList">Admin stuffz</th>
			<th>Event Name</th>
			<th>Description</th>
			<th>Address</th>
			<th>Age Requirement</th>
			<th>Hours</th>
			<th>Venue</th>
			<th>Genre</th>
		</tr>
		<%
			Key venueKey;
			String genreName;
			for (Entity event : allEvents) {
					String eventName = Events.getName(event);
					String eventDescription = Events.getDescription(event);
					String eventAddress = Events.getAddress(event);
					int ageReq = Events.getAgeRequirement(event);
					String hours = Events.getEventHours(event);
					venueKey = (Key) Events.getVenueKey(event);
					genreName = Genres.getName(Genres.getGenreByKey(Events.getGenreKey(event)));
					
					
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=eventName%>,'<%=eventDescription%>',<%=eventAddress%>)">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=eventName%>)">Delete</button>
			</td>

			<td><div id="view<%=eventName%>"><%=eventName%></div>

				<div id="edit<%=eventName%>" style="display: none">

					<form id="form<%=eventName%>" action="/updateEventCommand" method="get">
						<input type="hidden" value="<%=eventName%>" name="eventName" />
						
						
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="editEventNameInput<%=eventName%>" class="editVenueNameInput"
										value="<%=eventName%>" name="eventName" />
									<div id="editVenueNameError<%=eventName%>" class="error" style="display: none">Invalid event name
										(minimum 3 characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Description:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=eventDescription%>"
										name="eventDescription" /></td>
							</tr>
							<tr>
								<td class="editTable">Address:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=eventAddress%>"
										name="eventAddress" /></td>
							</tr>
							
							
						</table>
						

						
						<button id="saveEditEventButton<%=eventName%>" type="button" onclick="saveEditEvent(<%=eventName%>)">Save</button>
						<button type="button" onclick="cancelEditEvent(<%=eventName%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=eventName%>" style="display: none">
					Do you want to delete this venue?
					<button type="button" onclick="confirmDeleteEvent(<%=eventName%>)">Delete</button>
					<button type="button" onclick="cancelDeleteEvent(<%=eventName%>)">Cancel</button>
				</div></td>
				<td><div id="view<%=eventDescription%>"><%=eventDescription%></div></td>
			<td><div id="view<%=eventAddress%>"><%=eventAddress%></div></td>
			<td><div id="view<%=ageReq%>"><%=ageReq%></div></td>
			<td><div id="view<%=hours%>"><%=hours%></div></td>
			<td><div id="view<%=venueKey%>"><%=venueKey%></div></td>
			<td><div id="view<%=genreName %>"><%=genreName %></div>
				
				
		</tr>

		<%
			}

			}
		%>
		</table>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addEventForm" action="/addEventCommand" method="get">
						<p>New Event:</p>
						Name: <input id="addEventInput" type="text" name="eventName" size="50" /><br>
						Description: <input id="addEventInput" type="text" name="eventDescription" size="50" /><br>
						Address: <input id="addEventInput" type="text" name="eventAddress" size="50" /><br>
						Age Requirements: <input id="addEventInput" type="text" name="ageRequirement" size="50" /><br>
						Event Hours: <input id="addEventInput" type="text" name="eventHours" size="50" /><br>
						Venues: <input id="addEventInputVenue" type="text" name="venueName"/><br>
						Genre: <input id="addEventInputGenre" type="text" name="genreName"/><br>
						<input id="addEventButton" type="submit" value="Add" />
					</form>
					<div id="addEventError" class="error" style="display: none">Invalid event name (minimum 3 characters:
						letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	

</body>
</html>





