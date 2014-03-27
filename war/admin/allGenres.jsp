<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Genres"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Jason Pierce
   
   Version 2 - Spring 2014
-->

<html>
<head>

<title>All Genres</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">


<script>

var selectedGenreForEdit = null  
var editNameError = false;

$(document).ready(function(){ //test
	
	// keypress genre for Add button
	$("#addGenreInput").keyup(function() {
	genreName=$("#addGenreInput").val();
	if (checkGenreName(genreName)) {
		$("#addGenreButton").attr("disabled",null);
		$("#addGenreError").hide();
	} else {
		$("#addGenreButton").attr("disabled","disabled");
		if (genreName!=null && genreName.length>0) 
			$("#addGenreError").show();
	}
	});
	
	$(".editGenreNameInput").keyup(function() {
		if (selectedGenreForEdit==null)
			return;
		genreName=$("#editGenreNameInput"+selectedGenreForEdit).val();
		editNameError = ! checkGenreName(genreName);
		updateSaveEditButton();
		});
	
});



function updateSaveEditButton() {
	if (editNameError||editDescriptionError||editAddressError) {
		$("#saveEditGenreButton"+selectedGenreForEdit).attr("disabled","disabled", "disabled");
	} else {
		$("#saveEditGenreButton"+selectedGenreForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editGenreNameError"+selectedGenreForEdit).show();
	} else {
		$("#editGenreNameError"+selectedGenreForEdit).hide();
	}
	
}



var genreNamePattern = /^[ \w-'',]{3,100}$/
genreNamePattern.compile(genreNamePattern)

// check the syntax of the name of a venue 
function checkGenreName(genreName) {
	return genreNamePattern.test(genreName);
}


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addGenreButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(genreName) {
	disableAllButtons(true);
	$("#delete"+genreName).show();
}

var selectedGenreForDelete=null;

function confirmDeleteGenre(genreName) {
	selectedGenreForDelete=genreName;
	$.post("admin/deleteGenreCommand", 
			{genreName: genreName}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
			
				cancelDeleteGenre(selectedGenreForDelete);
				selectedGenre=null;
				
			}
			
	);
	
}

function cancelDeleteGenre(genreName) {
	$("#delete"+genreName).hide();
	disableAllButtons(false);
}

var selectedGenreOldName=null;

function editButton(genreName) {
	selectedGenreForEdit=genreName;
	disableAllButtons(true);
	editNameError = false;
	updateSaveEditButton();
	selectedGenreOldName=$("#editGenreNameInput"+selectedGenreForEdit).val();	
	$("#view"+genreName).hide();
	$("#edit"+genreName).show();
}


function saveEditGenre(genreName) {
	document.forms["form"+genreName].submit();
}

function cancelEditGenre(genreName) {
	$("#editGenreNameInput"+genreName).val(selectedGenreOldName);
	$("#edit"+genreName).hide();
	$("#view"+genreName).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allGenres = Genres.getFirstGenres(20);
		if (allGenres.isEmpty()) {
	%>
	<h1>No Genre Defined</h1>
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
			<th>Genre Name</th>
			<th>View</th>
		</tr>
		<%
			for (Entity genre : allGenres) {
					String genreName = Genres.getName(genre);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=genreName%>)">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=genreName%>)">Delete</button>
			</td>

			<td><div id="view<%=genreName%>"><%=genreName%></div>

				<div id="edit<%=genreName%>" style="display: none">

					<form id="form<%=genreName%>" action="/updateGenreCommand" method="get">
						<input type="hidden" value="<%=genreName%>" name="genreName" />
						
						
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="/editGenreNameInput<%=genreName%>" class="editVenueNameInput"
										value="<%=genreName%>" name="genreName" />
									<div id="editVenueNameError<%=genreName%>" class="error" style="display: none">Invalid genre name
										(minimum 3 characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							
						</table>
						

						
						<button id="saveEditGenreButton<%=genreName%>" type="button" onclick="saveEditGenre(<%=genreName%>)">Save</button>
						<button type="button" onclick="cancelEditGenre(<%=genreName%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=genreName%>" style="display: none">
					Do you want to delete this venue?
					<button type="button" onclick="confirmDeleteGenre(<%=genreName%>)">Delete</button>
					<button type="button" onclick="cancelDeleteGenre(<%=genreName%>)">Cancel</button>
				</div></td>
				
				
		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addGenreForm" action="/addGenreCommand" method="get">
						<p>New Genre:</p>
						Name: <input id="addGenreInput" type="text" name="genreName" size="50" /><br>
						<input id="addGenreButton" type="submit" value="Add" />
					</form>
					<div id="addGenreError" class="error" style="display: none">Invalid genre name (minimum 3 characters:
						letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>