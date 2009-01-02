<!--- this page retrieves all the data from tblProvince and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblProvince --->
<CFQUERY NAME="qryProvince" DATASOURCE="#request.ds#">
	SELECT * FROM tblProvince
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblProvince.txt"
	OUTPUT="""intProvID"",""strAbbreviated"",""strProvNm""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryProvince">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblProvince.txt"
	OUTPUT="#qryProvince.intProvID#,""#qryProvince.strAbbreviated#"",""#qryProvince.strProvNm#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblProvince.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
