<!---
This page is used to display the disposal project information.  It first checks to see if various
actions are taking place and performs the appropriate queries for these actions. These actions iclude: 
adding, editing and deleting status updates; adding, editing and deleting PIN/PID's; and adding and editing
first nations consultation information.  
Next, it performs a main query for displaying the project data.  After this it performs
many queries for populating list-boxes and displaying status updates, appraisals, and PIN/PID's.  Then it
contains the html, javascript, and ColdFusion for displaying all of the project data.

If the user is not logged in, the save button will not be displayed, nor will any of the buttons that
are used for adding, editing and deleting data.
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Disposals</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<CFIF IsDefined("URL.backup")>

	<CFQUERY NAME="qryDisplayProject" DATASOURCE="#request.ds#">
		SELECT	tblProjects.intProjectID,
				tblProjects.intProjectNo,
				tblProjects.intProvID,
				tblProjects.intLocationID,
				tblProjects.strDescription,
				tblProjects.strLegal,
				tblProjects.intClientDept,
				tblProjects.intSecondDept,
				tblProjects.intClientContactID,
				tblProjects.intAgent,
				tblProjects.strFileNo,
				tblProjects.datStartDate,
				tblProjects.datComplDate,
				tblProjects.curSSAFees,
				tblProjects.curSSADisbursements,
				tblProjects.bolCancelled,
				tblProjects.curPrice,
				tblProjects.curExpToDate,
				tblDisposals.strRollNumber,
				tblDisposals.strProjRefNo,
				tblDisposals.strLDU,
				tblDisposals.strPACNo,
				tblDisposals.strSMANo,
				tblDisposals.datReportOfSurplus,
				tblDisposals.intDisposalMethod,
				tblDisposals.intInterestSoldID,
				tblDisposals.intPropertyTypeID,
				tblDisposals.intPurchaserTypeID,
				tblFactSheet.strGeneralDesc,
				tblFactSheet.strAvailable,
				tblFactSheet.strUrbanCentre,
				tblFactSheet.strAddress,
				tblFactSheet.sngParcelSize,
				tblFactSheet.strTopography,
				tblFactSheet.strAccess,
				tblFactSheet.strBuildingDesc,
				tblFactSheet.strZoning,
				tblFactSheet.strServices,
				tblFactSheet.strLandUse,
				tblFactSheet.intAge,
				tblFactSheet.strCondition,
				tblFactSheet.strEnvironIssues,
				tblFactSheet.strTenure,
				tblFactSheet.strRestrictions,
				tblFactSheet.strAcquiDate,
				tblFactSheet.strPurchasedFrom,
				tblFactSheet.curAmountPaid,
				tblFactSheet.strHistory,
				tblFactSheet.strKnownInterests,
				tblFactSheet.curLandAsses,
				tblFactSheet.curBuildingAsses,			
				tblFactSheet.intYear,
				tblFactSheet.curPILT,
				tblLocation.strLocation,
				tblProvince.strAbbreviated,
				tblDept.strDeptName,
				tblAgent.strFirstName,
				tblAgent.strLastName,
				tblClientContact.strFirstName AS strContactFirst,
				tblClientContact.strLastName AS strContactLast
		FROM	tblProjects,
				tblDisposals,
				tblFactSheet,
				tblLocation,
				tblProvince,
				tblDept,
				tblAgent,
				tblClientContact
		WHERE	tblProjects.intProjectID = tblDisposals.intProjectID
		AND		tblDisposals.intProjectID = tblFactSheet.intProjectID
		AND		tblProjects.intLocationID = tblLocation.intLocationID
		AND		tblProjects.intProvID = tblProvince.intProvID
		AND		tblProjects.intClientDept = tblDept.intDeptID
		AND		tblProjects.intAgent = tblAgent.intAgentID
		AND		tblProjects.intClientContactID = tblClientContact.intClientContactID
		AND		tblProjects.intProjectID = #URL.projectID#
	</CFQUERY>

	<CFOUTPUT QUERY="qryDisplayProject">	
		<!--- User is entering page from the search results, so save all
		data in backup variables in case the project is automatically saved
		(for example, when adding a status update) and then the user clicks
		on cancel.  When cancel is clicked they are returned to projectList.cfm
		and all the data is restored to the data in these variables. --->
		<CFLOCK SCOPE="SESSION" TYPE="EXCLUSIVE" TIMEOUT="15">
			<CFSET Session.backupProjectID = intProjectID>
			<CFSET Session.backupProjectNo = intProjectNo>
			<CFSET Session.backupProvID = intProvID>
			<CFSET Session.backupLocationID = intLocationID>
			<CFSET Session.backupDescription = strDescription>
			<CFSET Session.backupLegal = strLegal>
			<CFSET Session.backupClientDept = intClientDept>
			<CFSET Session.backupSecondDept = intSecondDept>
			<CFSET Session.backupClientContact = intClientContactID>
			<CFSET Session.backupAgent = intAgent>
			<CFSET Session.backupFileNo = strFileNo>
			<CFSET Session.backupStartDate = datStartDate>
			<CFSET Session.backupComplDate = datComplDate>
			<CFSET Session.backupCancelled = bolCancelled>
			<CFSET Session.backupSSAFees = curSSAFees>
			<CFSET Session.backupSSADisbursements = curSSADisbursements>
			<CFSET Session.backupPrice = curPrice>
			<CFSET Session.backupExpToDate = curExpToDate>
			<CFSET Session.backupRollNumber = strRollNumber>
			<CFSET Session.backupProjRefNo = strProjRefNo>
			<CFSET Session.backupLDU = strLDU>
			<CFSET Session.backupPACNo = strPACNo>
			<CFSET Session.backupSMANo = strSMANo>
			<CFSET Session.backupReportOfSurplus = datReportOfSurplus>
			<CFSET Session.backupDisposalMethod = intDisposalMethod>
			<CFSET Session.backupInterestSold = intInterestSoldID>
			<CFSET Session.backupPropertyTypeID = intPropertyTypeID>
			<CFSET Session.backupPurchaserTypeID = intPurchaserTypeID>
			<CFSET Session.backupGeneralDesc = strGeneralDesc>
			<CFSET Session.backupAvailable = strAvailable>
			<CFSET Session.backupUrbanCentre = strUrbanCentre>
			<CFSET Session.backupAddress = strAddress>
			<CFSET Session.backupParcelSize = sngParcelSize>
			<CFSET Session.backupTopography = strTopography>
			<CFSET Session.backupAccess = strAccess>
			<CFSET Session.backupBuildingDesc = strBuildingDesc>
			<CFSET Session.backupZoning = strZoning>
			<CFSET Session.backupServices = strServices>
			<CFSET Session.backupLandUse = strLandUse>
			<CFSET Session.backupAge = intAge>
			<CFSET Session.backupCondition = strCondition>
			<CFSET Session.backupEnvironIssues = strEnvironIssues>
			<CFSET Session.backupTenure = strTenure>
			<CFSET Session.backupRestrictions = strRestrictions>
			<CFSET Session.backupAcquiDate = strAcquiDate>
			<CFSET Session.backupPurchasedFrom = strPurchasedFrom>
			<CFSET Session.backupAmountPaid = curAmountPaid>
			<CFSET Session.backupHistory = strHistory>
			<CFSET Session.backupKnownInterests = strKnownInterests>
			<CFSET Session.backupLandAsses = curLandAsses>
			<CFSET Session.backupBuildingAsses = curBuildingAsses>			
			<CFSET Session.backupYear = intYear>
			<CFSET Session.backupPILT = curPILT>
			
			<CFSET Session.backupAbbreviated = strAbbreviated>
			<CFSET Session.backupLocation = strLocation>
			<CFSET Session.backupFirstName = strFirstName>
			<CFSET Session.backupLastName = strLastName>
			<CFSET Session.backupContactFirst = strContactFirst>
			<CFSET Session.backupContactLast = strContactLast>
			<CFSET Session.backupDeptName= strDeptName>
		</CFLOCK>
	</CFOUTPUT>	
</CFIF>

