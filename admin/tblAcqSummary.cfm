<!--- this page retrieves all the data from tblAcqSummary and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblAcqSummary --->
<CFQUERY NAME="qryAcqSummary" DATASOURCE="#request.ds#">
	SELECT * FROM tblAcqSummary
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblAcqSummary.txt"
	OUTPUT="""intProjectID"",""bolSaved"",""strLocation"",""strDescription"",""strLegal"",""strRollNumber"",""strCustodian"",""strPropertyUse"",""strInterestAcquired"",""strAcquiredFrom"",""strPurchasePrice"",""strAppraisedValue"",""strAcquisitionDate"",""strAgent"",""strFileNo"",""memRemarks""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryAcqSummary">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblAcqSummary.txt"
	OUTPUT="#qryAcqSummary.intProjectID#,#qryAcqSummary.bolSaved#,""#qryAcqSummary.strLocation#"",""#Replace(qryAcqSummary.strDescription, Chr(34), Chr(39), "ALL")#"",""#Replace(qryAcqSummary.strLegal, Chr(34), Chr(39), "ALL")#"",""#qryAcqSummary.strRollNumber#"",""#qryAcqSummary.strCustodian#"",""#qryAcqSummary.strPropertyUse#"",""#qryAcqSummary.strInterestAcquired#"",""#qryAcqSummary.strAcquiredFrom#"",""#qryAcqSummary.strPurchasePrice#"",""#qryAcqSummary.strAppraisedValue#"",""#qryAcqSummary.strAcquisitionDate#"",""#qryAcqSummary.strAgent#"",""#qryAcqSummary.strFileNo#"",""#qryAcqSummary.memRemarks#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblAcqSummary.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
