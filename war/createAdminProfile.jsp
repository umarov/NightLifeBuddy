<%@page import="com.google.appengine.api.users.UserService, com.google.appengine.api.users.UserServiceFactory, com.google.appengine.api.users.User" %>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="nightlifebuddy.AdminProfile"%>
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
  	<link rel="stylesheet" href="/stylesheets/base.css">
  	<link rel="stylesheet" href="/stylesheets/skeleton.css">
  	<link rel="stylesheet" href="/stylesheets/layout.css">
  	<link rel="stylesheet" href="/stylesheets/custom.css">
  	<link rel="stylesheet" href="/stylesheets/font-awesome.min.css">
  	<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  
  	<!-- SCRIPTS -->
  	<script src="//code.jquery.com/jquery-1.9.1.js"></script>
  	<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  	
	</head>
	<body>
	
	<% 
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	%>
	
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
		Entity admin = AdminProfile.getAdminProfileWithLoginID(user.getUserId());
		if (admin == null) 
		{
			%>
			<p>To be an admin, one has to sign up for it... Go ahead:</p>
			<form id="createAdminProfile" action="/addAdminProfileServlet" method="get">
				<input type="text" id="createAdminProfileInput" name="loginID" value="<%=user.getUserId()%>"> <br/>
				Name: <input type="text" id="createAdmingProfileInput" name="name"> <br/>
				Email: <input type="text" id="createAdminProfileInput" name="email" value="<%=user.getEmail() %>"> <br/>
				<input type="submit" id="createAdminProfileButton" value="Create Profile">
			
			</form>
			
			<%
		} else 
		{
			%>
			<script>document.location.replace("/admin")</script>
			<%
		}
		%>
	
	
	
	
	</body>
	
	</html>
