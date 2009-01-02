<!--- this page retrieves all the data from tblStatus and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblStatus --->
<CFQUERY NAME="qryStatus" DATASOURCE="#request.ds#">
	SELECT * FROM tblStatus
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblStatus.txt"
	OUTPUT="""intStatusID"",""intProjectID"",""memStatus"",""datUpdate""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryStatus">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblStatus.txt"
	OUTPUT="#qryStatus.intStatusID#,#qryStatus.intProjectID#,""#Replace(qryStatus.memStatus, Chr(34), Chr(39), "ALL")#"",""#DateFormat(qryStatus.datUpdate, "m/d/yyyy")#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblStatus.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
