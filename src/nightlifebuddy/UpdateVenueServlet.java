/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Muzafar Umarov
 */

package nightlifebuddy;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Update the admin profile.
 */
@SuppressWarnings("serial")
public class UpdateVenueServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                
        	String name = req.getParameter("venueName");
        	String desc = req.getParameter("venueDescription");
        	String address = req.getParameter("venueAddress");
        	int agereq =  Integer.parseInt(req.getParameter("ageRequirement"));
        	String hours = req.getParameter("venueHours");
        	
        	Venues.updateVenueCommand(name, desc, address, agereq, hours);

            resp.sendRedirect("/admin/allVenues.jsp");
        }
}