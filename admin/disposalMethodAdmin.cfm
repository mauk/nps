<!--- This page is used to add, edit and delete disposal methods --->

<!--- only users with Administrative access can edit disposal methods --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Disposal Methods Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new disposal method... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new disposal method already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblDisposalMethod
		WHERE	strDisposalMethod = '#UCASE(Form.disposalMethod)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Disposal Method")#">
		<CFABORT>
	</CFIF>

	<!--- add new disposal method to the database --->
	<CFQUERY NAME="qryAddDisposalMethod" DATASOURCE="#request.ds#">
		INSERT 	INTO tblDisposalMethod (strDisposalMethod)
		VALUES	('#Form.disposalMethod#')
	</CFQUERY>
	
<!--- If user is editing an existing disposal method... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new disposal method name is already used (for a
	disposal method other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblDisposalMethod
		WHERE	strDisposalMethod = '#UCASE(Form.disposalMethod)#'
		AND		intDisposalMethodID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Disposal Method")#">
		<CFABORT>
	</CFIF>

	<!--- update the disposal method record specified by Form.edit --->
	<CFQUERY NAME="qryEditDisposalMethod" DATASOURCE="#request.ds#">
		UPDATE	tblDisposalMethod
		SET		strDisposalMethod = '#Form.disposalMethod#'
		WHERE	intDisposalMethodID = #Form.edit#
	</CFQUERY>
	
<!--- If user is deleting a disposal method... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the disposal method has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblDisposals WHERE intDisposalMethod = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if it doesn't, delete the disposal method --->
		<CFQUERY NAME="qryDeleteDisposalMethod" DATASOURCE="#request.ds#">
			DELETE FROM	tblDisposalMethod
			WHERE		intDisposalMethodID = #URL.delete#
		</CFQUERY>
	</CFIF>
	
</CFIF>

<!--- query to display the data for all of the disposal methods --->
<CFQUERY NAME="qryDisposalMethod" DATASOURCE="#request.ds#">
	SELECT * FROM tblDisposalMethod WHERE intDisposalMethodID <> #request.defaultDisposalMethod# ORDER BY strDisposalMethod
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Disposal Methods Admin</b></p>
<p><a class="link" href="disposalMethodEdit.cfm?add=yes">Add New Disposal Method</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Disposal Method</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryDisposalMethod">
	<tr>
		<td>#strDisposalMethod#</td>
		<td><a class="link" href="disposalMethodEdit.cfm?edit=#intDisposalMethodID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Disposal Method?');" href="disposalMethodAdmin.cfm?delete=#intDisposalMethodID#">Delete</a></td>
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