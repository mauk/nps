<!--- this page retrieves all the data from tblFirstNationsRemarks and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblFirstNationsRemarks --->
<CFQUERY NAME="qryFirstNationsRemarks" DATASOURCE="#request.ds#">
	SELECT * FROM tblFirstNationsRemarks
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblFirstNationsRemarks.txt"
	OUTPUT="""intUpdateID"",""datDate"",""memRemark"",""intBandID"",""intAgentID""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryFirstNationsRemarks">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblFirstNationsRemarks.txt"
	OUTPUT="#qryFirstNationsRemarks.intUpdateID#,#DateFormat(qryFirstNationsRemarks.datDate, "m/d/yyyy")#,""#Replace(qryFirstNationsRemarks.memRemark, Chr(34), Chr(39), "ALL")#"",#qryFirstNationsRemarks.intBandID#,#qryFirstNationsRemarks.intAgentID#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblFirstNationsRemarks.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
