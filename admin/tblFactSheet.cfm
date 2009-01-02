<!--- this page retrieves all the data from tblFactSheet and inserts it into
a comma delimited text file that can be saved from the browser --->

<CFIF Client.admin EQ 1 OR Client.admin EQ 2>

<!--- Query that selects all data from tblFactSheet --->
<CFQUERY NAME="qryFactSheet" DATASOURCE="#request.ds#">
	SELECT * FROM tblFactSheet
</CFQUERY>

<!--- create a text file with the column headings --->
<CFFILE ACTION="WRITE"
	FILE="#request.path_ascii#tblFactSheet.txt"
	OUTPUT="""intProjectID"",""strPropLocated"",""strGeneralDesc"",""strAvailable"",""strUrbanCentre"",""strAddress"",""sngParcelSize"",""strTopography"",""strAccess"",""strBuildingDesc"",""strZoning"",""strServices"",""strLandUse"",""intAge"",""strCondition"",""strEnvironIssues"",""strTenure"",""strRestrictions"",""strAcquiDate"",""strPurchasedFrom"",""curAmountPaid"",""strHistory"",""strKnownInterests"",""curLandAsses"",""curBuildingAsses"",""intYear"",""curPILT""">
	
<!--- loop through each record in the query and append it to the text file --->
<CFLOOP QUERY="qryFactSheet">
<CFFILE ACTION="APPEND"
	FILE="#request.path_ascii#tblFactSheet.txt"
	OUTPUT="#qryFactSheet.intProjectID#,""#qryFactSheet.strPropLocated#"",""#qryFactSheet.strGeneralDesc#"",""#qryFactSheet.strAvailable#"",""#qryFactSheet.strUrbanCentre#"",""#qryFactSheet.strAddress#"",#qryFactSheet.sngParcelSize#,""#qryFactSheet.strTopography#"",""#qryFactSheet.strAccess#"",""#qryFactSheet.strBuildingDesc#"",""#qryFactSheet.strZoning#"",""#qryFactSheet.strServices#"",""#qryFactSheet.strLandUse#"",#qryFactSheet.intAge#,""#qryFactSheet.strCondition#"",""#qryFactSheet.strEnvironIssues#"",""#qryFactSheet.strTenure#"",""#qryFactSheet.strRestrictions#"",""#qryFactSheet.strAcquiDate#"",""#qryFactSheet.strPurchasedFrom#"",#qryFactSheet.curAmountPaid#,""#qryFactSheet.strHistory#"",""#qryFactSheet.strKnownInterests#"",#qryFactSheet.curLandAsses#,#qryFactSheet.curBuildingAsses#,#qryFactSheet.intYear#,#qryFactSheet.curPILT#">
</CFLOOP>


<!--- direct the browser to the new text file --->
<CFLOCATION URL="ascii/tblFactSheet.txt">

<CFELSE>
	<CFLOCATION URL="../login.cfm">
</CFIF>
