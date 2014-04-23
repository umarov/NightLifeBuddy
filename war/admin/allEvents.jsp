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

window.onload = function() {
	
	var venuesListDiv = document.getElementById('addVenueName');
	var venuesList = document.createElement('select');
	
	<%for (Entity venue : venues)
	{%>
	var option = document.createElement('option');
	option.text ="<%=Venues.getName(venue)%>";
	venuesList.appendChild(option);
	<%}%>
	venuesList.name = "venueName";
	venuesList.form = "createNewVenueForm";
	
	venuesListDiv.appendChild(venuesList);
	
	var genresListDiv = document.getElementById('addGenreName');
	var genresList = document.createElement('select');
	
	<%for (Entity genre : genres)
	{%>
	var option = document.createElement('option');
	option.text ="<%=Genres.getName(genre)%>";
	genresList.appendChild(option);
	<%}%>
	genresList.name = "genreName";
	genresList.form = "createNewVenueForm";
	
	genresListDiv.appendChild(genresList);
	
	
}

function makeEditable(key)
{
	console.log("editInput"+key + " is being worked on");
	var readOnlyStatus = document.getElementById('editInput' + key).readOnly;
	
	if (readOnlyStatus)
	{
		document.getElementById('editInput' + key).readOnly = false;
		console.log("editInput"+key + " is editable");
	}
	else
	{
		document.getElementById('editInput' + key).readOnly = true;
		console.log("editInput"+key + " is not editable");
	}
}

function makeEditableAuto(type)
{
	if(type === 'venue')
	{
		document.getElementById('addEventInputVenue').readOnly = false;
	}
	if(type === 'genre')
	{
		document.getElementById('addEventInputGenre').readOnly = false;
	}
	
}

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
			<th>Event Name</th>
			<th>Description</th>
			<th>Address</th>
			<th>Age Requirement</th>
			<th>Hours</th>
			<th>Venue</th>
			<th>Genre</th>
		</tr>
		<%
			String venueName;
			String genreName;
			int i = 0;
			for (Entity event : allEvents) {
					String eventName = Events.getName(event);
					String eventDescription = Events.getDescription(event);
					String eventAddress = Events.getAddress(event);
					int ageReq = Events.getAgeRequirement(event);
					String hours = Events.getEventHours(event);
					venueName = (Events.getVenueKey(event)== null?"":Events.getVenueKey(event).getName());
					genreName = Events.getGenreName(event);
					
					
		%>

		<tr>
			<td><form action="/updateEventCommand" method="get">
				<input id="editInput<%=i%>" value="<%=eventName%>" name="eventName" ondblclick="makeEditable(<%=i++ %>)" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventDescription%>" name="eventDescription"/>
				<input type="hidden" value="<%=eventAddress%>" name="eventAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="eventHours" />
				<input type="hidden" value="<%=venueName%>" name="venueName"/>
				<input type="hidden" value="<%=genreName%>" name="genreName"/>
				</form>
			</td>	
			<td><form action="/updateEventCommand" method="get">
				<input id="editInput<%=i%>" value="<%=eventDescription%>" name="eventDescription" ondblclick="makeEditable(<%=i++ %>)" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventName%>" name="eventName"/>
				<input type="hidden" value="<%=eventAddress%>" name="eventAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="eventHours" />
				<input type="hidden" value="<%=venueName%>" name="venueName"/>
				<input type="hidden" value="<%=genreName%>" name="genreName"/>
				</form>
			</td>	
			<td><form action="/updateEventCommand" method="get">
				<input id="editInput<%=i%>" value="<%=eventAddress%>" name="eventAddress" ondblclick="makeEditable(<%=i++ %>)" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventDescription%>" name="eventDescription"/>
				<input type="hidden" value="<%=eventName%>" name="eventName"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="eventHours" />
				<input type="hidden" value="<%=venueName%>" name="venueName"/>
				<input type="hidden" value="<%=genreName%>" name="genreName"/>
				</form>
			</td>	
			<td><form action="/updateEventCommand" method="get">
				<input id="editInput<%=i%>" value="<%=ageReq%>" name="ageRequirement" ondblclick="makeEditable(<%=i++ %>)" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventDescription%>" name="eventDescription"/>
				<input type="hidden" value="<%=eventAddress%>" name="eventAddress"/>
				<input type="hidden" value="<%=eventName%>" name="eventName"/>
				<input type="hidden" value="<%=hours%>" name="eventHours" />
				<input type="hidden" value="<%=venueName%>" name="venueName"/>
				<input type="hidden" value="<%=genreName%>" name="genreName"/>
				</form>
			</td>	
			<td><form action="/updateEventCommand" method="get">
				<input id="editInput<%=i%>" value="<%=hours%>" name="eventHours" ondblclick="makeEditable(<%=i%>)" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventDescription%>" name="eventDescription"/>
				<input type="hidden" value="<%=eventAddress%>" name="eventAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=venueName%>" name="venueName"/>
				<input type="hidden" value="<%=eventName%>" name="eventName"/>
				<input type="hidden" value="<%=genreName%>" name="genreName"/>
				</form>
			</td>	
			<td><form action="/updateEventCommand" method="get">
				<input id="addEventInputVenue" value="<%=venueName%>" name="venueName" ondblclick="makeEditableAuto('venue')" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventDescription%>" name="eventDescription"/>
				<input type="hidden" value="<%=eventAddress%>" name="eventAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="eventHours" />
				<input type="hidden" value="<%=eventName%>" name="eventName"/>
				<input type="hidden" value="<%=genreName%>" name="genreName"/>
				</form>
			</td>	
			<td><form action="/updateEventCommand" method="get">
				<input id="addEventInputGenre" value="<%=genreName%>" name="genreName" ondblclick="makeEditableAuto('genre')" readonly="true"/>
				<input type="hidden" value="<%=eventName%>" name="oldEventName"/>
				<input type="hidden" value="<%=eventDescription%>" name="eventDescription"/>
				<input type="hidden" value="<%=eventAddress%>" name="eventAddress"/>
				<input type="hidden" value="<%=ageReq%>" name="ageRequirement"/>
				<input type="hidden" value="<%=hours%>" name="eventHours" />
				<input type="hidden" value="<%=venueName%>" name="venueName"/>
				<input type="hidden" value="<%=eventName%>" name="eventName"/>
				</form>
			</td>					
		</tr>

		<%
			}
%>
</table>
<%
			}
		%>
		
	<table>
		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form id="createNewVenueForm" name="addEventForm" action="/addEventCommand" method="get">
						<p>New Event:</p>
						Name: <input id="addEventInput" type="text" name="eventName" size="50" /><br>
						Description: <input id="addEventInput" type="text" name="eventDescription" size="50" /><br>
						Address: <input id="addEventInput" type="text" name="eventAddress" size="50" /><br>
						Age Requirements: <input id="addEventInput" type="text" name="ageRequirement" size="50" /><br>
						Event Hours: <input id="addEventInput" type="text" name="eventHours" size="50" /><br>
						Venues: <div id="addVenueName" type="text" name="venueName"></div>
						Genre: <div id="addGenreName" type="text" name="genreName"></div>
						<input id="addEventButton" type="submit" value="Add" />
					</form>
					
				</td>
			</tr>
		</tfoot>
		</table>

	

</body>
</html>





