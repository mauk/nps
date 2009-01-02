<!--- This page is called whenever the user leaves consulting.cfm except for when
they click "Cancel", "Admin" or go to an external site.  consulting.cfm passes this file all 
the data from consulting.cfm's forms and then this file saves it to the database and sends 
the user to the url specified in Form.page. --->

<!--- Format currencies so they don't contain any commas or dollar signs ($).
If the data entered in the form is not a proper currency or numeric value,
then send the user to errorCurrency.cfm with the appropriate QueryString parameters--->
<CFSET formattedFees = Form.SSAFees>
<CFLOOP CONDITION="FindOneOf(',', formattedFees) NEQ 0">
	<CFSET temp = RemoveChars(formattedFees, FindOneOf(",", formattedFees), 1)>
	<CFSET formattedFees = #temp#>	
</CFLOOP>
<CFIF Mid(formattedFees, 1, 1) EQ "$">
	<CFSET formattedFees = RemoveChars(formattedFees, 1, 1)>
</CFIF>
<CFIF formattedFees EQ "">
	<CFSET formattedFees = 0>
</CFIF>

<CFSET formattedDisbursements = Form.SSADisbursements>
<CFLOOP CONDITION="FindOneOf(',', formattedDisbursements) NEQ 0">
	<CFSET temp = RemoveChars(formattedDisbursements, FindOneOf(",", formattedDisbursements), 1)>
	<CFSET formattedDisbursements = #temp#>	
</CFLOOP>
<CFIF Mid(formattedDisbursements, 1, 1) EQ "$">
	<CFSET formattedDisbursements = RemoveChars(formattedDisbursements, 1, 1)>
</CFIF>
<CFIF formattedDisbursements EQ "">
	<CFSET formattedDisbursements = 0>
</CFIF>

<CFSET formattedExpToDate = Form.expToDate>
<CFLOOP CONDITION="FindOneOf(',', formattedExpToDate) NEQ 0">
	<CFSET temp = RemoveChars(formattedExpToDate, FindOneOf(",", formattedExpToDate), 1)>
	<CFSET formattedExpToDate = #temp#>
</CFLOOP>
<CFIF Mid(formattedExpToDate, 1, 1) EQ "$">
	<CFSET formattedExpToDate = RemoveChars(formattedExpToDate, 1, 1)>
</CFIF>
<CFIF formattedExpToDate EQ "">
	<CFSET formattedExpToDate = 0>
</CFIF>

<!--- query to retrieve the name of the department --->
<CFQUERY NAME="qryClientName" DATASOURCE="#request.ds#">
	SELECT		strDeptName
	FROM 		tblDept
	WHERE		intDeptID = #Form.dept#
</CFQUERY>

<!--- query to retrieve the name of the location --->
<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#">
	SELECT		strLocation
	FROM		tblLocation
	WHERE		intLocationID = #Form.locationID#
</CFQUERY>

<!--- query to retrieve the abbreviation of the province --->
<CFQUERY NAME="qryProvince" DATASOURCE="#request.ds#">
	SELECT		strAbbreviated
	FROM		tblProvince
	WHERE		intProvID = #Form.provID#
</CFQUERY>

<!--- query to retrieve the name of the advisor --->
<CFQUERY NAME="qryAdvisor" DATASOURCE="#request.ds#">
	SELECT		strFirstName, strLastName
	FROM		tblAgent
	WHERE		intAgentID = #Form.agent#
</CFQUERY>

<!--- update the session variables --->
<CFLOCK SCOPE="SESSION" TYPE="EXCLUSIVE" TIMEOUT="15">
	<CFSET Session.backupProvID = #Form.provID#>
	<CFSET Session.backupProjectNo = #Form.projectNo#>
	<CFSET Session.backupLocationID = #Form.locationID#>
	<CFSET Session.backupDescription = #Form.description#>
	<CFSET Session.backupLegal = #Form.legal#>
	<CFSET Session.backupClientDept = #Form.dept#>
	<CFSET Session.backupSecondDept = #Form.secondDept#>
	<CFSET Session.backupClientContact = #Form.clientContact#>
	<CFSET Session.backupAgent = #Form.agent#>
	<CFSET Session.backupFileNo = #Form.fileNo#>
	<CFSET Session.backupSSAFees = #formattedFees#>
	<CFSET Session.backupSSADisbursements = #formattedDisbursements#>
	<CFSET Session.backupExpToDate = #formattedExpToDate#>
	<CFSET Session.backupStartDate = #DateFormat(Form.startDate, "yyyy/m/d")#>
	<CFSET Session.backupComplDate = #DateFormat(Form.complDate, "yyyy/m/d")#>
	<CFIF #Form.cancelled# EQ "yes">
		<CFSET Session.backupCancelled = True>
	<CFELSE>
		<CFSET Session.backupCancelled = False>
	</CFIF>
	
	<CFSET Session.backupDeptName = #qryClientName.strDeptName#>
	<CFSET Session.backupLocation = #qryLocation.strLocation#>
	<CFSET Session.backupAbbreviated = #qryProvince.strAbbreviated#>
	<CFSET Session.backupFirstName = #qryAdvisor.strFirstName#>
	<CFSET Session.backupLastName = #qryAdvisor.strLastName#>
</CFLOCK>	

<!--- send user to the specified url --->
<CFLOCATION URL="#Form.page#">
