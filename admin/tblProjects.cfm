<!--- this page retrieves all the data from tblProjects and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblProjects --->
<CFQUERY NAME="qryProjects" DATASOURCE="#request.ds#">
	SELECT * FROM tblProjects
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblProjects.txt"
	OUTPUT="""intAgent"",""intProjectID"",""intProjectNo"",""intProvID"",""strDescription"",""strLegal"",""intClientDept"",""intSecondDept"",""strFileNo"",""datStartDate"",""datComplDate"",""bolCancelled"",""curSSAFees"",""curSSADisbursements"",""intProjectType"",""intClientContactID"",""intLocationID"",""curPrice"",""curExpToDate""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryProjects">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblProjects.txt"
	OUTPUT="#qryProjects.intAgent#,#qryProjects.intProjectID#,#qryProjects.intProjectNo#,#qryProjects.intProvID#,""#Replace(qryProjects.strDescription, Chr(34), Chr(39), "ALL")#"",""#Replace(qryProjects.strLegal, Chr(34), Chr(39), "ALL")#"",#qryProjects.intClientDept#,#qryProjects.intSecondDept#,""#qryProjects.strFileNo#"",#DateFormat(qryProjects.datStartDate, "m/d/yyyy")#,#DateFormat(qryProjects.datComplDate, "m/d/yyyy")#,#qryProjects.bolCancelled#,#qryProjects.curSSAFees#,#qryProjects.curSSADisbursements#,#qryProjects.intProjectType#,#qryProjects.intClientContactID#,#qryProjects.intLocationID#,#qryProjects.curPrice#,#qryProjects.curExpToDate#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblProjects.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
