<!--- This page is used to add, edit and departments --->

<!--- only users with Administrative and Write access can edit departments --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Departments Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is adding a new department... --->
<CFIF IsDefined("Form.add")>

	<!--- perform query to see if the new department name already exists --->
	<CFQUERY NAME="qryDuplicateName" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblDept
		WHERE	strDeptName = '#UCASE(Form.name)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicateName.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Department Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- perform query to see if the new department abreviation already exists --->
	<CFQUERY NAME="qryDuplicateAbrev" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblDept
		WHERE	strDeptAbrev = '#UCASE(Form.abrev)#'
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicateAbrev.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Department Abbreviation")#">
		<CFABORT>
	</CFIF>
	
	<!--- add new department to the database --->
	<CFQUERY NAME="qryAddDept" DATASOURCE="#request.ds#">
		INSERT 	INTO tblDept (strDeptName, strDeptAbrev, bolActive)
		VALUES	('#Form.name#', '#Form.abrev#', <CFIF IsDefined("Form.active")>True<CFELSE>False</CFIF>)
	</CFQUERY>
	<!--- set qryDeptCache to 0 days so that qryDept on the 
	project pages will be refreshed --->
	<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
		<CFSET application.qryDeptCache = #CreateTimeSpan(0,0,0,0)#>
	</CFLOCK>
	
<!--- If user is editing an existing department... --->
<CFELSEIF IsDefined("Form.edit")>

	<!--- perform query to see if the new department name already exists 
	(for a department other than the one being edited)--->
	<CFQUERY NAME="qryDuplicateName" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblDept
		WHERE	strDeptName = '#UCASE(Form.name)#'
		AND		intDeptID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicateName.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Department Name")#">
		<CFABORT>
	</CFIF>
	
	<!--- perform query to see if the new department abbreviation already exists 
	(for a department other than the one being edited)--->
	<CFQUERY NAME="qryDuplicateAbrev" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblDept
		WHERE	strDeptAbrev = '#UCASE(Form.abrev)#'
		AND		intDeptID <> #Form.edit#
	</CFQUERY>
	<!--- if it is, display an eror and abort all other operations --->
	<CFIF qryDuplicateAbrev.RecordCount>
		<CFLOCATION URL="errorDuplicate.cfm?item=#URLEncodedFormat("Department Abbreviation")#">
		<CFABORT>
	</CFIF>
	
	<!--- update the department record specified by Form.edit --->
	<CFQUERY NAME="qryEditDept" DATASOURCE="#request.ds#">
		UPDATE	tblDept
		SET		strDeptAbrev = '#Form.abrev#',
				strDeptName = '#Form.name#',
			<CFIF IsDefined("Form.active")>
				bolActive = True
			<CFELSE>
				bolActive = False
			</CFIF>
		WHERE	intDeptID = #Form.edit#
	</CFQUERY>
	<!--- set qryDeptCache to 0 days so that qryDept on the 
	project pages will be refreshed --->
	<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
		<CFSET application.qryDeptCache = #CreateTimeSpan(0,0,0,0)#>
	</CFLOCK>
	
<!--- If user is deleting a department... --->
<CFELSEIF IsDefined("URL.delete")>

	<!--- perform query to see if the department has any projects --->
	<CFQUERY NAME="qryIsItemUsed" DATASOURCE="#request.ds#">
		SELECT intProjectID FROM tblProjects WHERE intClientDept = #URL.delete#
	</CFQUERY>
	<!--- if it does, display an error and abort all other operations --->
	<CFIF qryIsItemUsed.RecordCount>
		<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
		<CFABORT>
	<CFELSE>
	
	<!--- if it doesn't, delete the department --->
		<CFQUERY NAME="qryDeleteDept" DATASOURCE="#request.ds#">
			DELETE FROM	tblDept
			WHERE		intDeptID = #URL.delete#
		</CFQUERY>
		<!--- set qryDeptCache to 0 days so that qryDept on the 
		project pages will be refreshed --->
		<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
			<CFSET application.qryDeptCache = #CreateTimeSpan(0,0,0,0)#>
		</CFLOCK>
	</CFIF>
</CFIF>

<!--- query to display the data for all of the departments --->
<CFQUERY NAME="qryDepartment" DATASOURCE="#request.ds#">
	SELECT * FROM tblDept ORDER BY strDeptAbrev
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Clients/Departments Admin</b></p>
<p><a class="link" href="deptEdit.cfm?add=yes">Add New Client/Dept</a></p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Abbreviation</b></td>
		<td><b>Name</b></td>
		<td><b>Active?</b></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryDepartment">
	<tr>
		<td>#strDeptAbrev#</td>
		<td>#strDeptName#</td>
		<td align="center"><CFIF #bolActive# EQ True>Yes<CFELSE>No</CFIF></td>
		<td><a class="link" href="deptEdit.cfm?edit=#intDeptID#">Edit</a></td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Department?');" href="deptAdmin.cfm?delete=#intDeptID#">Delete</a></td>
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