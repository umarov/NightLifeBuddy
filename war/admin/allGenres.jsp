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
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

<script>


function makeEditable(key)
{
	
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
			<th>Genre Name (Double Click to edit)</th>
		</tr>
		<%
		int i = 0;	
		for (Entity genre : allGenres) {
					String genreName = Genres.getName(genre);
					Long key = Genres.getKey(genreName).getId();
		%>

		<tr>
			<td><div id="edit<%=i%>">
				<form action="/updateGenreCommand" method="get">
				<input id="edit<%=i%>Input" ondblclick="makeEditable(<%=i %>)" readonly="true" name="genreName" value="<%=genreName%>"/>
				<input type="hidden" value="<%=genreName%>" name="oldGenreName"/>
				</form>
			</div>	
		</tr>

		<%
			i++;	
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