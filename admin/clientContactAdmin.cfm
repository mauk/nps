<!--- This page is used to add, edit and delete client contacts --->

<!--- only users with Administrative or Write access can edit client contacts --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Client Contact Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new client contact... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new client contact already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblClientContact
		WHERE	strFirstName = '#UCASE(Form.firstName)#'
		AND		strLastName = '#UCASE(Form.lastName)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Client Contact Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- add new client contact to the database --->
	<CFQUERY NAME="qryAddChief" DATASOURCE="#request.ds#">
		INSERT 	INTO tblClientContact (strFirstName, strLastName, strArea, bolActive)
		VALUES	('#Form.firstName#', '#Form.lastName#', '#Form.area#', <CFIF IsDefined("Form.active")>True<CFELSE>False</CFIF>)
	</CFQUERY>
	
<!--- If user is editing an existing client contact... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new client contact name is already used (for a
	client contact other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblClientContact
		WHERE	strFirstName = '#UCASE(Form.firstName)#'
		AND		strLastName = '#UCASE(Form.lastName)#'
		AND		intClientContactID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Cilent Contact Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- update the client contact record specified by Form.edit --->
	<CFQUERY NAME="qryEditChief" DATASOURCE="#request.ds#">
		UPDATE	tblClientContact
		SET		strFirstName = '#Form.firstName#',
				strLastName = '#Form.lastName#',
				strArea = '#Form.area#',
			<CFIF IsDefined("Form.active")>
				bolActive = True
			<CFELSE>
				bolActive = False
			</CFIF>
		WHERE	intClientContactID = #Form.edit#
	</CFQUERY>
	
<!--- If user is deleting an advisor... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the client contact has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblProjects WHERE intClientContactID = #URL.delete#
	</CFQUERY>
	<!--- if they do, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if they do not, delete the client contact --->
		<CFQUERY NAME="qryDeleteChief" DATASOURCE="#request.ds#">
			DELETE FROM	tblClientContact
			WHERE		intClientContactID = #URL.delete#
		</CFQUERY>
	</CFIF>
	
</CFIF>

<!--- query to display all of the client contacts, except for the default value --->
<CFQUERY NAME="qryClientContact" DATASOURCE="#request.ds#">
	SELECT * FROM tblClientContact WHERE intClientContactID <> #request.defaultClientContact# ORDER BY strFirstName, strLastName
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Client Contact Admin</b></p>
<p><a class="link" href="clientContactEdit.cfm?add=yes">Add New Area Chief</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>First Name</b></td>
		<td><b>Last Name</b></td>
		<td><b>Area</b></td>
		<td><b>Active?</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryClientContact">
	<tr>
		<td>#strFirstName#</td>
		<td>#strLastName#</td>
		<td>#strArea#<CFIF #strArea# EQ "">&nbsp;</CFIF></td>
		<td align="center"><CFIF #bolActive# EQ True>Yes<CFELSE>No</CFIF></td>
		<td><a class="link" href="clientContactEdit.cfm?edit=#intClientContactID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Client Contact?');" href="clientContactAdmin.cfm?delete=#intClientContactID#">Delete</a></td>
	</tr>
</CFOUTPUT>
</table>
<br><br>
</body>
</html>
<CFELSE>
<!--- the user does not have access to this page so display a message --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Admin</title>
</head>
<body>
<br><br><p align="center"><b>Sorry, you do not have access to this part of the site.</b></p>
</body>
</CFIF>