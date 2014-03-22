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


//TOOD comments

@SuppressWarnings("serial")
public class DeleteGenreServlet extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		boolean result=Genres.deleteGenreCommand(req.getParameter("venueName"));
		resp.setStatus((result)?HttpServletResponse.SC_OK:HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	}
}