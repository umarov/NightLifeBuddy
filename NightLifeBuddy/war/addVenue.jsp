<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link href="http://www.gstatic.com/codesite/ph/17444577587916266307/css/ph_core.css" rel="stylesheet" type="text/css" />
 	<link href="http://code.google.com/css/codesite.pack.04102009.css" rel="stylesheet" type="text/css" />
  	<script language="javascript" src='script/jquery-1.6.min.js'></script>
  	<script language="javascript" src='script/ajax.util.js'></script>
</head>
<body>
<div class="create-ctr" id="venue-create-ctr">
	  	<h2>Create Venue</h2>
	  	<form action="/venues" method="post" name="venue-create-form" id="venue-create-form" >
	  
	  	<table width="200" cellspacing="0" cellpadding="0">
	  	<tbody>
	  	<tr >
		 <td>Name </td>
          <td><input type="text" style="width: 185px;" autocomplete="off" class="gsc-input" maxlength="2048" name="name" id="name" /></span></td>
		 </tr>
		<tr>
           <td>Description</td>
           <td><input type="text" style="width: 185px;" autocomplete="off" class="gsc-input" maxlength="2048" name="description" id="description" /></td>
         </tr>
         <tr>
           <td>Address</td>
           <td><input type="text" style="width: 185px;" autocomplete="off" class="gsc-input" maxlength="2048" name="address" id="address" /></td>
         </tr>
        <tr>
          <td>&nbsp;</td>
          <td> 
          <input type="submit" class="submit" title="Save" value="Save" />
          <input type="button" class="cancel" title="Cancel" value="Cancel" onclick="cancel('venue')" />
          <input type="reset" id="product-reset" class="cancel" title="Reset" value="Reset" style="visibility: hidden"/>
         </td>
        </tr>
	  	</tbody>
  </table>
  </form>
  </div>
  
  </div>
</body>

</html>
