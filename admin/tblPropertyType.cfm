<!--- this page retrieves all the data from tblPropertyType and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblPropertyType --->
<CFQUERY NAME="qryPropertyType" DATASOURCE="#request.ds#">
	SELECT * FROM tblPropertyType
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblPropertyType.txt"
	OUTPUT="""intPropertyTypeID"",""strPropertyType""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryPropertyType">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblPropertyType.txt"
	OUTPUT="#qryPropertyType.intPropertyTypeID#,""#qryPropertyType.strPropertyType#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblPropertyType.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
