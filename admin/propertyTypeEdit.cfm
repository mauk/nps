<!--- This page displays the form for adding and editing property types --->

<!--- only users with Administrative access can edit property type --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Property Type</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing a property type, retrieve the property type's information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryPropertyType" DATASOURCE="#request.ds#">
		SELECT * FROM tblPropertyType WHERE intPropertyTypeID = #URL.edit#
	</CFQUERY>
</CFIF>
</head>

<!--- If the user is editing a property type, display the following form
populated with data from the above query. --->
<CFIF IsDefined("URL.edit")>

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Edit Property Type</b></p><br>
<FORM NAME="form1" ACTION="propertyTypeAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="propertyType_required" VALUE="You must enter a property type">
<CFOUTPUT QUERY="qryPropertyType">
<!--- the hidden field, edit, tells propertyTypeAdmin.cfm 
which property type the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="#intPropertyTypeID#">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Property Type:</td>
		<td><INPUT TYPE="text" NAME="propertyType" SIZE="50" MAXLENGTH=50 VALUE="#strPropertyType#"></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="##" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="propertyTypeAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</CFOUTPUT>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new property type, so display the following form --->

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Property Type</b></p><br>
<FORM NAME="form1" ACTION="propertyTypeAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="propertyType_required" VALUE="You must enter a property type.">
<!--- The hidden field, add, tells propertyTypeAdmin.cfm 
that the user is adding a property type --->
<INPUT TYPE="hidden" NAME="add" VALUE="yes">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Property Type:</td>
		<td><INPUT TYPE="text" NAME="propertyType" SIZE="30"></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="propertyTypeAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
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