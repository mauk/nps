<!---
This page is used to display the acquisition project information.  It first checks to see if various
actions are taking place and performs the appropriate queries for these actions. These actions iclude: 
adding, editing and deleting status updates; adding, editing and deleting appraisals; and adding and 
deleting PIN/PID's.  Next, it performs a main query for displaying the project data.  After this it performs
many queries for populating list-boxes and displaying status updates, appraisals, and PIN/PID's. Then it
outputs the html, javascript, and ColdFusion for displaying all of the project data.  

If the user is not logged in, the save button will not be displayed, nor will any of the buttons that
are used for adding, editing and deleting data.
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Acquisitions</title>
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
				tblAcquisitions.datOffer,
				tblAcquisitions.datClose,
				tblAcquisitions.intInterestType,
				tblAcquisitions.strRollNumber,
				tblAcquisitions.strAcquiredFrom,
				tblAcquisitions.strPropertyUse,
				tblAcquisitions.memPropDescription,
				
				<!--- Added Lawler --->
				tblAcquisitions.strLawyer,
				
				tblLocation.strLocation,
				tblProvince.strAbbreviated
		FROM	tblProjects,
				tblAcquisitions,
				tblLocation,
				tblProvince
		WHERE	tblProjects.intProjectID = tblAcquisitions.intProjectID
		AND		tblProjects.intLocationID = tblLocation.intLocationID
		AND		tblProjects.intProvID = tblProvince.intProvID
		AND		tblProjects.intProjectID = #URL.projectID#
	</CFQUERY>
	
	<CFOUTPUT QUERY="qryDisplayProject">
		<!--- User is entering page from the search results (or newProject.cfm), so save all
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
			<CFSET Session.backupAgent = intAgent>
			<CFSET Session.backupFileNo = strFileNo>
			<CFSET Session.backupStartDate = datStartDate>
			<CFSET Session.backupComplDate = datComplDate>
			<CFSET Session.backupOffer = datOffer>
			<CFSET Session.backupPrice = curPrice>
			<CFSET Session.backupClose = datClose>
			<CFSET Session.backupSSAFees = curSSAFees>
			<CFSET Session.backupSSADisbursements = curSSADisbursements>
			<CFSET Session.backupExpToDate = curExpToDate>
			<CFSET Session.backupInterestType = intInterestType>
			<CFSET Session.backupRollNumber = strRollNumber>
			<CFSET Session.backupAcquiredFrom = strAcquiredFrom>
			<CFSET Session.backupPropertyUse = strPropertyUse>
			<CFSET Session.backupCancelled = bolCancelled>
			<CFSET Session.backupPropDescription = memPropDescription>
			<CFSET Session.backupClientContact = intClientContactID>
			
			<!--- added this --->
			<CFSET Session.backupLawyer = strLawyer>
			
			<CFSET Session.backupAbbreviated = strAbbreviated>
			<CFSET Session.backupLocation = strLocation>
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
	<CFSET tempAgent = Session.backupAgent>
	<CFSET tempFileNo = Session.backupFileNo>
	<CFSET tempStartDate = Session.backupStartDate>
	<CFSET tempComplDate = Session.backupComplDate>
	<CFSET tempOffer = Session.backupOffer>
	<CFSET tempPrice = Session.backupPrice>
	<CFSET tempClose = Session.backupClose>
	<CFSET tempSSAFees = Session.backupSSAFees>
	<CFSET tempSSADisbursements = Session.backupSSADisbursements>
	<CFSET tempExpToDate = Session.backupExpToDate>
	<CFSET tempInterestType = Session.backupInterestType>
	<CFSET tempRollNumber = Session.backupRollNumber>
	<CFSET tempAcquiredFrom = Session.backupAcquiredFrom>
	<CFSET tempPropertyUse = Session.backupPropertyUse>
	<CFSET tempCancelled = Session.backupCancelled>
	<CFSET tempPropDescription = Session.backupPropDescription>
	<CFSET tempClientContact = Session.backupClientContact>
	
