<!--- this page allows users to customize the data that will appear on the Summary
of Property Acquisition report (acquisitionSummaryPrint.cfm).  Initially, the data
is taken from the main project tables (tblAcquisitions and tblProjects). When they
click on Print Preview the data entered in the form will be saved to a separate
table, tblAcqSummary, so the next time they come to this page that is where the 
data will be taken from. --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Summary of Property Acquisition</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!--- this query retrieves the saved data from tblAcqSummary if there is any.  
If there isn't, bolSaved will be false and the page will display data from the 
main project tables (tblAcquisitions and tblProjects) --->
<CFQUERY NAME="qryDisplaySaved" DATASOURCE="#request.ds#">
	SELECT	bolSaved,
			strLocation,
			strDescription,
			strLegal,
			strRollNumber,
			strCustodian,
			strPropertyUse,
			strInterestAcquired,
			strAcquiredFrom,
			strPurchasePrice,
			strAppraisedValue,
			strAcquisitionDate,
			strAgent,
			strFileNo,
			memRemarks
	FROM	tblAcqSummary
	WHERE	intProjectID = #URL.projectID#
</CFQUERY>

<CFOUTPUT QUERY="qryDisplaySaved">
	<CFIF #bolSaved# EQ True>
		<!--- If bolSaved is true, then set saved to "yes" and nothing more needs to be done
		because we will use qryDisplaySaved to display the data. --->
		<CFSET saved="yes">
	<CFELSE>
		<!--- If bolSaved is false, then set saved to "no" and retrieve the default data which
		is the data from tblProjects and tblAcquisitions. --->
		<CFSET saved="no">
		<CFLOCK SCOPE="SESSION" TYPE="EXCLUSIVE" TIMEOUT="15">
			<CFSET tempAbbreviated = Session.backupAbbreviated>
			<CFSET tempLocation = Session.backupLocation>
			<CFSET tempDescription = Session.backupDescription>
			<CFSET tempLegal = Session.backupLegal>
			<CFSET tempRollNumber = Session.backupRollNumber>	
			<CFSET tempDeptName = Session.backupDeptName>		
			<CFSET tempPropertyUse = Session.backupPropertyUse>
			<CFSET tempInterestAcquired = Session.backupInterestAcquired>
			<CFSET tempAcquiredFrom = Session.backupAcquiredFrom>
			<CFSET tempPrice = Session.backupPrice>
			<CFSET tempClose = Session.backupClose>
			<CFSET tempFirstName = Session.backupFirstName>
			<CFSET tempLastName = Session.backupLastName>	
			<CFSET tempFileNo = Session.backupFileNo>		
					
		</CFLOCK>
			
		<!--- qryAppraisedValue selects the most recent appraised value for this project.
		To do this it selects data from a pre-defined query in Access --->
		<CFQUERY NAME="qryAppraisedValue" DATASOURCE="#request.ds#">
			SELECT		curApprAmount
			FROM		tblAppraisals
			WHERE		intProjectID = #URL.projectID#
			ORDER BY	datApprDate DESC
		</CFQUERY>
	</CFIF>
</CFOUTPUT>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<blockquote>
<table border="0" cellpadding="0" cellspacing="0" width="650">
<tr>
<td>
<p>This form shows the field values as they will be displayed on the Summary of Property Acquisition form.
Any changes you make to the values will not be saved in the main database but will be saved for future use
with the Acquisition Summary form only.</p>
<p>To print the form click on the "Print Preview" button below, which will take you to a formatted page.
Click on "Print..." under the File menu of the web browser to print the page.<p>
<p><b>Note:</b> If you do not want the page numbers, date, and URL to show up on the printed page, click on
"Page Setup..." under the File menu.  If using Netscape, un-check all the boxes under "Header" and "Footer", and click OK. 
If using Internet Explorer, remove all the values in the "Header" and "Footer" text boxes and click OK
(this will be permanent for IE).</p>
</td>
</tr>
</table>
</blockquote>

