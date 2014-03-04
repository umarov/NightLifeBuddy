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


//TOOD comments

@SuppressWarnings("serial")
public class DeleteEventServlet extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		boolean result=Events.deleteEventCommand(req.getParameter("eventName"));
		resp.setStatus((result)?HttpServletResponse.SC_OK:HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	}
}