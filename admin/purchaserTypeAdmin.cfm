<!--- This page is used to add, edit and delete purchaser types --->

<!--- only users with Administrative access can edit purchaser types --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Purchaser Types Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new purchaser type... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new purchaser type already exists --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblPurchaserType
		WHERE	strPurchaserType = '#UCASE(Form.purchaserType)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Purchaser Type")#">
		<CFABORT>
	</CFIF>
	
	<!--- add new purchaser type to the database --->
	<CFQUERY NAME="qryAddPurchaserType" DATASOURCE="#request.ds#">
		INSERT 	INTO tblPurchaserType (strPurchaserType)
		VALUES	('#Form.purchaserType#')
	</CFQUERY>
	
<!--- If user is editing an existing purchaser type... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new purchaser type name is already used (for a
	purchaser type other than the one being edited) --->
	<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblPurchaserType
		WHERE	strPurchaserType = '#UCASE(Form.purchaserType)#'
		AND		intPurchaserTypeID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicate.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Purchaser Type")#">
		<CFABORT>
	</CFIF>

	<!--- update the purchaser type record specified by Form.edit --->
	<CFQUERY NAME="qryEditPurchaserType" DATASOURCE="#request.ds#">
		UPDATE	tblPurchaserType
		SET		strPurchaserType = '#Form.purchaserType#'
		WHERE	intPurchaserTypeID = #Form.edit#
	</CFQUERY>
	
<!--- If user is deleting a purchaser type... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the purchaser type has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblDisposals WHERE intPurchaserTypeID = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if it doesn't, delete the purchaser type --->
		<CFQUERY NAME="qryDeletePurchaserType" DATASOURCE="#request.ds#">
			DELETE FROM	tblPurchaserType
			WHERE		intPurchaserTypeID = #URL.delete#
		</CFQUERY>
	</CFIF>
	
</CFIF>

<!--- query to display all of the purchaser types --->
<CFQUERY NAME="qryPurchaserType" DATASOURCE="#request.ds#">
	SELECT * FROM tblPurchaserType WHERE intPurchaserTypeID <> #request.defaultPurchaserType# ORDER BY strPurchaserType
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Purchaser Types Admin</b></p>
<p><a class="link" href="purchaserTypeEdit.cfm?add=yes">Add New Purchaser Type</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Purchaser Type</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryPurchaserType">
	<tr>
		<td>#strPurchaserType#</td>
		<td><a class="link" href="purchaserTypeEdit.cfm?edit=#intPurchaserTypeID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Purchaser Type?');" href="purchaserTypeAdmin.cfm?delete=#intPurchaserTypeID#">Delete</a></td>
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