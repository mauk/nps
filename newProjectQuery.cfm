<!--- 
newProjectQuery.cfm is called when a user clicks on "Submit" on newProject.cfm. 
It reads Form.projectType and performs the appropriate queries to create a new 
project of the type specified in this field. The data from the other fields from 
newProject.cfm is also entered into the project.
--->

<!--- Query to create a new record in tblProjects --->
<CFQUERY NAME="qryUpdateProject" DATASOURCE="#request.ds#">
	INSERT INTO	tblProjects (
					intProjectType,
					intProvID,
					intLocationID,
					strDescription,
					intClientDept,
					intSecondDept,
					intClientContactID,
					intAgent<CFIF #Form.startDate# NEQ "">,
					datStartDate
				</CFIF>
					)
				VALUES (
					#Form.projectType#,
					#Form.province#,
					#Form.location#,
					'#Form.description#',
					#Form.department#,
					#Form.secondDept#,
					#Form.clientContact#,
					#Form.agent#<CFIF #Form.startDate# NEQ "">,
					###DateFormat(Form.startDate, "yyyy/m/d")###
				</CFIF>
					)
</CFQUERY>
<!--- Query to get the newly created project ID --->
<CFQUERY NAME="qryGetNewID" DATASOURCE="#request.ds#">
	SELECT	MAX(intProjectID) AS maxProjectID
	FROM	tblProjects
</CFQUERY>
<!--- store the new project ID in a variable --->
<CFOUTPUT QUERY="qryGetNewID">
	<CFSET projectID = maxProjectID>
</CFOUTPUT>


<CFIF #Form.projectType# EQ 1>
<!--- then the new project is an acquisition --->

	<!--- add a record to tblAcquisitions with the new project ID --->
	<CFQUERY NAME="qryAddAcquisition" DATASOURCE="#request.ds#">
		INSERT INTO	tblAcquisitions (intProjectID, intInterestType)
		VALUES (#projectID#, #request.defaultInterestSold#)
	</CFQUERY>
	<!--- add a record to tblAcqSummary with the new project ID --->
	<CFQUERY NAME="qryAddAcqSummary" DATASOURCE="#request.ds#">
		INSERT INTO	tblAcqSummary (intProjectID)
		VALUES (#projectID#)
	</CFQUERY>
	<!--- send the user to the new project --->
	<CFLOCATION URL="acquisitions.cfm?projectID=#projectID#&backup=yes">
	
<CFELSEIF #Form.projectType# EQ 2>
<!--- then the new project is an disposal --->

	<!--- find the location's name --->
	<CFQUERY NAME="qryLocationName" DATASOURCE="#request.ds#">
		SELECT	strLocation
		FROM	tblLocation
		WHERE	intLocationID = #Form.location#
	</CFQUERY>
	<!--- set the value of projUrbanCentre to the location --->
	<CFOUTPUT QUERY="qryLocationName">
		<CFSET projUrbanCentre = strLocation>
	</CFOUTPUT>
	
	<!--- add a record to tblDisposals with the new project ID and default values
	for some fields --->
	<CFQUERY NAME="qryAddDisposal" DATASOURCE="#request.ds#">
		INSERT INTO	tblDisposals (intProjectID, intInterestSoldID, intDisposalMethod, intPropertyTypeID, intPurchaserTypeID)
		VALUES (#projectID#, #request.defaultInterestSold#, #request.defaultPropertyType#, #request.defaultPropertyType#, #request.defaultPurchaserType#)
	</CFQUERY>
	<!--- add a record to tblFactSheet with the new project ID and with 
	strUrbanCentre set to the value in projUrbanCentre --->
	<CFQUERY NAME="qryAddFactSheet" DATASOURCE="#request.ds#">
		INSERT INTO	tblFactSheet (intProjectID, strUrbanCentre)
		VALUES (#projectID#, '#projUrbanCentre#')
	</CFQUERY>
	<!--- add a record to tblDispSummary with the new project ID --->
	<CFQUERY NAME="qryAddDispSummary" DATASOURCE="#request.ds#">
		INSERT INTO	tblDispSummary (intProjectID)
		VALUES (#projectID#)
	</CFQUERY>
	<!--- send the user to the new project --->
	<CFLOCATION URL="disposals.cfm?projectID=#projectID#&backup=yes">
	
<CFELSEIF #Form.projectType# EQ 3>
<!--- then the new project is a consulting project and no more records need to be added --->

	<!--- send the user to the new project --->
	<CFLOCATION URL="consulting.cfm?projectID=#projectID#&backup=yes">
	
</CFIF>
