<!--- this page retrieves many of the fields associated with acquisition projects. --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data --->
<CFQUERY NAME="qryAcquisitions" DATASOURCE="#request.ds#">
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
				tblAcquisitions.datOffer,
				tblAcquisitions.datClose,
				tblAcquisitions.strRollNumber,
				tblAcquisitions.strAcquiredFrom,
				tblAcquisitions.strPropertyUse,
				tblAcquisitions.memPropDescription,
				tblAgent.strFirstName AS strAgentFirstName,
				tblAgent.strLastName AS strAgentLastName,
				tblLocation.strLocation,
				tblProvince.strAbbreviated AS strProvAbrev,
				tblDept.strDeptAbrev,
				tblClientContact.strFirstName AS strClientContactFirst,
				tblClientContact.strLastName AS strClientContactLast,
				tblInterestSold.strInterestSold
	FROM		tblProjects,
				tblAcquisitions,
				tblAgent,
				tblLocation,
				tblProvince,
				tblDept,
				tblClientContact,
				tblInterestSold
	WHERE		tblProjects.intProjectID = tblAcquisitions.intProjectID
	AND			tblProjects.intAgent = tblAgent.intAgentID
	AND			tblProjects.intLocationID = tblLocation.intLocationID
	AND			tblProjects.intProvID = tblProvince.intProvID
	AND			tblProjects.intClientDept = tblDept.intDeptID
	AND			tblProjects.intClientContactID = tblClientContact.intClientContactID
	AND			tblAcquisitions.intInterestType = tblInterestSold.intInterestSoldID
	AND			tblProjects.intProjectType = 1
	ORDER BY	tblProjects.intProjectID	
				
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#asciiAcquisitions.txt"
	OUTPUT="""intProjectID"",""intProjectNo"",""strDescription"",""strLegal"",""strFileNo"",""datStartDate"",""datComplDate"",""bolCancelled"",""curSSAFees"",""curSSADisbursements"",""curPrice"",""curExpToDate"",""strAgentFirstName"",""strAgentLastName"",""strLocation"",""strProvAbrev"",""strDeptAbrev"",""strClientContactFirst"",""strClientContactLast"",""datOffer"",""datClose"",""strInterestSold"",""strRollNumber"",""strAcquiredFrom"",""strPropertyUse"",""memPropDescription""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryAcquisitions">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#asciiAcquisitions.txt"
	OUTPUT="#qryAcquisitions.intProjectID#,#qryAcquisitions.intProjectNo#,""#Replace(qryAcquisitions.strDescription, Chr(34), Chr(39), "ALL")#"",""#Replace(qryAcquisitions.strLegal, Chr(34), Chr(39), "ALL")#"",""#qryAcquisitions.strFileNo#"",#DateFormat(qryAcquisitions.datStartDate, "m/d/yyyy")#,#DateFormat(qryAcquisitions.datComplDate, "m/d/yyyy")#,#qryAcquisitions.bolCancelled#,#qryAcquisitions.curSSAFees#,#qryAcquisitions.curSSADisbursements#,#qryAcquisitions.curPrice#,#qryAcquisitions.curExpToDate#,""#qryAcquisitions.strAgentFirstName#"",""#qryAcquisitions.strAgentLastName#"",""#qryAcquisitions.strLocation#"",""#qryAcquisitions.strProvAbrev#"",""#qryAcquisitions.strDeptAbrev#"",""#qryAcquisitions.strClientContactFirst#"",""#qryAcquisitions.strClientContactLast#"",#DateFormat(qryAcquisitions.datOffer, "m/d/yyyy")#,#DateFormat(qryAcquisitions.datClose, "m/d/yyyy")#,""#qryAcquisitions.strInterestSold#"",""#qryAcquisitions.strRollNumber#"",""#qryAcquisitions.strAcquiredFrom#"",""#qryAcquisitions.strPropertyUse#"",""#Replace(qryAcquisitions.memPropDescription, Chr(34), Chr(39), "ALL")#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/asciiAcquisitions.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
