<!--- This page displays the form for adding and editing advisors --->

<!--- only users with Administrative access can edit advisors --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Agent</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing an advisor, retrieve the advisor's information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#">
	SELECT	tblAgent.intAgentID,
			tblAgent.strFirstName,
			tblAgent.strLastName,
			tblAgent.strAbrev,
			tblAgent.strPassword,
			tblAccessLevel.intAccessLevel
	FROM	tblAgent, tblAccessLevel
	WHERE	tblAgent.intAccessLevel = tblAccessLevel.intAccessLevel
	AND		tblAgent.intAgentID = #URL.edit#
</CFQUERY>
</CFIF>

<!--- Query to populate the Access Level list box --->
<CFQUERY NAME="qryAccessLevel" DATASOURCE="#request.ds#">
	SELECT * FROM tblAccessLevel ORDER BY strAccessLevel
</CFQUERY>
</head>

<!--- If the user is editing an Advisor, display the following form --->
<CFIF IsDefined("URL.edit")>

<body bgcolor="#FFFFFF" text="#000000">
<!--- variables used to populate the form with the query results --->
<CFOUTPUT QUERY="qryAgent">
<CFSET projAgentID = intAgentID>
<CFSET projFirstName = strFirstName>
<CFSET projLastName = strLastName>
<CFSET projAbrev = strAbrev>
<CFSET projPassword = strPassword>
<CFSET projAccessLevel = intAccessLevel>
</CFOUTPUT>
<p><b>Edit Advisor</b></p><br>
<FORM NAME="form1" ACTION="agentAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="firstName_required" VALUE="You must enter a first name.">
<INPUT TYPE="hidden" NAME="lastName_required" VALUE="You must enter a last name.">
<INPUT TYPE="hidden" NAME="abrev_required" VALUE="You must enter an abbreviation.">
<INPUT TYPE="hidden" NAME="password_required" VALUE="You must enter a password.">
<!--- the hidden field, edit, tells agentAdmin.cfm which Advisor the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="<CFOUTPUT>#projAgentID#</CFOUTPUT>">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">First Name:</td>
		<td><INPUT TYPE="text" NAME="firstName" SIZE="30" MAXLENGTH=30 VALUE="<CFOUTPUT>#projFirstName#</CFOUTPUT>"></td> 
	</tr>
	<tr>
		<td valign="right">Last Name:</td>
		<td><INPUT TYPE="text" NAME="lastName" SIZE="30" MAXLENGTH=30 VALUE="<CFOUTPUT>#projLastName#</CFOUTPUT>"></td> 
	</tr>
	<tr>
		<td valign="right">Abbreviation:</td>
		<td><INPUT TYPE="text" NAME="abrev" SIZE="3" MAXLENGTH=3 VALUE="<CFOUTPUT>#projAbrev#</CFOUTPUT>"></td> 
	</tr>
	<tr>
		<td valign="right">Password:</td>
		<td><INPUT TYPE="text" NAME="password" SIZE="15" MAXLENGTH=15 VALUE="<CFOUTPUT>#projPassword#</CFOUTPUT>"></td> 
	</tr>
	<tr>
		<td valign="right">Access Level:</td>
		<td>
			<SELECT NAME="accessLevel">
			<CFOUTPUT QUERY="qryAccessLevel">
				<OPTION VALUE=#intAccessLevel#<CFIF #intAccessLevel# EQ #projAccessLevel#> SELECTED</CFIF>>#strAccessLevel#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="agentAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new Advisor, so display the following form --->
<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Agent</b></p><br>
<FORM NAME="form1" ACTION="agentAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="firstName_required" VALUE="You must enter a first name.">
<INPUT TYPE="hidden" NAME="lastName_required" VALUE="You must enter a last name.">
<INPUT TYPE="hidden" NAME="abrev_required" VALUE="You must enter an abbreviation.">
<INPUT TYPE="hidden" NAME="password_required" VALUE="You must enter a password.">
<!--- The hidden field, add, tells agentAdmin.cfm that the user is adding an advisor --->
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
		<td valign="right">Abbreviation:</td>
		<td><INPUT TYPE="text" NAME="abrev" SIZE="10"></td> 
	</tr>
	<tr>
		<td valign="right">Password:</td>
		<td><INPUT TYPE="text" NAME="password" SIZE="30"></td> 
	</tr>
	<tr>
		<td valign="right">Access Level:</td>
		<td>
			<SELECT NAME="accessLevel">
			<CFOUTPUT QUERY="qryAccessLevel">
				<OPTION VALUE=#intAccessLevel#<CFIF #intAccessLevel# EQ 2> SELECTED</CFIF>>#strAccessLevel#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="agentAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
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