<!--- statusPrint.cfm displays the Status Updates for a specific project 
in a printable format. If the user is logged in, then clicking on "Status 
Journal " on the "Print" menu from the project pages (acquisitions.cfm, 
disposals.cfm, and consulting.cfm) will request the project type's save page 
(acquisitionSave.cfm, disposalSave.cfm, or consultingSave.cfm) which, in 
turn, will request statusPrint.cfm. If the user is not logged in, they will 
be taken directly to statusPrint.cfm to avoid saving changes they may have 
made to the project. --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Status Journal</title>
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

<!--- store project data in temp variables --->
<CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="10">
<CFSET tempDeptName = #Session.backupDeptName#>
<CFSET tempLocation = #Session.backupLocation#>
<CFSET tempAbbreviated = #Session.backupAbbreviated#>
<CFSET tempFirstName = #Session.backupFirstName#>
<CFSET tempLastName = #Session.backupLastName#>
<CFSET tempFileNo = #Session.backupFileNo#>
<CFSET tempDescription = #Session.backupDescription#>
</CFLOCK>


<!--- Query to retrieve the projects status updates --->
<CFQUERY NAME="qryStatus" DATASOURCE="#request.ds#">
	SELECT		tblStatus.intStatusID,
				tblStatus.memStatus,
				tblStatus.datUpdate
	FROM		tblStatus, tblProjects
	WHERE		tblStatus.intProjectID = tblProjects.intProjectID
	AND			tblStatus.intProjectID = #URL.projectID#
	ORDER BY	tblStatus.datUpdate ASC
</CFQUERY>
</head>

<body bgcolor="#FFFFFF" text="#000000">

<!-- If browser is Internet Explorer, display options to save and print report.
The links themselves will not be printed because of the class="noprint". The
browser is determined using JavaScript as opposed to CFSCRIPT (which is used in other pages)
because if the page is saved with IE, we do not want a user to open the file in Netscape
and have these links displayed, for they will not work in Netscape. -->
<script Language="Javascript">
	if (document.all) {
		document.write('<p class="noprint"><a class="link" href="#" onclick="execCommand(\'SaveAs\',\'False\',\'statusPrint\');">save</a> | <a class="link" href="javascript:window.print();">print</a></p>');
	}
</script>

<br>
<CFOUTPUT>
<table border="0" cellpadding="4" cellspacing="0" width="650" align="center">
	<tr>
		<td valign="top" width="125"><b>Client:</b></td>
		<td width="525">#tempDeptName#</td>
	</tr>
	<tr>
		<td valign="top"><b>Location:</b></td>
		<td>#tempLocation#, #tempAbbreviated#</td>
	</tr>
	<tr>
		<td valign="top"><b>Description:</b></td>
		<td>#tempDescription#</td>
	</tr>
	<tr>
		<td valign="top"><b>Advisor:</b></td>
		<td>#tempFirstName# #tempLastName#</td>
	</tr>
	<tr>
		<td valign="top"><b>File No:</b></td>
		<td>#tempFileNo#</td>
	</tr>
</table>
</CFOUTPUT>
<br>
<table border="0" cellpadding="6" cellspacing="0" width="650" align="center">
	<tr bgcolor="#0099CC">
		<td width="100"><font color="#ffffff">Date</font></td>
		<td width="550"><font color="#ffffff">Status</font></td>
	</tr>
<CFOUTPUT QUERY="qryStatus">
	<tr <CFIF (currentrow MOD 2) NEQ 1>bgcolor="##D9F0FF"</CFIF>>
		<td valign="top">#DateFormat(datUpdate, "mmm d, yyyy")#</td>
		<td>#memStatus#</td>
	</tr>
</CFOUTPUT>
</table>
</body>
</html>
