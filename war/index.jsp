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
  
  <script>
<%List<Entity> venues = Venues.getFirstVenues(20);%>

$.getScript("//twitter.github.io/typeahead.js/releases/latest/typeahead.bundle.js", function()
{
var substringMatcher = function(strs) {
return function findMatches(q, cb) {
var matches, substringRegex;

// an array that will be populated with substring matches
matches = [];

// regex used to determine if a string contains the substring `q`
substrRegex = new RegExp(q, 'i');

// iterate through the pool of strings and for any string that
// contains the substring `q`, add it to the `matches` array
$.each(strs, function(i, str) {
if (substrRegex.test(str)) {
// the typeahead jQuery plugin expects suggestions to a
// JavaScript object, refer to typeahead docs for more info
matches.push({ value: str });
}
});

cb(matches);
};
};

var availableTags = new Array();
<%for (Entity venue : venues)
{%>
availableTags.push("<%=Venues.getName(venue)%>");
<%}%>

$('#the-search-box .typeahead').typeahead({
hint: true,
highlight: true,
minLength: 1
},
{
name: 'venues',
displayKey: 'value',
source: substringMatcher(availableTags)
});
});

  
  function loadUrl(location)
  {
	  this.document.location.href = location;
  }
  window.onload = function()
  {
	  var searchDiv = document.getElementById('search-div');
	  document.getElementById('mainSearchButton').onclick = function search()
	  {
		$('#search-div').empty();
		$('#search-div').className = 'results';
		$('#search-div').attr('disabled', true);
		
		var searchCommand = document.getElementById('searchBox').value;
	  	var allVenues = new Array();
	  	<%for (Entity venue : venues)
	  	{%>
	  	allVenues.push('<%=Venues.getName(venue)%>');
	  	<%}%>
	  	var index;
	  	var numResultsFound = 0;
	  	var redirectVenue;
	  	var newLine = document.createElement('li');
	  	for(index = 0; searchCommand != "" && index < allVenues.length; index++)
	  		{
	  			if (allVenues[index].toLowerCase().match(searchCommand.toLowerCase()) != null)
	  				{
	  					newLine = document.createElement('div');
	  					newLine.className = 'two-thirds column';
	  					var searchResult = document.createElement('a');
	  					
	  					searchResult.appendChild(document.createTextNode(allVenues[index]));
	  					searchResult.title = allVenues[index] + " profile";
	  					searchResult.href = "/venues/profile.jsp?venueName=" + allVenues[index];
	  					newLine.appendChild(searchResult);
	  					searchDiv.appendChild(newLine);
	  					redirectVenue = searchResult.href;
	  					numResultsFound++; 					
	  					
	  					
	  				}
	  		}
	  	if (numResultsFound === 1)
	  		{
	  			loadUrl(redirectVenue);
	  		}
	  	else 
	  		{
	  			if (numResultsFound > 1)
	  				{ 
	  					$('.typeahead').typeahead('close');
	  					$('#search-div').removeAttr('disabled');
	  				}
	  			else
	  				if(numResultsFound === 0)
	  					searchDiv.appendChild(document.createTextNode("No venues found"));
	  				
	  		}
	  	
	  	
	  	
	  }
  }
  

</script>

  </head>

  <body>
	<%@include file="header.jsp" %>
   
      
      	<div class="row">
		   <div class="sixteen columns">
		      <h2 class="searchTitle"> Start the night off right. Searching by Venue: </h2>
		   </div>
		</div>
		<div class="row">
			
		   <div class="eleven columns offset-by-five">
		   		<div id="the-search-box" class="mainSearch left">
		   				<input onkeydown="if (event.keyCode == 13) { document.getElementById('mainSearchButton').click(); return false; }" id="searchBox"  class="typeahead" type="text" placeholder="For example, 'Echostage'" autocomplete="off" name="search">
				    	<input id="mainSearchButton" type="submit" value="search" />
				</div> 
		      	
		   </div>
		 </div>	
		 <div id="search-div">
     
      
      </div><!-- end #search-div -->
    <%@include file="footer.jsp" %>
  </body>
</html>
