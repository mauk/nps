<!--- this page retrieves all the data from tblProjectType and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblProjectType --->
<CFQUERY NAME="qryProjectType" DATASOURCE="#request.ds#">
	SELECT * FROM tblProjectType
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblProjectType.txt"
	OUTPUT="""intProjTypeID"",""strProjType""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryProjectType">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblProjectType.txt"
	OUTPUT="#qryProjectType.intProjTypeID#,""#qryProjectType.strProjType#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblProjectType.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
