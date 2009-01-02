<!--- this page retrieves all the data from tblAppraisals and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblAppraisals --->
<CFQUERY NAME="qryAppraisals" DATASOURCE="#request.ds#">
	SELECT * FROM tblAppraisals
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblAppraisals.txt"
	OUTPUT="""intApprID"",""datApprDate"",""curApprAmount"",""strAppraisalNo"",""intProjectID"",""strApprName""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryAppraisals">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblAppraisals.txt"
	OUTPUT="#qryAppraisals.intApprID#,#DateFormat(qryAppraisals.datApprDate, "m/d/yyyy")#,#qryAppraisals.curApprAmount#,""#qryAppraisals.strAppraisalNo#"",#qryAppraisals.intProjectID#,""#qryAppraisals.strApprName#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblAppraisals.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
