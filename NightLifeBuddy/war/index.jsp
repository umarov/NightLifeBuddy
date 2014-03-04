<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Venues"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
  <head>
    <title>Nightlife Buddy</title>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  	<script src="//code.jquery.com/jquery-1.9.1.js"></script>
  	<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
		
	<script>
	var _hidediv = null;
	$(document).ready(function(){
		if(_hidediv)
	        _hidediv();
		var div = document.getElementById('searchDiv');
	    div.style.display = 'none';
	    _hidediv = function () { div.style.display = 'none'; };
	}
	
	
	function showdiv(id) {
	    if(_hidediv)
	        _hidediv();
	    var div = document.getElementById(id);
	    div.style.display = 'block';
	    _hidediv = function () { div.style.display = 'none'; };
	}
	</script>
  </head>

  <body>
    <h1>Hello App Engine!</h1>
	
    <table>
      <tr>
        <td colspan="2" style="font-weight:bold;">Available Servlets:</td>        
      </tr>
      <tr>
        <td><a href="/admin/allVenues.jsp">All Venues</a></td>
        <td><a href="/admin/allEvents.jsp">All Events</a></td>
      </tr>
      </table>
   
      	<%!List<Entity> results = null; %>
      	
      <%	
      	results= Venues.getResults();
      	if (results == null)
      	{
      %>
      	<p>Hello, feel free to search for a venue. </p>
      	<form name="searchVenue" action="/admin/seachVenueCommand" method="get">
      	
      		<input id="searchVenueInput" type="text" name="search" size="100" />
      		<input id="searchVenueButton" type="submit" value="search" />
      	
      	</form>	
      <%
      	}
      	else
      	{
      		%>
      		<p>Hello, feel free to search for a venue.</p>
      		
      		<form name="searchVenue" action="/admin/seachVenueCommand" method="get">      	
      			<input id="searchVenueInput" type="text" name="search" size="100" />
      			<input id="searchVenueButton" type="submit" onclick="showdiv('searchDiv')" value="search" />
      		</form>
      		<div id="searchDiv" >
      		<table>
      		
      		<tr>
      			<th>#</th>
      			<th>Name</th>
      			<th>Description</th>
      			<th>Address</th>
      		</tr>
      		
      		<%
      		int number = 0;
      		for (Entity venue : results) 
      		{
				String venueName = Venues.getName(venue);
				String venueDescription = Venues.getDescription(venue);
				String venueAddress = Venues.getAddress(venue);
				number++;
			%>
      	
      		
       		
      		<tr>
      		
      			<th class="searchResults"><%=number%></th>
      			<th class="searchResults"><%=venueName%></th>
      			<th class="searchResults"><%=venueDescription%></th>
      			<th class="searchResults"><%=venueAddress%></th>
      		
      		</tr>
      	
      	</table>	
      	</div>
      <%
      
      	}
      	results.clear();
      	number = 0;
      	}
      %>
      
    
  </body>
</html>
