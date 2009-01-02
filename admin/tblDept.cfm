<!--- this page retrieves all the data from tblDept and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblDept --->
<CFQUERY NAME="qryDept" DATASOURCE="#request.ds#">
	SELECT * FROM tblDept
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblDept.txt"
	OUTPUT="""intDeptID"",""strDeptAbrev"",""strDeptName"",""bolActive""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryDept">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblDept.txt"
	OUTPUT="#qryDept.intDeptID#,""#qryDept.strDeptAbrev#"",""#qryDept.strDeptName#"",#qryDept.bolActive#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblDept.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
