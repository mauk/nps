<!--- This page displays the form for adding and editing client contact information --->

<!--- only users with Administrative and Write access can edit advisor --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Area Chief</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing a client contact, retrieve the advisors information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryDept" DATASOURCE="#request.ds#">
		SELECT * FROM tblClientContact WHERE intClientContactID = #URL.edit#
	</CFQUERY>
</CFIF>
</head>

<CFIF IsDefined("URL.edit")>
<!--- If the user is editing a client contact, display the following form --->

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Edit Area Chief</b></p><br>
<FORM NAME="form1" ACTION="clientContactAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="firstName_required" VALUE="You must enter a first name">
<INPUT TYPE="hidden" NAME="lastName_required" VALUE="You must enter a last name.">
<CFOUTPUT QUERY="qryDept">
<!--- the hidden field, edit, tells clientContactAdmin.cfm 
which client contact the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="#intClientContactID#">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">First Name:</td>
		<td><INPUT TYPE="text" NAME="firstName" SIZE="30" MAXLENGTH=30 VALUE="#strFirstName#"></td> 
	</tr>
	<tr>
		<td valign="right">Last Name:</td>
		<td><INPUT TYPE="text" NAME="lastName" SIZE="30" MAXLENGTH=30 VALUE="#strLastName#"></td> 
	</tr>
	<tr>
		<td valign="right">Area:</td>
		<td><INPUT TYPE="text" NAME="area" SIZE="50" MAXLENGTH=50 VALUE="#strArea#"></td> 
	</tr>
	<tr>
		<td valign="right">Active?:</td>
		<td><INPUT TYPE="checkbox" NAME="active" VALUE="yes"<CFIF #bolActive# EQ True> CHECKED</CFIF>></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="##" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="clientContactAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</CFOUTPUT>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new Advisor, so display the following form --->

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Area Chief</b></p><br>
<FORM NAME="form1" ACTION="clientContactAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="firstName_required" VALUE="You must enter a first name.">
<INPUT TYPE="hidden" NAME="lastName_required" VALUE="You must enter a last name.">
<!--- The hidden field, add, tells clientContactAdmin.cfm 
that the user is adding a client contact --->
<INPUT TYPE="hidden" NAME="add" VALUE="yes">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">First Name:</td>
		<td><INPUT TYPE="text" NAME="firstName" SIZE="30"></td> 
	</tr>
	<tr>
		<td valign="right">Last Name:</td>
		<td><INPUT TYPE="text" NAME="lastName" SIZE="30"></td> 
	</tr>
	<tr>
		<td valign="right">Area:</td>
		<td><INPUT TYPE="text" NAME="area" SIZE="30"></td> 
	</tr>
	<tr>
		<td valign="right">Active?:</td>
		<td><INPUT TYPE="checkbox" NAME="active" CHECKED></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="clientContactAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>

</CFIF>
</html>
<CFELSE>
<!--- The user does not have access to this page so display a message --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Admin</title>
</head>
<body>
<br><br><p align="center"><b>Sorry, you do not have access to this part of the site.</b></p>
</body>
</CFIF>