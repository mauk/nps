<!--- this page is autmatically run every time a page is loaded.  It is mostly used to set variables. --->

<!--- Turn on ClientManagement, ClientCookies and SessionManagement, and set the sessionTimeOut to 1 hour --->
<CFAPPLICATION 
	NAME="Projects" 
	CLIENTMANAGEMENT="Yes" 
	SETCLIENTCOOKIES="Yes" 
	SESSIONMANAGEMENT="Yes"
	SESSIONTIMEOUT=#CreateTimeSpan(0, 1, 0, 0)#>

<!--- By default, the user is not logged in and their admin level is set to 3 (read-only) --->
<CFPARAM NAME="Client.LoggedIn" DEFAULT="No">
<CFPARAM NAME="Client.Admin" DEFAULT="3">
<!--- Declare Client.sort and Client.lastSort with default values so that
projectList.cfm will sort the search results properly on the user's first visit --->
<CFPARAM NAME="Client.sort" DEFAULT="tblProjectType.strProjType">
<CFPARAM NAME="Client.lastSort" DEFAULT="tblLocation.strLocation">


<!--- The name of the datasource used througout the site is "AcqDisp" but can
be referred to by #request.ds# --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
<!--- 	<CFSET application.ds = "AcqDisp"> --->
	<CFSET application.ds = "NPS">
</CFLOCK>
<CFLOCK SCOPE="APPLICATION" TYPE="READONLY" TIMEOUT="2">
	<CFSET request.ds = Duplicate(application.ds)>
</CFLOCK>

<!--- These variables hold values for the CACHEDWITHIN attribute of some queries.
When a record is added, edited or deleted from the tables, the variable is set to
0 so that the query is refreshed.  After the query is run, the variable will be set
back to it's default value.  This is only done for queries that are frequently 
accessed, but usually return the same results. --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFIF NOT IsDefined("application.qryAgentCache")>
		<CFSET application.qryAgentCache = #CreateTimeSpan(30,0,0,0)#>
	</CFIF>
</CFLOCK>
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFIF NOT IsDefined("application.qryDeptCache")>
		<CFSET application.qryDeptCache = #CreateTimeSpan(30,0,0,0)#>
	</CFIF>
</CFLOCK>
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFIF NOT IsDefined("application.qryLocationCache")>
		<CFSET application.qryLocationCache = #CreateTimeSpan(15,0,0,0)#>
	</CFIF>
</CFLOCK>
<CFLOCK SCOPE="APPLICATION" TYPE="READONLY" TIMEOUT="2">
	<CFSET request.qryAgentCache = Duplicate(application.qryAgentCache)>
	<CFSET request.qryDeptCache = Duplicate(application.qryDeptCache)>
	<CFSET request.qryLocationCache = Duplicate(application.qryLocationCache)>
</CFLOCK>



<!--- the path for the admin directory where the ASCII text files are created --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="2">
	<CFSET application.path_ascii = "d:\web\NPS\admin\ascii\">
</CFLOCK>
<CFLOCK SCOPE="APPLICATION" TYPE="READONLY" TIMEOUT="2">
	<CFSET request.path_ascii = Duplicate(application.path_ascii)>
</CFLOCK>

<!--- Define variables for the default values of the following fields.
These values all correspond to a blank entry in the field --->
<CFLOCK SCOPE="APPLICATION" TYPE="EXCLUSIVE" TIMEOUT="10">
	<CFSET application.defaultDisposalMethod=1>
	<CFSET application.defaultInterestSold=1>
	<CFSET application.defaultPropertyType=1>
	<CFSET application.defaultPurchaserType=1>
	<CFSET application.defaultClientContact=1>
</CFLOCK>
<CFLOCK SCOPE="APPLICATION" TYPE="READONLY" TIMEOUT="10">
	<CFSET request.defaultDisposalMethod = Duplicate(application.defaultDisposalMethod)>
	<CFSET request.defaultInterestSold = Duplicate(application.defaultInterestSold)>
	<CFSET request.defaultPropertyType = Duplicate(application.defaultPropertyType)>
	<CFSET request.defaultPurchaserType = Duplicate(application.defaultPurchaserType)>
	<CFSET request.defaultClientContact = Duplicate(application.defaultClientContact)>
</CFLOCK>









