<!---
projectList.cfm displays all the projects that meet the criteria entered in projectSearch.cfm. 
The form data from projectSearch.cfm is saved into client variables so that if projectList.cfm 
is requested by a page other than projectSearch.cfm, it can still generate the same search query. 
projectList.cfm generates a link for each project consisting of the appropriate project page 
(either acquisitions.cfm, disposals.cfm or consulting.cfm) followed by the "projectID" 
querystring parameter. 

The user can sort the projects by clicking on the column headings. When 
this happens, projectList.cfm sends a form to itself with Form.sort containing the field to be 
sorted by. 

When a user opens a project, the project data is saved in backup session variables.  
If a user clicks on "Cancel" on one of the project pages, projectList.cfm performs 
queries to restore the projects data to that which was saved in these session variables
in order to undo any changes. 
--->

<!--- If the user has clicked cancel but the session variables have timed out,
we cannot restore the project and the user is sent to projectSearch.cfm --->
<CFIF IsDefined("URL.cancelType") AND NOT IsDefined("Session.backupProjectID")>
	<CFLOCATION URL="projectSearch.cfm">
</CFIF>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Search Results</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<CFIF IsDefined("URL.saveType") AND URL.saveType EQ "disposal">
<!--- User clicked cancel on a disposal project --->

	<!--- set temp variables equal to the session variables in order to 
	maintain locking practices --->
	<CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="15">
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
		<CFSET tempExpToDate = Session.backupExpToDate>
		<CFSET tempPrice = Session.backupPrice>
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
		<CFSET tempPILT = Session.backupPILT>	
		
		<!--- added this --->
		<CFSET tempAssessmentYear = Session.backupAssessmentYear>
		<CFSET tempLawyer = Session.backupLawyer>
		<CFSET tempPILTyear = Session.backupPILTyear>
		<CFSET tempRemarks = Session.backupRemarks>
			
	</CFLOCK>

	<!--- Query to update tblProjects with backup values --->
	<CFQUERY NAME="qryUpdateProject" DATASOURCE="#request.ds#">
		UPDATE	tblProjects
		SET		intProvID = #tempProvID#,
			<CFIF #tempProjectNo# NEQ "">
				intProjectNo = #tempProjectNo#,
			<CFELSE>
				intProjectNo = Null,
			</CFIF>
				intLocationID = #tempLocationID#,
				strDescription = '#tempDescription#',
				strLegal = '#tempLegal#',
				intClientDept = #tempClientDept#,
				intSecondDept = #tempSecondDept#,
				intClientContactID = #tempClientContact#,
				intAgent = #tempAgent#,
				strFileNo = '#tempFileNo#',
				curSSAFees = #tempSSAFees#,
				curSSADisbursements = #tempSSADisbursements#,
				curExpToDate = #tempExpToDate#,
				curPrice = #tempPrice#,
				
			<CFIF #tempStartDate# NEQ "">
				datStartDate = ###tempStartDate###,
			<CFELSE>
				datStartDate = Null,
			</CFIF>
			<CFIF #tempComplDate# NEQ "">
				datComplDate = ###tempComplDate###,
			<CFELSE>
				datComplDate = Null,
			</CFIF>
				bolCancelled = #tempCancelled#
		WHERE 	intProjectID = #tempProjectID#
	</CFQUERY>

	<!--- Query to update tblDisposals with backup values --->
	<CFQUERY NAME="qryUpdateDisposal" DATASOURCE="#request.ds#">
		UPDATE	tblDisposals
		SET		strRollNumber = '#tempRollNumber#',
				strProjRefNo = '#tempProjRefNo#',
				strLDU = '#tempLDU#',
				strPACNo = '#tempPACNo#',
				strSMANo = '#tempSMANo#',
				intDisposalMethod = #tempDisposalMethod#,
				intInterestSoldID = #tempInterestSold#,
				intPropertyTypeID = #tempPropertyTypeID#,
				intPurchaserTypeID = #tempPurchaserTypeID#,
				
				<!--- added this --->
				strLawyer = '#tempLawyer#',
				
			<CFIF #tempReportOfSurplus# NEQ "">
				datReportOfSurplus = ###tempReportOfSurplus###
			<CFELSE>
				datReportOfSurplus = Null
			</CFIF>
		WHERE 	intProjectID = #tempProjectID#
	</CFQUERY>

	<!--- Query to update tblFactSheet with backup values --->
	<CFQUERY NAME="qryUpdateFactSheet" DATASOURCE="#request.ds#">
		UPDATE	tblFactSheet
		SET		strGeneralDesc = '#tempGeneralDesc#',
				strAvailable = '#tempAvailable#',
				strUrbanCentre = '#tempUrbanCentre#',
				strAddress = '#tempAddress#',

				<!--- added this --->
				strRemarks = '#tempRemarks#',
				
			<CFIF #tempParcelSize# NEQ "">
				sngParcelSize = #tempParcelSize#,
			<CFELSE>
				sngParcelSize = Null,
			</CFIF>
				strTopography = '#tempTopography#',
				strAccess = '#tempAccess#',
				strBuildingDesc = '#tempBuildingDesc#',
				strZoning = '#tempZoning#',
				strServices = '#tempServices#',
				strLandUse = '#tempLandUse#',
			<CFIF #tempAge# NEQ "">
				intAge = #tempAge#,
			<CFELSE>
				intAge = Null,
			</CFIF>
				strCondition = '#tempCondition#',
				strEnvironIssues = '#tempEnvironIssues#',
				strTenure = '#tempTenure#',
				strRestrictions = '#tempRestrictions#',
				strAcquiDate = '#tempAcquiDate#',
				strPurchasedFrom = '#tempPurchasedFrom#',
				curAmountPaid = #tempAmountPaid#,
				strHistory = '#tempHistory#',
				strKnownInterests = '#tempKnownInterests#',
				curLandAsses = #tempLandAsses#,
				curBuildingAsses = #tempBuildingAsses#,
			<CFIF #tempAssessmentYear# NEQ "">
				intAssessmentYear = #tempAssessmentYear#,
			<CFELSE>
				intAssessmentYear = Null,
			</CFIF>
			
			<!--- added this --->
			<CFIF #tempPILTyear# NEQ "">
				intPILTyear = #tempPILTyear#,
			<CFELSE>
				intPILTyear = Null,
			</CFIF>
				curPILT = #tempPILT#
		WHERE 	intProjectID = #tempProjectID#
	</CFQUERY>
	
