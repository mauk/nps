<!--- this page retrieves all the data from tblDisposals and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblDisposals --->
<CFQUERY NAME="qryDisposals" DATASOURCE="#request.ds#">
	SELECT * FROM tblDisposals
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblDisposals.txt"
	OUTPUT="""intProjectID"",""strRollNumber"",""strProjRefNo"",""strLDU"",""strPACNo"",""strSMANo"",""datReportOfSurplus"",""intDisposalMethod"",""intPropertyTypeID"",""intPurchaserTypeID"",""intInterestSoldID""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryDisposals">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblDisposals.txt"
	OUTPUT="#qryDisposals.intProjectID#,""#qryDisposals.strRollNumber#"",""#qryDisposals.strProjRefNo#"",""#qryDisposals.strLDU#"",""#qryDisposals.strPACNo#"",""#qryDisposals.strSMANo#"",#DateFormat(qryDisposals.datReportOfSurplus, "m/d/yyyy")#,#qryDisposals.intDisposalMethod#,#qryDisposals.intPropertyTypeID#,#qryDisposals.intPurchaserTypeID#,#qryDisposals.intInterestSoldID#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblDisposals.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
