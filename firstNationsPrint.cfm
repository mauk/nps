<!--- this page displays the First Nations consultation 
data in a printable format. If the user is logged in, then clicking 
on "First Nations Consultations" on the "Print" menu from disposals.cfm 
will request disposalSave.cfm which, in turn, will request 
this page. If the user is not logged in, they will be 
taken directly to here to avoid saving changes they 
may have made. --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>First Nations Consultations</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<STYLE TYPE="text/css">
BODY {font-family: Helvetica; font-size: 10pt;}
P {font-family: Helvetica; font-size: 10pt;}
TABLE, TR, TD {font-family: Helvetica; font-size: 10pt;}
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

<!--- retrieve the band data --->
<CFQUERY NAME="qryBand" DATASOURCE="#request.ds#">
	SELECT		*
	FROM		tblBand
	WHERE		intProjectID = #URL.projectID#
	ORDER BY	strBandName
</CFQUERY>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">

<!-- If browser is Internet Explorer, display options to save and print report.
The links themselves will not be printed because of the class="noprint". The
browser is determined using JavaScript as opposed to CFSCRIPT (which is used in other pages)
because if the page is saved with IE, we do not want a user to open the file in Netscape
and have these links displayed, for they will not work in Netscape.  -->
<script Language="Javascript">
	if (document.all) {
		document.write('<p class="noprint"><a class="link" href="#" onclick="execCommand(\'SaveAs\',\'False\',\'firstNationsPrint.htm\');">save</a> | <a class="link" href="javascript:window.print();">print</a></p>');
	}
</script>

<table border="0" cellpadding="0" cellspacing="0" width="660" align="center">
<tr>
<td>

<br>
<CFOUTPUT>
<table border="0" cellpadding="4" cellspacing="0" width="660">
	<tr>
		<td valign="top" width="125"><b>Client:</b></td>
		<td width="505">#tempDeptName#</td>
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
<table width="660" border="0" cellpadding="2" cellspacing="0">
<!--- loop through each band (for the given project) --->
<CFLOOP QUERY="qryBand">
	<tr>
		<td valign="top" colspan="3">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="4">
						<b><br><CFOUTPUT>#qryband.strBandName#</CFOUTPUT></b>
					</td>
				</tr>
				<tr>
					<td><img src="images/transparent.gif" border="0" width="51" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="211" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="51" height="1"></td>
					<td><img src="images/transparent.gif" border="0" width="211" height="1"></td>
				</tr>
				<tr>
					<td valign="top">Chief:</td>
					<td><CFOUTPUT>#qryband.strChiefName#</CFOUTPUT></td>
					<td valign="top">Tel:</td>
					<td><CFOUTPUT>#qryband.strPhone#</CFOUTPUT></td>
				</tr>
				<tr>
					<td valign="top">Contact:</td>
					<td><CFOUTPUT>#qryband.strContact#</CFOUTPUT></td>
					<td valign="top">Fax:</td>
					<td><CFOUTPUT>#qryband.strFax#</CFOUTPUT></td>
				</tr>
				<tr>
					<td valign="top">Address:</td>
					<td><CFOUTPUT>#qryband.strAddress#</CFOUTPUT></td>
					<td valign="top">E-mail:</td>
					<td><CFOUTPUT>#qryband.strEmail#</CFOUTPUT></td>
				</tr>

			</table>
		</td>
	</tr>
	<tr bgcolor="#0099CC">
		<td width="95" height="25"><font color="#ffffff">&nbsp;Date:</font></td>
		<td width="165" height="25"><font color="#ffffff">By:</font></td>
		<td width="400" height="25"><font color="#ffffff">Remarks:</font></td>
	</tr>
	<!--- retrieve the remarks for each band --->
	<CFQUERY NAME="qryRemarks" DATASOURCE="#request.ds#">
		SELECT	tblFirstNationsRemarks.datDate,
				tblFirstNationsRemarks.memRemark,
				tblAgent.strFirstName,
				tblAgent.strLastName
		FROM	tblFirstNationsRemarks, tblAgent
		WHERE	tblFirstNationsRemarks.intBandID = #qryBand.intBandID#
		AND		tblFirstNationsRemarks.intAgentID = tblAgent.intAgentID	
		ORDER BY datDate DESC
	</CFQUERY>
	<!--- display the remarks --->
	<CFLOOP QUERY="qryRemarks">
	<tr<CFIF (currentrow MOD 2) EQ 1> bgcolor="#D9F0FF"</CFIF>>
		<td width="95" valign="top"><CFOUTPUT>#DateFormat(qryRemarks.datDate, "mmm d, yyyy")#</CFOUTPUT></td>
		<td width="165" valign="top"><CFOUTPUT>#strFirstName# #strLastName#</CFOUTPUT></td>
		<td width="400"><CFOUTPUT>#qryRemarks.memRemark#</CFOUTPUT></td>
	</tr>
	</CFLOOP>
	<tr>
		<td width="95"><img src="images/transparent.gif" border="0" width="91" height="1"></td>
		<td width="165"><img src="images/transparent.gif" border="0" width="161" height="1"></td>
		<td width="400"><img src="images/transparent.gif" border="0" width="396" height="1"></td>
	</tr>
</CFLOOP>
</table>
<br>
</td>
</tr>
</table>
</body>
</html>
