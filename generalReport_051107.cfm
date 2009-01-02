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

A.link:link {color: #0066CC; text-decoration: underline;}
A.link:visited {color: #0066CC; text-decoration: underline;}
A.link:hover {color: #ff9900; text-decoration: underline;}
A.link:active {color: #ff9900; text-decoration: underline;}
</STYLE>

<STYLE TYPE="text/css" MEDIA="print">
.noprint { display:none; }
</STYLE>

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
<CFIF #Client.location# IS NOT 0 AND #Client.description# IS "">
	AND		tblLocation.intLocationID = #Client.location#
<CFELSEIF #Client.location# IS NOT 0 AND #Client.description# IS NOT "">
	AND		(tblLocation.intLocationID = #Client.location#
	OR		tblProjects.strDescription LIKE '%#Client.description#%')
<CFELSEIF #Client.location# IS 0 AND #Client.description# IS NOT "">
	AND		tblProjects.strDescription LIKE '%#Client.description#%'
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
<CFIF IsDefined("Form.include")>
	<!--- user has included the extra fields --->
	<table border="0" cellpadding="4" cellspacing="0" width="1180">
		<tr>
			<td colspan="5">
				<b>SSA Amount</b>: <CFOUTPUT>#Form.SSA#</CFOUTPUT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<b>YTD Expenditures</b>: <CFOUTPUT>#Form.expenditures#</CFOUTPUT>
			</td>
			<td align="right" colspan="3"> 
				<b><CFOUTPUT>#MonthAsString(DatePart("m", Now()))# #DatePart("d", Now())#, #DatePart("yyyy", Now())#</CFOUTPUT></b>
			</td>
		</tr>
		<tr>
			<td with="170"><img src="images/transparent.gif" border="0" width="162" height="1"></td>
			<td with="60"><img src="images/transparent.gif" border="0" width="52" height="1"></td>
			<td with="130"><img src="images/transparent.gif" border="0" width="122" height="1"></td>
			<td with="85"><img src="images/transparent.gif" border="0" width="77" height="1"></td>
			<td with="85"><img src="images/transparent.gif" border="0" width="77" height="1"></td>
			<td with="50"><img src="images/transparent.gif" border="0" width="42" height="1"></td>
			<td with="290"><img src="images/transparent.gif" border="0" width="282" height="1"></td>
			<td with="310"><img src="images/transparent.gif" border="0" width="302" height="1"></td>
		</tr>
		<tr bgcolor="#0099CC">
			<td><font color="#ffffff">Location</font></td>
			<td><font color="#ffffff">Client</font></td>
			<td><font color="#ffffff">Client Contact</font></td>
			<td><font color="#ffffff">SSA Amount</font></td>
			<td><font color="#ffffff">Exp. To Date</font></td>
			<td><font color="#ffffff">Advisor</font></td>
			<td><font color="#ffffff">Description</font></td>
			<td><font color="#ffffff">Status</font></td>
		</tr>
	<!--- output the query results --->
	<CFOUTPUT QUERY="qryProjects">
		<tr>
			<td height="30" valign="top">#strLocation#, #strAbbreviated#&nbsp;</td>
			<td height="30" valign="top">#strDeptAbrev#&nbsp;</td>
			<td height="30" valign="top">#strFirstName# #strLastName#&nbsp;</td>
			<td height="30" valign="top">#DollarFormat(curSSAFees + curSSADisbursements)#&nbsp;</td>
			<td height="30" valign="top">#DollarFormat(curExpToDate)#&nbsp;</td>
			<td height="30" valign="top">#strAbrev#&nbsp;</td>
			<td height="30" valign="top">#strDescription#&nbsp;</td>
			<td height="30" valign="top"><CFIF #LastOfmemStatus# NEQ "">#DateFormat(LastOfdatUpdate, "mmm d, yyyy")# - #LastOfmemStatus#</CFIF>&nbsp;</td>
		</tr>
		<tr>
			<!--- Netscape would not print black.gif properly, so if the user is using Netscape,
			the image source is "black.gif" instead of "images/black.gif".  Because "black.gif" does
			not exist, the broken image icon appears, but it looks like a line because the image 
			height is only set to 2 pixels. --->
			<td colspan="8"><img src="<CFIF browser EQ "MSIE">images/</CFIF>black.gif" width="1172" height="<CFIF browser EQ "MSIE">1<CFELSE>2</CFIF>" border="0"></td>
		</tr>
	</CFOUTPUT>
	</table>
<CFELSE>
	<!--- user has not included the extra fields --->
	<table border="0" cellpadding="4" cellspacing="0" width="1180">
		<tr>
			<td align="right" colspan="6"> 
				<b><CFOUTPUT>#MonthAsString(DatePart("m", Now()))# #DatePart("d", Now())#, #DatePart("yyyy", Now())#</CFOUTPUT></b>
			</td>
		</tr>
		<tr>
			<td with="170"><img src="images/transparent.gif" border="0" width="162" height="1"></td>
			<td with="60"><img src="images/transparent.gif" border="0" width="52" height="1"></td>
			<td with="155"><img src="images/transparent.gif" border="0" width="147" height="1"></td>
			<td with="60"><img src="images/transparent.gif" border="0" width="52" height="1"></td>
			<td with="360"><img src="images/transparent.gif" border="0" width="352" height="1"></td>
			<td with="375"><img src="images/transparent.gif" border="0" width="367" height="1"></td>
		</tr>
		<tr bgcolor="#0099CC">
			<td><font color="#ffffff">Location</font></td>
			<td><font color="#ffffff">Client</font></td>
			<td><font color="#ffffff">Client Contact</font></td>
			<td><font color="#ffffff">Advisor</font></td>
			<td><font color="#ffffff">Description</font></td>
			<td><font color="#ffffff">Status</font></td>
		</tr>
	<!--- output the query results --->
	<CFOUTPUT QUERY="qryProjects">
		<tr>
			<td height="30" valign="top">#strLocation#, #strAbbreviated#&nbsp;</td>
			<td height="30" valign="top">#strDeptAbrev#&nbsp;</td>
			<td height="30" valign="top">#strFirstName# #strLastName#&nbsp;</td>
			<td height="30" valign="top">#strAbrev#&nbsp;</td>
			<td height="30" valign="top">#strDescription#&nbsp;</td>
			<td height="30" valign="top"><CFIF #LastOfmemStatus# NEQ "">#DateFormat(LastOfdatUpdate, "mmm d, yyyy")# - #LastOfmemStatus#</CFIF>&nbsp;</td>
		</tr>
		<tr>
			<!--- Netscape would not print black.gif properly, so if the user is using Netscape,
			the image source is "black.gif" instead of "images/black.gif".  Because "black.gif" does
			not exist, the broken image icon appears, but it looks like a line because the image 
			height is only set to 2 pixels. --->
			<td colspan="6"><img src="<CFIF browser EQ "MSIE">images/</CFIF>black.gif" width="1172" height="<CFIF browser EQ "MSIE">1<CFELSE>2</CFIF>" border="0"></td>
		</tr>
	</CFOUTPUT>
	</table>
</CFIF>

</body>
</html>
