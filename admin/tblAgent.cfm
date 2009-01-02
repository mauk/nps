<!--- this page retrieves all the data from tblAgent and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblAgent --->
<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#">
	SELECT * FROM tblAgent
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblAgent.txt"
	OUTPUT="""strAbrev"",""strLastName"",""strFirstName"",""strPassword"",""intAgentID"",""intAccessLevel"",""datLastVisit""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryAgent">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblAgent.txt"
	OUTPUT="""#qryAgent.strAbrev#"",""#qryAgent.strLastName#"",""#qryAgent.strFirstName#"",""#qryAgent.strPassword#"",#qryAgent.intAgentID#,#qryAgent.intAccessLevel#,#DateFormat(qryAgent.datLastVisit, "m/d/yyyy")#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblAgent.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
