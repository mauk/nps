<!---
generalReport.cfm produces a report formatted for printing from the browser. It uses the
same search and sort criteria as projectList.cfm to select and sort the projects. 
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Project Summary Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<STYLE TYPE="text/css">

BODY {font-family: Helvetica; font-size: 9pt;}
P {font-family: Helvetica; font-size: 9pt;}
TABLE, TR, TD {font-family: Helvetica; font-size: 9pt;}
H2 {font-family: Helvetica; font-size: 16pt; font-weight: bold;}
H3 {font-family: Helvetica; font-size: 15pt; font-weight: bold;}

A.link:link {color: #0066CC; text-decoration: underline;}
A.link:visited {color: #0066CC; text-decoration: underline;}
A.link:hover {color: #ff9900; text-decoration: underline;}
A.link:active {color: #ff9900; text-decoration: underline;}
</STYLE>

<STYLE TYPE="text/css" MEDIA="print">
.noprint { display:none; }
</STYLE>

<!--- Query to select the projects --->
<CFQUERY NAME="qryProjects" DATASOURCE="#request.ds#">
	SELECT tblProjects.intProjectID,
			tblProjects.strDescription,
			tblProjects.strLegal,
			tblProjects.intProjectNo,
			tblProjects.strFileNo,
			tblDept.strDeptAbrev,
			tblProjectType.strProjType,
			tblLocation.strLocation,
			tblProvince.strAbbreviated,
			tblProjects.strLegal,
			tblAgent.strFirstName,
			tblAgent.strLastName,
			qryMostRecentStatus.LastOfdatUpdate,
			qryMostRecentStatus.LastOfmemStatus,
			tblProjects.curPrice
	FROM	tblLocation INNER JOIN 
			(tblAgent INNER JOIN
			(tblDept INNER JOIN
			((tblProjectType INNER JOIN
			(tblProjects LEFT JOIN
			tblProvince ON tblProjects.intProvID = tblProvince.intProvID)
			ON tblProjectType.intProjTypeID = tblProjects.intProjectType)
			LEFT JOIN qryMostRecentStatus ON tblProjects.intProjectID = qryMostRecentStatus.intProjectID)
			ON tblDept.intDeptID = tblProjects.intClientDept)
			ON tblAgent.intAgentID = tblProjects.intAgent)
			ON tblLocation.intLocationID = tblProjects.intLocationID
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
	ORDER BY	#Client.sort#, #Client.lastSort#
</CFQUERY>



<!--- check browser version --->
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
		document.write('<p class="noprint"><a class="link" href="#" onclick="execCommand(\'SaveAs\',\'False\',\'projectSummaryReport.htm\');">save</a> | <a class="link" href="javascript:window.print();">print</a></p>');
	}
</script>

<h2 align="center">Project Summary Report</h2>
<!--- display search and sort criteria --->
<CFOUTPUT><b>#qryProjects.RecordCount# projects matched your search criteria:</b><br><br></CFOUTPUT>
<CFIF #Client.Location# IS NOT 0 OR #Client.agent# IS NOT 0 OR #Client.department# IS NOT 0 OR #Client.projectType# IS NOT "all">
	<b>SEARCH CRITERIA:</b><br>
</CFIF>
<CFIF #Client.location# IS NOT 0>
	<CFQUERY NAME="qryLocationName" DATASOURCE="#request.ds#">
		SELECT strLocation FROM tblLocation WHERE intLocationID = #Client.location#
	</CFQUERY>
	<CFOUTPUT QUERY="qryLocationName">
		<b>&nbsp;Location</b>: #strLocation#<br>
	</CFOUTPUT>
</CFIF>
<CFIF #Client.agent# IS NOT 0>
	<CFQUERY NAME="qryAgentName" DATASOURCE="#request.ds#">
		SELECT strFirstName, strLastName FROM tblAgent WHERE intAgentID = #Client.agent#
	</CFQUERY>
	<CFOUTPUT QUERY="qryAgentName">
		<b>&nbsp;Advisor</b>: #strFirstName# #strLastName#<br>
	</CFOUTPUT>
</CFIF>
<CFIF #Client.department# IS NOT 0>
	<CFQUERY NAME="qryDeptName" DATASOURCE="#request.ds#">
		SELECT strDeptName FROM tblDept WHERE intDeptID = #Client.department#
	</CFQUERY>
	<CFOUTPUT QUERY="qryDeptName">
		<b>&nbsp;Client</b>: #strDeptName#<br>
	</CFOUTPUT>
</CFIF>
<CFIF #Client.projectType# EQ "acquisition">
	<b>&nbsp;Type</b>: Acquisition<br>
<CFELSEIF #Client.projectType# EQ "disposal">
	<b>&nbsp;Type</b>: Disposal<br>
<CFELSEIF #Client.projectType# EQ "consulting">
	<b>&nbsp;Type</b>: Consulting<br>
</CFIF>
<CFIF #Client.status# EQ "active">
	<b>&nbsp;Status</b>: Active<br>
<CFELSEIF #Client.status# EQ "complete">
	<b>&nbsp;Status</b>: Complete<br>
</CFIF>
<CFIF IsDefined("Client.sort")>
	<CFIF #Client.sort# IS "location">
		<br><b>Sort By</b>: Location<br>
	<CFELSEIF #Client.sort# IS "agent">
		<br><b>Sort By</b>: Advisor<br>
	<CFELSEIF #Client.sort# IS "client">
		<br><b>Sort By</b>: Client<br>
	</CFIF>
</CFIF>

<table border="0" cellpadding="4" cellspacing="0" width="1200">
	<tr>
		<td with="230"><img src="images/transparent.gif" border="0" width="222" height="1"></td>
		<td with="170"><img src="images/transparent.gif" border="0" width="162" height="1"></td>
		<td with="420"><img src="images/transparent.gif" border="0" width="412" height="1"></td>
		<td with="390"><img src="images/transparent.gif" border="0" width="382" height="1"></td>
	</tr>
	<tr>
		<td colspan="4"><img src="<CFIF browser EQ "MSIE">images/</CFIF>black.gif" width="1180" height="<CFIF browser EQ "MSIE">1<CFELSE>2</CFIF>" border="0"></td>
	</tr>
<CFOUTPUT QUERY="qryProjects">
	<tr>
		<td valign="top">
			<table border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td width="76" valign="top"><b>Project Type</b>:</td>
					<td>#strProjType#</td>
				</tr>
				<tr>
					<td valign="top"><b>Location</b>:</td>
					<td>#strLocation#<CFIF #strAbbreviated# NEQ "">, #strAbbreviated#</CFIF></td>
				</tr>
				<tr>
					<td valign="top"><b>Client</b>:</td>
					<td>#strDeptAbrev#</td>
				</tr>
				<tr>
					<td valign="top"><b>Advisor</b>:</td>
					<td>#strFirstName# #strLastName#</td>
				</tr>
			</table>
		</td>
		<td valign="top">
			<table border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td width="70" valign="top"><b>Project No</b>:</td>
					<td>#intProjectNo#</td>
				</tr>
				<tr>
					<td valign="top"><b>File No</b>:</td>
					<td>#strFileNo#</td>
				</tr>
				<tr>
					<td><b>Price</b>:</td>
					<td>#DollarFormat(curPrice)#</td>
				</tr>
			</table>
		</td>
		<td valign="top">
			<table border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="118"><b>Project Description</b>:</td>
					<td valign="top">#strDescription#</td>
				</tr>
				<tr>
					<td valign="top"><b>Legal Description</b>:</td>
					<td valign="top">#strLegal#</td>
				</tr>
			</table>
		</td>
		<td valign="top">
			<table border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="100"><b>Project Status</b>:&nbsp;&nbsp;</td>
					<td valign="top"><b>#DateFormat(LastOfdatUpdate, "mmm d, yyyy")#</b><CFIF #LastOfmemStatus# NEQ ""> - #LastOfmemStatus#</CFIF></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<!--- Netscape would not print black.gif properly, so if the user is using Netscape,
		the image source is "black.gif" instead of "images/black.gif".  Because "black.gif" does
		not exist, the broken image icon appears, but it looks like a line because the image 
		height is only set to 2 pixels. --->
		<td colspan="4"><img src="<CFIF browser EQ "MSIE">images/</CFIF>black.gif" width="1180" height="<CFIF browser EQ "MSIE">1<CFELSE>2</CFIF>" border="0"></td>
	</tr>

</CFOUTPUT>
</table>


</body>
</html>
