<!--- This page is called whenever the user leaves disposals.cfm except for when
they click "Cancel", "Admin" or go to an external site.  disposals.cfm passes this file all 
the data from disposals.cfm's forms and then this file saves it to the database and sends 
the user to the url specified in Form.page. --->

<!--- Format currencies so they don't contain any commas or dollar signs ($).
If the data entered in the form is not a proper currency or numeric value,
then send the user to errorCurrency.cfm with the appropriate QueryString parameters--->
<CFIF LSIsCurrency(Form.Price)>
	<CFSET formattedPrice = LSParseCurrency(Form.Price)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("Sale Price")#&value=#Form.price#">
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

<CFIF LSIsCurrency(Form.amountPaid)>
	<CFSET formattedAmountPaid = LSParseCurrency(Form.amountPaid)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("Amount Paid")#&value=#Form.amountPaid#">
	<CFABORT>
</CFIF>

<CFIF LSIsCurrency(Form.landAsses)>
	<CFSET formattedLandAsses = LSParseCurrency(Form.landAsses)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("Land Assessment")#&value=#Form.landAsses#">
	<CFABORT>
</CFIF>

<CFIF LSIsCurrency(Form.buildingAsses)>
	<CFSET formattedBuildAsses = LSParseCurrency(Form.buildingAsses)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("Building Assessment")#&value=#Form.buildingAsses#">
	<CFABORT>
</CFIF>

<CFIF LSIsCurrency(Form.PILT)>
	<CFSET formattedPILT = LSParseCurrency(Form.PILT)>
<CFELSE>
	<CFLOCATION URL="errorCurrency.cfm?field=PILT&value=#Form.PILT#">
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

<!--- query to retrieve the name of the client contact --->
<CFQUERY NAME="qryClientContact" DATASOURCE="#request.ds#">
	SELECT		strFirstName, strLastName
	FROM		tblClientContact
	WHERE		intClientContactID = #Form.clientContact#
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
	
	<!--- added this --->
	<CFSET Session.backupLawyer = #Form.lawyer#>
	<CFSET Session.backupPILTyear = #Form.PILTyear#>
	<CFSET Session.backupRemarks = #Form.remarks#>
	
	<CFIF #Form.cancelled# EQ "yes">
		<CFSET Session.backupCancelled = True>
	<CFELSE>
		<CFSET Session.backupCancelled = False>
	</CFIF>
	<CFSET Session.backupRollNumber = #Form.rollNumber#>
	<CFSET Session.backupProjRefNo = #Form.projRefNo#>
	<CFSET Session.backupLDU = #Form.LDU#>
	<CFSET Session.backupPACNo = #Form.PACNo#>
	<CFSET Session.backupSMANo = #Form.SMANo#>
	<CFSET Session.backupDisposalMethod = #Form.disposalMethod#>
	<CFSET Session.backupInterestSold = #Form.interestSold#>
	<CFSET Session.backupPropertyTypeID = #Form.propertyType#>
	<CFSET Session.backupPurchaserTypeID = #Form.purchaserType#>
	<CFSET Session.backupReportOfSurplus = #DateFormat(Form.reportOfSurplus, "yyyy/m/d")#>
	<CFSET Session.backupGeneralDesc = #Form.generalDesc#>
	<CFSET Session.backupAvailable = #Form.available#>
	<CFSET Session.backupUrbanCentre = #Form.urbanCentre#>
	<CFSET Session.backupAddress = #Form.address#>
	<CFSET Session.backupParcelSize = #Form.parcelSize#>
	<CFSET Session.backupTopography = #Form.topography#>
	<CFSET Session.backupAccess = #Form.access#>
	<CFSET Session.backupBuildingDesc = #Form.buildingDesc#>
	<CFSET Session.backupZoning = #Form.zoning#>
	<CFSET Session.backupServices = #Form.services#>
	<CFSET Session.backupLandUse = #Form.landUse#>
	<CFSET Session.backupAge = #Form.age#>
	<CFSET Session.backupCondition = #Form.condition#>
	<CFSET Session.backupEnvironIssues = #Form.environIssues#>
	<CFSET Session.backupTenure = #Form.tenure#>
	<CFSET Session.backupRestrictions = #Form.restrictions#>
	<CFSET Session.backupAcquiDate = #Form.acquiDate#>
	<CFSET Session.backupPurchasedFrom = #Form.purchasedFrom#>
	<CFSET Session.backupAmountPaid = #formattedAmountPaid#>
	<CFSET Session.backupHistory = #Form.history#>
	<CFSET Session.backupKnownInterests = #Form.knownInterests#>
	<CFSET Session.backupLandAsses = #formattedLandAsses#>
	<CFSET Session.backupBuildingAsses = #formattedBuildAsses#>

	<!--- added this --->
	<CFSET Session.backupAssessmentYear = #Form.assessmentYear#>
	<CFSET Session.backupPILT = #formattedPILT#>
	
	<CFSET Session.backupDeptName = #qryClientName.strDeptName#>
	<CFSET Session.backupLocation = #qryLocation.strLocation#>
	<CFSET Session.backupAbbreviated = #qryProvince.strAbbreviated#>
	<CFSET Session.backupFirstName = #qryAdvisor.strFirstName#>
	<CFSET Session.backupLastName = #qryAdvisor.strLastName#>
	<CFSET Session.backupContactFirst = #qryClientContact.strFirstName#>
	<CFSET Session.backupContactLast = #qryClientContact.strLastName#>
</CFLOCK>

<!--- send user to the specified url --->
<CFLOCATION URL="#Form.page#">
