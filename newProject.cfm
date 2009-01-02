<!---
this page is where the user creates a new project. Except for the Project Type 
drop-down list, all the fields on this page are common to all three project types. 
The user may add new options to three of the drop-down lists: Location, Client/Department, 
and Client Contact. When the user clicks on one of the "Add New" buttons they will be 
taken to addOptions.cfm. When they return, the option they added will automatically be 
selected. When they have finished filling in the data for their new project, the user can 
click on "Submit" or "Cancel". If they choose submit, the form is sent to 
newProjectQuery.cfm which creates the new project and sends the user to the appropriate 
page (acquisitions.cfm, disposals.cfm, or consulting.cfm).
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>New Project</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<CFIF IsDefined("Form.optionType")>
<!--- If a new option is being added (or the user has clicked "Cancel"
on the addOptions.cfm page) then declare variables with the values
from the hidden fields on addOptions.cfm (which are the same values
that were sent to addOptions.cfm by this file). --->
	<CFSET newProjType = Form.projectType>
	<CFSET newProvID = Form.province>
	<CFSET newLocationID = Form.location>
	<CFSET newDescription = Form.description>
	<CFSET newDept = Form.department>
	<CFSET newSecondDept = Form.secondDept>
	<CFSET newClientContact = Form.clientContact>
	<CFSET newAgent = Form.agent>
	<CFSET newStartDate = Form.startDate>	

	<CFIF #Form.optionType# EQ "location">
	<!--- then a location is being added --->
	
		<!--- perform query to see if the new location name already exists --->
		<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
			SELECT	*
			FROM	tblLocation
			WHERE	strLocation = '#UCASE(Form.locName)#'
		</CFQUERY>
		<!--- if it is, display an eror and abort all other operations --->
		<CFIF qryDuplicate.RecordCount>
			<CFLOCATION URL="admin/errorDuplicate.cfm?item=#URLEncodedFormat("Location Name")#">
			<CFABORT>
		</CFIF>
	
		<!--- Query to add the location --->
		<CFQUERY NAME="qryAddLocation" DATASOURCE="#request.ds#">
			INSERT 	INTO tblLocation (strLocation)
			VALUES	('#UCase(Form.locName)#')
		</CFQUERY>
		<!--- set qryLocationCache to 0 days so that qryLocation on the 
		project pages will be refreshed --->
		<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
			<CFSET application.qryLocationCache = #CreateTimeSpan(0,0,0,0)#>
		</CFLOCK>
		<!--- Query to find the new location's ID --->
		<CFQUERY NAME="qryGetNewID" DATASOURCE="#request.ds#">
			SELECT	intLocationID
			FROM	tblLocation
			WHERE	strLocation = '#Form.locName#'
		</CFQUERY>
		<!--- set the value of newLocationID to the newly created ID --->
		<CFOUTPUT QUERY="qryGetNewID">
			<CFSET newLocationID = intLocationID>
		</CFOUTPUT>
		
	<CFELSEIF #Form.optionType# EQ "dept">
	<!--- then a department is being added --->
	
		<!--- perform query to see if the new department name already exists --->
		<CFQUERY NAME="qryDuplicateName" DATASOURCE="#request.ds#">
			SELECT	*
			FROM	tblDept
			WHERE	strDeptName = '#UCASE(Form.deptName)#'
		</CFQUERY>
		<!--- if it is, display an eror and abort all other operations --->
		<CFIF qryDuplicateName.RecordCount>
			<CFLOCATION URL="admin/errorDuplicate.cfm?item=#URLEncodedFormat("Department Name")#">
			<CFABORT>
		</CFIF>
		
		<!--- perform query to see if the new department abreviation already exists --->
		<CFQUERY NAME="qryDuplicateAbrev" DATASOURCE="#request.ds#">
			SELECT	*
			FROM	tblDept
			WHERE	strDeptAbrev = '#UCASE(Form.deptAbbrev)#'
		</CFQUERY>
		<!--- if it is, display an eror and abort all other operations --->
		<CFIF qryDuplicateAbrev.RecordCount>
			<CFLOCATION URL="admin/errorDuplicate.cfm?item=#URLEncodedFormat("Department Abbreviation")#">
			<CFABORT>
		</CFIF>
	
		<!--- Query to add the department --->
		<CFQUERY NAME="qryAddDept" DATASOURCE="#request.ds#">
			INSERT 	INTO tblDept (strDeptName, strDeptAbrev, bolActive)
			VALUES	('#Form.deptName#', '#Form.deptAbbrev#', TRUE)
		</CFQUERY>
		<!--- set qryDeptCache to 0 days so that qryDept on the 
		project pages will be refreshed --->
		<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
			<CFSET application.qryDeptCache = #CreateTimeSpan(0,0,0,0)#>
		</CFLOCK>
		<!--- Query to find the new department's ID --->
		<CFQUERY NAME="qryGetNewID" DATASOURCE="#request.ds#">
			SELECT	intDeptID
			FROM	tblDept
			WHERE	strDeptName = '#Form.deptName#'
		</CFQUERY>
		<!--- set the value of newDept to the newly created ID --->
		<CFOUTPUT QUERY="qryGetNewID">
			<CFSET newDept = intDeptID>
		</CFOUTPUT>
		
	<CFELSEIF #Form.optionType# EQ "clientContact">
	<!--- then a client contact is being added --->
	
		<!--- perform query to see if the new client contact already exists --->
		<CFQUERY NAME="qryDuplicate" DATASOURCE="#request.ds#">
			SELECT	*
			FROM	tblClientContact
			WHERE	strFirstName = '#UCASE(Form.firstName)#'
			AND		strLastName = '#UCASE(Form.lastName)#'
		</CFQUERY>
		<!--- if it is, display an eror and abort all other operations --->
		<CFIF qryDuplicate.RecordCount>
			<CFLOCATION URL="admin/errorDuplicate.cfm?item=#URLEncodedFormat("Client Contact Name")#">
			<CFABORT>
		</CFIF>
	
		<!--- Query to add the client contact --->
		<CFQUERY NAME="qryAddClientContact" DATASOURCE="#request.ds#">
			INSERT 	INTO tblClientContact (strFirstName, strLastName, strArea)
			VALUES	('#Form.firstName#', '#Form.lastName#', '#Form.area#')
		</CFQUERY>
		<!--- Query to find the new client contact's ID --->
		<CFQUERY NAME="qryGetNewID" DATASOURCE="#request.ds#">
			SELECT	intClientContactID
			FROM	tblClientContact
			WHERE	strFirstName = '#Form.firstName#'
			AND		strLastName = '#Form.lastName#'
			AND		strArea = '#Form.area#'
		</CFQUERY>
		<!--- set the value of newClientContact to the newly created ID --->
		<CFOUTPUT QUERY="qryGetNewID">
			<CFSET newClientContact = intClientContactID>
		</CFOUTPUT>
		
	</CFIF>
	