<!--- added this --->
	<CFSET tempLawyer = Session.backupLawyer>
		
	<CFSET tempAbbreviated = Session.backupAbbreviated>
	<CFSET tempLocation = Session.backupLocation>
</CFLOCK>

<!--- If status is being updated, run query to save new values --->
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


<!--- If appraisal is being updated or added, format the Value field so it 
doesn't contain any commas or dollar signs ($). If the data entered in 
the Value field is not a proper currency or numeric value, then send the 
user to errorCurrency.cfm with the appropriate QueryString parameters--->
<CFIF IsDefined("Form.appraisalUpdate") OR IsDefined("Form.appraisalAdd")>
	<CFIF LSIsCurrency(Form.value)>
		<CFSET formattedValue = LSParseCurrency(Form.value)>
	<CFELSE>
		<CFLOCATION URL="errorCurrency.cfm?field=#URLEncodedFormat("Appraisal Value")#&value=#Form.value#">
		<CFABORT>
	</CFIF>
</CFIF>
<!--- If appraisal is being updated, run query to save new values --->
<CFIF IsDefined("Form.appraisalUpdate")>
	<CFQUERY NAME="qryUpdateappraisal" DATASOURCE="#request.ds#">
		UPDATE	tblAppraisals
		SET		datApprDate = ###DateFormat(Form.date, "yyyy/m/d")###,
				curApprAmount = #formattedValue#,
				strApprName = '#Form.apprName#',
				strAppraisalNo = '#Form.apprNo#'
		WHERE	intApprID = #Form.appraisalID#
	</CFQUERY>
