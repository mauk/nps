<!--- This page saves the data that was sent from disposalSummary.cfm into
tblDispSummary, and then displays it in a printable format --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Summary of Property Disposal</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<STYLE TYPE="text/css">
BODY {font-family: Helvetica; font-size: 11pt;}
P {font-family: Helvetica; font-size: 11pt;}
TABLE, TR, TD {font-family: Helvetica; font-size: 11pt;}
H2 {font-family: Helvetica; font-size: 17pt; font-weight: bold;}

A.link:link {color: #0066CC; text-decoration: underline;}
A.link:visited {color: #0066CC; text-decoration: underline;}
A.link:hover {color: #ff9900; text-decoration: underline;}
A.link:active {color: #ff9900; text-decoration: underline;}
</STYLE>

<STYLE TYPE="text/css" MEDIA="print">
.noprint { display:none; }
</STYLE>

<!--- query for saving the data sent by disposalSummary.cfm --->
<CFQUERY NAME="qryUpdateDispSummary" DATASOURCE="#request.ds#">
	UPDATE	tblDispSummary
	SET		strLocation = '#Form.location#',
			strDescription = '#Form.description#',
			strLegal = '#Form.legal#',
			strCustodian = '#Form.custodian#',
			strPurchaser = '#Form.purchaser#',
			strSalePrice = '#Form.salePrice#',
			strAppraisedValue = '#Form.appraisedValue#',
			strCompletionDate = '#Form.completionDate#',
			strAgent = '#Form.agent#',
			strFileNo = '#Form.fileNo#',
			strProjectNumber = '#Form.projectNumber#',
			strRollNumber = '#Form.rollNumber#',
			memRemarks = '#Form.remarks#',
			bolSaved = True
	WHERE 	intProjectID = #Form.projectID#
</CFQUERY>

<!--- check browser version for proper display in both browsers --->
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

<body bgcolor="#FFFFFF" text="#000000">

<!-- If browser is Internet Explorer, display options to save and print report.
The links themselves will not be printed because of the class="noprint". -->
<script Language="Javascript">
	if (document.all) {
		document.write('<p class="noprint"><a class="link" href="javascript:window.print();">print</a></p>');
	}
</script>

<table width="640" cellpadding="5" cellspacing="0" border="0" align="center">
	<tr>
		<td colspan="2" align="center"><img src="images/pwgsc2.gif" width="600" height="28"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><hr><h2>Summary of Property Disposal</h2><hr><br></td>
	</tr>
<CFOUTPUT>
	<tr>
		<td width="205" valign="top"><b>Property Location:</b></td>
		<td width="435">#Form.location#</td>
	</tr>
	<tr>
		<td valign="top"><b>Description:</b></td>
		<td>#Form.description#</td>
	</tr>
	<tr>
		<td valign="top"><b>Legal Description:</b></td>
		<td>#Form.legal#</td>
	</tr>
	<tr>
		<td valign="top"><b>Custodian:</b></td>
		<td>#Form.custodian#</td>
	</tr>
	<tr>
		<td valign="top"><b>Purchaser:</b></td>
		<td>#Form.purchaser#</td>
	</tr>
	<tr>
		<td valign="top"><b>Sale Price:</b></td>
		<td>#Form.salePrice#</td>
	</tr>
	<tr>
		<td valign="top"><b>Appraised Value:</b></td>
		<td>#Form.appraisedValue#</td>
	</tr>
	<tr>
		<td valign="top"><b>Date of Completion:</b></td>
		<td>#Form.completionDate#</td>
	</tr>
	<tr>
		<td valign="top"><b>Real Estate Advisor:</b></td><!---[ap:locator:051107:u4]--->
		<td>#Form.agent#</td>
	</tr>
	<tr>
		<td valign="top"><b>File Number:</b></td>
		<td>#Form.fileNo#</td>
	</tr>
	<tr>
		<td valign="top"><b>Project Number:</b></td>
		<td>#Form.projectNumber#</td>
	</tr>
	<tr>
		<td valign="top"><b>BC Assessment Roll ##:</b></td>
		<td>#Form.rollNumber#</td>
	</tr>
	<tr>
		<td valign="top"><b>Remarks:</b></td>
		<td>#Form.remarks#</td>
	</tr>
</CFOUTPUT>
	<tr>
		<!--- Netscape would not print black.gif properly, so if the user is using Netscape,
		the image source is "black.gif" instead of "images/black.gif".  Because "black.gif" does
		not exist, the broken image icon appears, but it looks like a line because the image 
		height is only set to 2 pixels. --->
		<td><br><br><br><CFOUTPUT>#DateFormat(Now(), "mmmm d, yyyy")#</CFOUTPUT><br><img src="<CFIF browser EQ "MSIE">images/</CFIF>black.gif" width="150" height="<CFIF browser EQ "MSIE">1<CFELSE>2</CFIF>"><br>Date</td>
		<td><br><br><br><br><img src="<CFIF browser EQ "MSIE">images/</CFIF>black.gif" width="350" height="<CFIF browser EQ "MSIE">1<CFELSE>2</CFIF>"><br><CFOUTPUT>#Form.agent#</CFOUTPUT>, Real Estate Advisor</td><!---[ap:locator:051107:u4]--->
	</tr>
	<tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" width="40"><br><br><span style="font-size: 11pt;">cc:</span></td>
					<td valign="top"><br><br>
						<span style="font-size: 11pt;">Client-HQ<br>
						Client-Region<br>
						Municipal Grants<br>
						REAS Clerk<br></span>
				</tr>
			</table>
		</td>
	</tr>
</table>

</body>
</html>
