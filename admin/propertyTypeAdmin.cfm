<!--- This page is used to add, edit and delete property types --->

<!--- only users with Administrative access can edit property types --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Property Types Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new property type... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new property type already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblPropertyType
		WHERE	strPropertyType = '#UCASE(Form.propertyType)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Property Type")#">
		<CFABORT>
	</CFIF>

	<!--- add new property type to the database --->
	<CFQUERY NAME="qryAddPropertyType" DATASOURCE="#request.ds#">
		INSERT 	INTO tblPropertyType (strPropertyType)
		VALUES	('#Form.propertyType#')
	</CFQUERY>
	
<!--- If user is editing an existing property type... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new property type name is already used (for a
	property type other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblPropertyType
		WHERE	strPropertyType = '#UCASE(Form.propertyType)#'
		AND		intPropertyTypeID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Property Type")#">
		<CFABORT>
	</CFIF>

	<!--- update the property type record specified by Form.edit --->
	<CFQUERY NAME="qryEditPropertyType" DATASOURCE="#request.ds#">
		UPDATE	tblPropertyType
		SET		strPropertyType = '#Form.propertyType#'
		WHERE	intPropertyTypeID = #Form.edit#
	</CFQUERY>
	
<!--- If user is deleting a property type... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the property type has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblDisposals WHERE intPropertyTypeID = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if it doesn't, delete the property type --->
		<CFQUERY NAME="qryDeletePropertyType" DATASOURCE="#request.ds#">
			DELETE FROM	tblPropertyType
			WHERE		intPropertyTypeID = #URL.delete#
		</CFQUERY>
	</CFIF>
	
</CFIF>

<!--- query to display all of the property types --->
<CFQUERY NAME="qryPropertyType" DATASOURCE="#request.ds#">
	SELECT * FROM tblPropertyType WHERE intPropertyTypeID <> #request.defaultPropertyType# ORDER BY strPropertyType
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Property Types Admin</b></p>
<p><a class="link" href="propertyTypeEdit.cfm?add=yes">Add New Property Type</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Property Type</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryPropertyType">
	<tr>
		<td>#strPropertyType#</td>
		<td><a class="link" href="propertyTypeEdit.cfm?edit=#intPropertyTypeID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Property Type?');" href="propertyTypeAdmin.cfm?delete=#intPropertyTypeID#">Delete</a></td>
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