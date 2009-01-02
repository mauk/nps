<!--- this page retrieves many of the fields associated with consulting projects. --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data --->
<CFQUERY NAME="qryConsulting" DATASOURCE="#request.ds#">
	SELECT		tblProjects.intProjectID,
				tblProjects.intProjectNo,
				tblProjects.strDescription,
				tblProjects.strFileNo,
				tblProjects.datStartDate,
				tblProjects.datComplDate,
				tblProjects.bolCancelled,
				tblProjects.curSSAFees,
				tblProjects.curSSADisbursements,
				tblProjects.curExpToDate,
				tblAgent.strFirstName AS strAgentFirstName,
				tblAgent.strLastName AS strAgentLastName,
				tblLocation.strLocation,
				tblProvince.strAbbreviated AS strProvAbrev,
				tblDept.strDeptAbrev,
				tblClientContact.strFirstName AS strClientContactFirst,
				tblClientContact.strLastName AS strClientContactLast
	FROM		tblProjects,
				tblAgent,
				tblLocation,
				tblProvince,
				tblDept,
				tblClientContact
	WHERE		tblProjects.intAgent = tblAgent.intAgentID
	AND			tblProjects.intLocationID = tblLocation.intLocationID
	AND			tblProjects.intProvID = tblProvince.intProvID
	AND			tblProjects.intClientDept = tblDept.intDeptID
	AND			tblProjects.intClientContactID = tblClientContact.intClientContactID
	AND			tblProjects.intProjectType = 3
	ORDER BY	tblProjects.intProjectID	
				
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#asciiConsulting.txt"
	OUTPUT="""intProjectID"",""intProjectNo"",""strDescription"",""strFileNo"",""datStartDate"",""datComplDate"",""bolCancelled"",""curSSAFees"",""curSSADisbursements"",""curExpToDate"",""strAgentFirstName"",""strAgentLastName"",""strLocation"",""strProvAbrev"",""strDeptAbrev"",""strClientContactFirst"",""strClientContactLast""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryConsulting">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#asciiConsulting.txt"
	OUTPUT="#qryConsulting.intProjectID#,#qryConsulting.intProjectNo#,""#Replace(qryConsulting.strDescription, Chr(34), Chr(39), "ALL")#"",""#qryConsulting.strFileNo#"",#DateFormat(qryConsulting.datStartDate, "m/d/yyyy")#,#DateFormat(qryConsulting.datComplDate, "m/d/yyyy")#,#qryConsulting.bolCancelled#,#qryConsulting.curSSAFees#,#qryConsulting.curSSADisbursements#,#qryConsulting.curExpToDate#,""#qryConsulting.strAgentFirstName#"",""#qryConsulting.strAgentLastName#"",""#qryConsulting.strLocation#"",""#qryConsulting.strProvAbrev#"",""#qryConsulting.strDeptAbrev#"",""#qryConsulting.strClientContactFirst#"",""#qryConsulting.strClientContactLast#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/asciiConsulting.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
