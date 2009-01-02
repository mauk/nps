<!--- this page retrieves all the data from tblInterestSold and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblInterestSold --->
<CFQUERY NAME="qryInterestSold" DATASOURCE="#request.ds#">
	SELECT * FROM tblInterestSold
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblInterestSold.txt"
	OUTPUT="""intInterestSoldID"",""strInterestSold""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryInterestSold">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblInterestSold.txt"
	OUTPUT="#qryInterestSold.intInterestSoldID#,""#qryInterestSold.strInterestSold#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblInterestSold.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
