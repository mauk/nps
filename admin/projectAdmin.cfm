<!--- This page is used to delete projects --->

<!--- only users with Administrative access can delete projects --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Project Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is deleting a project... --->
<CFIF IsDefined("URL.delete")>
	<!--- If the project's type is Acquisition... --->
	<CFIF #URL.projType# EQ "Acquisition">
		
		<!--- delete the projects corresponding tblAcquisitions record --->
		<CFQUERY NAME="qryDeleteAcquisition" DATASOURCE="#request.ds#">
			DELETE FROM tblAcquisitions
			WHERE		intProjectID = #URL.delete#
		</CFQUERY>
		<!--- delete the projects tblProject record ("cascade delete" 
		is set for some relationships in the database, so all corresponding
		appraisals, status updates, and PIN/PID's will automatically be 
		deleted when the tblProject record is deleted). --->
		<CFQUERY NAME="qryDeleteProject" DATASOURCE="#request.ds#">
			DELETE FROM	tblProjects
			WHERE		intProjectID = #URL.delete#
		</CFQUERY>
	
	<!--- If the project's type is Disposal... --->	
	<CFELSEIF #URL.projType# EQ "Disposal">
		<!--- perform query to see if the project has any corresponding
		tblBand records. --->
		<CFQUERY NAME="qryHasBand" DATASOURCE="#request.ds#">
			SELECT intProjectID FROM tblBand WHERE intProjectID = #URL.delete#
		</CFQUERY>
		
		<CFIF qryHasBand.RecordCount>
			<!--- If so, the project cannot be deleted because of the importance
			of the First Nations Consultation data --->
			<CFINCLUDE TEMPLATE="errorReferentialIntegrity.cfm">
			<CFABORT>
			
		<CFELSE>
			<!--- If not, delete the projects corresponding tblDisposals record--->
			<CFQUERY NAME="qryDeleteDisposal" DATASOURCE="#request.ds#">
				DELETE FROM tblDisposals
				WHERE		intProjectID = #URL.delete#
			</CFQUERY>
			<!--- delete the projects tblProject record ("cascade delete" 
			is set for some relationships in the database, so all corresponding
			status updates and PIN/PID's will automatically be deleted when the 
			tblProject record is deleted). --->
			<CFQUERY NAME="qryDeleteProject" DATASOURCE="#request.ds#">
				DELETE FROM	tblProjects
				WHERE		intProjectID = #URL.delete#
			</CFQUERY>
			
		</CFIF>
	
	<!--- If the project's type is Consulting... --->	
	<CFELSE>
		<!--- delete the projects tblProject record ("cascade delete" 
		is set for some relationships in the database, so all corresponding
		status updates will automatically be deleted when the tblProject 
		record is deleted). --->
		<CFQUERY NAME="qryDeleteProject" DATASOURCE="#request.ds#">
			DELETE FROM	tblProjects
			WHERE		intProjectID = #URL.delete#
		</CFQUERY>
	
	</CFIF>
	
	
	
</CFIF>

<!--- Query to display a list of all of the projects --->
<CFQUERY NAME="qryProjects" DATASOURCE="#request.ds#">
	SELECT	tblProjects.intProjectID,
			tblProjectType.strProjType,
			tblLocation.strLocation,
			tblProjects.strDescription,
			tblAgent.strFirstName,
			tblAgent.strLastName,
			tblDept.strDeptAbrev
	FROM	tblProjects,
			tblProjectType,
			tblLocation,
			tblAgent,
			tblDept
	WHERE	tblProjects.intProjectType = tblProjectType.intProjTypeID
	AND		tblProjects.intLocationID = tblLocation.intLocationID
	AND		tblProjects.intAgent = tblAgent.intAgentID
	AND		tblProjects.intClientDept = tblDept.intDeptID
	ORDER BY strProjType, strFirstName, strLastName, strLocation, strDeptAbrev, strDescription
</CFQUERY>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Project Admin</b><br>
Sorted from left to right</p>
<br>
<table border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td><b>Project Type</b></td>
		<td><b>Advisor</b></td>
		<td><b>Location</b></td>
		<td><b>Client</b></td>
		<td><b>Description</b></td>
		<td>&nbsp;</td>
	</tr>
<CFOUTPUT QUERY="qryProjects">
	<tr>
		<td>#strProjType#</td>
		<td>#strFirstName# #strLastName#</td>
		<td>#strLocation#</td>
		<td>#strDeptAbrev#</td>
		<td>#strDescription#</td>
		<td><a class="link" onClick="return confirm('Are you sure you want to permanently delete this Project?');" href="projectAdmin.cfm?delete=#intProjectID#&projType=#strProjType#">Delete</a></td>
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