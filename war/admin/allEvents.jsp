<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Events"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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


<script>

var selectedEventForEdit = null  
var editNameError = false;
var editDescriptionError = false;
var editAddressError = false;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addEventInput").keyup(function() {
	eventName=$("#addEventInput").val();
	if (checkEventName(eventName)) {
		$("#addEventButton").attr("disabled",null);
		$("#addEventError").hide();
	} else {
		$("#addEventButton").attr("disabled","disabled");
		if (eventName!=null && eventName.length>0) 
			$("#addEventError").show();
	}
	});
	
	$(".editEventNameInput").keyup(function() {
		if (selectedEventForEdit==null)
			return;
		eventName=$("#editEventNameInput"+selectedEventForEdit).val();
		editNameError = ! checkEventName(eventName);
		updateSaveEditButton();
		});
	
});



function updateSaveEditButton() {
	if (editNameError||editDescriptionError||editAddressError) {
		$("#saveEditEventButton"+selectedEventForEdit).attr("disabled","disabled", "disabled");
	} else {
		$("#saveEditEventButton"+selectedEventForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editEventNameError"+selectedEventForEdit).show();
	} else {
		$("#editEventNameError"+selectedEventForEdit).hide();
	}
	
}



var eventNamePattern = /^[ \w-'',]{3,100}$/
eventNamePattern.compile(eventNamePattern)

// check the syntax of the name of a venue 
function checkEventName(eventName) {
	return eventNamePattern.test(eventName);
}


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addEventButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(eventName) {
	disableAllButtons(true);
	$("#delete"+eventName).show();
}

var selectedEventForDelete=null;

function confirmDeleteEvent(eventName) {
	selectedEventForDelete=eventName;
	$.post("admin/deleteEventCommand", 
			{eventName: eventName}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
			
				cancelDeleteEvent(selectedEventForDelete);
				selectedEvent=null;
				
			}
			
	);
	
}

function cancelDeleteEvent(eventName) {
	$("#delete"+eventName).hide();
	disableAllButtons(false);
}

var selectedEventOldName=null;
var selectedEventOldAddress=null;
var selectedEventOldDescription=null;

function editButton(eventName, eventDescription, eventAddress) {
	selectedEventForEdit=eventName;
	disableAllButtons(true);
	editNameError = false;
	editDescriptionError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedEventOldName=$("#editEventNameInput"+selectedEventForEdit).val();
	selectedEVentOldAddress=null;
	selectedEventOldDescription=null;	
	$("#view"+eventName).hide();
	$("#edit"+eventName).show();
}


function saveEditEvent(eventName) {
	document.forms["form"+eventName].submit();
}

function cancelEditEvent(eventName) {
	$("#editEventNameInput"+eventName).val(selectedEventOldName);
	$("#edit"+eventName).hide();
	$("#view"+eventName).show();
	disableAllButtons(false);
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
				<a href="/admin/logout">Log Out</a>
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
			<th>View</th>
		</tr>
		<%
			for (Entity event : allEvents) {
					String eventName = Events.getName(event);
					String eventDescription = Events.getDescription(event);
					String eventAddress = Events.getAddress(event);
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
								<td class="editTable"><input type="text" class="editText" value="<%=Events.getDescription(event)%>"
										name="eventDescription" /></td>
							</tr>
							<tr>
								<td class="editTable">Address:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Events.getAddress(event)%>"
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
				
				
		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addEventForm" action="/addEventCommand" method="get">
						<p>New Event:</p>
						Name: <input id="addEventInput" type="text" name="eventName" size="50" /><br>
						Description: <input id="addEventInput" type="text" name="eventDescription" size="50" /><br>
						Address: <input id="addEventInput" type="text" name="eventAddress" size="50" /><br>
						<input id="addEventButton" type="submit" value="Add" />
					</form>
					<div id="addEventError" class="error" style="display: none">Invalid event name (minimum 3 characters:
						letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>





