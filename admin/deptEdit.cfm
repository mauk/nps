<!--- This page displays the form for adding and editing departments --->

<!--- only users with Administrative access can edit departments --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Client/Dept</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing a department, retrieve the department's information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryDept" DATASOURCE="#request.ds#">
		SELECT * FROM tblDept WHERE intDeptID = #URL.edit#
	</CFQUERY>
</CFIF>
</head>

<!--- If the user is editing a department, display the following form --->
<CFIF IsDefined("URL.edit")>

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Edit Client/Dept</b></p><br>
<FORM NAME="form1" ACTION="deptAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="abrev_required" VALUE="You must enter a department abbreviation.">
<INPUT TYPE="hidden" NAME="name_required" VALUE="You must enter a department name.">
<CFOUTPUT QUERY="qryDept">
<!--- the hidden field, edit, tells departmentAdmin.cfm which department the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="#intDeptID#">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Name:</td>
		<td><INPUT TYPE="text" NAME="name" SIZE="50" MAXLENGTH=75 VALUE="#strDeptName#"></td> 
	</tr>
	<tr>
		<td valign="right">Abbreviation:</td>
		<td><INPUT TYPE="text" NAME="abrev" SIZE="10" MAXLENGTH=12 VALUE="#strDeptAbrev#"></td> 
	</tr>
	<tr>
		<td valign="right">Active?:</td>
		<td><INPUT TYPE="checkbox" NAME="active" VALUE="yes"<CFIF #bolActive# EQ True> CHECKED</CFIF>></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="##" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="deptAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</CFOUTPUT>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new department, so display the following form --->
<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Client/Dept</b></p><br>
<FORM NAME="form1" ACTION="deptAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="abrev_required" VALUE="You must enter a department abbreviation.">
<INPUT TYPE="hidden" NAME="name_required" VALUE="You must enter a department name.">
<!--- The hidden field, add, tells departmentAdmin.cfm that the user is adding a department --->
<INPUT TYPE="hidden" NAME="add" VALUE="yes">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Name:</td>
		<td><INPUT TYPE="text" NAME="name" SIZE="30"></td> 
	</tr>
	<tr>
		<td valign="right">Abbreviation:</td>
		<td><INPUT TYPE="text" NAME="abrev" SIZE="10"></td> 
	</tr>
	<tr>
		<td valign="right">Active?:</td>
		<td><INPUT TYPE="checkbox" NAME="active" CHECKED></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="deptAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
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