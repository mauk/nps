<!--- this page retrieves all the data from tblBand and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblBand --->
<CFQUERY NAME="qryBand" DATASOURCE="#request.ds#">
	SELECT * FROM tblBand
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblBand.txt"
	OUTPUT="""intBandID"",""intProjectID"",""strBandName"",""strChiefName"",""strContact"",""strPhone"",""strFax"",""strAddress"",""strEmail""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryBand">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblBand.txt"
	OUTPUT="#qryBand.intBandID#,#qryBand.intProjectID#,""#qryBand.strBandName#"",""#qryBand.strChiefName#"",""#qryBand.strContact#"",""#qryBand.strPhone#"",""#qryBand.strFax#"",""#qryBand.strAddress#"",""#qryBand.strEmail#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblBand.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