<CFELSEIF IsDefined("URL.saveType") AND URL.saveType EQ "acquisition">
<!--- User clicked cancel on an acquisition project --->

	<!--- set temp variables equal to the session variables in order to 
	maintain locking practices --->
	<CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="15">
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
		<CFSET tempExpToDate = Session.backupExpToDate>
		<CFSET tempOffer = Session.backupOffer>
		<CFSET tempPrice = Session.backupPrice>
		<CFSET tempClose = Session.backupClose>
		<CFSET tempRollNumber = Session.backupRollNumber>
		<CFSET tempInterestType = Session.backupInterestType>
		<CFSET tempAcquiredFrom = Session.backupAcquiredFrom>
		<CFSET tempPropertyUse = Session.backupPropertyUse>
		<CFSET tempCancelled = Session.backupCancelled>
		<CFSET tempPropDescription = Session.backupPropDescription>
		
		<!--- added this --->
		<CFSET tempLawyer = Session.backupLawyer>
		
	</CFLOCK>

	<!--- Query to update tblProjects with backup values --->
	<CFQUERY NAME="qryUpdateProject" DATASOURCE="#request.ds#">
		UPDATE	tblProjects
		SET		intProvID = #tempProvID#,
			<CFIF #tempProjectNo# NEQ "">
				intProjectNo = #tempProjectNo#,
			<CFELSE>
				intProjectNo = Null,
			</CFIF>
				intLocationID = #tempLocationID#,
				strDescription = '#tempDescription#',
				strLegal = '#tempLegal#',
				intClientDept = #tempClientDept#,
				intSecondDept = #tempSecondDept#,
				intClientContactID = #tempClientContact#,
				intAgent = #tempAgent#,
				strFileNo = '#tempFileNo#',
				curSSAFees = #tempSSAFees#,
				curSSADisbursements = #tempSSADisbursements#,
				curPrice = #tempPrice#,
				curExpToDate = #tempExpToDate#,
			<CFIF #tempStartDate# NEQ "">
				datStartDate = ###tempStartDate###,
			<CFELSE>
				datStartDate = Null,
			</CFIF>
			<CFIF #tempComplDate# NEQ "">
				datComplDate = ###tempComplDate###,
			<CFELSE>
				datComplDate = Null,
			</CFIF>
				bolCancelled = #tempCancelled#
		WHERE 	intProjectID = #tempProjectID#
	</CFQUERY>

	
	<!--- Query to update tblAcquisitions with backup values --->
	<CFQUERY NAME="qryUpdateAcquisition" DATASOURCE="#request.ds#">
		UPDATE 	tblAcquisitions
		SET		intInterestType = #tempInterestType#,
			
			<CFIF #tempOffer# NEQ "">
				datOffer = ###tempOffer###,
			<CFELSE>
				datOffer = Null,
			</CFIF>
			<CFIF #tempClose# NEQ "">
				datClose = ###tempClose###,
			<CFELSE>
				datClose = Null,
			</CFIF>
				strRollNumber = '#tempRollNumber#',
				strAcquiredFrom = '#tempAcquiredFrom#',
				strPropertyUse = '#tempPropertyUse#',
				memPropDescription = '#tempPropDescription#',
				
				<!--- added this --->
				strLawyer = '#tempLawyer#'
				
		WHERE 	intProjectID = #tempProjectID#
	</CFQUERY>

