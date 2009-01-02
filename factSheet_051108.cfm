<!--- this file displays the data from tblFactSheet (as well as a couple of 
other tables) in a printable format. If the user is logged in, then clicking 
on "Fact Sheet" on the "Print" menu from disposals.cfm will request disposalSave.cfm 
which, in turn, will request this file. If the user is not logged in, they will 
be taken directly here to avoid saving changes they may have made to 
the project.  --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Fact Sheet</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<STYLE TYPE="text/css">
BODY {font-family: Helvetica; font-size: 10pt;}
P {font-family: Helvetica; font-size: 10pt;}
TABLE, TR, TD {font-family: Helvetica; font-size: 10pt;}
H2 {font-family: Helvetica; font-size: 16pt; font-weight: bold;}

A.link:link {color: #0066CC; text-decoration: underline;}
A.link:visited {color: #0066CC; text-decoration: underline;}
A.link:hover {color: #ff9900; text-decoration: underline;}
A.link:active {color: #ff9900; text-decoration: underline;}
</STYLE>

<STYLE TYPE="text/css" MEDIA="print">
.noprint { display:none; }
</STYLE>

<!--- set temp variables equal to the session variables for dispalying
the fact sheet data --->
<CFLOCK SCOPE="SESSION" TYPE="READONLY" TIMEOUT="15">
	<CFSET tempDescription = Session.backupDescription>
	<CFSET tempLegal = Session.backupLegal>
	<CFSET tempLDU = Session.backupLDU>
	<CFSET tempFirstName = Session.backupFirstName>
	<CFSET tempLastName = Session.backupLastName>
	<CFSET tempContactFirst = Session.backupContactFirst>
	<CFSET tempContactLast = Session.backupContactLast>
	<CFSET tempDeptName = Session.backupDeptName>
	<CFSET tempLocation = Session.backupLocation>
	
	<CFSET tempGeneralDesc = Session.backupGeneralDesc>
	<CFSET tempAvailable = Session.backupAvailable>
	<CFSET tempUrbanCentre = Session.backupUrbanCentre>
	<CFSET tempAddress = Session.backupAddress>
	<CFSET tempParcelSize = Session.backupParcelSize>
	<CFSET tempTopography = Session.backupTopography>
	<CFSET tempAccess = Session.backupAccess>
	<CFSET tempBuildingDesc = Session.backupBuildingDesc>
	<CFSET tempZoning = Session.backupZoning>
	<CFSET tempServices = Session.backupServices>
	<CFSET tempLandUse = Session.backupLandUse>
	<CFSET tempAge = Session.backupAge>
	<CFSET tempCondition = Session.backupCondition>
	<CFSET tempEnvironIssues = Session.backupEnvironIssues>
	<CFSET tempTenure = Session.backupTenure>
	<CFSET tempRestrictions = Session.backupRestrictions>
	<CFSET tempAcquiDate = Session.backupAcquiDate>
	<CFSET tempPurchasedFrom = Session.backupPurchasedFrom>
	<CFSET tempAmountPaid = Session.backupAmountPaid>
	<CFSET tempHistory = Session.backupHistory>
	<CFSET tempKnownInterests = Session.backupKnownInterests>
	<CFSET tempLandAsses = Session.backupLandAsses>
	<CFSET tempBuildingAsses = Session.backupBuildingAsses>			
	<CFSET tempYear = Session.backupYear>
	<CFSET tempPILT = Session.backupPILT>
</CFLOCK>

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!-- If browser is Internet Explorer, display options to save and print report.
The links themselves will not be printed because of the class="noprint". The
browser is determined using JavaScript as opposed to CFSCRIPT (which is used in other pages)
because if the page is saved with IE, we do not want a user to open the file in Netscape
and have these links displayed, for they will not work in Netscape. -->
<script Language="Javascript">
	if (document.all) {
		document.write('<p class="noprint"><a class="link" href="#" onClick="execCommand(\'SaveAs\',\'False\',\'factSheet.htm\');">save</a> | <a class="link" href="javascript:window.print();">print</a></p>');
	}
</script>

<table width="640" cellpadding="1" cellspacing="0" border="0" align="center">
	<tr>
		<td colspan="3" align="center">
			<span style="font-family: Helvetica; font-size: 16pt; font-weight: bold;">Fact Sheet</span><br><span style="font-family: Helvetica; font-size: 10pt; font-weight: normal;">Inventory of Potentially Surplus Property</span>
			<p align="right"><CFOUTPUT>#DateFormat(Now(), "mmmm d, yyyy")#</CFOUTPUT></p>
		</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Property Identification</b></td>
	</tr>
<CFOUTPUT>
	<tr>
		<td align="right" width="220">City/Town:</td>
		<td>&nbsp;</td>
		<td width="420">#tempLocation#</td>
	</tr>
	<tr>
		<td align="right">Nearest Urban Centre:</td>
		<td>&nbsp;</td>
		<td>#tempUrbanCentre#</td>
	</tr>
	<tr>
		<td align="right">Street Address:</td>
		<td>&nbsp;</td>
		<td>#tempAddress#</td>
	</tr>
	<tr>
		<td align="right" valign="top">General Description:</td>
		<td>&nbsp;</td>
		<td>#tempGeneralDesc#</td>
	</tr>
	<tr>
		<td align="right" valign="top">Legal Description:</td>
		<td>&nbsp;</td>
		<td>#tempLegal#</td>
	</tr>
	<tr>
		<td align="right">LDU No:</td>
		<td>&nbsp;</td>
		<td>#tempLDU#</td>
	</tr>
	<tr>
		<td align="right">Property is Available:</td>
		<td>&nbsp;</td>
		<td>#tempAvailable#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Custodian and Contact Information</b></td>
	</tr>
	<tr>
		<td align="right">Custodian Department:</td>
		<td>&nbsp;</td>
		<td>#tempDeptName#</td>
	</tr>
	<tr>
		<td align="right">Custodian Contact:</td>
		<td>&nbsp;</td>
		<td>#tempContactFirst# #tempContactLast#</td>
	</tr>
	<tr>
		<td align="right">PWGSC Contact:</td>
		<td>&nbsp;</td>
		<td>#tempFirstName# #tempLastName#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Description of Property</b></td>
	</tr>
	<tr>
		<td align="right">Parcel Size (ha):</td>
		<td>&nbsp;</td>
		<td>#tempParcelSize#</td>
	</tr>
	<tr>
		<td align="right">Topography:</td>
		<td>&nbsp;</td>
		<td>#tempTopography#</td>
	</tr>
	<tr>
		<td align="right">Access:</td>
		<td>&nbsp;</td>
		<td>#tempAccess#</td>
	</tr>
	<tr>
		<td align="right">Building Description:</td>
		<td>&nbsp;</td>
		<td>#tempBuildingDesc#</td>
	</tr>
	<tr>
		<td align="right">Zoning:</td>
		<td>&nbsp;</td>
		<td>#tempZoning#</td>
	</tr>
	<tr>
		<td align="right">Services:</td>
		<td>&nbsp;</td>
		<td>#tempServices#</td>
	</tr>
	<tr>
		<td align="right">Surrounding Land Use:</td>
		<td>&nbsp;</td>
		<td>#tempLandUse#</td>
	</tr>
	<tr>
		<td align="right" valign="top">Environmental Issues:</td>
		<td>&nbsp;</td>
		<td>#tempEnvironIssues#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Improvements</b></td>
	</tr>
	<tr>
		<td align="right">Age:</td>
		<td>&nbsp;</td>
		<td>#tempAge#</td>
	</tr>
	<tr>
		<td align="right">Condition:</td>
		<td>&nbsp;</td>
		<td>#tempCondition#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Ownership</b></td>
	</tr>
	<tr>
		<td align="right">Tenure:</td>
		<td>&nbsp;</td>
		<td>#tempTenure#</td>
	</tr>
	<tr>
		<td align="right">Restrictions:</td>
		<td>&nbsp;</td>
		<td>#tempRestrictions#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>History</b></td>
	</tr>
	<tr>
		<td align="right">Acquisition Date:</td>
		<td>&nbsp;</td>
		<td>#tempAcquiDate#</td>
	</tr>
	<tr>
		<td align="right">Purchased From:</td>
		<td>&nbsp;</td>
		<td>#tempPurchasedFrom#</td>
	</tr>
	<tr>
		<td align="right">Amount Paid:</td>
		<td>&nbsp;</td>
		<td>#DollarFormat(tempAmountPaid)#</td>
	</tr>
	<tr>
		<td align="right">History:</td>
		<td>&nbsp;</td>
		<td>#tempHistory#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Known and/or Potential Interests, Concerns, Proposals</b></td>
	</tr>
	<tr>
		<td align="right" valign="top">Known Interests:</td>
		<td>&nbsp;</td>
		<td>#tempKnownInterests#</td>
	</tr>
	<tr>
		<td colspan="3"><b><br>Assessment & Taxation</b></td>
	</tr>
	<tr>
		<td align="right">Land Assessment:</td>
		<td>&nbsp;</td>
		<td>#DollarFormat(tempLandAsses)#</td>
	</tr>
	<tr>
		<td align="right">Building Assessment:</td>
		<td>&nbsp;</td>
		<td>#DollarFormat(tempBuildingAsses)#</td>
	</tr>
	<tr>
		<td align="right">Year:</td>
		<td>&nbsp;</td>
		<td>#tempYear#</td>
	</tr>
	<tr>
		<td align="right">PILT:</td>
		<td>&nbsp;</td>
		<td>#DollarFormat(tempPILT)#</td>
	</tr>
</CFOUTPUT>
</table>
</body>
</html>