<CFLOCK SCOPE="SESSION" TYPE="EXCLUSIVE" TIMEOUT="15">
	<CFSET tempProjectID = Session.backupProjectID>
	<CFSET tempProjectNo = Session.backupProjectNo>
	<CFSET tempProvID = Session.backupProvID>
	<CFSET tempLocationID = Session.backupLocationID>
	<CFSET tempDescription = Session.backupDescription>
	<CFSET tempLegal = Session.backupLegal>
	<CFSET tempClientDept = Session.backupClientDept>
	<CFSET tempSecondDept = Session.backupSecondDept>
	<CFSET tempClientContact = Session.backupClientContact>
	<CFSET tempAgent = Session.backupAgent>
	<CFSET tempFileNo = Session.backupFileNo>
	<CFSET tempStartDate = Session.backupStartDate>
	<CFSET tempComplDate = Session.backupComplDate>
	<CFSET tempCancelled = Session.backupCancelled>
	<CFSET tempSSAFees = Session.backupSSAFees>
	<CFSET tempSSADisbursements = Session.backupSSADisbursements>
	<CFSET tempPrice = Session.backupPrice>
	<CFSET tempExpToDate = Session.backupExpToDate>
	<CFSET tempRollNumber = Session.backupRollNumber>
	<CFSET tempProjRefNo = Session.backupProjRefNo>
	<CFSET tempLDU = Session.backupLDU>
	<CFSET tempPACNo = Session.backupPACNo>
	<CFSET tempSMANo = Session.backupSMANo>
	<CFSET tempReportOfSurplus = Session.backupReportOfSurplus>
	<CFSET tempDisposalMethod = Session.backupDisposalMethod>
	<CFSET tempInterestSold = Session.backupInterestSold>
	<CFSET tempPropertyTypeID = Session.backupPropertyTypeID>
	<CFSET tempPurchaserTypeID = Session.backupPurchaserTypeID>
	<CFSET tempGeneralDesc = Session.backupGeneralDesc>
	<CFSET tempAvailable = Session.backupAvailable>
	<CFSET tempUrbanCentre = Session.backupUrbanCentre>
	<CFSET tempAddress = Session.backupAddress>
	<CFSET tempParcelSize = Session.backupParcelSize>
	<CFSET tempTopography = Session.backupTopography>
	<CFSET tempAccess = Session.backupAccess>
	<CFSET tempBuildingDesc = Session.backupBuildingDesc>
	<CFSET tempZoning = Session.backupZoning>
	<CFSET tempServices = Session.backupServices>
	<CFSET tempLandUse = Session.backupLandUse>
	<CFSET tempAge = Session.backupAge>
	<CFSET tempCondition = Session.backupCondition>
	<CFSET tempEnvironIssues = Session.backupEnvironIssues>
	<CFSET tempTenure = Session.backupTenure>
	<CFSET tempRestrictions = Session.backupRestrictions>
	<CFSET tempAcquiDate = Session.backupAcquiDate>
	<CFSET tempPurchasedFrom = Session.backupPurchasedFrom>
	<CFSET tempAmountPaid = Session.backupAmountPaid>
	<CFSET tempHistory = Session.backupHistory>
	<CFSET tempKnownInterests = Session.backupKnownInterests>
	<CFSET tempLandAsses = Session.backupLandAsses>
	<CFSET tempBuildingAsses = Session.backupBuildingAsses>			
	<CFSET tempYear = Session.backupYear>
	<CFSET tempPILT = Session.backupPILT>
		
	<CFSET tempAbbreviated = Session.backupAbbreviated>
	<CFSET tempLocation = Session.backupLocation>
	<CFSET tempFirstName = Session.backupFirstName>
	<CFSET tempLastName = Session.backupLastName>
	<CFSET tempContactFirst = Session.backupContactFirst>
	<CFSET tempContactLast = Session.backupContactLast>
	<CFSET tempDeptName = Session.backupDeptName>
</CFLOCK>

<!--- If status is being update, run query to save new values --->
<CFIF IsDefined("Form.statusUpdate")>
	<CFQUERY NAME="qryUpdateStatus" DATASOURCE="#request.ds#">
		UPDATE	tblStatus
		SET		memStatus = '#Form.status#',
				datUpdate = ###DateFormat(Form.date, "yyyy/m/d")###
		WHERE	intStatusID = #Form.statusID#
	</CFQUERY>