<CFELSEIF IsDefined("URL.saveType") AND URL.saveType EQ "consulting">
<!--- User clicked cancel on a consulting project --->

	<!--- set temp variables equal to the session variables in order to 
	maintain locking practices --->
	<CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="15">
		<CFSET tempProjectID = Session.backupProjectID>
		<CFSET tempProjectNo = Session.backupProjectNo>
		<CFSET tempProvID = Session.backupProvID>
		<CFSET tempLocationID = Session.backupLocationID>
		<CFSET tempDescription = Session.backupDescription>
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
		<CFSET tempExpToDate = Session.backupExpToDate>
	</CFLOCK>

	<!--- Query to update tblProjects with backup values --->
	<CFQUERY NAME="qryUpdateProject" DATASOURCE="#request.ds#">
		UPDATE	tblProjects
		SET		intProvID = #tempProvID#,
			<CFIF #tempProjectNo# NEQ "">
				intProjectNo = #tempProjectNo#,
			<CFELSE>
				intProjectNo = Null,
			</CFIF>
				intLocationID = #tempLocationID#,
				strDescription = '#tempDescription#',
				intClientDept = #tempClientDept#,
				intSecondDept = #tempSecondDept#,
				intClientContactID = #tempClientContact#,
				intAgent = #tempAgent#,
				strFileNo = '#tempFileNo#',
				curSSAFees = #tempSSAFees#,
				curSSADisbursements = #tempSSADisbursements#,
				curExpToDate = #tempExpToDate#,
			<CFIF #tempStartDate# NEQ "">
				datStartDate = ###tempStartDate###,
			<CFELSE>
				datStartDate = Null,
			</CFIF>
			<CFIF #tempComplDate# NEQ "">
				datComplDate = ###tempComplDate###,
			<CFELSE>
				datComplDate = Null,
			</CFIF>
				bolCancelled = #tempCancelled#
		WHERE 	intProjectID = #tempProjectID#
	</CFQUERY>

