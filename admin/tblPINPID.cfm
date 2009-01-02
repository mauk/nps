<!--- this page retrieves all the data from tblPINPID and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblPINPID --->
<CFQUERY NAME="qryPINPID" DATASOURCE="#request.ds#">
	SELECT * FROM tblPINPID
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblPINPID.txt"
	OUTPUT="""intProjectID"",""strPINPID"",""bolIsPID""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryPINPID">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblPINPID.txt"
	OUTPUT="#qryPINPID.intProjectID#,""#qryPINPID.strPINPID#"",#qryPINPID.bolIsPID#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblPINPID.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