<CFIF #saved# EQ "no">
	<!--- the acquisition summary data has not been saved before so display the data from qryDisplayDefault --->
	<FORM NAME="form1" ACTION="acquisitionSummaryPrint.cfm" METHOD="POST">
	<CFOUTPUT>
	<INPUT TYPE="hidden" NAME="projectID" VALUE="#URL.projectID#">
	<table border="0" width="715" cellpadding="4" cellspacing="0">
		<tr>
			<td width="130"><img src="images/transparent.gif" width="130" height="1"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="150">Property Location:</td>
			<td width="565"><INPUT TYPE="text" NAME="location" SIZE="48" VALUE="#tempLocation#, #tempAbbreviated#"></td>
		</tr>
		<tr>
			<td>Description:</td>
			<td><INPUT TYPE="text" NAME="description" SIZE="48" VALUE="#tempDescription#"></td>
		</tr>
		<tr>
			<td>Legal:</td>
			<td><INPUT TYPE="text" NAME="legal" SIZE="48" VALUE="#tempLegal#"></td>
		</tr>
		<tr>
			<td>BC Assessment Roll ##:</td>
			<td><INPUT TYPE="text" NAME="rollNumber" SIZE="48" VALUE="#tempRollNumber#"></td>
		</tr>
		<tr>
			<td>Custodian:</td>
			<td><INPUT TYPE="text" NAME="custodian" SIZE="48" VALUE="#tempDeptName#"></td>
		
		</tr>
		<tr>
			<td>Use of Property:</td>
			<td><INPUT TYPE="text" NAME="propertyUse" SIZE="48" VALUE="#tempPropertyUse#"></td>
		</tr>
		<tr>
			<td>Interest Acquired:</td>
			<td><INPUT TYPE="text" NAME="interestAcquired" SIZE="48" VALUE="#tempInterestAcquired#"></td>
		</tr>
		<tr>
			<td>Acquired From:</td>
			<td><INPUT TYPE="text" NAME="acquiredFrom" SIZE="48" VALUE="#tempAcquiredFrom#"></td>
		</tr>
		<tr>
			<td>Purchase Price:</td>
			<td><INPUT TYPE="text" NAME="purchasePrice" SIZE="48" VALUE="#DollarFormat(tempPrice)#"></td>
		</tr>
	</CFOUTPUT>
		<tr>
			<td>Appraised Value:</td>
			<td><INPUT TYPE="text" NAME="appraisedValue" SIZE="48" VALUE="<CFOUTPUT QUERY="qryAppraisedValue" MAXROWS="1">#DollarFormat(curApprAmount)#</CFOUTPUT>"></td>
		</tr>
	<CFOUTPUT>
		<tr>
			<td>Date of Acquisition:</td>
			<td><INPUT TYPE="text" NAME="completionDate" SIZE="48" VALUE="#DateFormat(tempClose, "mmmm d, yyyy")#"></td>
		</tr>
		<tr>
			<td>Real Estate Advisors:</td><!---[ap:locator:051107:u4]--->
			<td><INPUT TYPE="text" NAME="agent" SIZE="48" VALUE="#tempFirstName# #tempLastName#"></td>
		</tr>
		<tr>
			<td>File No:</td>
			<td><INPUT TYPE="text" NAME="fileNo" SIZE="48" VALUE="#tempFileNo#"></td>
		</tr>
	</CFOUTPUT>
		<tr>
			<td valign="top">Remarks:</td>
			<td><TEXTAREA NAME="remarks" ROWS="4" COLS="49" WRAP="VIRTUAL"></TEXTAREA></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><br><a href="nowhere.cfm" onClick="document.form1.submit(); return false"><img src="images/button_print_preview.gif" width="90" hight="25" border="0"></a>
			&nbsp;<a href="acquisitions.cfm?projectID=<CFOUTPUT>#URL.projectID#</CFOUTPUT>"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
		</tr>
	</table>
	<br>
	</FORM>
<CFELSE>
	<!--- the acquisition summary data has already been saved so display the data from qryDisplaySaved --->
	<FORM NAME="form1" ACTION="acquisitionSummaryPrint.cfm" METHOD="POST">
	<CFOUTPUT QUERY="qryDisplaySaved">
	<INPUT TYPE="hidden" NAME="projectID" VALUE="#URL.projectID#">
	<table border="0" width="715" cellpadding="4" cellspacing="0">
		<tr>
			<td width="130"><img src="images/transparent.gif" width="130" height="1"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="150">Location:</td>
			<td width="565"><INPUT TYPE="text" NAME="location" SIZE="48" VALUE="#strLocation#"></td>
		</tr>
		<tr>
			<td>Description:</td>
			<td><INPUT TYPE="text" NAME="description" SIZE="48" VALUE="#strDescription#"></td>
		</tr>
		<tr>
			<td>Legal:</td>
			<td><INPUT TYPE="text" NAME="legal" SIZE="48" VALUE="#strLegal#"></td>
		</tr>
		<tr>
			<td>BC Assessment Roll ##:</td>
			<td><INPUT TYPE="text" NAME="rollNumber" SIZE="48" VALUE="#strRollNumber#"></td>
		</tr>
		<tr>
			<td>Custodian:</td>
			<td><INPUT TYPE="text" NAME="custodian" SIZE="48" VALUE="#strCustodian#"></td>
		
		</tr>
		<tr>
			<td>Use of Property:</td>
			<td><INPUT TYPE="text" NAME="propertyUse" SIZE="48" VALUE="#strPropertyUse#"></td>
		</tr>
		<tr>
			<td>Interest Acquired:</td>
			<td><INPUT TYPE="text" NAME="interestAcquired" SIZE="48" VALUE="#strInterestAcquired#"></td>
		</tr>
		<tr>
			<td>Acquired From:</td>
			<td><INPUT TYPE="text" NAME="acquiredFrom" SIZE="48" VALUE="#strAcquiredFrom#"></td>
		</tr>
		<tr>
			<td>Purchase Price:</td>
			<td><INPUT TYPE="text" NAME="purchasePrice" SIZE="48" VALUE="#strPurchasePrice#"></td>
		</tr>
		<tr>
			<td>Appraised Value:</td>
			<td><INPUT TYPE="text" NAME="appraisedValue" SIZE="48" VALUE="#strAppraisedValue#"></td>
		</tr>
		<tr>
			<td>Date of Acquisition:</td>
			<td><INPUT TYPE="text" NAME="completionDate" SIZE="48" VALUE="#strAcquisitionDate#"></td>
		</tr>
		<tr>
			<td>Real Estate Advisors:</td><!---[ap:locator:051107:u4]--->
			<td><INPUT TYPE="text" NAME="agent" SIZE="48" VALUE="#strAgent#"></td>
		</tr>
		<tr>
			<td>File No:</td>
			<td><INPUT TYPE="text" NAME="fileNo" SIZE="48" VALUE="#strFileNo#"></td>
		</tr>
		<tr>
			<td valign="top">Remarks:</td>
			<td><TEXTAREA NAME="remarks" ROWS="4" COLS="49" WRAP="VIRTUAL">#memRemarks#</TEXTAREA></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><br><a href="nowhere.cfm" onClick="document.form1.submit(); return false"><img src="images/button_print_preview.gif" width="90" hight="25" border="0"></a>
			&nbsp;<a href="acquisitions.cfm?projectID=#URL.projectID#"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
		</tr>
	</table>
	<br>
	</CFOUTPUT>
	</FORM>
</CFIF>
</body>
</html>