<CFELSE>
<!--- then the user has just arrived to the New Project page so
set the variables to their default values --->
	<CFSET newProjType = 1>
	<CFSET newProvID = 59>
	<CFSET newLocationID = 1>
	<CFSET newDescription = "">
	<CFSET newDept = 2>
	<CFSET newSecondDept = 0>
	<CFSET newClientContact = 1>
	<CFSET newAgent = 0>
	
</CFIF>

<!--- Query for populating the Advisor list-box --->
<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#">
	SELECT		intAgentID,
				strFirstName,
				strLastName
	FROM 		tblAgent
	WHERE		intAccessLevel = 1
	OR			intAccessLevel = 2
	ORDER BY 	strFirstName
</CFQUERY>
<!--- Query for populating the Client/Department list-box --->
<CFQUERY NAME="qryDept" DATASOURCE="#request.ds#">
	SELECT		intDeptID,
				strDeptName
	FROM 		tblDept
	WHERE		bolActive = True
	ORDER BY 	strDeptName
</CFQUERY>
<!--- Query for populating the Location list-box --->
<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#">
	SELECT DISTINCT
				tblLocation.intLocationID,
				tblLocation.strLocation
	FROM 		tblLocation, 
				tblProjects
	WHERE		bolActive = True
	ORDER BY 	tblLocation.strLocation
</CFQUERY>
<!--- Query for populating the Province list-box --->
<CFQUERY NAME="qryProvince" DATASOURCE="#request.ds#">
	SELECT		tblProvince.intProvID,
				tblProvince.strProvNm
	FROM		tblProvince
	WHERE		intProvID = 59 OR intProvID = 60 OR intProvID = 0
	ORDER BY	intProvID
</CFQUERY>
<!--- Query for populating the Project Type list-box --->
<CFQUERY NAME="qryProjectType" DATASOURCE="#request.ds#">
	SELECT		tblProjectType.intProjTypeID,
				tblProjectType.strProjType
	FROM		tblProjectType
	ORDER BY	strProjType
</CFQUERY>
<!--- Query for populating the Client Contact list-box --->
<CFQUERY NAME="qryClientContact" DATASOURCE="#request.ds#">
	SELECT		intClientContactID,
				strFirstName,
				strLastName
	FROM		tblClientContact
	WHERE		bolActive = True
	ORDER BY	strFirstName, strLastName 
</CFQUERY>

<SCRIPT Language="Javascript">

function sendForm(type) {
// When a user clicks on a button to add a new option, this 
// function is called.  It changes the destination of the form
// from newProjectQuery.cfm to addOptions.cfm and also sets
// the value of optionType to that specified by the arguement, type.

	
	document.Form1.action = "addOptions.cfm"
	document.Form1.optionType.value = type;

	document.Form1.submit();
}