</CFIF>

<CFIF IsDefined("Form.status")>
<!--- then user is performing a new search --->

	<!--- set client variables equal to the search parameters
	so that the search can be duplicated at a later time or
	on a different page --->
	<CFSET Client.status = Form.status>
	<CFSET Client.projectType = Form.projectType>
	<CFSET Client.location = Form.location>
	<!---[ap:locator:051107:u1]--->
	<CFSET Client.province = Form.province>
	<!---[ap:locator:051107:u2]--->
	<!---CFSET Client.description = Form.description--->
	<CFSET Client.agent = Form.agent>
	<CFSET Client.department = Form.department>
	<CFSET Client.projectNo = Form.projectNo>
	<CFSET Client.fileNo = Form.fileNo>
	<CFSET Client.clientContact = Form.clientContact>
</CFIF>

<CFIF IsDefined("Form.sort")>
<!--- then user has clicked on a column heading to sort the search results --->

	<!--- projects are sorted by Client.sort and then Client.lastSort
	so we set Client.last sort equal to Client.sort and then Client.sort
	to the new sort chosen by the user --->
	<CFSET Client.lastSort = Client.sort>
	<CFSET Client.sort = Form.sort>
</CFIF>

<CFIF NOT IsDefined("Client.status")>
<!--- then something is wrong (perhaps they entered a url in the address bar to take
them directly here, without performing a search) so they must perform a new search. --->
	<CFLOCATION URL="projectSearch.cfm">
</CFIF>

<!--- Query to find all the projects that meet the search criteria --->
<CFQUERY NAME="qryProjects" DATASOURCE="#request.ds#">
	SELECT	tblProjects.intProjectID,
			tblProjectType.strProjType,
			tblProjectType.intProjTypeID,
			tblLocation.strLocation,
			tblProjects.strDescription,
			tblAgent.strFirstName,
			tblAgent.strLastName,
			tblDept.strDeptAbrev,
			
			
			<!--- added this 
			tblAcquisitions.strLawyer, --->
			
			tblProjects.intSecondDept
			
	FROM	tblProjects,
			tblProjectType,
			tblLocation,
			tblAgent,
			tblDept,
			tblClientContact
	WHERE	tblProjects.intProjectType = tblProjectType.intProjTypeID
	AND		tblProjects.intLocationID = tblLocation.intLocationID
	AND		tblProjects.intAgent = tblAgent.intAgentID
	AND		tblProjects.intClientDept = tblDept.intDeptID
	AND		tblProjects.intClientContactID = tblClientContact.intClientContactID
