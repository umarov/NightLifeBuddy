/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu
 */

package nightlifebuddy;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import nightlifebuddy.AdminProfile;

/**
 * Answer to the HTTP Servlet to add an admin profile. Redirect to the list of admin profiles. If error (e.g.
 * duplicated login ID) show error page.
 */
@SuppressWarnings("serial")
public class AddAdminProfileServlet extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String loginID = req.getParameter("loginID");
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		AdminProfile.createAdminProfile(loginID, name, email);
		
		resp.sendRedirect("/admin/adminHome.jsp");
	}
}
