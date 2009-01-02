<!--- This page is used to add, edit and delete advisors --->

<!--- only users with Administrative access can edit advisors --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Advisors Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new advisor... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new abbreviation is already used --->
	<CFQUERY NAME="qryDuplicateAbrev" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblAgent
		WHERE	strAbrev = '#UCASE(Form.abrev)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicateAbrev.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Abbreviation")#">
		<CFABORT>
	</CFIF>
	
	<!--- perform query to see if the new advisor name already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblAgent
		WHERE	strFirstName = '#UCASE(Form.firstName)#'
		AND		strLastName = '#UCASE(Form.lastName)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Advisor Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- add new Advisor to the database --->
	<CFQUERY NAME="qryAddAgent" DATASOURCE="#request.ds#">
		INSERT 	INTO tblAgent (strFirstName, strLastName, strAbrev, strPassword, intAccessLevel)
		VALUES	('#UCase(Form.firstName)#', 
				'#UCase(Form.lastName)#', 
				'#UCase(Form.abrev)#', 
				'#UCase(Form.password)#', 
				#Form.accessLevel#)
	</CFQUERY>
	<!--- set qryAgentCache to 0 days so that qryAgent on the 
	project pages will be refreshed --->
	<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
		<CFSET application.qryAgentCache = #CreateTimeSpan(0,0,0,0)#>
	</CFLOCK>
	
<!--- If user is editing an existing advisor... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new abbreviation is already used (for an
	advisor other than the one being edited) --->
	<CFQUERY NAME="qryDuplicateAbrev" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblAgent
		WHERE	strAbrev = '#UCASE(Form.abrev)#'
		AND		intAgentID <> #Form.edit# 
	</CFQUERY>
	<!--- if it is, display an error and abort all other operations --->
	<CFIF qryDuplicateAbrev.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Abbreviation")#">
		<CFABORT>
	</CFIF>
	
	<!--- perform query to see if the new advisor name is already used (for an
	advisor other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblAgent
		WHERE	strFirstName = '#UCASE(Form.firstName)#'
		AND		strLastName = '#UCASE(Form.lastName)#'
		AND		intAgentID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Advisor Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- update the advisor record specified by Form.edit --->
	<CFQUERY NAME="qryEditAgent" DATASOURCE="#request.ds#">
		UPDATE	tblAgent
		SET		strFirstName = '#UCase(Form.firstName)#', 
				strLastName = '#UCase(Form.lastName)#', 
				strAbrev = '#UCase(Form.abrev)#', 
				strPassword = '#UCase(Form.password)#', 
				intAccessLevel = #Form.accessLevel#
		WHERE	intAgentID = #Form.edit#
	</CFQUERY>
	<!--- set qryAgentCache to 0 days so that qryAgent on the 
	project pages will be refreshed --->
	<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
		<CFSET application.qryAgentCache = #CreateTimeSpan(0,0,0,0)#>
	</CFLOCK>
	
<!--- If user is deleting an advisor... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the Advisor has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblProjects WHERE intAgent = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	<!--- if it doesn't, delete the advisor --->
		<CFQUERY NAME="qryDeleteAgent" DATASOURCE="#request.ds#">
			DELETE FROM	tblAgent
			WHERE		intAgentID = #URL.delete#
		</CFQUERY>
		<!--- set qryAgentCache to 0 days so that qryAgent on the 
		project pages will be refreshed --->
		<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
			<CFSET application.qryAgentCache = #CreateTimeSpan(0,0,0,0)#>
		</CFLOCK>
	</CFIF>
	
</CFIF>

<!--- query to display the data for all of the advisors --->
<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#">
	SELECT	tblAgent.intAgentID,
			tblAgent.strFirstName,
			tblAgent.strLastName,
			tblAgent.strAbrev,
			tblAgent.strPassword,
			tblAgent.datLastVisit,
			tblAccessLevel.strAccessLevel
	FROM	tblAgent, tblAccessLevel
	WHERE	tblAgent.intAccessLevel = tblAccessLevel.intAccessLevel
	ORDER BY	strFirstName, strLastName
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Advisors Admin</b></p>
<p><a class="link" href="agentEdit.cfm?add=yes">Add New Advisor</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>First Name</b></td>
		<td><b>Last Name</b></td>
		<td><b>Abbrev.</b></td>
		<td><b>Password</b></td>
		<td><b>Access Level</b></td>
		<td><b>Last Visit</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryAgent">
	<tr>
		<td>#strFirstName#</td>
		<td>#strLastName#</td>
		<td align="center">#strAbrev#</td>
		<td>#strPassword#</td>
		<td>#strAccessLevel#</td>
		<td>#DateFormat(datLastVisit, "mmm d, yyyy")#&nbsp;</td>
		<td><a class="link" href="agentEdit.cfm?edit=#intAgentID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Advisor?');" href="agentAdmin.cfm?delete=#intAgentID#">Delete</a></td>
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