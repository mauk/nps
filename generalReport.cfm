<!---
this page produces a report formatted for printing from the browser. 
It displays whatever projects were found and listed on the Search Results 
page. These projects are sorted based on user input on generalReportCreate.cfm. 
User input on generalReportCreate.cfm also indicates whether SSA Amount and 
Expenditures to Date information will be displayed in the report.
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>PWGSC Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<STYLE TYPE="text/css">

BODY {font-family: Helvetica; font-size: 9pt;}
P {font-family: Helvetica; font-size: 9pt;}
TABLE, TR, TD {font-family: Helvetica; font-size: 9pt;}
H2 {font-family: Helvetica; font-size: 16pt; font-weight: bold;}
H3 {font-family: Helvetica; font-size: 15pt; font-weight: bold;}
h4.typehead {text-decoration: underline; margin-top: 2em; text-align: center;}

A.link:link {color: #0066CC; text-decoration: underline;}
A.link:visited {color: #0066CC; text-decoration: underline;}
A.link:hover {color: #ff9900; text-decoration: underline;}
A.link:active {color: #ff9900; text-decoration: underline;}

div.subheader {width: 1180px; padding: 4px;}
div.subheader .date {float: right; font-weight: bold; padding-right: 10px;}

table.report {border-collapse:collapse; clear: both;}
table.report tr.record td {border-bottom: 1px solid black; vertical-align: top; padding-top: 8px; padding-bottom: 8px;}
</STYLE>

<STYLE TYPE="text/css" MEDIA="print">
.noprint { display:none; }
</STYLE>

<!--- Include the report helper functions (e.g. printReportHeader) --->
<cfinclude template="reports_util.cfm">

<!--- Query to obtain project types --->
<cfquery name="qryProjTypes" datasource="#request.ds#">
	SELECT		strProjType
	FROM		tblProjectType
	ORDER BY	strProjType
</cfquery>

<!--- retrieve all the projects that match the search criteria (as stored in client variables) --->
<CFQUERY NAME="qryProjects" DATASOURCE="#request.ds#">
	SELECT	tblProjects.intProjectID,
			tblProjectType.strProjType,
			tblLocation.strLocation,
			tblProvince.strAbbreviated,
			tblProjects.strDescription,
			tblProjects.curExpToDate,
			tblProjects.curSSAFees,
			tblProjects.curSSADisbursements,
			tblAgent.strAbrev,
			tblDept.strDeptAbrev,
			tblClientContact.strFirstName,
			tblClientContact.strLastName,
			qryMostRecentStatus.LastOfdatUpdate,
			qryMostRecentStatus.LastOfmemStatus
	FROM	tblDept INNER JOIN 
			(tblLocation INNER JOIN 
			(tblAgent INNER JOIN 
			((tblProjectType INNER JOIN 
			((tblProjects INNER JOIN 
			tblProvince ON tblProjects.intProvID = tblProvince.intProvID) 
			INNER JOIN tblClientContact ON tblProjects.intClientContactID = tblClientContact.intClientContactID) 
			ON tblProjectType.intProjTypeID = tblProjects.intProjectType) 
			LEFT JOIN qryMostRecentStatus ON tblProjects.intProjectID = qryMostRecentStatus.intProjectID) 
			ON tblAgent.intAgentID = tblProjects.intAgent) 
			ON tblLocation.intLocationID = tblProjects.intLocationID) 
			ON tblDept.intDeptID = tblProjects.intClientDept
	WHERE	1 = 1
<CFIF #Client.status# EQ "active">
	AND		((tblProjects.datComplDate IS NULL OR tblProjects.datComplDate > #Now()#) AND tblProjects.bolCancelled = False)
<CFELSEIF #Client.status# EQ "complete">
	AND		(tblProjects.datComplDate < #Now()# OR tblProjects.bolCancelled = True)
</CFIF>
<CFIF #Client.projectType# EQ "acquisition">
	AND		tblProjectType.intProjTypeID = 1
<CFELSEIF #Client.projectType# EQ "disposal">
	AND		tblProjectType.intProjTypeID = 2
<CFELSEIF #Client.projectType# EQ "consulting">
	AND		tblProjectType.intProjTypeID = 3
</CFIF>
<CFIF #Client.location# IS NOT 0 <!---AND #Client.description# IS ""--->>
	AND		tblLocation.intLocationID = #Client.location#
	
<!---
<CFELSEIF #Client.location# IS NOT 0 AND #Client.description# IS NOT "">
	AND		(tblLocation.intLocationID = #Client.location#
	OR		tblProjects.strDescription LIKE '%#Client.description#%')
<CFELSEIF #Client.location# IS 0 AND #Client.description# IS NOT "">
	AND		tblProjects.strDescription LIKE '%#Client.description#%'
--->	
	
</CFIF>
<CFIF #Client.agent# IS NOT 0>
	AND		tblAgent.intAgentID = #Client.agent#
</CFIF>
<CFIF #Client.department# IS NOT 0>
	AND		tblDept.intDeptID = #Client.department#
</CFIF>
<CFIF #Client.projectNo# IS NOT "">
	AND		tblProjects.intProjectNo = #Client.projectNo#
</CFIF>
<CFIF #Client.fileNo# IS NOT "">
	AND		tblProjects.strFileNo = '#Client.fileNo#'
</CFIF>
<!--- sort the projects based on Form.sort which is provided generalReportCreate.cfm --->
<CFIF #Form.sort# EQ "location">
	ORDER BY tblLocation.strLocation
<CFELSEIF #Form.sort# EQ "agent">
	ORDER BY tblAgent.strAbrev
<CFELSEIF #Form.sort# EQ "clientContact">
	ORDER BY tblClientContact.strFirstName, tblClientContact.strLastName
</CFIF>
</CFQUERY>

<!--- Group project types and store in a structure --->
<cfset qryAllProjectsByType = StructNew()>
<cfloop query="qryProjTypes">
	<cfquery dbtype="query" name="qryProjectsByType">
		SELECT	*
		FROM	qryProjects
		WHERE	strProjType = '#qryProjTypes.strProjType#'
	</cfquery>
	<cfscript>
		StructInsert(qryAllProjectsByType, '#qryProjTypes.strProjType#', #qryProjectsByType#);
	</cfscript>
</cfloop>

<!--- check browser version and choose the appropraite css --->
<cfparam name="attributes.user_agent" default="#cgi.http_user_agent#">
<cfscript>
	attributes.browserName="Unknown";
	attributes.browserVersion="0";
	if (Len(attributes.user_agent)) {
		if (Find("MSIE",attributes.user_agent)) { // it's a Microsoft browser
			attributes.browserName="MSIE";
			attributes.browserVersion=Val(RemoveChars(attributes.user_agent,1,Find("MSIE",attributes.user_agent)+4));
		}
		else {
			if (Find("Mozilla",attributes.user_agent)) { // it's a Netscape compatible browser
				if (not Find("compatible",attributes.user_agent)) { // its probably a Netscape browser
					attributes.browserName="Netscape";
					attributes.browserVersion=Val(RemoveChars(attributes.user_agent,1,Find("/",attributes.user_agent)));
				}
				else {
					attributes.browserName="compatible"; // not Netscape
				}
			}
			if (Find("ColdFusion",attributes.user_agent)) { // Customisation sample - detection of Colf Fusion Scheduler or CFHTTP tag
				attributes.browserName="ColdFusion";
			}
		}
	}
	// for using as tag or module
	caller.browserName=attributes.browserName;
	caller.browserVersion=attributes.browserVersion;
</cfscript>

<!--- set browser version and name variables --->
<cfset browser = "#caller.browserName#">
<cfset version = "#caller.browserVersion#">

</head>

<body bgcolor="#FFFFFF" text="#000000" link="#0066ff" vlink="#0066ff" alink="#999999" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">

<!-- If browser is Internet Explorer, display options to save and print report.
The links themselves will not be printed because of the class="noprint". The
browser is determined using JavaScript as opposed to CFSCRIPT (which is used in other pages)
because if the page is saved with IE, we do not want a user to open the file in Netscape
and have these links displayed, for they will not work in Netscape. -->
<script Language="Javascript">
	if (document.all) {
		document.write('<p class="noprint"><a class="link" href="#" onclick="execCommand(\'SaveAs\',\'False\',\'generalReport.htm\');">save</a> | <a class="link" href="javascript:window.print();">print</a></p>');
	}
</script>

<h2 align="center">PWGSC Realty Projects</h2>
<h3 align="center"><CFIF #Client.projectType# EQ "acquisition">Acquisition<CFELSEIF #Client.projectType# EQ "disposal">Disposal<CFELSEIF #Client.projectType# EQ "consulting">Consulting<CFELSE>Projects</CFIF> Report</h3>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
	
</table>

<!--- There are two reports that can be generated, one has the SSA Amount 
and YTD Expenditures listed at the top as well as two extra columns (SSA
Amount and Exp. to Date), and the other doesn't. The user specifies which
they want on generalReportCreate.cfm --->

<!--- Subheader of the table that contains current date and SSA Amount/YTD Expenditures (if requested) --->
<div class="subheader">
	<cfoutput>
		<div class="date">
			#MonthAsString(DatePart("m", Now()))# #DatePart("d", Now())#, #DatePart("yyyy", Now())#
		</div>
		<!--- If include SSA Amount and Expenditures checkbox was checked, output it --->
		<cfif isDefined("Form.include")>
			<div>
				<strong>SSA Amount</strong>: #Form.SSA#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>YTD Expenditures</strong>: #Form.expenditures#
			</div>
		</cfif>
	</cfoutput>
</div>

<!--- Set up the report headers (table) --->
<cfset rptHeaders = ArrayNew(2)>
<cfif isDefined("Form.include")>
	<cfset rptHeaders[1][1] = 162>		<cfset rptHeaders[1][2] = "Location">
	<cfset rptHeaders[2][1] = 52>		<cfset rptHeaders[2][2] = "Client">
	<cfset rptHeaders[3][1] = 122>		<cfset rptHeaders[3][2] = "Client Contact">
	<cfset rptHeaders[4][1] = 77>		<cfset rptHeaders[4][2] = "SSA Amount">
	<cfset rptHeaders[5][1] = 77>		<cfset rptHeaders[5][2] = "Exp. To Date">
	<cfset rptHeaders[6][1] = 42>		<cfset rptHeaders[6][2] = "Advisor">
	<cfset rptHeaders[7][1] = 282>		<cfset rptHeaders[7][2] = "Description">
	<cfset rptHeaders[8][1] = 302>		<cfset rptHeaders[8][2] = "Status">
<cfelse>
	<cfset rptHeaders[1][1] = 162>		<cfset rptHeaders[1][2] = "Location">
	<cfset rptHeaders[2][1] = 52>		<cfset rptHeaders[2][2] = "Client">
	<cfset rptHeaders[3][1] = 147>		<cfset rptHeaders[3][2] = "Client Contact">
	<cfset rptHeaders[4][1] = 52>		<cfset rptHeaders[4][2] = "Advisor">
	<cfset rptHeaders[5][1] = 352>		<cfset rptHeaders[5][2] = "Description">
	<cfset rptHeaders[6][1] = 367>		<cfset rptHeaders[6][2] = "Status">
</cfif>

<!--- Helper function to print two different kinds of reports --->
<cffunction name="printReportRecords" output="yes">
	<cfargument name="boolInclude" type="boolean">
	<cfif boolInclude IS 1>
		<td>#strLocation#, #strAbbreviated#&nbsp;</td>
		<td>#strDeptAbrev#&nbsp;</td>
		<td>#strFirstName# #strLastName#&nbsp;</td>
		<td>#DollarFormat(curSSAFees + curSSADisbursements)#&nbsp;</td>
		<td>#DollarFormat(curExpToDate)#&nbsp;</td>
		<td>#strAbrev#&nbsp;</td>
		<td>#strDescription#&nbsp;</td>
		<td><CFIF #LastOfmemStatus# NEQ "">#DateFormat(LastOfdatUpdate, "mmm d, yyyy")# - #LastOfmemStatus#</CFIF>&nbsp;</td>
	<cfelse>
		<td>#strLocation#, #strAbbreviated#&nbsp;</td>
		<td>#strDeptAbrev#&nbsp;</td>
		<td>#strFirstName# #strLastName#&nbsp;</td>
		<td>#strAbrev#&nbsp;</td>
		<td>#strDescription#&nbsp;</td>
		<td><CFIF #LastOfmemStatus# NEQ "">#DateFormat(LastOfdatUpdate, "mmm d, yyyy")# - #LastOfmemStatus#</CFIF>&nbsp;</td>
	</cfif>
</cffunction>

<!--- If sorting by location, also sort by project type (first level) --->
<cfif Form.sort EQ "Location">
	<cfloop query="qryProjTypes">
		<h4 class="typehead"><cfoutput>#qryProjTypes.strProjType#</cfoutput></h4>
		<table border="0" cellpadding="4" cellspacing="0" width="1180" class="report">
			<cfoutput>#printReportHeaders(rptHeaders)#</cfoutput>
			<cfoutput query="qryAllProjectsByType.#qryProjTypes.strProjType#">
				<tr class="record">
					#printReportRecords(isDefined("Form.include"))#
				</tr>
			</cfoutput>
		</table>
	</cfloop>
<!--- Otherwise, display as normal (sorted by requested column) --->
<cfelse>
	<table border="0" cellpadding="4" cellspacing="0" width="1180" class="report">
		<cfoutput>#printReportHeaders(rptHeaders)#</cfoutput>
		<cfoutput query="qryProjects">
			<tr class="record">
				#printReportRecords(isDefined("Form.include"))#
			</tr>
		</cfoutput>
	</table>
</cfif>

</body>
</html>