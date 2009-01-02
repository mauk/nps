<!--- this page retrieves all the data from tblDispSummary and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblDispSummary --->
<CFQUERY NAME="qryDispSummary" DATASOURCE="#request.ds#">
	SELECT * FROM tblDispSummary
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblDispSummary.txt"
	OUTPUT="""intProjectID"",""bolSaved"",""strLocation"",""strDescription"",""strLegal"",""strCustodian"",""strPurchaser"",""strSalePrice"",""strAppraisedValue"",""strCompletionDate"",""strAgent"",""strFileNo"",""strProjectNumber"",""strRollNumber"",""memRemarks""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryDispSummary">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblDispSummary.txt"
	OUTPUT="#qryDispSummary.intProjectID#,#qryDispSummary.bolSaved#,""#qryDispSummary.strLocation#"",""#Replace(qryDispSummary.strDescription, Chr(34), Chr(39), "ALL")#"",""#Replace(qryDispSummary.strLegal, Chr(34), Chr(39), "ALL")#"",""#qryDispSummary.strCustodian#"",""#qryDispSummary.strPurchaser#"",""#qryDispSummary.strSalePrice#"",""#qryDispSummary.strAppraisedValue#"",""#qryDispSummary.strCompletionDate#"",""#qryDispSummary.strAgent#"",""#qryDispSummary.strFileNo#"",""#qryDispSummary.strProjectNumber#"",""#qryDispSummary.strRollNumber#"",""#qryDispSummary.memRemarks#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblDispSummary.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
