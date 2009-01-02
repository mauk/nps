<!--- This page is used to add, edit and delete locations --->

<!--- only users with Administrative access can edit locations --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Locations Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new location... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new location name already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblLocation
		WHERE	strLocation = '#UCASE(Form.name)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Location Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- add new location to the database --->
	<CFQUERY NAME="qryAddLoc" DATASOURCE="#request.ds#">
		INSERT 	INTO tblLocation (strLocation, bolActive)
		VALUES	('#UCase(Form.name)#', <CFIF IsDefined("Form.active")>True<CFELSE>False</CFIF>)
	</CFQUERY>
	<!--- set qryLocationCache to 0 days so that qryLocation on the 
	project pages will be refreshed --->
	<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
		<CFSET application.qryLocationCache = #CreateTimeSpan(0,0,0,0)#>
	</CFLOCK>
	
<!--- If user is editing an existing location... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new location name is already used (for a
	location other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblLocation
		WHERE	strLocation = '#UCASE(Form.name)#'
		AND		intLocationID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Location Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- update the location record specified by Form.edit --->
	<CFQUERY NAME="qryEditLoc" DATASOURCE="#request.ds#">
		UPDATE	tblLocation
		SET		strLocation = '#UCase(Form.name)#',
			<CFIF IsDefined("Form.active")>
				bolActive = True
			<CFELSE>
				bolActive = False
			</CFIF>
		WHERE	intLocationID = #Form.edit#
	</CFQUERY>
	<!--- set qryLocationCache to 0 days so that qryLocation on the 
	project pages will be refreshed --->
	<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
		<CFSET application.qryLocationCache = #CreateTimeSpan(0,0,0,0)#>
	</CFLOCK>
	
<!--- If user is deleting a location... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the Advisor has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblProjects WHERE intLocationID = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if it doesn't, delete the location --->
		<CFQUERY NAME="qryDeleteLoc" DATASOURCE="#request.ds#">
			DELETE FROM	tblLocation
			WHERE		intLocationID = #URL.delete#
		</CFQUERY>
		<!--- set qryLocationCache to 0 days so that qryLocation on the 
		project pages will be refreshed --->
		<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
			<CFSET application.qryLocationCache = #CreateTimeSpan(0,0,0,0)#>
		</CFLOCK>
	</CFIF>
	
</CFIF>

<!--- query to display the data for all of the locations --->
<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#">
	SELECT	*
	FROM	tblLocation
	ORDER BY	strLocation
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Locations Admin</b></p>
<p><a class="link" href="locationEdit.cfm?add=yes">Add New Location</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Name</b></td>
		<td><b>Active?</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryLocation">
	<tr>
		<td>#strLocation#</td>
		<td align="center"><CFIF #bolActive# EQ True>Yes<CFELSE>No</CFIF></td>
		<td><a class="link" href="locationEdit.cfm?edit=#intLocationID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Location?');" href="locationAdmin.cfm?delete=#intLocationID#">Delete</a></td>
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