<CFIF #Client.status# EQ "active">
	AND		((tblProjects.datComplDate IS NULL OR tblProjects.datComplDate > #Now()#) AND tblProjects.bolCancelled = 0)
<CFELSEIF #Client.status# EQ "complete">
	AND		(tblProjects.datComplDate < #Now()# OR tblProjects.bolCancelled = 1)
</CFIF>
<CFIF #Client.projectType# EQ "acquisition">
	AND		tblProjectType.intProjTypeID = 1
<CFELSEIF #Client.projectType# EQ "disposal">
	AND		tblProjectType.intProjTypeID = 2
<CFELSEIF #Client.projectType# EQ "consulting">
	AND		tblProjectType.intProjTypeID = 3
</CFIF>
<!---[ap:locator:051107:u1]--->
<CFIF #Client.province# NEQ "all">
	AND		tblProjects.intProvID = #Client.province#
</CFIF>
<!---[ap:locator:051107:u2]--->
<CFIF #Client.location# IS NOT 0>
	AND		tblLocation.intLocationID = #Client.location#
</CFIF>
<!---CFIF #Client.location# IS NOT 0 AND #Client.description# IS "">
	AND		tblLocation.intLocationID = #Client.location#
<CFELSEIF #Client.location# IS NOT 0 AND #Client.description# IS NOT "">
	AND		(tblLocation.intLocationID = #Client.location#
	OR		tblProjects.strDescription LIKE '%#Client.description#%')
<CFELSEIF #Client.location# IS 0 AND #Client.description# IS NOT "">
	AND		tblProjects.strDescription LIKE '%#Client.description#%'
</CFIF--->
<CFIF #Client.agent# IS NOT 0>
	AND		tblAgent.intAgentID = #Client.agent#
</CFIF>
<CFIF #Client.department# IS NOT 0>
	AND		(tblProjects.intClientDept = #Client.department# OR tblProjects.intSecondDept = #Client.department#)
</CFIF>
<CFIF #Client.projectNo# IS NOT "">
	AND		tblProjects.intProjectNo = #Client.projectNo#
</CFIF>
<CFIF #Client.fileNo# IS NOT "">
	AND		tblProjects.strFileNo = '#Client.fileNo#'
</CFIF>
<CFIF #Client.clientContact# IS NOT 0>
	AND		tblProjects.intClientContactID = #Client.clientContact#
</CFIF>
<!--- If Client.sort and Client.lastSort are valid then sort by them,
otherwise set them to default values and then sort by them. --->
<CFIF (#Client.sort# EQ "tblProjectType.strProjType"
	OR #Client.sort# EQ "tblLocation.strLocation"
	OR #Client.sort# EQ "tblProjects.strDescription"
	OR #Client.sort# EQ "tblAgent.strFirstName, tblAgent.strLastName"
	OR #Client.sort# EQ "tblDept.strDeptAbrev")
	AND (#Client.lastSort# EQ "tblProjectType.strProjType"
	OR #Client.lastSort# EQ "tblLocation.strLocation"
	OR #Client.lastSort# EQ "tblProjects.strDescription"
	OR #Client.lastSort# EQ "tblAgent.strFirstName, tblAgent.strLastName"
	OR #Client.lastSort# EQ "tblDept.strDeptAbrev")>
	ORDER BY	#Client.sort#, #Client.lastSort#
<CFELSE>
	<CFSET Client.sort="tblProjectType.strProjType">
	<CFSET Client.sort="tblLocation.strLocation">
	ORDER BY	#Client.sort#, #Client.lastSort#
</CFIF>
</CFQUERY>


<SCRIPT LANGUAGE="JavaScript">
<!--
function submitSort(sortParam) {
// This function is called when a user clicks on a column heading.
// It submits sortForm with the sort field set to sortParam
	document.sortForm.sort.value = sortParam;
	document.sortForm.submit();
}
//-->
</SCRIPT>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript functions and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<!--- this form is the form that is sent when a user clicks on the column
headings. The sort field is set using javascript. --->
<FORM ACTION="projectList.cfm" METHOD="POST" NAME="sortForm">
<CFOUTPUT>
<INPUT TYPE="hidden" NAME="sort">
</CFOUTPUT>	
</FORM>

<!--- display the search parameters --->
<p>
<CFOUTPUT><b>&nbsp;#qryProjects.RecordCount# projects matched your search criteria:</b><br><br></CFOUTPUT>
<!---[ap:locator:051107:u1]--->
<CFIF #Client.Location# IS NOT 0 OR #Client.agent# IS NOT 0 OR #Client.department# IS NOT 0 OR #Client.projectType# IS NOT "all" OR #Client.clientContact# IS NOT 0 OR #Client.province# NEQ "all">
	<b>&nbsp;Search Criteria:</b><br>
	<CFIF #Client.status# EQ "active">
		<b><font color="#006699">&nbsp;&nbsp;Status</font></b>: Active<br>
	<CFELSEIF #Client.status# EQ "complete">
		<b><font color="#006699">&nbsp;&nbsp;Status</font></b>: Complete<br>
	</CFIF>
	<CFIF #Client.projectType# EQ "acquisition">
		<b><font color="#006699">&nbsp;&nbsp;Type</font></b>: Acquisition<br>
	<CFELSEIF #Client.projectType# EQ "disposal">
		<b><font color="#006699">&nbsp;&nbsp;Type</font></b>: Disposal<br>
	<CFELSEIF #Client.projectType# EQ "consulting">
		<b><font color="#006699">&nbsp;&nbsp;Type</font></b>: Consulting<br>
	</CFIF>
	<!---[ap:locator:051107:u1]--->
	<CFIF #Client.province# NEQ "all">
		<CFQUERY NAME="qryProvinceName" DATASOURCE="#request.ds#">
			SELECT strProvNm FROM tblProvince WHERE intProvID = #Client.province#
		</CFQUERY>
		<CFOUTPUT QUERY="qryProvinceName">
			<b><font color="##006699">&nbsp;&nbsp;Province/Territory</font></b>: #strProvNm#<br>
		</CFOUTPUT>
	</CFIF>
	<CFIF #Client.location# IS NOT 0>
		<CFQUERY NAME="qryLocationName" DATASOURCE="#request.ds#">
			SELECT strLocation FROM tblLocation WHERE intLocationID = #Client.location#
		</CFQUERY>
		<CFOUTPUT QUERY="qryLocationName">
			<b><font color="##006699">&nbsp;&nbsp;Location</font></b>: #strLocation#<br>
		</CFOUTPUT>
	</CFIF>
	<CFIF #Client.agent# IS NOT 0>
		<CFQUERY NAME="qryAgentName" DATASOURCE="#request.ds#">
			SELECT strFirstName, strLastName FROM tblAgent WHERE intAgentID = #Client.agent#
		</CFQUERY>
		<CFOUTPUT QUERY="qryAgentName">
			<b><font color="##006699">&nbsp;&nbsp;Advisor</font></b>: #strFirstName# #strLastName#<br>
		</CFOUTPUT>
	</CFIF>
	<CFIF #Client.department# IS NOT 0>
		<CFQUERY NAME="qryDeptName" DATASOURCE="#request.ds#">
			SELECT strDeptName FROM tblDept WHERE intDeptID = #Client.department#
		</CFQUERY>
		<CFOUTPUT QUERY="qryDeptName">
			<b><font color="##006699">&nbsp;&nbsp;Client</font></b>: #strDeptName#<br>
		</CFOUTPUT>
	</CFIF>
	<CFIF #Client.clientContact# IS NOT 0>
		<CFQUERY NAME="qryContactName" DATASOURCE="#request.ds#">
			SELECT strFirstName, strLastName FROM tblClientContact WHERE intClientContactID = #Client.clientContact#
		</CFQUERY>
		<CFOUTPUT QUERY="qryContactName">
			<b><font color="##006699">&nbsp;&nbsp;Client Contact</font></b>: #strFirstName# #strLastName#<br>
		</CFOUTPUT>
	</CFIF>
</p>
</CFIF>

<!--- table for project results --->
<table border="0" cellpadding="4" cellspacing="0" width="757">
<CFOUTPUT>
	<!--- column headings: each link calls submitSort() and supplies the field to be sorted by --->
	<tr bgcolor="0099cc"> 
    	<td width="85"><a href="##" onClick="submitSort('tblProjectType.strProjType'); return false;"><img src="images/column_projectType.gif" border="0" width="69" height="16"><CFIF (IsDefined("Client.sort") AND #Client.sort# EQ "tblProjectType.strProjType") OR NOT IsDefined("Client.sort")><img src="images/column_sort_on.gif" border="0" width="16" height="16"><CFELSE><img src="images/column_sort_off.gif" border="0" width="16" height="16"></CFIF></a></td>
		<td width="115"><a href="##" onClick="submitSort('tblLocation.strLocation'); return false;"><img src="images/column_location.gif" border="0" width="48" height="16"><CFIF IsDefined("Client.sort") AND #Client.sort# EQ "tblLocation.strLocation"><img src="images/column_sort_on.gif" border="0" width="16" height="16"><CFELSE><img src="images/column_sort_off.gif" border="0" width="16" height="16"></CFIF></a></td>
		<td width="319"><a href="##" onClick="submitSort('tblProjects.strDescription'); return false;"><img src="images/column_description.gif" border="0" width="62" height="16"><CFIF IsDefined("Client.sort") AND #Client.sort# EQ "tblProjects.strDescription"><img src="images/column_sort_on.gif" border="0" width="16" height="16"><CFELSE><img src="images/column_sort_off.gif" border="0" width="16" height="16"></CFIF></a></td>
		<td width="120"><a href="##" onClick="submitSort('tblAgent.strFirstName, tblAgent.strLastName'); return false;"><img src="images/column_advisor.gif" border="0" width="44" height="16"><CFIF IsDefined("Client.sort") AND #Client.sort# EQ "tblAgent.strFirstName, tblAgent.strLastName"><img src="images/column_sort_on.gif" border="0" width="16" height="16"><CFELSE><img src="images/column_sort_off.gif" border="0" width="16" height="16"></CFIF></a></td>
		<td width="58"><a href="##" onClick="submitSort('tblDept.strDeptAbrev'); return false;"><img src="images/column_client.gif" border="0" width="33" height="16"><CFIF IsDefined("Client.sort") AND #Client.sort# EQ "tblDept.strDeptAbrev"><img src="images/column_sort_on.gif" border="0" width="16" height="16"><CFELSE><img src="images/column_sort_off.gif" border="0" width="16" height="16"></CFIF></a><img src="images/transparent.gif" width="17" height="1" border="0"></td>
    	<td width="60">&nbsp;</td>
	</tr>
</CFOUTPUT>
<!--- loop through each project found --->
<CFLOOP QUERY="qryProjects"> 

	<!--- Determine the project type and set pageType to the appropriate value. 
	This variable is used to make the links to the project pages. --->
    <CFIF #qryProjects.intProjTypeID# EQ 1>
    	<CFSET pageType = "acquisitions.cfm">
    <CFELSEIF #qryProjects.intProjTypeID# EQ 2>
    	<CFSET pageType = "disposals.cfm">
    <CFELSE>
    	<CFSET pageType = "consulting.cfm">
    </CFIF>
	
	<!--- Get the name of the second department if it exists. --->
	<CFIF #qryProjects.intSecondDept# NEQ 0>
		<CFQUERY NAME="qrySecondDept" DATASOURCE="#request.ds#">
			SELECT	strDeptAbrev
			FROM	tblDept
			WHERE	intDeptID = #qryProjects.intSecondDept#
		</CFQUERY>
	</CFIF>
	<CFOUTPUT>
	
	<!--- display the project data (including the second department if it exists) --->
    <tr <CFIF (currentrow MOD 2) NEQ 1>bgcolor="##D9F0FF"</CFIF>> 
      <td valign="top">#qryProjects.strProjType#</td>
      <td valign="top">#qryProjects.strLocation#</td>
      <td valign="top">#qryProjects.strDescription#<CFIF #qryProjects.strDescription# EQ "">&nbsp;</CFIF></td>
      <td valign="top">#qryProjects.strFirstName# #strLastName#</td>
      <td valign="top">#qryProjects.strDeptAbrev#<CFIF #qryProjects.intSecondDept# NEQ 0><BR>#qrySecondDept.strDeptAbrev#</CFIF></td>
      <td valign="top"><a href="#pageType#?projectID=#qryProjects.intProjectID#&backup=yes"><img src="images/button_details.gif" border="0" width="59" height="19"></a></td>
    </tr>
	</CFOUTPUT>
</CFLOOP> 
</table>
<br><br>



</body>
</html>
