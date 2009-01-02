<!--- This page is used to add, edit and delete interest sold types --->

<!--- only users with Administrative access can edit interest sold types --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Interest Sold Types Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new interest sold type... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new interest sold already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblInterestSold
		WHERE	strInterestSold = '#UCASE(Form.interestSold)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Interest Sold Type")#">
		<CFABORT>
	</CFIF>

	<!--- add new interest sold type to the database --->
	<CFQUERY NAME="qryAddInterestSold" DATASOURCE="#request.ds#">
		INSERT 	INTO tblInterestSold (strInterestSold)
		VALUES	('#Form.interestSold#')
	</CFQUERY>
	
<!--- If user is editing an existing interest sold type... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new interest sold name is already used (for a
	interest sold other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblInterestSold
		WHERE	strInterestSold = '#UCASE(Form.interestSold)#'
		AND		intInterestSoldID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Interest Sold Type")#">
		<CFABORT>
	</CFIF>

	<!--- update the interest sold type record specified by Form.edit --->
	<CFQUERY NAME="qryEditInterestSold" DATASOURCE="#request.ds#">
		UPDATE	tblInterestSold
		SET		strInterestSold = '#Form.interestSold#'
		WHERE	intInterestSoldID = #Form.edit#
	</CFQUERY>
	
<!--- If user is deleting an interest sold type... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform two queries to see if the interest sold type has any projects
	(one query for disposals and one for acquisitions). --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblDisposals WHERE intInterestSoldID = #URL.delete#
	</CFQUERY>
	<CFQUERY NAME="qryIsItemUsed2" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblAcquisitions WHERE intInterestType = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount OR qryIsItemUsed2.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if they do not, delete the interest sold type --->
		<CFQUERY NAME="qryDeleteInterestSold" DATASOURCE="#request.ds#">
			DELETE FROM	tblInterestSold
			WHERE		intInterestSoldID = #URL.delete#
		</CFQUERY>
	</CFIF>
	
</CFIF>

<!--- query to display the data for all of the interest sold types --->
<CFQUERY NAME="qryInterestSold" DATASOURCE="#request.ds#">
	SELECT * FROM tblInterestSold WHERE intInterestSoldID <> #request.defaultInterestSold# ORDER BY strInterestSold
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Interest Sold Types Admin</b></p>
<p><a class="link" href="interestSoldEdit.cfm?add=yes">Add New Interest Sold Type</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Purchaser Type</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryInterestSold">
	<tr>
		<td>#strInterestSold#</td>
		<td><a class="link" href="interestSoldEdit.cfm?edit=#intInterestSoldID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Interest Sold Type?');" href="interestSoldAdmin.cfm?delete=#intInterestSoldID#">Delete</a></td>
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