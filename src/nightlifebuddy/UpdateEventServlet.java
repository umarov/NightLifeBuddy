/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alfredo Loris
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
public class UpdateEventServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                Events.updateEventCommand(req.getParameter("eventName"), req.getParameter("eventDescription"), req.getParameter("eventAddress"));

                resp.sendRedirect("/admin/allEvents.jsp");
        }
}