<!--- This page displays the form for adding and editing locations --->

<!--- only users with Administrative access can edit locations --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Location</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing an advisor, retrieve the location's information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#">
	SELECT	*
	FROM	tblLocation
	WHERE	tblLocation.intLocationID = #URL.edit#
</CFQUERY>
</CFIF>
</head>

<!--- If the user is editing a location, display the following form --->
<CFIF IsDefined("URL.edit")>

<body bgcolor="#FFFFFF" text="#000000">
<CFOUTPUT QUERY="qryLocation">
<CFSET projLocationID = intLocationID>
<CFSET projLocation = strLocation>
<CFSET projActive = bolActive>
</CFOUTPUT>
<p><b>Edit Location</b></p><br>
<FORM NAME="form1" ACTION="locationAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="name_required" VALUE="You must enter a location name.">
<!--- the hidden field, edit, tells locationAdmin.cfm which location the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="<CFOUTPUT>#projLocationID#</CFOUTPUT>">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Name:</td>
		<td><INPUT TYPE="text" NAME="name" SIZE="50" MAXLENGTH=50 VALUE="<CFOUTPUT>#projLocation#</CFOUTPUT>"></td> 
	</tr>
	<tr>
		<td valign="right">Active?:</td>
		<td><INPUT TYPE="checkbox" NAME="active" VALUE="yes"<CFIF #projActive# EQ True> CHECKED</CFIF>></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="locationAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new location, so display the following form --->

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Location</b></p><br>
<FORM NAME="form1" ACTION="locationAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="name_required" VALUE="You must enter a location name.">
<!--- The hidden field, add, tells locationAdmin.cfm that the user is adding a location --->
<INPUT TYPE="hidden" NAME="add" VALUE="yes">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Name:</td>
		<td><INPUT TYPE="text" NAME="name" SIZE="30"></td> 
	</tr>
	<tr>
		<td valign="right">Active?:</td>
		<td><INPUT TYPE="checkbox" NAME="active" CHECKED></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="locationAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
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