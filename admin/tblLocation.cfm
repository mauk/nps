<!--- this page retrieves all the data from tblLocation and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblLocation --->
<CFQUERY NAME="qryLocation" DATASOURCE="#request.ds#">
	SELECT * FROM tblLocation
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblLocation.txt"
	OUTPUT="""intLocationID"",""strLocation"",""bolActive""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryLocation">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblLocation.txt"
	OUTPUT="#qryLocation.intLocationID#,""#qryLocation.strLocation#"",#qryLocation.bolActive#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblLocation.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
