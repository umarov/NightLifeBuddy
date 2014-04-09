<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Venues"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="com.google.appengine.api.datastore.Key, com.google.appengine.api.datastore.KeyFactory" %>
 
<!DOCTYPE html>
<html>
  <head>
<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Muzafar Umarov, Jason Pierce, Alfredo Loris
   
   Version 2 - Spring 2014
-->

	<!-- Basic Page Needs
  ================================================== -->

	<title>Nightlife Buddy</title>
	<meta name="author" content="Muzafar Umarov, Jason Pierce, Alfredo Loris">

	<!-- Mobile Specific Metas
  ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  
  <!-- CSS -->
  <link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">
  <link rel="stylesheet" href="stylesheets/base.css">
  <link rel="stylesheet" href="stylesheets/skeleton.css">
  <link rel="stylesheet" href="stylesheets/layout.css">
  <link rel="stylesheet" href="stylesheets/custom.css">
  <link rel="stylesheet" href="stylesheets/font-awesome.min.css">
  <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  
  <!-- SCRIPTS -->
  <script src="//code.jquery.com/jquery-1.11.0.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <script src="js/jquery.videoBG.js"></script>
  <script src="//twitter.github.io/typeahead.js/releases/latest/typeahead.bundle.js"></script>
  
  <script>
<%List<Entity> venues = Venues.getFirstVenues(20);%>

$(function() {
	var availableTags = new Array();
	<%for (Entity venue : venues)
	{%>
	availableTags.push("<%=Venues.getName(venue)%>");
	<%}%>
    $( ".typeahead" ).autocomplete({
      source: availableTags
    });
  });

</script>

  </head>

  <body>
	<%@include file="header.jsp" %>
   
      	<%!List<Entity> results = null; %>
      	
      <%	
      	results= Venues.getResults();
      	if (results == null)
      	{
      %>
      	<div class="row">
		   <div class="sixteen columns">
		      <h2 class="searchTitle"> Start the night off right. Searching by Venue: </h2>
		   </div>
		</div>
		<div class="row">
			
		   <div class="eleven columns offset-by-five">
		   		<form class="mainSearch left" name="searchVenue" action="/seachVenueCommand" method="get">
		   			<input class="typeahead" type="text" placeholder="For example, 'Echostage'" autocomplete="off" name="search">
				    <input  type="submit" value="search" />
				</form> 
		      	
		   </div>
		 </div>	
		 <div id="searchDiv">
      <%
      	}
      	else
      	{
      		%>
      		
      	<div class="row">
		   <div class="sixteen columns">
		      <h2 class="searchTitle">Start the night off right. Searching by Venue:</h2>
		   </div>
		</div>
		<div class="row no-margin">
		   <div class="eleven columns offset-by-five">
		      	<form class="mainSearch left" name="searchVenue" action="/seachVenueCommand" method="get">
		      		<input class="typeahead" type="text" placeholder="For example, 'Echostage'" autocomplete="off" name="search">
				    <input  type="submit" value="search" />
      			</form>
      		</div>
      	</div>
      	<div id="searchDiv">
	      	
      		
      		
      		
      		<%
      		
      		int number = 0;
      		for (Entity venue : results) 
      		{
				String venueName = Venues.getName(venue);
				String venueDescription = Venues.getDescription(venue);
				String venueAddress = Venues.getAddress(venue);
				number++;
			%>
			
      		<div class="row">
      			<div class="results">
	      			<div class="seven columns">
	      				<h4><a href="/venues/profile.jsp?venueName=<%=venueName%>"><%=venueName%></a></h4>
	      				<p>
	      					<%=venueDescription%>
	      				</p>
	      				<span class="address">
	      					<%=venueAddress%>
	      				</span>
	      			</div>
      			</div>
      		</div>
      		
      			
      <%
      
      	}
      	results.clear();
      	number = 0;
      	}
      %>
      
      </div><!-- end #searchDiv -->
    <%@include file="footer.jsp" %>
  </body>
</html>
