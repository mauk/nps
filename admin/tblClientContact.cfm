<!--- this page retrieves all the data from tblClientContact and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblClientContact --->
<CFQUERY NAME="qryClientContact" DATASOURCE="#request.ds#">
	SELECT * FROM tblClientContact
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblClientContact.txt"
	OUTPUT="""intClientContactID"",""strFirstName"",""strLastName"",""strArea"",""bolActive""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryClientContact">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblClientContact.txt"
	OUTPUT="#qryClientContact.intClientContactID#,""#qryClientContact.strFirstName#"",""#qryClientContact.strLastName#"",""#qryClientContact.strArea#"",#qryClientContact.bolActive#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblClientContact.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
