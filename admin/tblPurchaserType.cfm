<!--- this page retrieves all the data from tblPurchaserType and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblPurchaserType --->
<CFQUERY NAME="qryPurchaserType" DATASOURCE="#request.ds#">
	SELECT * FROM tblPurchaserType
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblPurchaserType.txt"
	OUTPUT="""intPurchaserTypeID"",""strPurchaserType""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryPurchaserType">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblPurchaserType.txt"
	OUTPUT="#qryPurchaserType.intPurchaserTypeID#,""#qryPurchaserType.strPurchaserType#""">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblPurchaserType.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
