<!--- This page is called whenever the user leaves acquisitions.cfm except for when
they click "Cancel", "Admin" or go to an external site.  acquisitions.cfm passes this file all 
the data from acquisitions.cfm's forms and then this file saves it to the database and sends 
the user to the url specified in Form.page. --->

<!--- Format currencies so they don't contain any commas or dollar signs ($).
If the data entered in the form is not a proper currency or numeric value,
then send the user to errorCurrency.cfm with the appropriate QueryString parameters--->
<CFIF LSIsCurrency(Form.Price)>
	<CFSET formattedPrice = LSParseCurrency(Form.Price)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=Price&value=#Form.price#">
	<CFABORT>
</CFIF>

<CFIF LSIsCurrency(Form.expToDate)>
	<CFSET formattedExpToDate = LSParseCurrency(Form.expToDate)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("Expenditures to Date")#&value=#Form.expToDate#">
	<CFABORT>
</CFIF>

<CFIF LSIsCurrency(Form.SSAFees)>
	<CFSET formattedFees = LSParseCurrency(Form.SSAFees)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("SSA Fees")#&value=#Form.SSAFees#">
	<CFABORT>
</CFIF>

<CFIF LSIsCurrency(Form.SSADisbursements)>
	<CFSET formattedDisbursements = LSParseCurrency(Form.SSADisbursements)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("SSA Disbursements")#&value=#Form.SSADisbursements#">
	<CFABORT>
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

<!--- query to retrieve the name of the Interest Type --->
<CFQUERY NAME="qryInterestAcquired" DATASOURCE="#request.ds#">
	SELECT		strInterestSold
	FROM		tblInterestSold
	WHERE		intInterestSoldID = #Form.interestType#
</CFQUERY>

<!--- update the session variables --->
<CFLOCK SCOPE="SESSION" TYPE="EXCLUSIVE" TIMEOUT="20">
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
	<CFSET Session.backupPrice = #formattedPrice#>
	<CFSET Session.backupExpToDate = #formattedExpToDate#>
	<CFSET Session.backupStartDate = #DateFormat(Form.startDate, "yyyy/m/d")#>
	<CFSET Session.backupComplDate = #DateFormat(Form.complDate, "yyyy/m/d")#>
	
		<!--- added this  --->
	<CFSET Session.backupLawyer = #Form.lawyer#>
	
	
	<CFIF #Form.cancelled# EQ "yes">
		<CFSET Session.backupCancelled = True>
	<CFELSE>
		<CFSET Session.backupCancelled = False>
	</CFIF>
	<CFSET Session.backupOffer = #DateFormat(Form.offer, "yyyy/m/d")#>
	<CFSET Session.backupClose = #DateFormat(Form.close, "yyyy/m/d")#>
	<CFSET Session.backupRollNumber = #Form.rollNumber#>
	<CFSET Session.backupAcquiredFrom = #Form.acquiredFrom#>
	<CFSET Session.backupPropertyUse = #Form.propertyUse#>
	<CFSET Session.backupPropDescription = #Form.propDescription#>
	<CFSET Session.backupInterestType = #Form.interestType#>
	
	<CFSET Session.backupDeptName = #qryClientName.strDeptName#>
	<CFSET Session.backupLocation = #qryLocation.strLocation#>
	<CFSET Session.backupAbbreviated = #qryProvince.strAbbreviated#>
	<CFSET Session.backupFirstName = #qryAdvisor.strFirstName#>
	<CFSET Session.backupLastName = #qryAdvisor.strLastName#>
	<CFSET Session.backupInterestAcquired = #qryInterestAcquired.strInterestSold#>
	
</CFLOCK>
	

<!--- send user to the specified url --->
<CFLOCATION URL="#Form.page#">
