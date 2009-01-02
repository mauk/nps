<!---
This page is used to log in the user. When the user fills out the form 
and clicks submit, the form is sent to projectSearch.cfm along with 
the hidden field, Form.LoggingOn. This tells projectSearch.cfm to attempt 
to log in the user. If the user information is correct, the appropriate 
client variables are set to log in the user, otherwise projectSearch.cfm 
requests login.cfm?failed=yes and the process is repeated.
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Login</title>

<!--- query for the advisor name drop-down list --->
<CFQUERY NAME="GetEmployees" DATASOURCE="#request.ds#">
	SELECT		intAgentID,
				strFirstName,
				strLastName
	FROM 		tblAgent
	WHERE		intAccessLevel < 3
	ORDER BY 	strFirstName
</CFQUERY>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

</head>

<BODY BGCOLOR="#ffffff" MARGINHEIGHT="0" TOPMARGIN="0" MARGINWIDTH="0" LEFTMARGIN="0">

<h2>&nbsp;Login</h2>
<table width="600" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>
	  <FORM ACTION="projectSearch.cfm" METHOD="POST">
	    <table align="center" width="525" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td>
	    <INPUT TYPE="hidden" NAME="LoggingOn" VALUE="1">
	    <br><br><br><br>
<CFOUTPUT>
	    <CFIF IsDefined("URL.failed")>
			<!--- The user has attempted to login and failed, projectSearch.cfm will
			send them back here with URL.failed defined. --->
	        <FONT COLOR="##FF0000">That is not a valid password.</FONT><br>
		    Please try again or <a href="projectSearch.cfm?Logout=yes">click here</a> to return to the Project Search. 
 	    <CFELSE>
	        Please select your name from the list and enter your password.
	    </CFIF>
</CFOUTPUT>
	    <br><br>
    
		<SELECT NAME="Employee">
		<!--- Display every employee. --->
		<CFOUTPUT QUERY="GetEmployees">
			<OPTION VALUE=#intAgentID#>#strFirstName# #strLastName#</OPTION>
		</CFOUTPUT>
		</SELECT>
		
		<B>Password:</B>
		<INPUT TYPE="password" NAME="Password" SIZE="15">
		<INPUT TYPE="Submit" VALUE="Login">
	  <br><br><br><br><br>
	  </td>
	  </tr>
	  </table>
      </form>
	 

      <img src="images/footer.gif" width="600" height="36"> 
	  
	</td>
  </tr>
</table>
</body>
</html>
