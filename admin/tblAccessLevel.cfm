<!--- this page retrieves all the data from tblAccessLevel and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

	<!--- Query that selects all data from tblAccessLevel --->
	<CFQUERY NAME="qryAccessLevel" DATASOURCE="#request.ds#">
		SELECT * FROM tblAccessLevel
	</CFQUERY>
	
	<!--- create a text file with the column headings --->
	<CFFILE ACTION="WRITE"
		FILE="#request.path_ascii#tblAccessLevel.txt"
		OUTPUT="""intAccessLevel"",""strAccessLevel""">
		
	<!--- loop through each record in the query and append it to the text file --->
	<CFLOOP QUERY="qryAccessLevel">
	<CFFILE ACTION="APPEND"
		FILE="#request.path_ascii#tblAccessLevel.txt"
		OUTPUT="#qryAccessLevel.intAccessLevel#,""#qryAccessLevel.strAccessLevel#""">
	</CFLOOP>
	
	
	<!--- direct the browser to the new text file --->
	<CFLOCATION URL="ascii/tblAccessLevel.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
