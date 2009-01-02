<!--- Are we logging into the application? --->
<CFIF IsDefined("Form.LoggingOn")>

	<!--- Check to see if valid --->
	<CFQUERY NAME="CheckUser" DATASOURCE="#request.ds#">

		SELECT	intAgentID, strFirstName, strLastName, intAccessLevel
		FROM 	tblAgent
		WHERE 	intAgentID = #Form.Employee# 
		AND 	strPassword = '#Form.Password#'

	</CFQUERY>
    
	<!--- Every query contains an element called "recordcount" which tells us how many rows are returned.  
	In this case we are checking to see if a user matched the validation query above. 
	If the recordcount is 0 (no match in the database), the cfif statement below will be false,
	and the user will not be logged in. Any number other than 0 is seen as true. --->
	<CFIF CheckUser.RecordCount>
	
		<!--- Login successful, set client variables. --->
		<CFSET Client.LoggedIn="Yes">
		<CFSET Client.Employee_Nm=CheckUser.strFirstName & " " & CheckUser.strLastName>
		<CFSET Client.Employee_ID=CheckUser.intAgentID>
		<CFSET Client.Admin=CheckUser.intAccessLevel>
		
	<CFELSE>
	
		<!--- Login failed, so display the login form again --->
		<CFLOCATION URL="login.cfm?failed=yes">
		
	</CFIF>

</CFIF>

<!--- If the user clicks the logout link they will be returned to projectSearch.cfm and logged out ---> 
<CFIF IsDefined("URL.Logout")>

	<CFSET Client.LoggedIn="No">
	<CFSET Client.Admin="3">

</CFIF>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Project Search</title>

<!--- Query for populating the Advisor list box.  
Only advisors who actually have projects are displayed --->
<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#">
	SELECT DISTINCT
				tblAgent.intAgentID,
				tblAgent.strFirstName,
				tblAgent.strLastName
	FROM 		tblAgent,
				tblProjects
	WHERE		tblAgent.intAgentID = tblProjects.intAgent
	ORDER BY 	tblAgent.strFirstName, tblAgent.strLastName
</CFQUERY>
<!--- Query for populating the Client/Department list box.  
Only departments who have projects are displayed --->
<CFQUERY NAME="qryDept" DATASOURCE="#request.ds#">
	SELECT DISTINCT
				tblDept.intDeptID,
				tblDept.strDeptName
	FROM 		tblDept,
				tblProjects
	WHERE		tblDept.intDeptID = tblProjects.intClientDept
	ORDER BY 	strDeptName
</CFQUERY>
<!--- Query for populating the Location list box.  
Only locations that have projects are displayed --->
<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#">
	SELECT DISTINCT
				tblLocation.intLocationID,
				tblLocation.strLocation
	FROM 		tblLocation, 
				tblProjects
	WHERE		tblLocation.intLocationID = tblProjects.intLocationID
	ORDER BY 	tblLocation.strLocation
</CFQUERY>
<!--- Query for populating the Client Contact list box.  
Only client contacts who are actually contacts for projects are displayed --->
<CFQUERY NAME="qryClientContact" DATASOURCE="#request.ds#">
	SELECT DISTINCT
				tblClientContact.intClientContactID,
				tblClientContact.strFirstName,
				tblClientContact.strLastName
	FROM		tblClientContact,
				tblProjects
	WHERE		tblClientContact.intClientContactID = tblProjects.intClientContactID
	AND			tblClientContact.intClientContactID <> #request.defaultClientContact#
	ORDER BY	tblClientContact.strFirstName, tblClientContact.strLastName				
</CFQUERY>

<CFINCLUDE TEMPLATE="header.cfm">

<h2>&nbsp;Project Search</h2>

<table width="750" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>
		<FORM ACTION="projectList.cfm" METHOD="POST" NAME="searchForm">
		<INPUT TYPE="hidden" NAME="projectNo_integer" VALUE="You must enter an integer in the Project Number field">
	    <table align="center" width="525" border="0" cellpadding="5" cellspacing="0">
			<tr>
				<td align="right">
					Status:
				</td>
				<td>
					  <SELECT NAME="status">
						<OPTION VALUE="all">All</OPTION>
						<OPTION VALUE="active" SELECTED>Active</OPTION>
						<OPTION VALUE="complete">Completed</OPTION>
					</SELECT>
				</td>
			</tr>
			<tr>
				<td align="right">
					Project Type:
				</td>
				<td>
					<SELECT NAME="projectType">
						<OPTION VALUE="all" SELECTED>All</OPTION>
						<OPTION VALUE="acquisition">Acquisition</OPTION>
						<OPTION VALUE="disposal">Disposal</OPTION>
						<OPTION VALUE="consulting">Consulting</OPTION>
					</SELECT>
				</td>
			</tr>
			<tr>
				<td align="right">
					Location:
				</td>
				<td>
					<SELECT NAME="location">
						<OPTION VALUE=0 SELECTED>All</OPTION>
					<CFOUTPUT QUERY="qryLocation">
						<OPTION VALUE=#intLocationID#>#strLocation#</OPTION>
					</CFOUTPUT>
					</SELECT>
				</td>
			</tr>		
			<tr>
				<td align="right">	
					Description:
				</td>
				<td>
					<INPUT TYPE="text" NAME="description" SIZE=20>
				</td>
			</tr>
			<tr>
				<td align="right">
					Advisor:
				</td>
				<td>
					<SELECT NAME="agent">
						<OPTION VALUE=0>All</OPTION>
					<CFOUTPUT QUERY="qryAgent">
						<OPTION VALUE=#intAgentID# <CFIF Client.LoggedIn EQ "Yes" AND #intAgentID# EQ Client.Employee_ID>SELECTED</CFIF>>#strFirstName# #strLastName#</OPTION>
					</CFOUTPUT>
					</SELECT>
				</td>
			</tr>
			<tr>
				<td align="right">
					Client/Department:
				</td>
				<td>
					<SELECT NAME="department">
						<OPTION VALUE=0 SELECTED>All</OPTION>
					<CFOUTPUT QUERY="qryDept">
						<OPTION VALUE=#intDeptID#>#strDeptName#</OPTION>
					</CFOUTPUT>
					</SELECT>
				</td>
			</tr>
			<tr>
				<td align="right">	
					Project Number:
				</td>
				<td>
					<INPUT TYPE="text" NAME="projectNo" SIZE=10>
				</td>
			</tr>
			<tr>
				<td align="right">	
					File Number:
				</td>
				<td>
					<INPUT TYPE="text" NAME="fileNo" SIZE=10>
				</td>
			</tr>
			<tr>
				<td align="right">
					Client Contact:
				</td>
				<td>
					<SELECT NAME="clientContact">
						<OPTION VALUE=0 SELECTED>All</OPTION>
					<CFOUTPUT QUERY="qryClientContact">
						<OPTION VALUE=#intClientContactID#>#strFirstName# #strLastName#</OPTION>
					</CFOUTPUT>
					</SELECT>
				</td>
			</tr>
			<tr>
				<td align="center" colspan=2>
					<a href="#" onClick="document.searchForm.submit(); return false"><img src="images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;
					<a href="#" onClick="document.searchForm.reset(); return false;"><img src="images/button_reset.gif" width="61" height="25" border="0"></a>
				</td>
			</tr>
	  </table>
      </form>
	</td>
  </tr>
</table>
</body>
</html>