<!--- If new appraisal is being added, run query to save new appraisal --->
<CFELSEIF IsDefined("Form.appraisalAdd")>
	<CFQUERY NAME="qryAddAppraisal" DATASOURCE="#request.ds#">
		INSERT	INTO tblAppraisals (datApprDate, curApprAmount, strApprName, strAppraisalNo, intProjectID)
		VALUES	(###DateFormat(Form.date, "yyyy/m/d")###, #formattedValue#, '#Form.apprName#', '#Form.apprNo#', #URL.projectID#)
	</CFQUERY>
<!--- If appraisal is being deleted, run query to delete the specified query --->
<CFELSEIF IsDefined("URL.appraisalDelete")>
	<CFQUERY NAME="qryDeleteAppraisal" DATASOURCE="#request.ds#">
		DELETE FROM	tblAppraisals
		WHERE		intApprID = #URL.appraisalDelete# 
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

<!--- Query for populating Interest Type list-box --->
<CFQUERY NAME="qryInterestType" DATASOURCE="#request.ds#">
	SELECT		tblInterestSold.intInterestSoldID,
				tblInterestSold.strInterestSold
	FROM		tblInterestSold
	ORDER BY	strInterestSold
</CFQUERY>

<!--- Query for displaying Status Updates --->
<CFQUERY NAME="qryStatus" DATASOURCE="#request.ds#">
	SELECT		tblStatus.intStatusID,
				tblStatus.memStatus,
				tblStatus.datUpdate
	FROM		tblStatus, tblProjects
	WHERE		tblStatus.intProjectID = tblProjects.intProjectID
	AND			tblStatus.intProjectID = #URL.projectID#
	ORDER BY	tblStatus.datUpdate DESC
</CFQUERY>

<!--- Query for displaying Appraisal info --->
<CFQUERY NAME="qryAppraisal" DATASOURCE="#request.ds#">
	SELECT		tblAppraisals.intApprID,
				tblAppraisals.datApprDate,
				tblAppraisals.curApprAmount,
				tblAppraisals.strAppraisalNo,
				tblAppraisals.strApprName
	FROM		tblAppraisals
	WHERE		tblAppraisals.intProjectID = #URL.projectID#
	ORDER BY	tblAppraisals.datApprDate DESC
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


<!-- define styles for the tab layers (not the tab buttons) -->
<STYLE TYPE="text/css">
.tab {position: absolute; left: 0; top: 145; width: 750px; background-color: white; z-index: 10;}
#tab1 {visibility: <CFOUTPUT><CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">visible<CFELSE>hidden</CFIF></CFOUTPUT>;}
#tab2 {visibility: <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "property">visible<CFELSE>hidden</CFIF></CFOUTPUT>;}
#tab3 {visibility: <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "purchase">visible<CFELSE>hidden</CFIF></CFOUTPUT>;}
#tab4 {visibility: <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "status">visible<CFELSE>hidden</CFIF></CFOUTPUT>;}
</STYLE>

<SCRIPT Language="Javascript">

function tabButton(name, image_on, image_off, is_on) {
// Constructor for the tabButton class
	this.name = name;
	this.image_on = image_on;
	this.image_off = image_off;
	this.is_on = is_on;
}

// Define 4 tabButton objects
var tabButton1 = new tabButton("tabButton_1", "images/tab_project_on.gif", "images/tab_project.gif", <CFOUTPUT><CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton2 = new tabButton("tabButton_2", "images/tab_property_on.gif", "images/tab_property.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "property">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton3 = new tabButton("tabButton_3", "images/tab_purchase_on.gif", "images/tab_purchase.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "purchase">true<CFELSE>false</CFIF></CFOUTPUT>);
var tabButton4 = new tabButton("tabButton_4", "images/tab_status_on.gif", "images/tab_status.gif", <CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "status">true<CFELSE>false</CFIF></CFOUTPUT>);
// declare lastTabButton variable
var lastTabButton;
<!--- set lastTabButton to equal the tab that has been requested in URL.view --->
lastTabButton = <CFOUTPUT><CFIF NOT IsDefined("URL.view") OR #URL.view# EQ "project">tabButton1<CFELSEIF #URL.view# EQ "property">tabButton2<CFELSEIF #URL.view# EQ "purchase">tabButton3<CFELSEIF #URL.view# EQ "status">tabButton4</CFIF></CFOUTPUT>;

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
	else {
		daTabButton = tabButton4;
	}
  
	if (lastTabButton != daTabButton) {
		// a new tab has been clicked, so turn off the lastTabButton
		changeImages(lastTabButton.name, lastTabButton.image_off);
		lastTabButton.is_on = false;
		// and turn on the new tabButton
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
// This argument tells the form processing page (acquisitionSave.cfm)
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
		
		// what I added
		document.mainForm.lawyer.value = document.tab1.document.ProjectForm.lawyer.value;
		
		// tab2 fields
		document.mainForm.legal.value = document.tab2.document.PropertyForm.legal.value;
		document.mainForm.rollNumber.value = document.tab2.document.PropertyForm.rollNumber.value;
		document.mainForm.interestType.value = document.tab2.document.PropertyForm.interestType.options[document.tab2.document.PropertyForm.interestType.selectedIndex].value;
		document.mainForm.propertyUse.value = document.tab2.document.PropertyForm.propertyUse.value;
		document.mainForm.propDescription.value = document.tab2.document.PropertyForm.propDescription.value;
		// tab3 fields
		document.mainForm.acquiredFrom.value = document.tab3.document.PurchaseForm.acquiredFrom.value;
		document.mainForm.price.value = document.tab3.document.PurchaseForm.price.value;
		document.mainForm.offer.value = document.tab3.document.PurchaseForm.offer.value;
		document.mainForm.close.value = document.tab3.document.PurchaseForm.close.value;
		// tell acquisitionSave.cfm what page to go to after processing the form
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
		
		// what I added
		document.mainForm.lawyer.value = document.ProjectForm.lawyer.value;
		
		// tab2 fields
		document.mainForm.legal.value = document.PropertyForm.legal.value;
		document.mainForm.rollNumber.value = document.PropertyForm.rollNumber.value;
		document.mainForm.interestType.value = document.PropertyForm.interestType.options[document.PropertyForm.interestType.selectedIndex].value;
		document.mainForm.propertyUse.value = document.PropertyForm.propertyUse.value;
		document.mainForm.propDescription.value = document.PropertyForm.propDescription.value;
		// tab3 fields
		document.mainForm.acquiredFrom.value = document.PurchaseForm.acquiredFrom.value;
		document.mainForm.price.value = document.PurchaseForm.price.value;
		document.mainForm.offer.value = document.PurchaseForm.offer.value;
		document.mainForm.close.value = document.PurchaseForm.close.value;
		// tell acquisitionSave.cfm what page to go to after processing the form
		document.mainForm.page.value = send_to
	}
	document.mainForm.submit();
}

</SCRIPT>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript functions and CSS --->
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
		<td><a href="#" onClick="tabToggle('tab3'); tabChange('tab_3'); return false;"><img name="tabButton_3" src="images/tab_purchase<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "purchase">_on</CFIF></CFOUTPUT>.gif" width="98" height="25" border="0"></a></td>
		<td><a href="#" onClick="tabToggle('tab4'); tabChange('tab_4'); return false;"><img name="tabButton_4" src="images/tab_status<CFOUTPUT><CFIF IsDefined("URL.view") AND #URL.view# EQ "status">_on</CFIF></CFOUTPUT>.gif" width="84" height="25" border="0"></a></td>
		<td><img src="images/transparent.gif" width="140" height="1"></td>
		<td width="100%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" bgcolor="#0099cc"><img src="images/titleAcquisition.gif" width="109" height="31"><img src="images/transparent.gif" width="24" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="94" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="98" height="1"></td>
		<td bgcolor="#0099cc"><img src="images/transparent.gif" width="84" height="1"></td>
		<td width="140" align="right" bgcolor="#0099cc"><CFOUTPUT><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('projectList.cfm?saveType=acquisition'); return false;"><img src="images/button_save.gif" width="48" height="19" border="0"></a><CFELSE>&nbsp;</CFIF></CFOUTPUT> <a href="projectList.cfm"><img src="images/button_cancel_grey.gif" width="60" height="19" border="0"></a></td>
		<td width="100%" bgcolor="#0099cc">&nbsp;</td>
	</tr>
</table>

<!-- the main form which all the values from the separate forms are sent to when the project is saved -->
<FORM NAME="mainForm" ACTION="acquisitionSave.cfm" METHOD="POST">
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
	<INPUT TYPE="hidden" NAME="agent">
	<INPUT TYPE="hidden" NAME="fileNo">
	<INPUT TYPE="hidden" NAME="startDate">
	<INPUT TYPE="hidden" NAME="startDate_date" VALUE="You must enter a proper date (yyyy/m/d) in the Project Start Date field">
	<INPUT TYPE="hidden" NAME="complDate">
	<INPUT TYPE="hidden" NAME="complDate_date" VALUE="You must enter a proper date (yyyy/m/d) in the Project Completion Date field">
	<INPUT TYPE="hidden" NAME="offer">
	<INPUT TYPE="hidden" NAME="offer_date" VALUE="You must enter a proper date (yyyy/m/d) in the Offer Date field">
	<INPUT TYPE="hidden" NAME="price">
	<INPUT TYPE="hidden" NAME="close">
	<INPUT TYPE="hidden" NAME="close_date" VALUE="You must enter a proper date (yyyy/m/d) in the Close Date field">
	<INPUT TYPE="hidden" NAME="SSAFees">
	<INPUT TYPE="hidden" NAME="SSADisbursements">
	<INPUT TYPE="hidden" NAME="expToDate">
	<INPUT TYPE="hidden" NAME="interestType">
	<INPUT TYPE="hidden" NAME="rollNumber">
	<INPUT TYPE="hidden" NAME="acquiredFrom">
	<INPUT TYPE="hidden" NAME="propertyUse">
	<INPUT TYPE="hidden" NAME="cancelled">
	<INPUT TYPE="hidden" NAME="propDescription">
	<INPUT TYPE="hidden" NAME="clientContact">
	
	<!--- added this  --->
	<INPUT TYPE="hidden" NAME="lawyer">
	
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
		<td><INPUT TYPE="text" NAME="projectNo" SIZE="8" MAXLENGTH="7" VALUE="<CFOUTPUT>#tempProjectNo#</CFOUTPUT>"></td>
		<td align="right">File Number:</td>
		<td colspan="3"><INPUT TYPE="text" NAME="fileNo" SIZE="15" MAXLENGTH="16" VALUE="<CFOUTPUT>#tempFileNo#</CFOUTPUT>"></td>
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
	<!--- What I added --->
	<tr>
  		<td colspan="6">&nbsp;</td>
 	</tr>
	<tr>
		<td align="right">Lawyer:</td>
		<td><INPUT TYPE="text" NAME="lawyer" SIZE=42 MAXLENGTH=40 VALUE="<CFOUTPUT>#tempLawyer#</CFOUTPUT>"></td>
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
		<td></td>
	</tr>
	<tr>
		<td align="right">Legal Description:</td>
		<td><TEXTAREA NAME="legal" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempLegal#</CFOUTPUT></TEXTAREA></td>
		
	</tr>
	<tr>
		<td align="right">Roll Number:</td>
		<td><INPUT TYPE="text" NAME="rollNumber" SIZE=15 MAXLENGTH=30 VALUE="<CFOUTPUT>#tempRollNumber#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right" valign="top">PIN/PID:</td>
		<td>
			<table border="0" cellpadding="3" cellspacing="0">
			<CFIF Client.LoggedIn EQ "Yes">
				<tr>
					<td colspan="2">&nbsp;</td>
					<td><CFOUTPUT><a href="##" onClick="sendForm('addPINPID.cfm?type=acquisitions&projectID=#tempProjectID#'); return false;"><img src="images/button_add_PINPID.gif" width="61" height="16" border="0"></a></CFOUTPUT></td>
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
					<td><CFIF Client.LoggedIn EQ "Yes"><a onClick="return confirm('Are you sure you want to permanently delete this PIN/PID?');" href="acquisitions.cfm?projectID=#URL.projectID#&pinpidDelete=#strPINPID#&view=property"><img src="images/button_delete.gif" width="44" height="16" border="0"></a></CFIF></td>
				</tr>
			</CFOUTPUT>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">Interest Acquired:</td>
		<td><SELECT NAME="interestType">
			<CFOUTPUT QUERY="qryInterestType">
				<OPTION VALUE=#intInterestSoldID#<CFIF #tempInterestType# EQ #intInterestSoldID#> SELECTED</CFIF>>#strInterestSold#</OPTION>
			</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right">Property Use:</td>
		<td><INPUT TYPE="text" NAME="propertyUse" SIZE=40 MAXLENGTH=50 VALUE="<CFOUTPUT>#tempPropertyUse#</CFOUTPUT>"></td>
	</tr>	
	<tr>
		<td align="right" valign="top">Brief Description:</td>
		<td colspan="5"><TEXTAREA NAME="propDescription" ROWS=2 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFOUTPUT>#tempPropDescription#</CFOUTPUT></TEXTAREA></td>
	</tr>
</table>
</FORM>
</DIV>

<!-- Layer for the Purchase Info tab -->
<DIV ID="tab3" class="tab">
<FORM NAME="PurchaseForm">
<table>
	<tr>
		<td><img src="images/transparent.gif" width="175" height="1"></td>
		<td></td>
	</tr>
	<tr>
		<td align="right">Acquired From:</td>
		<td><INPUT TYPE="text" NAME="acquiredFrom" SIZE=40 MAXLENGTH=50 VALUE="<CFOUTPUT>#tempAcquiredFrom#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Price:</td>
		<td><INPUT TYPE="text" NAME="price" SIZE=10 VALUE="<CFOUTPUT>#DollarFormat(tempPrice)#</CFOUTPUT>"></td>
	</tr>
	<tr>
		<td align="right">Offer Date:</td>
		<td><INPUT TYPE="text" NAME="offer" SIZE=10 VALUE="<CFOUTPUT>#DateFormat(tempOffer, "yyyy/m/d")#</CFOUTPUT>"> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?tab=tab3&form=PurchaseForm&field=offer','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
	<tr>
		<td align="right">Close Date:</td>
		<td><INPUT TYPE="text" NAME="close" SIZE=10 VALUE="<CFOUTPUT>#DateFormat(tempClose, "yyyy/m/d")#</CFOUTPUT>"> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?tab=tab3&form=PurchaseForm&field=close','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
</table>
<br>
<table border="0" cellpadding="4" cellspacing="0" width="600" align="center">
	<tr bgcolor="#FFFFFF">
		<td width="100">Appraisal Info:</td>
		<td width="110">&nbsp;</td>
		<td wdith="160">&nbsp;</td>
		<td wdith="140">&nbsp;</td>
		<td wdith="90">&nbsp;</td>
	</tr>
	<tr bgcolor="#0099CC">
		<td width="100"><font color="#ffffff">Date</font></td>
		<td width="110"><font color="#ffffff">Value</font></td>
		<td width="160"><font color="#ffffff">Appraiser Name</font></td>
		<td width="140"><font color="#ffffff">Appraisal Number</font></td>
		<td wdith="90" align="center"><CFIF Client.LoggedIn EQ "Yes"><CFOUTPUT><a href="##" onClick="sendForm('appraisalUpdate.cfm?type=acquisitions&projectID=#tempProjectID#&add=yes'); return false;"><img src="images/button_add_status.gif" width="61" height="16" border="0"></a></CFOUTPUT></CFIF></td>
	</tr>
<CFOUTPUT QUERY="qryAppraisal">
	<tr <CFIF (currentrow MOD 2) NEQ 1>bgcolor="##D9F0FF"</CFIF>>
		<td>#DateFormat(datApprDate, "mmm d, yyyy")#&nbsp;</td>
		<td>#DollarFormat(curApprAmount)#&nbsp;</td>
		<td>#strApprName#&nbsp;</td>
		<td>#strAppraisalNo#&nbsp;</td>
		<td align="right" valign="top"><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('appraisalUpdate.cfm?type=acquisitions&projectID=#tempProjectID#&appraisalID=#intApprID#'); return false;"><img src="images/button_edit.gif" width="40" height="16" border="0"></a>&nbsp;<a onClick="return confirm('Are you sure you want to permanently delete this Appraisal?');" href="acquisitions.cfm?projectID=#URL.projectID#&appraisalDelete=#intApprID#&view=purchase"><img src="images/button_delete.gif" width="44" height="16" border="0"></a></CFIF></td>
	</tr>
</CFOUTPUT>
</table>
<br><br>
</FORM>
</DIV>

<!-- Layer for the Status tab -->
<DIV ID="tab4" class="tab">
<br>
<table border="0" cellpadding="4" cellspacing="0" width="720" align="center">
	<tr bgcolor="#0099CC">
		<td width="80"><font color="#ffffff">Date</font></td>
		<td width="570"><font color="#ffffff">Status</font></td>
		<td wdith="70" align="center"><CFIF Client.LoggedIn EQ "Yes"><CFOUTPUT><a href="##" onClick="sendForm('statusUpdate.cfm?type=acquisitions&projectID=#tempProjectID#&add=yes'); return false;"><img src="images/button_add_status.gif" width="61" height="16" border="0"></a></CFOUTPUT></CFIF></td>
	</tr>
<CFOUTPUT QUERY="qryStatus">
	<tr <CFIF (currentrow MOD 2) NEQ 1>bgcolor="##D9F0FF"</CFIF>>
		<td valign="top">#DateFormat(datUpdate, "mmm d, yyyy")#</td>
		<td>#memStatus#</td>
		<td align="right" valign="top"><CFIF Client.LoggedIn EQ "Yes"><a href="##" onClick="sendForm('statusUpdate.cfm?type=acquisitions&projectID=#tempProjectID#&statusID=#intStatusID#'); return false;"><img src="images/button_edit.gif" width="40" height="16" border="0"></a>&nbsp;<a onClick="return confirm('Are you sure you want to permanently delete this Status Update');" href="acquisitions.cfm?projectID=#URL.projectID#&statusDelete=#intStatusID#&view=status"><img src="images/button_delete.gif" width="44" height="16" border="0"></a></CFIF></td>
	</tr>
</CFOUTPUT>
</table>
<br><br>
</DIV>
<img src="images/transparent.gif" width="1" height="120"><br>
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
</body>
</html>
