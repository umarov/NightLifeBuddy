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

var selectedVenueForEdit = null  
var editNameError = false;
var editDescriptionError = false;
var editAddressError = false;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addVenueInput").keyup(function() {
	venueName=$("#addVenueInput").val();
	$("#addVenueButton").attr("disabled",null);
	$("#addVenueError").hide();
	});
	
	$(".editVenueNameInput").keyup(function() {
		if (selectedVenueForEdit==null)
			return;
		venueName=$("#editVenueNameInput"+selectedVenueForEdit).val();
		updateSaveEditButton();
		});
	
});	



function updateSaveEditButton() {
	$("#saveEditVenueButton"+selectedVenueForEdit).attr("disabled","disabled", "disabled");
	$("#editVenueNameError"+selectedVenueForEdit).show();
	
}



function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addVenueButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(venueName) {
	disableAllButtons(true);
	$("#delete"+venueName).show();
}

var selectedVenueForDelete=null;

function confirmDeleteVenue(venueName) {
	selectedVenueForDelete=venueName;
	$.post("admin/deleteVenueCommand", 
			{venueName: venueName}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
			
				cancelDeleteVenue(selectedVenueForDelete);
				selectedVenue=null;
				
			}
			
	);
	
}

function cancelDeleteVenue(venueName) {
	$("#delete"+venueName).hide();
	disableAllButtons(false);
}

var selectedVenueOldName=null;
var selectedVenueOldAddress=null;
var selectedVenueOldDescription=null;

function editButton(venueName, venueDescription, venueAddress) {
	selectedVenueForEdit=venueName;
	disableAllButtons(true);
	editNameError = false;
	editDescriptionError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedVenueOldName=$("#editVenueNameInput"+selectedVenueForEdit).val();
	selectedVenueOldAddress=null;
	selectedVenueOldDescription=null;	
	$("#view"+venueName).hide();
	$("#edit"+venueName).show();
}



function saveEditVenue(venueName) {
	document.forms["form"+venueName].submit();
}

function cancelEditVenue(venueName) {
	$("#editVenueNameInput"+venueName).val(selectedVenueOldName);
	$("#edit"+venueName).hide();
	$("#view"+venueName).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allVenues = Venues.getFirstVenues(20);
		if (allVenues.isEmpty()) {
	%>
	<h1>No Event Defined</h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/index.jsp">Home</a>
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
	</div>
	<%
		} else {
	%>
	<h1>All Events</h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/index.jsp">Home</a>
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
	</div>

	<table id="main">
		<tr>
			<th class="adminOperationsList">Admin stuffz</th>
			<th>Venue Name</th>
			<th>Description</th>
			<th>Address</th>
			<th>View</th>
		</tr>
		<%
			for (Entity venue : allVenues) {
					String venueName = Venues.getName(venue);
					String venueDescription = Venues.getDescription(venue);
					String venueAddress = Venues.getAddress(venue);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=venueName%>,'<%=venueDescription%>',<%=venueAddress%>)">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=venueName%>)">Delete</button>
			</td>

			<td><div id="view<%=venueName%>"><%=venueName%></div>

				<div id="edit<%=venueName%>" style="display: none">

					<form id="form<%=venueName%>" action="/admin/updateVenueCommand" method="get">
						<input type="hidden" value="<%=venueName%>" name="venueName" />
						
						
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="editVenueNameInput<%=venueName%>" class="editVenueNameInput"
										value="<%=venueName%>" name="venueName" />
									<div id="editVenueNameError<%=venueName%>" class="error" style="display: none">Invalid venue name
										(minimum 3 characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Description:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Venues.getDescription(venue)%>"
										name="venueDescription" /></td>
							</tr>
							<tr>
								<td class="editTable">Address:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Venues.getAddress(venue)%>"
										name="venueAddress" /></td>
							</tr>
							
						</table>
						

						
						<button id="saveEditVenueButton<%=venueName%>" type="button" onclick="saveEditVenue(<%=venueName%>)">Save</button>
						<button type="button" onclick="cancelEditVenue(<%=venueName%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=venueName%>" style="display: none">
					Do you want to delete this venue?
					<button type="button" onclick="confirmDeleteVenue(<%=venueName%>)">Delete</button>
					<button type="button" onclick="cancelDeletevenue(<%=venueName%>)">Cancel</button>
				</div></td>
				<td><div id="view<%=venueDescription%>"><%=venueDescription%></div></td>
			<td><div id="view<%=venueAddress%>"><%=venueAddress%></div></td>
				
				
		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addVenueForm" action="/admin/addVenueCommand" method="get">
						<p>New Venue:</p>
						Name: <input id="addVenueInput" type="text" name="venueName" size="50" /><br>
						Description: <input id="addVenueInput" type="text" name="venueDescription" size="50" /><br>
						Address: <input id="addVenueInput" type="text" name="venueAddress" size="50" /><br>
						<input id="addVenueButton" type="submit" value="Add" />
					</form>
					<div id="addVenueError" class="error" style="display: none">Invalid venue name (minimum 3 characters:
						letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
