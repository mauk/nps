<!--- this page retrieves all the data from tblDisposalMethod and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblDisposalMethod --->
<CFQUERY NAME="qryDisposalMethod" DATASOURCE="#request.ds#">
	SELECT * FROM tblDisposalMethod
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblDisposalMethod.txt"
	OUTPUT="""intDisposalMethodID"",""strDisposalMethod""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryDisposalMethod">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblDisposalMethod.txt"
	OUTPUT="#qryDisposalMethod.intDisposalMethodID#,""#qryDisposalMethod.strDisposalMethod#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblDisposalMethod.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
