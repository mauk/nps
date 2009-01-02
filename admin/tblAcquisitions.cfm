<!--- this page retrieves all the data from tblAcquisitions and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblAcquisitions --->
<CFQUERY NAME="qryAcquisitions" DATASOURCE="#request.ds#">
	SELECT * FROM tblAcquisitions
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblAcquisitions.txt"
	OUTPUT="""intProjectID"",""datOffer"",""datClose"",""intInterestType"",""strRollNumber"",""strAcuiredFrom"",""strPropertyUse"",""memPropDescription""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryAcquisitions">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblAcquisitions.txt"
	OUTPUT="#qryAcquisitions.intProjectID#,#DateFormat(qryAcquisitions.datOffer, "m/d/yyyy")#,#DateFormat(qryAcquisitions.datClose, "m/d/yyy")#,#qryAcquisitions.intInterestType#,""#qryAcquisitions.strRollNumber#"",""#qryAcquisitions.strAcquiredFrom#"",""#qryAcquisitions.strPropertyUse#"",""#Replace(qryAcquisitions.memPropDescription, Chr(34), Chr(39), "ALL")#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblAcquisitions.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
