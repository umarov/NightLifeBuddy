<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.Venues"%>
<%@page import="nightlifebuddy.Genres"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
  <head>
  <!DOCTYPE html>
  
<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Muzafar Umarov, Jason Pierce, Alfredo Loris
   
   Version 2 - Spring 2014
-->

	<!-- Basic Page Needs
  ================================================== -->
	<meta charset="utf-8">
	<title>Nightlife Buddy</title>
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Mobile Specific Metas
  ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  
    <title>Nightlife Buddy</title>
  <!-- CSS -->
  <link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">
  <link rel="stylesheet" href="stylesheets/base.css">
  <link rel="stylesheet" href="stylesheets/skeleton.css">
  <link rel="stylesheet" href="stylesheets/layout.css">
  <link rel="stylesheet" href="stylesheets/custom.css">
  <link rel="stylesheet" href="stylesheets/font-awesome.min.css">
  
  
  <!--  jQuery and javascript stuff yo --
  =================================================  -->
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
  <div id="header">
	<div class="container">
		<div class="row">
			<h1><a href="index.jsp">NightLife Buddy</a></h1>
			<div class="sixteen columns">
			     <ul class="nav">
			     	<li><a href="/admin/allVenues.jsp"><i class="fa fa-building-o"></i></a></li>
			     	<li><a href="/admin/allEvents.jsp"><i class="fa fa-ticket"></i></a></li>
			     	<li><a href="/admin/allGenres.jsp"><i class="fa fa-music"></i></a></li>
			     	<li><a href="#"><i class="fa fa-map-marker"></i></a></li>
			     </ul>
			</div>
	  	</div>
	 </div>
  </div>
   <div id="content" class="container">
    
    
        <%!List<Entity> results = null; %>
        
      <%  
        results= Venues.getResults();
        if (results == null)
        {
      %>
      		<div class="row">
		       <div class="sixteen columns">
		         <h2 class="searchTitle">Start the night off right. Searching by Venue:</h2>
		       </div>
		     </div>
		    <div class="row">
		      <div class="eleven columns offset-by-five">
		        <form class="mainSearch left" name="searchVenue" action="/admin/seachVenueCommand" method="get">
		          <input id="searchVenueInput" type="text" name="search" size="100" />
		          <input id="searchVenueButton" type="submit" value="search" />
		        </form> 
		      </div>
		     </div>
		     
		     
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
		    <div class="row">
		      <div class="eleven columns offset-by-five">
		        <form class="mainSearch left" name="searchVenue" action="/admin/seachVenueCommand" method="get">
		          <input id="searchVenueInput" type="text" name="search" size="100" />
			        <input id="searchVenueButton" type="submit" onclick="showdiv('searchDiv')" value="search" />
			      </form> 
			    </div>
			 </div>
			 <div class="row" id="searchDiv">
          		<table>

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
            <th>#</th>
            <th>Name</th>
            <th>Description</th>
            <th>Address</th>
          </tr>
          </div>
          <div class="row">
          <tr>
            <th class="searchResults"><%=number%></th>
            <th class="searchResults"><%=venueName%></th>
            <th class="searchResults"><%=venueDescription%></th>
            <th class="searchResults"><%=venueAddress%></th>
          </tr>
        
        </table>  
        </div>
      <%
      		results.clear();
        	}//end for
        number = 0;
        }//end if/else
      %>
      
      </div>
    
  </body>
</html>