<!--- If new status is being added, run query to save new status --->
<CFELSEIF IsDefined("Form.statusAdd")>
	<CFQUERY NAME="qryAddStatus" DATASOURCE="#request.ds#">
		INSERT	INTO tblStatus (memStatus, datUpdate, intProjectID)
		VALUES	('#Form.status#', ###DateFormat(Form.date, "yyyy/m/d")###, #URL.projectID#)
	</CFQUERY>
<!--- If status is being deleted, run query to delete the specified query --->
<CFELSEIF IsDefined("URL.statusDelete")>
	<CFQUERY NAME="qryDeleteStatus" DATASOURCE="#request.ds#">
		DELETE FROM	tblStatus
		WHERE		intStatusID = #URL.statusDelete# 
	</CFQUERY>
</CFIF>

<!--- If first nations band is being update, run query to save new values --->
<CFIF IsDefined("Form.bandUpdate")>
	<CFQUERY NAME="qryUpdateBand" DATASOURCE="#request.ds#">
		UPDATE	tblBand
		SET		strChiefName = '#Form.chiefName#',
				strContact = '#Form.contact#',
				strAddress = '#Form.address#',
				strPhone = '#Form.phone#',
				strFax = '#Form.fax#',
				strEmail = '#Form.email#'
		WHERE	intBandID = #Form.bandID#
	</CFQUERY>
<!--- If new status is being added, run query to save new status --->
<CFELSEIF IsDefined("Form.bandAdd")>
	<CFQUERY NAME="qryAddStatus" DATASOURCE="#request.ds#">
		INSERT	INTO tblBand (intProjectID, strBandName, strChiefName, strContact, strPhone, strFax, strAddress, strEmail)
		VALUES	(#URL.projectID#, '#Form.bandName#', '#Form.chiefName#', '#Form.contact#', '#Form.phone#', '#Form.fax#', '#Form.address#', '#Form.email#')
	</CFQUERY>
</CFIF>

<!--- If a new first nations consultation remark is being added, run query to save new remark --->
<CFIF IsDefined("Form.remarkAdd")>
	<CFQUERY NAME="qryAddRemark" DATASOURCE="#request.ds#">
		INSERT	INTO tblFirstNationsRemarks (intBandID, datDate, memRemark, intAgentID)
		VALUES	(#Form.bandID#, ###Form.remarkDate###, '#Form.remark#', #Form.agentID#)
	</CFQUERY>
</CFIF>

<!--- If a PIN/PID is being added, format the PIN/PID and then run query to add the new PIN/PID --->
<CFIF IsDefined("Form.pinpidAdd")>
	<CFSET formattedPINPID = Form.pinpid>
	<CFLOOP CONDITION="FindOneOf('-', formattedPINPID) NEQ 0">
		<CFSET temp = RemoveChars(formattedPINPID, FindOneOf("-", formattedPINPID), 1)>
		<CFSET formattedPINPID = #temp#>
	</CFLOOP>
	<!--- run query to look see if this PIN/PID already exists --->
	<CFQUERY NAME="qryUsedPINPID" DATASOURCE="#request.ds#">
		SELECT	strPINPID
		FROM	tblPINPID
		WHERE	strPINPID = '#formattedPINPID#'
	</CFQUERY>
	<CFIF qryUsedPINPID.RecordCount>
		<!--- if it PIN/PID already exists, include errorPINPID.cfm
		and abort all other operations --->
		<CFINCLUDE TEMPLATE="errorPINPID.cfm">
		<CFABORT>
	<CFELSE>
		<!--- otherwise add new PIN/PID --->
		<CFQUERY NAME="qryAddPINPID" DATASOURCE="#request.ds#">
			INSERT	INTO tblPINPID (strPINPID, bolIsPID, intProjectID)
			VALUES	('#formattedPINPID#', <CFIF Form.isPINorPID EQ "pid">True<CFELSE>False</CFIF>, #URL.projectID#) 
		</CFQUERY>
	</CFIF>
<!--- If a PIN/PID is being deleted, run a query to delete the PIN/PID --->
<CFELSEIF IsDefined("URL.pinpidDelete")>
	<CFQUERY NAME="qryDeletePINPID" DATASOURCE="#request.ds#">
		DELETE FROM	tblPINPID
		WHERE		strPINPID = '#URL.pinpidDelete#'
	</CFQUERY>
</CFIF>


<!--- Query for populating Advisor list-box --->
<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#" CACHEDWITHIN="#request.qryAgentCache#">
	SELECT		intAgentID,
				strFirstName,
				strLastName
	FROM 		tblAgent
	ORDER BY 	strFirstName
</CFQUERY>
<!--- set qryAgentCache to 15 days, incase it was set to 0 by agentAdmin.cfm --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFSET application.qryAgentCache = #CreateTimeSpan(30,0,0,0)#>
</CFLOCK>

<!--- Query for populating Client/Department list-box --->
<CFQUERY NAME="qryDept" DATASOURCE="#request.ds#" CACHEDWITHIN="#request.qryDeptCache#">
	SELECT		intDeptID,
				strDeptName
	FROM 		tblDept
	ORDER BY 	strDeptName
</CFQUERY>
<!--- set qryDeptCache to 15 days, incase it was set to 0 by deptAdmin.cfm --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFSET application.qryDeptCache = #CreateTimeSpan(30,0,0,0)#>
</CFLOCK>

<!--- Query for populating Location list-box --->
<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#" CACHEDWITHIN="#request.qryLocationCache#">
	SELECT 		intLocationID,
				strLocation
	FROM 		tblLocation
	ORDER BY 	strLocation
</CFQUERY>
<!--- set qryLocationCache to 15 days, incase it was set to 0 by locationAdmin.cfm --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFSET application.qryLocationCache = #CreateTimeSpan(15,0,0,0)#>
</CFLOCK>

<!--- Query for populating Province list-box --->
<CFQUERY NAME="qryProvince" DATASOURCE="#request.ds#">
	SELECT		tblProvince.intProvID,
				tblProvince.strProvNm
	FROM		tblProvince
	WHERE		intProvID = 59 OR intProvID = 60 OR intProvID = 0
	ORDER BY	intProvID
</CFQUERY>

<!--- Query for populating Interest Sold list-box --->
<CFQUERY NAME="qryInterestSold" DATASOURCE="#request.ds#">
	SELECT		tblInterestSold.intInterestSoldID,
				tblInterestSold.strInterestSold
	FROM		tblInterestSold
	ORDER BY	strInterestSold
</CFQUERY>

<!--- Query for populating Disposal Method list-box --->
<CFQUERY NAME="qryDisposalMethod" DATASOURCE="#request.ds#">
	SELECT		tblDisposalMethod.intDisposalMethodID,
				tblDisposalMethod.strDisposalMethod
	FROM		tblDisposalMethod
	ORDER BY	strDisposalMethod
</CFQUERY>

<!--- Query for populating Property Type list-box --->
<CFQUERY NAME="qryPropertyType" DATASOURCE="#request.ds#">
	SELECT		tblPropertyType.intPropertyTypeID,
				tblPropertyType.strPropertyType
	FROM		tblPropertyType
	ORDER BY	strPropertyType
</CFQUERY>

<!--- Query for populating Purchaser Type list-box --->
<CFQUERY NAME="qryPurchaserType" DATASOURCE="#request.ds#">
	SELECT		tblPurchaserType.intPurchaserTypeID,
				tblPurchaserType.strPurchaserType
	FROM		tblPurchaserType
	ORDER BY	strPurchaserType
</CFQUERY>

<!--- Query for displaying Status Updates --->
<CFQUERY NAME="qryStatus" DATASOURCE="#request.ds#">
	SELECT		tblStatus.intStatusID,
				tblStatus.memStatus,
				tblStatus.datUpdate
	FROM		tblStatus
	WHERE		tblStatus.intProjectID = #URL.projectID#
	ORDER BY	tblStatus.datUpdate DESC
</CFQUERY>

<!--- Query for displaying PIN/PID's --->
<CFQUERY NAME="qryPINPID" DATASOURCE="#request.ds#">
	SELECT		strPINPID,
				bolIsPID
	FROM		tblPINPID
	WHERE		tblPINPID.intProjectID = #URL.projectID#
</CFQUERY>

<!--- Query for populating Client Contact list-box --->
<CFQUERY NAME="qryClientContact" DATASOURCE="#request.ds#">
	SELECT		intClientContactID,
				strFirstName,
				strLastName
	FROM		tblClientContact
	ORDER BY	strFirstName, strLastName 
</CFQUERY>

<!--- query for dipslaying Band info for First Nations consultations --->
<CFQUERY NAME="qryBand" DATASOURCE="#request.ds#">
	SELECT		*
	FROM		tblBand
	WHERE		intProjectID = #URL.projectID#
	ORDER BY	strBandName
</CFQUERY>

<!--- Queries for displaying Location Name and Province at the top of the project page
as well as Agent Name and Department Name on the Fact Sheet tab 
<CFOUTPUT QUERY="qryDisplayProject">
	<CFSET locationID = intLocationID>
	<CFSET provID = intProvID>
	<CFSET agentID = intAgent>
	<CFSET deptID = intClientDept>
</CFOUTPUT>
<CFQUERY NAME="qryLocationName" DATASOURCE="#request.ds#">
	SELECT		strLocation
	FROM		tblLocation
	WHERE		intLocationID = #locationID#
</CFQUERY>
<CFQUERY NAME="qryProvinceName" DATASOURCE="#request.ds#">
	SELECT		strAbbreviated
	FROM		tblProvince
	WHERE		intProvID = #provID#
</CFQUERY>
<CFQUERY NAME="qryAgentName" DATASOURCE="#request.ds#">
	SELECT		strFirstName, strLastName
	FROM		tblAgent
	WHERE		intAgentID = #agentID#
</CFQUERY>
<CFQUERY NAME="qryDeptName" DATASOURCE="#request.ds#">
	SELECT		strDeptName
	FROM		tblDept
	WHERE		intDeptID = #deptID#
</CFQUERY>
<CFOUTPUT QUERY="qryLocationName">
	<CFSET projLocationName = strLocation>
</CFOUTPUT>
<CFOUTPUT QUERY="qryProvinceName">
	<CFSET projProvAbbrev = strAbbreviated>
</CFOUTPUT>
<CFOUTPUT QUERY="qryAgentName">
	<CFSET projAgentName = strFirstName & " " & strLastName>
</CFOUTPUT>
<CFOUTPUT QUERY="qryDeptName">
	<CFSET projDeptName = strDeptName>
</CFOUTPUT>
--->
<!-- define styles for the tab layers (not the tab buttons) -->
<STYLE TYPE="text/css">
.tab {position: absolute; left: 0; top: 145; width: 750px; background-color: white; z-index: 10;}
#tab1 {visibility: <CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">visible<CFELSE>hidden</CFIF>;}
#tab2 {visibility: <CFIF IsDefined("URL.view") AND #URL.view# EQ "property">visible<CFELSE>hidden</CFIF>;}
#tab3 {visibility: <CFIF IsDefined("URL.view") AND #URL.view# EQ "hq">visible<CFELSE>hidden</CFIF>;}
#tab4 {visibility: <CFIF IsDefined("URL.view") AND #URL.view# EQ "status">visible<CFELSE>hidden</CFIF>;}
#tab5 {visibility: <CFIF IsDefined("URL.view") AND #URL.view# EQ "factSheet">visible<CFELSE>hidden</CFIF>;}
#tab6 {visibility: <CFIF IsDefined("URL.view") AND #URL.view# EQ "firstNations">visible<CFELSE>hidden</CFIF>;}
</STYLE>

<SCRIPT Language="Javascript">
if (document.layers) {
  visible = 'show';
  hidden = 'hide';
} else if (document.all) {
  visible = 'visible';
  hidden = 'hidden';
}

function tabButton(name, image_on, image_off, is_on) {
// Constructor for the tabButton class
	this.name = name;
	this.image_on = image_on;
	this.image_off = image_off;
	this.is_on = is_on;
}

// Define 6 tabButton objects
var tabButton1 = new tabButton("tabButton_1", "images/tab_project_on.gif", "images/tab_project.gif", <CFOUTPUT><CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton2 = new tabButton("tabButton_2", "images/tab_property_on.gif", "images/tab_property.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "property">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton3 = new tabButton("tabButton_3", "images/tab_HQ_on.gif", "images/tab_HQ.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "hq">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton4 = new tabButton("tabButton_4", "images/tab_status_on.gif", "images/tab_status.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "status">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton5 = new tabButton("tabButton_5", "images/tab_factSheet_on.gif", "images/tab_factSheet.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "factSheet">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton6 = new tabButton("tabButton_6", "images/tab_firstNations_on.gif", "images/tab_firstNations.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "firstNations">true<CFELSE>false</CFIF></CFOUTPUT>);
// declare lastTabButton variable
var lastTabButton;
<!--- set lastTabButton to equal the tab that has been requested in URL.view --->
lastTabButton = <CFOUTPUT>
					<CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">tabButton1
					<CFELSEIF #URL.view# EQ "property">tabButton2
					<CFELSEIF #URL.view# EQ "hq">tabButton3
					<CFELSEIF #URL.view# EQ "status">tabButton4
					<CFELSEIF #URL.view# EQ "factSheet">tabButton5
					<CFELSEIF #URL.view# EQ "firstNations">tabButton6
					</CFIF>
				</CFOUTPUT>;
				
function tabChange(tab) {
// function for changing the images of 
// the tab buttons when a tab is clicked

	// set daTabButton equal to the currently clicked tabButton
	if (tab == "tab_1") {
		daTabButton = tabButton1;
	} 
	else if (tab == "tab_2") {
		daTabButton = tabButton2;
	} 
	else if (tab == "tab_3") {
		daTabButton = tabButton3;
	} 
	else if (tab == "tab_4") {
		daTabButton = tabButton4;
	}
	else if (tab == "tab_5") {
		daTabButton = tabButton5;
	}
	else {
		daTabButton = tabButton6;
	}
  
	if (lastTabButton != daTabButton) {
		// a new tab has been clicked, so turn off the lastTabButton
		changeImages(lastTabButton.name, lastTabButton.image_off);
		lastTabButton.is_on = false;
		// then turn on the new tabButton
		changeImages(daTabButton.name, daTabButton.image_on);
		daTabButton.is_on = true;
		// set lastTabButton equal to new tabButton
		lastTabButton = daTabButton;
	}
	// otherwise daTabButton is already on, so do nothing
}

function tabToggle(tab) {
// function for toggling the tab layers on and off

	if (document.layers) { // using netscape
		// set daTab equal to the tab that is being turned on
		daTab = document.layers[tab];
		// loop through all layers in document turning off each one
		for (var i = 0; i < document.layers.length; i++) {
			document.layers[i].visibility = hidden;
		}
		// turn on daTab
		daTab.visibility = visible;	
	}  
	else if (document.all) { // using IE
		// set daTab equal to the tab that is being turned on
		daTab = document.all(tab).style;
		// manually turn off all layers (could not find way to loop through all layers in IE)
		document.all('tab1').style.visibility = hidden;
		document.all('tab2').style.visibility = hidden;
		document.all('tab3').style.visibility = hidden;
		document.all('tab4').style.visibility = hidden;
		document.all('tab5').style.visibility = hidden;
		document.all('tab6').style.visibility = hidden;
		// turn on daTab
		daTab.visibility = visible;
	}
}

function sendForm(send_to) {
// This function is called whenever the project needs to be saved.
// It takes all of the values from the different forms and puts them into
// the form mainForm.  This is required because forms cannot exist on more
// than one layer so multiple forms are required, but only one form can be 
// sent at a time.  This sends all fo the forms at once.
//
// It takes one argument which is entered into the "page" field.
// This argument tells the form processing page (disposalSave.cfm)
// where to redirect the user after it has saved the project.

	if (document.layers) { // using Netscape
		// tab1 fields
		document.mainForm.provID.value = document.tab1.document.ProjectForm.province.options[document.tab1.document.ProjectForm.province.selectedIndex].value;
		document.mainForm.locationID.value = document.tab1.document.ProjectForm.location.options[document.tab1.document.ProjectForm.location.selectedIndex].value;
		document.mainForm.description.value = document.tab1.document.ProjectForm.description.value;
		document.mainForm.agent.value = document.tab1.document.ProjectForm.agent.options[document.tab1.document.ProjectForm.agent.selectedIndex].value;
		document.mainForm.dept.value = document.tab1.document.ProjectForm.department.options[document.tab1.document.ProjectForm.department.selectedIndex].value;
		document.mainForm.secondDept.value = document.tab1.document.ProjectForm.secondDept.options[document.tab1.document.ProjectForm.secondDept.selectedIndex].value;
		document.mainForm.clientContact.value = document.tab1.document.ProjectForm.clientContact.options[document.tab1.document.ProjectForm.clientContact.selectedIndex].value;
		document.mainForm.projectNo.value = document.tab1.document.ProjectForm.projectNo.value;
		document.mainForm.fileNo.value = document.tab1.document.ProjectForm.fileNo.value;
		document.mainForm.startDate.value = document.tab1.document.ProjectForm.startDate.value;
		document.mainForm.complDate.value = document.tab1.document.ProjectForm.completionDate.value;
		document.mainForm.SSAFees.value = document.tab1.document.ProjectForm.SSAFees.value;
		document.mainForm.SSADisbursements.value = document.tab1.document.ProjectForm.SSADisbursements.value;
		document.mainForm.cancelled.value = (document.tab1.document.ProjectForm.cancelled.checked) ? "yes" : "no";
		document.mainForm.expToDate.value = document.tab1.document.ProjectForm.expToDate.value;
		// tab2 fields
		document.mainForm.legal.value = document.tab2.document.PropertyForm.legal.value;
		document.mainForm.rollNumber.value = document.tab2.document.PropertyForm.rollNumber.value;
		document.mainForm.LDU.value = document.tab2.document.PropertyForm.LDU.value;
		document.mainForm.PACNo.value = document.tab2.document.PropertyForm.PACNo.value;
		document.mainForm.SMANo.value = document.tab2.document.PropertyForm.SMANo.value;
		document.mainForm.projRefNo.value = document.tab2.document.PropertyForm.projRefNo.value;
		document.mainForm.price.value = document.tab2.document.PropertyForm.price.value;
		// tab3 fields
		document.mainForm.reportOfSurplus.value = document.tab3.document.HQForm.reportOfSurplus.value;
		document.mainForm.disposalMethod.value = document.tab3.document.HQForm.disposalMethod.options[document.tab3.document.HQForm.disposalMethod.selectedIndex].value;
		document.mainForm.interestSold.value = document.tab3.document.HQForm.interestSold.options[document.tab3.document.HQForm.interestSold.selectedIndex].value;
		document.mainForm.propertyType.value = document.tab3.document.HQForm.propertyType.options[document.tab3.document.HQForm.propertyType.selectedIndex].value;
		document.mainForm.purchaserType.value = document.tab3.document.HQForm.purchaserType.options[document.tab3.document.HQForm.purchaserType.selectedIndex].value;
		// tab4 fields
		document.mainForm.generalDesc.value = document.tab5.document.FactSheetForm.generalDesc.value;
		document.mainForm.available.value = document.tab5.document.FactSheetForm.available.value;
		document.mainForm.urbanCentre.value = document.tab5.document.FactSheetForm.urbanCentre.value;
		document.mainForm.address.value = document.tab5.document.FactSheetForm.address.value;
		document.mainForm.parcelSize.value = document.tab5.document.FactSheetForm.parcelSize.value;
		document.mainForm.topography.value = document.tab5.document.FactSheetForm.topography.value;
		document.mainForm.access.value = document.tab5.document.FactSheetForm.access.value;
		document.mainForm.buildingDesc.value = document.tab5.document.FactSheetForm.buildingDesc.value;
		document.mainForm.zoning.value = document.tab5.document.FactSheetForm.zoning.value;
		document.mainForm.services.value = document.tab5.document.FactSheetForm.services.value;
		document.mainForm.landUse.value = document.tab5.document.FactSheetForm.landUse.value;
		document.mainForm.age.value = document.tab5.document.FactSheetForm.age.value;
		document.mainForm.condition.value = document.tab5.document.FactSheetForm.condition.value;
		document.mainForm.environIssues.value = document.tab5.document.FactSheetForm.environIssues.value;
		document.mainForm.tenure.value = document.tab5.document.FactSheetForm.tenure.value;
		document.mainForm.restrictions.value = document.tab5.document.FactSheetForm.restrictions.value;
		document.mainForm.acquiDate.value = document.tab5.document.FactSheetForm.acquiDate.value;
		document.mainForm.purchasedFrom.value = document.tab5.document.FactSheetForm.purchasedFrom.value;
		document.mainForm.amountPaid.value = document.tab5.document.FactSheetForm.amountPaid.value;
		document.mainForm.history.value = document.tab5.document.FactSheetForm.history.value;
		document.mainForm.knownInterests.value = document.tab5.document.FactSheetForm.knownInterests.value;
		document.mainForm.landAsses.value = document.tab5.document.FactSheetForm.landAsses.value;
		document.mainForm.buildingAsses.value = document.tab5.document.FactSheetForm.buildingAsses.value;
		document.mainForm.year.value = document.tab5.document.FactSheetForm.year.value;
		document.mainForm.PILT.value = document.tab5.document.FactSheetForm.PILT.value;
		// tell disposalSave.cfm what page to go to after processing the form
		document.mainForm.page.value = send_to
	}
	if (document.all) { // using IE
		// tab1 fields
		document.mainForm.provID.value = document.ProjectForm.province.options[document.ProjectForm.province.selectedIndex].value;
		document.mainForm.locationID.value = document.ProjectForm.location.options[document.ProjectForm.location.selectedIndex].value;
		document.mainForm.description.value = document.ProjectForm.description.value;
		document.mainForm.agent.value = document.ProjectForm.agent.options[document.ProjectForm.agent.selectedIndex].value;
		document.mainForm.dept.value = document.ProjectForm.department.options[document.ProjectForm.department.selectedIndex].value;
		document.mainForm.secondDept.value = document.ProjectForm.secondDept.options[document.ProjectForm.secondDept.selectedIndex].value;
		document.mainForm.clientContact.value = document.ProjectForm.clientContact.options[document.ProjectForm.clientContact.selectedIndex].value;
		document.mainForm.projectNo.value = document.ProjectForm.projectNo.value;
		document.mainForm.fileNo.value = document.ProjectForm.fileNo.value;
		document.mainForm.startDate.value = document.ProjectForm.startDate.value;
		document.mainForm.complDate.value = document.ProjectForm.completionDate.value;
		document.mainForm.SSAFees.value = document.ProjectForm.SSAFees.value;
		document.mainForm.SSADisbursements.value = document.ProjectForm.SSADisbursements.value;
		document.mainForm.cancelled.value = (document.ProjectForm.cancelled.checked) ? "yes" : "no";
		document.mainForm.expToDate.value = document.ProjectForm.expToDate.value;
		// tab2 fields
		document.mainForm.legal.value = document.PropertyForm.legal.value;
		document.mainForm.rollNumber.value = document.PropertyForm.rollNumber.value;
		document.mainForm.LDU.value = document.PropertyForm.LDU.value;
		document.mainForm.PACNo.value = document.PropertyForm.PACNo.value;
		document.mainForm.SMANo.value = document.PropertyForm.SMANo.value;
		document.mainForm.projRefNo.value = document.PropertyForm.projRefNo.value;
		document.mainForm.price.value = document.PropertyForm.price.value;
		// tab3 fields
		document.mainForm.reportOfSurplus.value = document.HQForm.reportOfSurplus.value;
		document.mainForm.disposalMethod.value = document.HQForm.disposalMethod.options[document.HQForm.disposalMethod.selectedIndex].value;
		document.mainForm.interestSold.value = document.HQForm.interestSold.options[document.HQForm.interestSold.selectedIndex].value;
		document.mainForm.propertyType.value = document.HQForm.propertyType.options[document.HQForm.propertyType.selectedIndex].value;
		document.mainForm.purchaserType.value = document.HQForm.purchaserType.options[document.HQForm.purchaserType.selectedIndex].value;
		// tab4 fields
		document.mainForm.generalDesc.value = document.FactSheetForm.generalDesc.value;
		document.mainForm.available.value = document.FactSheetForm.available.value;
		document.mainForm.urbanCentre.value = document.FactSheetForm.urbanCentre.value;
		document.mainForm.address.value = document.FactSheetForm.address.value;
		document.mainForm.parcelSize.value = document.FactSheetForm.parcelSize.value;
		document.mainForm.topography.value = document.FactSheetForm.topography.value;
		document.mainForm.access.value = document.FactSheetForm.access.value;
		document.mainForm.buildingDesc.value = document.FactSheetForm.buildingDesc.value;
		document.mainForm.zoning.value = document.FactSheetForm.zoning.value;
		document.mainForm.services.value = document.FactSheetForm.services.value;
		document.mainForm.landUse.value = document.FactSheetForm.landUse.value;
		document.mainForm.age.value = document.FactSheetForm.age.value;
		document.mainForm.condition.value = document.FactSheetForm.condition.value;
		document.mainForm.environIssues.value = document.FactSheetForm.environIssues.value;
		document.mainForm.tenure.value = document.FactSheetForm.tenure.value;
		document.mainForm.restrictions.value = document.FactSheetForm.restrictions.value;
		document.mainForm.acquiDate.value = document.FactSheetForm.acquiDate.value;
		document.mainForm.purchasedFrom.value = document.FactSheetForm.purchasedFrom.value;
		document.mainForm.amountPaid.value = document.FactSheetForm.amountPaid.value;
		document.mainForm.history.value = document.FactSheetForm.history.value;
		document.mainForm.knownInterests.value = document.FactSheetForm.knownInterests.value;
		document.mainForm.landAsses.value = document.FactSheetForm.landAsses.value;
		document.mainForm.buildingAsses.value = document.FactSheetForm.buildingAsses.value;
		document.mainForm.year.value = document.FactSheetForm.year.value;
		document.mainForm.PILT.value = document.FactSheetForm.PILT.value;
		// tell disposalSave.cfm what page to go to after processing the form
		document.mainForm.page.value = send_to
	}
	document.mainForm.submit();
}

</SCRIPT>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">
	


<!-- table for displaying the project location and description -->
<table width="650" border="0" cellpadding="7" cellspacing="0">
	<tr>
		<td valign="top" nowrap>
			<span style="font-family: Helvetica; font-size: 9pt; font-weight: bold; color: #000000;"><CFOUTPUT>#tempLocation#, #tempAbbreviated#</CFOUTPUT></span>
		</td>
		<td width="95%">
			<span style="font-family: Helvetica; font-size: 9pt; font-weight: bold; color: #000000;"><CFOUTPUT>#tempDescription#</CFOUTPUT></span>
		</td>	
	</tr>
</table>

<!-- table for the tab buttons and save/cancel buttons -->
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td><img src="images/transparent.gif" width="50" height="1"></td>
		<td><a href="#" onClick="tabToggle('tab1'); tabChange('tab_1'); return false;"><img name="tabButton_1" src="images/tab_project<CFOUTPUT><CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">_on</CFIF></CFOUTPUT>.gif" width="83" height="25" border="0"></a></td>
		<td><a href="#" onClick="tabToggle('tab2'); tabChange('tab_2'); return false;"><img name="tabButton_2" src="images/tab_property<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "property">_on</CFIF></CFOUTPUT>.gif" width="94" height="25" border="0"></a></td>
		<td><a href="#" onClick="tabToggle('tab3'); tabChange('tab_3'); return false;"><img name="tabButton_3" src="images/tab_HQ<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "hq">_on</CFIF></CFOUTPUT>.gif" width="81" height="25" border="0"></a></td>
		<td><a href="#" onClick="tabToggle('tab4'); tabChange('tab_4'); return false;"><img name="tabButton_4" src="images/tab_status<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "status">_on</CFIF></CFOUTPUT>.gif" width="84" height="25" border="0"></a></td>
		<td><a href="#" onClick="tabToggle('tab5'); tabChange('tab_5'); return false;"><img name="tabButton_5" src="images/tab_factSheet<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "factSheet">_on</CFIF></CFOUTPUT>.gif" width="82" height="25" border="0"></a></td>
		<td><a href="#" onClick="tabToggle('tab6'); tabChange('tab_6'); return false;"><img name="tabButton_6" src="images/tab_firstNations<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "firstNations">_on</CFIF></CFOUTPUT>.gif" width="94" height="25" border="0"></a></td>
		<td><img src="images/transparent.gif" width="140" height="1"></td>
		<td width="100%">&nbsp;</td>
	</tr>
	<tr>
	    <td valign="middle" colspan="2" bgcolor="#0099cc"><img src="images/titleDisposal.gif" width="70" height="31" align="absmiddle"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="94" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="81" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="84" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="82" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="94" height="1"></td>
		<td width="140" align="right" bgcolor="#0099cc"><CFOUTPUT><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('projectList.cfm?saveType=disposal'); return false;"><img src="images/button_save.gif" width="48" height="19" border="0"></a><CFELSE>&nbsp;</CFIF></CFOUTPUT> <a href="projectList.cfm"><img src="images/button_cancel_grey.gif" width="60" height="19" border="0"></a></td>
		<td bgcolor="#0099cc">&nbsp;</td>
	</tr>
</table>

<!-- the main form which all the values from the separate forms are sent to when the project is saved -->
<FORM NAME="mainForm" ACTION="disposalSave.cfm" METHOD="POST">
	<INPUT TYPE="hidden" NAME="page">
	<INPUT TYPE="hidden" NAME="projectID" VALUE=<CFOUTPUT>#URL.projectID#</CFOUTPUT>>
	<INPUT TYPE="hidden" NAME="projectNo">
	<INPUT TYPE="hidden" NAME="projectNo_integer">
	<INPUT TYPE="hidden" NAME="provID">
	<INPUT TYPE="hidden" NAME="locationID">
	<INPUT TYPE="hidden" NAME="description">
	<INPUT TYPE="hidden" NAME="legal">
	<INPUT TYPE="hidden" NAME="dept">
	<INPUT TYPE="hidden" NAME="secondDept">
	<INPUT TYPE="hidden" NAME="clientContact">
	<INPUT TYPE="hidden" NAME="agent">
	<INPUT TYPE="hidden" NAME="fileNo">
	<INPUT TYPE="hidden" NAME="startDate">
	<INPUT TYPE="hidden" NAME="startDate_date" VALUE="You must enter a proper date (yyyy/m/d) in the Project Start Date field">
	<INPUT TYPE="hidden" NAME="complDate">
	<INPUT TYPE="hidden" NAME="complDate_date" VALUE="You must enter a proper date (yyyy/m/d) in the Project Completion Date field">
	<INPUT TYPE="hidden" NAME="SSAFees">
	<INPUT TYPE="hidden" NAME="SSADisbursements">
	<INPUT TYPE="hidden" NAME="expToDate">
	<INPUT TYPE="hidden" NAME="cancelled">
	<INPUT TYPE="hidden" NAME="price">
	<INPUT TYPE="hidden" NAME="rollNumber">
	<INPUT TYPE="hidden" NAME="projRefNo">
	<INPUT TYPE="hidden" NAME="LDU">
	<INPUT TYPE="hidden" NAME="PACNo">
	<INPUT TYPE="hidden" NAME="SMANo">
	<INPUT TYPE="hidden" NAME="reportOfSurplus">
	<INPUT TYPE="hidden" NAME="reportOfSurplus_date" VALUE="You must enter a proper date (yyyy/m/d) in the Report of Surplus Date field">
	<INPUT TYPE="hidden" NAME="disposalMethod">
	<INPUT TYPE="hidden" NAME="interestSold">
	<INPUT TYPE="hidden" NAME="propertyType">
	<INPUT TYPE="hidden" NAME="purchaserType">
	<INPUT TYPE="hidden" NAME="generalDesc">
	<INPUT TYPE="hidden" NAME="available">
	<INPUT TYPE="hidden" NAME="urbanCentre">
	<INPUT TYPE="hidden" NAME="address">
	<INPUT TYPE="hidden" NAME="parcelSize">
	<INPUT TYPE="hidden" NAME="parcelSize_float">
	<INPUT TYPE="hidden" NAME="topography">
	<INPUT TYPE="hidden" NAME="access">
	<INPUT TYPE="hidden" NAME="buildingDesc">
	<INPUT TYPE="hidden" NAME="zoning">
	<INPUT TYPE="hidden" NAME="services">
	<INPUT TYPE="hidden" NAME="landUse">
	<INPUT TYPE="hidden" NAME="age">
	<INPUT TYPE="hidden" NAME="age_integer">
	<INPUT TYPE="hidden" NAME="condition">
	<INPUT TYPE="hidden" NAME="environIssues">
	<INPUT TYPE="hidden" NAME="tenure">
	<INPUT TYPE="hidden" NAME="restrictions">
	<INPUT TYPE="hidden" NAME="acquiDate">
	<INPUT TYPE="hidden" NAME="purchasedFrom">
	<INPUT TYPE="hidden" NAME="amountPaid">
	<INPUT TYPE="hidden" NAME="history">
	<INPUT TYPE="hidden" NAME="knownInterests">
	<INPUT TYPE="hidden" NAME="buildingAsses">
	<INPUT TYPE="hidden" NAME="landAsses">
	<INPUT TYPE="hidden" NAME="year">
	<INPUT TYPE="hidden" NAME="year_integer">
	<INPUT TYPE="hidden" NAME="PILT">	
</FORM>

<!-- Layer for the Project tab -->
<DIV ID="tab1" class="tab">
<FORM NAME="ProjectForm">
<table>
	<tr>
		<td><img src="images/transparent.gif" width="175" height="1"></td>
		<td colspan="5"></td>
	</tr>
	<tr>
		<td align="right">Location:</td>
		<td colspan="5" valign="middle">
			<SELECT NAME="location">
			<CFOUTPUT QUERY="qryLocation">
				<OPTION VALUE=#intLocationID#<CFIF #tempLocationID# EQ #intLocationID#> SELECTED</CFIF>>#strLocation#</OPTION>
			</CFOUTPUT>
			</SELECT>&nbsp;&nbsp;&nbsp;
			<SELECT NAME="province">
			<CFOUTPUT QUERY="qryProvince">
				<OPTION VALUE=#intProvID#<CFIF #tempProvID# EQ #intProvID#> SELECTED</CFIF>>#strProvNm#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>	
	<tr>
		<td align="right" valign="top">Description:</td>
		<td colspan="5"><TEXTAREA NAME="description" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempDescription#</CFOUTPUT></TEXTAREA></td>
	</tr>
	<tr>
		<td align="right">Advisor:</td>
		<td colspan="5">
			<SELECT NAME="agent">
			<CFOUTPUT QUERY="qryAgent">
				<OPTION VALUE=#intAgentID#<CFIF #tempAgent# EQ #intAgentID#> SELECTED</CFIF>>#strFirstName# #strLastName#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Client/Department:</td>
		<td colspan="3">
			<SELECT NAME="department">
			<CFOUTPUT QUERY="qryDept">
				<OPTION VALUE=#intDeptID#<CFIF #tempClientDept# EQ #intDeptID#> SELECTED</CFIF>>#strDeptName#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
		<td align="right">Client Contact:</td>
		<td><SELECT NAME="clientContact">
			<CFOUTPUT QUERY="qryClientContact">
				<OPTION VALUE=#intClientContactID#<CFIF #tempClientContact# EQ #intClientContactID#> SELECTED</CFIF>>#strFirstName# #strLastName#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Second Client/Dept:</td>
		<td colspan="5">
			<SELECT NAME="secondDept">
				<OPTION VALUE=0<CFIF #tempSecondDept# EQ 0> SELECTED</CFIF>> </OPTION>
			<CFOUTPUT QUERY="qryDept">
				<OPTION VALUE=#intDeptID#<CFIF #tempSecondDept# EQ #intDeptID#> SELECTED</CFIF>>#strDeptName#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr>
		<td align="right">Project Number:</td>
		<td><INPUT TYPE="text" NAME="projectNo" SIZE=8 MAXLENGTH=7 VALUE="<CFOUTPUT>#tempProjectNo#</CFOUTPUT>"></td>
		<td align="right">File Number:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="fileNo" SIZE=15 MAXLENGTH=16 VALUE="<CFOUTPUT>#tempFileNo#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Project Start Date:</td>
		<td><INPUT TYPE="text" NAME="startDate" SIZE=10 VALUE="<CFOUTPUT>#DateFormat(tempStartDate, "yyyy/m/d")#</CFOUTPUT>"></td>
		<td align="right">Project Completion Date:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="completionDate" SIZE=10 VALUE="<CFOUTPUT>#DateFormat(tempComplDate, "yyyy/m/d")#</CFOUTPUT>"> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?tab=tab1&form=ProjectForm&field=completionDate','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td> 
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>
		<td align="right">Cancelled:</td>
		<td colspan="3"><INPUT TYPE="checkbox" NAME="cancelled" VALUE="yes"<CFOUTPUT><CFIF #tempCancelled# EQ True> CHECKED</CFIF></CFOUTPUT>></td>
	</tr>
	<tr>
		<td align="right">SSA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Fees:</td>
		<td><INPUT TYPE="text" NAME="SSAFees" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempSSAFees)#</CFOUTPUT>"></td>
		<td align="right">Disbursements:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="SSADisbursements" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempSSADisbursements)#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Expenditures to Date:</td>
		<td colspan="5"><INPUT TYPE="text" NAME="expToDate" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempExpToDate)#</CFOUTPUT>"></td>
	</tr>
</table>
</FORM>
</DIV>

<!-- Layer for the Property Info tab -->
<DIV ID="tab2" class="tab">
<FORM NAME="PropertyForm">
<table>
	<tr>
		<td><img src="images/transparent.gif" width="175" height="1"></td>
		<td colspan="3"></td>
	</tr>
	<tr>
		<td align="right">Legal Description:</td>
		<td colspan="3"><TEXTAREA NAME="legal" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempLegal#</CFOUTPUT></TEXTAREA></td>
		
	</tr>
	<tr>
		<td align="right">Roll Number:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="rollNumber" SIZE=30 MAXLENGTH=50 VALUE="<CFOUTPUT>#tempRollNumber#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right" valign="top">PIN/PID:</td>
		<td>
			<table border="0" cellpadding="3" cellspacing="0">
			<CFIF Client.LoggedIn EQ "Yes">
				<tr>
					<td colspan="2">&nbsp;</td>
					<td><CFOUTPUT><a href="##" onClick="sendForm('addPINPID.cfm?type=disposals&projectID=#tempProjectID#'); return false;"><img src="images/button_add_PINPID.gif" width="61" height="16" border="0"></a></CFOUTPUT></td>
				</tr>
			</CFIF>
			<CFOUTPUT QUERY="qryPINPID">
				<!--- If the PIN/PID is a PID, insert two -'s --->
				<CFIF #bolIsPID# EQ True>
					<CFSET newPINPID = #Insert('-', strPINPID, 3)#>
					<CFSET newPINPID = #Insert('-', newPINPID, 7)#>
				<CFELSE>
					<CFSET newPINPID = #strPINPID#>
				</CFIF>
				<tr>
					<td with="65">#newPINPID#</td>
					<td><CFIF #bolIsPID# EQ True>PID<CFELSE>PIN</CFIF></td>
					<td><CFIF Client.LoggedIn EQ "Yes"><a onClick="return confirm('Are you sure you want to permanently delete this PIN/PID');" href="disposals.cfm?projectID=#URL.projectID#&pinpidDelete=#strPINPID#&view=property"><img src="images/button_delete.gif" width="44" height="16" border="0"></a></CFIF></td>
				</tr>
			</CFOUTPUT>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">LDU Number:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="LDU" SIZE=5 MAXLENGTH=5 VALUE="<CFOUTPUT>#tempLDU#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">PAC Number:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="PACNo" SIZE=5 MAXLENGTH=5 VALUE="<CFOUTPUT>#tempPACNo#</CFOUTPUT>"></td>
	</tr>	
	<tr>
		<td align="right">Project Number:</td>
		<td width="170"><CFOUTPUT>#tempProjectNo#</CFOUTPUT></td>
		<td align="right">SMA Number:</td>
		<td><INPUT TYPE="text" NAME="SMANo" SIZE=6 MAXLENGTH=6 VALUE="<CFOUTPUT>#tempSMANo#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Project Reference #(from REO):</td>
		<td colspan="3"><INPUT TYPE="text" NAME="projRefNo" SIZE=7 MAXLENGTH=7 VALUE="<CFOUTPUT>#tempProjRefNo#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Sale Price:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="price" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempPrice)#</CFOUTPUT>"></td>
	</tr>
</table>
</FORM>
</DIV>

<!-- Layer for the HQ tab -->
<DIV ID="tab3" class="tab">
<FORM NAME="HQForm">
<table>
	<tr>
		<td><img src="images/transparent.gif" width="175" height="1"></td>
		<td></td>
	</tr>
	<tr>
		<td align="right">Report of Surplus Date:</td>
		<td><INPUT TYPE="text" NAME="reportOfSurplus" SIZE=10 VALUE="<CFOUTPUT>#DateFormat(tempReportOfSurplus, "yyyy/m/d")#</CFOUTPUT>"> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?tab=tab3&form=HQForm&field=reportOfSurplus','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
	<tr>
		<td align="right">Dipsosal Method:</td>
		<td colspan="5">
			<SELECT NAME="disposalMethod">
			<CFOUTPUT QUERY="qryDisposalMethod">
				<OPTION VALUE=#intDisposalMethodID#<CFIF #tempDisposalMethod# EQ #intDisposalMethodID#> SELECTED</CFIF>>#strDisposalMethod#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Interest Sold:</td>
		<td colspan="5">
			<SELECT NAME="interestSold">
			<CFOUTPUT QUERY="qryInterestSold">
				<OPTION VALUE=#intInterestSoldID#<CFIF #tempInterestSold# EQ #intInterestSoldID#> SELECTED</CFIF>>#strInterestSold#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Property Type:</td>
		<td colspan="5">
			<SELECT NAME="propertyType">
			<CFOUTPUT QUERY="qryPropertyType">
				<OPTION VALUE=#intPropertyTypeID#<CFIF #tempPropertyTypeID# EQ #intPropertyTypeID#> SELECTED</CFIF>>#strPropertyType#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Purchaser Type:</td>
		<td colspan="5">
			<SELECT NAME="purchaserType">
			<CFOUTPUT QUERY="qryPurchaserType">
				<OPTION VALUE=#intPurchaserTypeID#<CFIF #tempPurchaserTypeID# EQ #intPurchaserTypeID#> SELECTED</CFIF>>#strPurchaserType#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
</table>
</FORM>
</DIV>

<!-- Layer for the Status tab -->
<DIV ID="tab4" class="tab">
<br>
<table border="0" cellpadding="4" cellspacing="0" width="720" align="center">
	<tr bgcolor="#0099CC">
		<td width="80"><font color="#ffffff">Date</font></td>
		<td width="570"><font color="#ffffff">Status</font></td>
		<td wdith="70" align="center"><CFIF Client.LoggedIn EQ "Yes"><CFOUTPUT><a href="##" onClick="sendForm('statusUpdate.cfm?type=disposals&projectID=#tempProjectID#&add=yes'); return false;"><img src="images/button_add_status.gif" width="61" height="16" border="0"></a></CFOUTPUT></CFIF></td>
	</tr>
<CFOUTPUT QUERY="qryStatus">
	<tr <CFIF (currentrow MOD 2) NEQ 1>bgcolor="##D9F0FF"</CFIF>>
		<td valign="top">#DateFormat(datUpdate, "mmm d, yyyy")#</td>
		<td>#memStatus#</td>
		<td align="right" valign="top"><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('statusUpdate.cfm?type=disposals&projectID=#tempProjectID#&statusID=#intStatusID#'); return false;"><img src="images/button_edit.gif" width="40" height="16" border="0"></a>&nbsp;<a onClick="return confirm('Are you sure you want to permanently delete this Status Update');" href="disposals.cfm?projectID=#URL.projectID#&statusDelete=#intStatusID#&view=status"><img src="images/button_delete.gif" width="44" height="16" border="0"></a></CFIF></td>
	</tr>
</CFOUTPUT>
</table>
<br><br>
</DIV>

<!-- Layer for the Fact Sheet tab -->
<DIV ID="tab5" class="tab">
<FORM NAME="FactSheetForm">
<table>
	<tr>
		<td><img src="images/transparent.gif" width="175" height="1"></td>
		<td></td>
	</tr>
	<tr>
		<td colspan="2"><b>Property Identification</b></td>
	</tr>
	<tr>
		<td align="right">City/Town:</td>
		<td><CFOUTPUT>#tempLocation#</CFOUTPUT></td>
	</tr>
	<tr>
		<td align="right">Nearest Urban Centre:</td>
		<td><INPUT TYPE="text" NAME="urbanCentre" SIZE=40 MAXLENGTH=70 VALUE="<CFOUTPUT>#tempUrbanCentre#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Street Address:</td>
		<td><INPUT TYPE="text" NAME="address" SIZE=50 MAXLENGTH=100 VALUE="<CFOUTPUT>#tempAddress#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right" valign="top">General Description:</td>
		<td><TEXTAREA NAME="generalDesc" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempGeneralDesc#</CFOUTPUT></TEXTAREA></td>
	</tr>
	<tr>
		<td align="right">Legal Description:</td>
		<td><CFOUTPUT>#tempLegal#</CFOUTPUT></td>
	</tr>
	<tr>
		<td align="right">LDU No:</td>
		<td><CFOUTPUT>#tempLDU#</CFOUTPUT></td>
	</tr>
	<tr>
		<td align="right">Property is Available:</td>
		<td><INPUT TYPE="text" NAME="available" SIZE=20 MAXLENGTH=50 VALUE="<CFOUTPUT>#tempAvailable#</CFOUTPUT>"> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?tab=tab5&form=FactSheetForm&field=available&asText=yes','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
	<tr>
		<td colspan="2"><b>Custodian and Contact Information</b></td>
	</tr>
	<tr>
		<td align="right">Custodian Department:</td>
		<td><CFOUTPUT>#tempDeptName#</CFOUTPUT></td>
	</tr>
	<tr>
		<td align="right">Custodian Contact:</td>
		<td><CFOUTPUT>#tempContactFirst# #tempContactLast#</CFOUTPUT></td>
	</tr>
	<tr>
		<td align="right">PQGSC Contact:</td>
		<td><CFOUTPUT>#tempFirstName# #tempLastName#</CFOUTPUT></td>
	</tr>
	<tr>
		<td colspan="2"><b>Description of Property</b></td>
	</tr>
	<tr>
		<td align="right">Parcel Size (ha):</td>
		<td><INPUT TYPE="text" NAME="parcelSize" SIZE=20 VALUE="<CFOUTPUT>#DecimalFormat(tempParcelSize)#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Topography:</td>
		<td><INPUT TYPE="text" NAME="topography" SIZE=50 MAXLENGTH=255 VALUE="<CFOUTPUT>#tempTopography#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Access:</td>
		<td><INPUT TYPE="text" NAME="access" SIZE=50 MAXLENGTH=100 VALUE="<CFOUTPUT>#tempAccess#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Building Description:</td>
		<td><INPUT TYPE="text" NAME="buildingDesc" SIZE=50 MAXLENGTH=255 VALUE="<CFOUTPUT>#tempBuildingDesc#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Zoning:</td>
		<td><INPUT TYPE="text" NAME="zoning" SIZE=50 MAXLENGTH=100 VALUE="<CFOUTPUT>#tempZoning#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Services:</td>
		<td><INPUT TYPE="text" NAME="services" SIZE=50 MAXLENGTH=255 VALUE="<CFOUTPUT>#tempServices#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Surrounding Land Use:</td>
		<td><INPUT TYPE="text" NAME="landUse" SIZE=50 MAXLENGTH=255 VALUE="<CFOUTPUT>#tempLandUse#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right" valign="top">Environmental Issues:</td>
		<td><TEXTAREA NAME="environIssues" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempEnvironIssues#</CFOUTPUT></TEXTAREA></td>
	</tr>
	<tr>
		<td colspan="2"><b>Improvements</b></td>
	</tr>
	<tr>
		<td align="right">Age:</td>
		<td><INPUT TYPE="text" NAME="age" SIZE=5 MAXLENGTH=5 VALUE="<CFOUTPUT>#tempAge#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Condition:</td>
		<td><INPUT TYPE="text" NAME="condition" SIZE=50 MAXLENGTH=255 VALUE="<CFOUTPUT>#tempCondition#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td colspan="2"><b>Ownership</b></td>
	</tr>
	<tr>
		<td align="right">Tenure:</td>
		<td><INPUT TYPE="text" NAME="tenure" SIZE=50 MAXLENGTH=50 VALUE="<CFOUTPUT>#tempTenure#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Restrictions:</td>
		<td><INPUT TYPE="text" NAME="restrictions" SIZE=50 MAXLENGTH=255 VALUE="<CFOUTPUT>#tempRestrictions#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td colspan="2"><b>History</b></td>
	</tr>
	<tr>
		<td align="right">Acquisition Date:</td>
		<td><INPUT TYPE="text" NAME="acquiDate" SIZE=10 VALUE="<CFOUTPUT>#tempAcquiDate#</CFOUTPUT>"> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?tab=tab5&form=FactSheetForm&field=acquiDate&asText=yes','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td> 
	</tr>
	<tr>
		<td align="right">Purchased From:</td>
		<td><INPUT TYPE="text" NAME="purchasedFrom" SIZE=50 MAXLENGTH=70 VALUE="<CFOUTPUT>#tempPurchasedFrom#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Amount Paid:</td>
		<td><INPUT TYPE="text" NAME="amountPaid" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempAmountPaid)#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">History:</td>
		<td><INPUT TYPE="text" NAME="history" SIZE=50 MAXLENGTH=100 VALUE="<CFOUTPUT>#tempHistory#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td colspan="2"><b>Known and/or Potential Interests, Concerns, Proposals</b></td>
	</tr>
	<tr>
		<td align="right" valign="top">Known Interests:</td>
		<td><TEXTAREA NAME="knownInterests" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempKnownInterests#</CFOUTPUT></TEXTAREA></td>
	</tr>
	<tr>
		<td colspan="2"><b>Assessment & Taxation</b></td>
	</tr>
	<tr>
		<td align="right">Land Assessment:</td>
		<td><INPUT TYPE="text" NAME="landAsses" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempLandAsses)#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Building Assessment:</td>
		<td><INPUT TYPE="text" NAME="buildingAsses" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempBuildingAsses)#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Year:</td>
		<td><INPUT TYPE="text" NAME="year" SIZE=4 MAXLENGTH=4 VALUE="<CFOUTPUT>#tempYear#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">PILT:</td>
		<td><INPUT TYPE="text" NAME="PILT" SIZE=15 VALUE="<CFOUTPUT>#DollarFormat(tempPILT)#</CFOUTPUT>"></td>
	</tr>
</table>
</FORM>
</DIV>

<!-- Layer for the First Nations Consultations tab -->
<DIV ID="tab6" class="tab">
<br>
<table width="700" border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td width="270" colspan="2">
			<CFOUTPUT><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('bandUpdate.cfm?projectID=#URL.projectID#&add=yes'); return false;"><img src="images/button_add_band.gif" border="0" width="96" height="16"></a></CFIF></CFOUTPUT>
		</td>
	</tr>
<CFLOOP QUERY="qryBand">
	<tr>
		<td valign="top" colspan="4">
			<table border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td colspan="5"><br><br><b><CFOUTPUT>#qryband.strBandName#</CFOUTPUT></b></td>
				</tr>
				<tr>
					<td><img src="images/transparent.gif" border="0" width="51" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="211" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="51" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="211" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="156" height="1"></td>
				</tr>
				<tr>
					<td valign="top">Chief:</td>
					<td><CFOUTPUT>#qryband.strChiefName#</CFOUTPUT></td>
					<td valign="top">Tel:</td>
					<td><CFOUTPUT>#qryband.strPhone#</CFOUTPUT></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">Contact:</td>
					<td><CFOUTPUT>#qryband.strContact#</CFOUTPUT></td>
					<td valign="top">Fax:</td>
					<td><CFOUTPUT>#qryband.strFax#</CFOUTPUT></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">Address:</td>
					<td><CFOUTPUT>#qryband.strAddress#</CFOUTPUT></td>
					<td valign="top">E-mail:</td>
					<td><CFOUTPUT>#qryband.strEmail#</CFOUTPUT></td> 
					<td align="right"><CFOUTPUT><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('bandUpdate.cfm?projectID=#URL.projectID#&bandID=#qryBand.intBandID#'); return false;"><img src="images/button_edit_band.gif" border="0" width="90" height="16"></a></CFIF></CFOUTPUT>&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr bgcolor="#0099CC">
		<td width="85" height="25"><font color="#ffffff">&nbsp;Date:</font></td>
		<td width="185" height="25"><font color="#ffffff">By:</font></td>
		<td width="280" height="25"><font color="#ffffff">Remarks:</font></td>
		<td width="150" height="25" align="right" valign="bottom">
			<CFOUTPUT><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('addRemark.cfm?projectID=#URL.projectID#&bandID=#qryBand.intBandID#'); return false;"><img src="images/button_add_remark.gif" border="0" width="104" height="16"></a></CFIF></CFOUTPUT>&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
	<CFQUERY NAME="qryRemarks" DATASOURCE="#request.ds#">
		SELECT	tblFirstNationsRemarks.datDate,
				tblFirstNationsRemarks.memRemark,
				tblAgent.strFirstName,
				tblAgent.strLastName
		FROM	tblFirstNationsRemarks, tblAgent
		WHERE	tblFirstNationsRemarks.intBandID = #qryBand.intBandID#
		AND		tblFirstNationsRemarks.intAgentID = tblAgent.intAgentID	
		ORDER BY datDate DESC
	</CFQUERY>
	<CFLOOP QUERY="qryRemarks">
	<tr<CFIF (currentrow MOD 2) EQ 1> bgcolor="#D9F0FF"</CFIF>>
		<td width="85" valign="top"><CFOUTPUT>#DateFormat(qryRemarks.datDate, "mmm d, yyyy")#</CFOUTPUT></td>
		<td width="185" valign="top"><CFOUTPUT>#strFirstName# #strLastName#</CFOUTPUT></td>
		<td width="430" colspan="2"><CFOUTPUT>#qryRemarks.memRemark#</CFOUTPUT></td>
	</tr>
	</CFLOOP>
	<tr>
		<td width="85"><img src="images/transparent.gif" border="0" width="81" height="1"></td>
		<td width="185"><img src="images/transparent.gif" border="0" width="181" height="1"></td>
		<td width="430" colspan="2"><img src="images/transparent.gif" border="0" width="426" height="1"></td>
	</tr>
</CFLOOP>
</table>
<br><br>
</DIV>
<br>

</body>
</html>
