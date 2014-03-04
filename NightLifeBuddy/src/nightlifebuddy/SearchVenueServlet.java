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
 * Search for a venue.
 */
@SuppressWarnings("serial")
public class SearchVenueServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                Venues.searchVenueCommand(req.getParameter("search"));

                resp.sendRedirect("/index.jsp");
        }
}
