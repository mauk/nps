<!--- this page retrieves many of the fields associated with disposal projects. --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data --->
<CFQUERY NAME="qryDisposals" DATASOURCE="#request.ds#">
	SELECT		tblProjects.intProjectID,
				tblProjects.intProjectNo,
				tblProjects.strDescription,
				tblProjects.strLegal,
				tblProjects.strFileNo,
				tblProjects.datStartDate,
				tblProjects.datComplDate,
				tblProjects.bolCancelled,
				tblProjects.curSSAFees,
				tblProjects.curSSADisbursements,
				tblProjects.curPrice,
				tblProjects.curExpToDate,
				tblDisposals.strRollNumber,
				tblDisposals.strProjRefNo,
				tblDisposals.strLDU,
				tblDisposals.strPACNo,
				tblDisposals.strSMANo,
				tblDisposals.datReportOfSurplus,
				tblAgent.strFirstName AS strAgentFirstName,
				tblAgent.strLastName AS strAgentLastName,
				tblLocation.strLocation,
				tblProvince.strAbbreviated AS strProvAbrev,
				tblDept.strDeptAbrev,
				tblClientContact.strFirstName AS strClientContactFirst,
				tblClientContact.strLastName AS strClientContactLast,
				tblDisposalMethod.strDisposalMethod,
				tblPropertyType.strPropertyType,
				tblPurchaserType.strPurchaserType,
				tblInterestSold.strInterestSold
	FROM		tblProjects,
				tblDisposals,
				tblAgent,
				tblLocation,
				tblProvince,
				tblDept,
				tblClientContact,
				tblDisposalMethod,
				tblPropertyType,
				tblPurchaserType,
				tblInterestSold
	WHERE		tblProjects.intProjectID = tblDisposals.intProjectID
	AND			tblProjects.intAgent = tblAgent.intAgentID
	AND			tblProjects.intLocationID = tblLocation.intLocationID
	AND			tblProjects.intProvID = tblProvince.intProvID
	AND			tblProjects.intClientDept = tblDept.intDeptID
	AND			tblProjects.intClientContactID = tblClientContact.intClientContactID
	AND			tblDisposals.intDisposalMethod = tblDisposalMethod.intDisposalMethodID
	AND			tblDisposals.intPropertyTypeID = tblPropertyType.intPropertyTypeID
	AND			tblDisposals.intPurchaserTypeID = tblPurchaserType.intPurchaserTypeID
	AND			tblDisposals.intInterestSoldID = tblInterestSold.intInterestSoldID
	AND			tblProjects.intProjectType = 2
	ORDER BY	tblProjects.intProjectID	
				
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#asciiDisposals.txt"
	OUTPUT="""intProjectID"",""intProjectNo"",""strDescription"",""strLegal"",""strFileNo"",""datStartDate"",""datComplDate"",""bolCancelled"",""curSSAFees"",""curSSADisbursements"",""curPrice"",""curExpToDate"",""strAgentFirstName"",""strAgentLastName"",""strLocation"",""strProvAbrev"",""strDeptAbrev"",""strClientContactFirst"",""strClientContactLast"",""strRollNumber"",""strProjRefNo"",""strLDU"",""strPACNo"",""strSMANo"",""datReportOfSurplus"",""strDisposalMethod"",""strPropertyType"",""strPurchaserType"",""strInterestSold""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryDisposals">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#asciiDisposals.txt"
	OUTPUT="#qryDisposals.intProjectID#,#qryDisposals.intProjectNo#,""#Replace(qryDisposals.strDescription, Chr(34), Chr(39), "ALL")#"",""#Replace(qryDisposals.strLegal, Chr(34), Chr(39), "ALL")#"",""#qryDisposals.strFileNo#"",#DateFormat(qryDisposals.datStartDate, "m/d/yyyy")#,#DateFormat(qryDisposals.datComplDate, "m/d/yyyy")#,#qryDisposals.bolCancelled#,#qryDisposals.curSSAFees#,#qryDisposals.curSSADisbursements#,#qryDisposals.curPrice#,#qryDisposals.curExpToDate#,""#qryDisposals.strAgentFirstName#"",""#qryDisposals.strAgentLastName#"",""#qryDisposals.strLocation#"",""#qryDisposals.strProvAbrev#"",""#qryDisposals.strDeptAbrev#"",""#qryDisposals.strClientContactFirst#"",""#qryDisposals.strClientContactLast#"",""#qryDisposals.strRollNumber#"",""#qryDisposals.strProjRefNo#"",""#qryDisposals.strLDU#"",""#qryDisposals.strPACNo#"",""#qryDisposals.strSMANo#"",#DateFormat(qryDisposals.datReportOfSurplus, "m/d/yyyy")#,""#qryDisposals.strDisposalMethod#"",""#qryDisposals.strPropertyType#"",""#qryDisposals.strPurchaserType#"",""#qryDisposals.strInterestSold#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/asciiDisposals.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