</SCRIPT>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript functions and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<H2>&nbsp;New Project</H2>
<CFIF Client.LoggedIn EQ "Yes">
<FORM NAME="Form1" ACTION="newProjectQuery.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="optionType">
<INPUT TYPE="hidden" NAME="startDate_date" VALUE="You must enter a proper date (yyyy/m/d) in the Project Start Date field">

<table border="0" cellpadding="4" cellspacing="0">
	<tr>
		<td align="right" width="150"><b><font color="#FF0000">Project Type</font></b>:</td>
		<td>
			<SELECT NAME="projectType">
			<CFOUTPUT QUERY="qryProjectType">
				<OPTION VALUE=#intProjTypeID#<CFIF #intProjTypeID# EQ #newProjType#> SELECTED</CFIF>>#strProjType#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Location:</td>
		<td valign="middle">
			<SELECT NAME="location">
			<CFOUTPUT QUERY="qryLocation">
				<OPTION VALUE=#intLocationID#<CFIF #intLocationID# EQ #newLocationID#> SELECTED</CFIF>>#strLocation#</OPTION>
			</CFOUTPUT>
			</SELECT>&nbsp;&nbsp;&nbsp;
			<SELECT NAME="province">
			<CFOUTPUT QUERY="qryProvince">
				<OPTION VALUE=#intProvID#<CFIF #intProvID# EQ #newProvID#> SELECTED</CFIF>>#strProvNm#</OPTION>
			</CFOUTPUT>
			</SELECT>&nbsp;&nbsp;&nbsp;
			<a href="#" onClick="sendForm('location'); return false;"><img src="images/button_add_location.gif" border="0" width="117" height="16"></a>
		</td>
	</tr>		
	<tr>
		<td align="right" valign="top">Description:</td>
		<td><TEXTAREA NAME="description" ROWS=2 COLS=40 WRAP="VIRTUAL"><CFOUTPUT>#newDescription#</CFOUTPUT></TEXTAREA></td>
	</tr>
	<tr>
		<td align="right">Advisor:</td>
		<td>
			<SELECT NAME="agent">
			<CFOUTPUT QUERY="qryAgent">
				<OPTION VALUE=#intAgentID#<CFIF #intAgentID# EQ #newAgent# OR (#newAgent# EQ 0 AND Client.LoggedIn EQ "Yes" AND #intAgentID# EQ Client.Employee_ID)> SELECTED</CFIF>>#strFirstName# #strLastName#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Client/Department:</td>
		<td>
			<SELECT NAME="department">
			<CFOUTPUT QUERY="qryDept">
				<OPTION VALUE=#intDeptID#<CFIF #intDeptID# EQ #newDept#> SELECTED</CFIF>>#strDeptName#</OPTION>
			</CFOUTPUT>
			</SELECT>&nbsp;&nbsp;&nbsp;
			<a href="#" onClick="sendForm('dept'); return false;"><img src="images/button_add_dept.gif" border="0" width="96" height="16"></a>
		</td>
	</tr>
	<tr>
		<td align="right">Second Client/Dept:</td>
		<td>
			<SELECT NAME="secondDept">
				<OPTION VALUE=0 SELECTED> </OPTION>
			<CFOUTPUT QUERY="qryDept">
				<OPTION VALUE=#intDeptID#<CFIF #intDeptID# EQ #newSecondDept#> SELECTED</CFIF>>#strDeptName#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Client Contact:</td>
		<td><SELECT NAME="clientContact">
			<CFOUTPUT QUERY="qryClientContact">
				<OPTION VALUE=#intClientContactID#<CFIF #intClientContactID# EQ #newClientContact#> SELECTED</CFIF>>#strFirstName# #strLastName#</OPTION>
			</CFOUTPUT>
			</SELECT>&nbsp;&nbsp;&nbsp;
			<a href="#" onClick="sendForm('clientContact'); return false;"><img src="images/button_add_contact.gif" border="0" width="117" height="16"></a>
		</td>
	</tr>
	<tr>
		<td align="right">Project Start Date:</td>
		<td><INPUT TYPE="text" NAME="startDate" SIZE=10<CFIF IsDefined("newStartDate")><CFOUTPUT> VALUE="#DateFormat(newStartDate, "yyyy/m/d")#"</CFOUTPUT><CFELSE><CFOUTPUT> VALUE="#DateFormat(now(), "yyyy/m/d")#"</CFOUTPUT></CFIF>> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?form=Form1&field=startDate','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<br><br>
			<a href="#" onClick="document.Form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;
			<a href="projectSearch.cfm"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a>
		</td>
	</tr>
</table>
</FORM>
<CFELSE>
<p align="center">You cannot add a new project unless you are logged in.
<br>Please click <a class="menuLink" href="projectSearch.cfm?Login=yes">here.</a></p>
</CFIF>
</body>
</html>
