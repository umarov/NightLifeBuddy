<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="com.google.appengine.api.datastore.Key, com.google.appengine.api.datastore.KeyFactory" %>
<%@page import="nightlifebuddy.Venues, nightlifebuddy.Events, nightlifebuddy.Genres"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: ALFREDO LORIS
   
   Version 2 - Spring 2014
-->

<html>
<head>
<%
//Key key = KeyFactory.stringToKey(request.getParameter("id"));
String name = request.getParameter("eventName");
Entity event;

//venue = Venues.getVenue(key);
event = Events.getEventWithName(name);
// List<Entity> eventsInThisVenue = Events.searchVenues(venue.getKey());
String eventName = "No event found";
String eventDescription = "No event found";
String eventAddress = "No event found";
int ageReq = 0;
String hours = "No event found";
String genre = "No event found";
if(event!= null)
{
	eventName = name;
	eventDescription = Events.getDescription(event);
	eventAddress = (String) Venues.getAddress(Venues.getVenueWithName(Events.getVenueName(event)));
	ageReq = Events.getAgeRequirement(event);
	hours = Events.getEventHours(event);
	genre = Events.getGenreName(event);
}

String url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + eventAddress +"&sensor=false";

%>

	<!-- Basic Page Needs
  ================================================== -->

	<title>Nightlife Buddy</title>
	<meta name="author" content="Muzafar Umarov, Jason Pierce, Alfredo Loris">

	<!-- Mobile Specific Metas
  ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  
  <!-- CSS -->
  <link rel="stylesheet" type="text/css" href="../stylesheets/parkingspot.css">
  <link rel="stylesheet" href="../stylesheets/base.css">
  <link rel="stylesheet" href="../stylesheets/skeleton.css">
  <link rel="stylesheet" href="../stylesheets/layout.css">
  <link rel="stylesheet" href="../stylesheets/custom.css">
  <link rel="stylesheet" href="../stylesheets/font-awesome.min.css">
  <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  
 <!-- SCRIPTS -->
  <script src="//code.jquery.com/jquery-1.9.1.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <script src="../js/jquery.videoBG.js"></script>
  <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
  
  
</head>
<body>

<%@include file="../header.jsp" %>
	<div class="row">
		<div class="eight columns">
			<h2><%=eventName%></h2>
			<hr>
			<p>
				Genre: <%=genre %>
			</p>
			<p>
				Minimum Age: <%=ageReq%>+
			</p>
			<p>
				Hours: <%=hours%>
			</p>
			<p>
				<%=eventDescription%>
			</p>
			
			<span class="address" id="eventAddress"><%=eventAddress%></span>
			
		</div>
	</div>
	<div class="row">
		<div class="twelve columns offset-by-two">
			<div id="map-canvas" style="height:500px; width:100%"></div>
		</div>
	</div>

<script>
	var geocoder = new google.maps.Geocoder();
	var map;

	function initialize() {
	  geocoder = new google.maps.Geocoder();
	  var latlng = new google.maps.LatLng(38.895475, -77.031755);
	  var mapOptions = {
	    zoom: 15,
	    center: latlng
	  }
	  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
	  codeAddress();
	}
	
	function codeAddress() {
	  var address = document.getElementById("eventAddress").innerHTML;
	  geocoder.geocode( { 'address': address}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	      map.setCenter(results[0].geometry.location);
	      var marker = new google.maps.Marker({
	          map: map,
	          position: results[0].geometry.location
	      });
	    } else {
	      alert("Geocode was not successful for the following reason: " + status);
	    }
	  });
	}
	
	google.maps.event.addDomListener(window, 'load', initialize);
</script>

    
		

<%@include file="../footer.jsp" %>
	
</body>
</html>