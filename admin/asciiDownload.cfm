<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>

<html>
<head>
<title>Table Download</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

</head>

<body bgcolor="#FFFFFF" text="#000000">
<CFINCLUDE TEMPLATE="nav.cfm">
<table border="0" cellpadding="0" cellspacing="0" width="650">
<tr>
<td colspan="3">
<br><p><b>Table Download</b> (in ASCII format)</p>
      <p>Click on one of the tables or composite downloads to open up the comma 
        delimited text file in your browser. When the text is displayed, click 
        on "File -> Save As..." and give the file an appropriate name ending in 
        ".txt". You can then import the text file into a database or spreadsheet 
        program. The column headings are on the first row and the data begins 
        on the second row. The text qualifier is a double quote ("). When you 
        have saved the file, click back to return to this page.</p>
      <p>Notes:</p>
      <ul>
	  	<li>When the text file loads in the browser click on the browser's refresh
		button to ensure that the most recent text file is loaded.</li>
	  	<li>If you are using Internet Explorer, the text file will be saved with 
        two extra rows at the bottom. Delete these rows either before or after 
        importing the text file into a database or spreadsheet. You will not be 
        able to specify a Primary Key in a database program until they have been 
        deleted.</li>
      	<li>To see what fields are used to link the tables together, please 
        see the <a class="link" href="../documentation/database.html">documentation</a>.</li>
	  </ul>
      <br><br>
</td>
</tr>
<tr>
<td width="50">
<td valign="top" width="200">
<p><b>Tables</b></p>
<p>   <a class="link" href="tblAccessLevel.cfm">tblAccessLevel</a><br>
      <a class="link" href="tblAcqSummary.cfm">tblAcqSummary</a><br>
      <a class="link" href="tblAcquisitions.cfm">tblAcquisitions</a><br>
      <a class="link" href="tblAgent.cfm">tblAgent</a><br>
      <a class="link" href="tblAppraisals.cfm">tblAppraisals</a><br>
      <a class="link" href="tblBand.cfm">tblBand</a><br>
      <a class="link" href="tblClientContact.cfm">tblClientContact</a><br>
      <a class="link" href="tblDept.cfm">tblDept</a><br>
      <a class="link" href="tblDisposalMethod.cfm">tblDisposalMethod</a><br>
      <a class="link" href="tblDisposals.cfm">tblDisposals</a><br>
      <a class="link" href="tblDispSummary.cfm">tblDispSummary</a><br>
      <a class="link" href="tblFactSheet.cfm">tblFactSheet</a><br>
      <a class="link" href="tblFirstNationsRemarks.cfm">tblFirstNationsRemarks</a><br>
      <a class="link" href="tblInterestSold.cfm">tblInterestSold</a><br>
	  <a class="link" href="tblLocation.cfm">tblLocation</a><br>
      <a class="link" href="tblPINPID.cfm">tblPINPID</a><br>
      <a class="link" href="tblProjects.cfm">tblProjects</a><br>
      <a class="link" href="tblProjectType.cfm">tblProjectType</a><br>
      <a class="link" href="tblPropertyType.cfm">tblPropertyType</a><br>
      <a class="link" href="tblProvince.cfm">tblProvince</a><br>
      <a class="link" href="tblPurchaserType.cfm">tblPurchaserType</a><br>
      <a class="link" href="tblStatus.cfm">tblStatus</a><br></p>
</td>
<td valign="top" width="400">
<p><b>Composites</b></p>
<p>   <a class="link" href="asciiAcquisitions.cfm">Acquisition Projects</a><br><br>
		The following acquisition data must be downloaded separately and linked using intProjectID:<br><br>
		Status Updates (tblStatus)<br>
		PIN/PID's (tblPINPID)<br>
		Appraisals (tblAppraisals)<br><br><br>
	  <a class="link" href="asciiDisposals.cfm">Disposal Projects</a><br><br>
        The following disposal data must be downloaded separately and linked using 
        intProjectID (except tblFirstNationsRemarks which is linked to tblBand using intBandID):<br>
        <br>
		Status Updates (tblStatus)<br>
        PIN/PID's (tblPINPID)<br>
		FactSheet Info (tblFactSheet)<br>
		First Nations Bands (tblBand)<br>
        First Nations Consultation Remarks (tblFirstNationsRemarks)<br>
        <br><br>
	  <a class="link" href="asciiConsulting.cfm">Consulting Projects</a><br><br>
		The following consulting project data must be downloaded separately and linked using intProjectID:<br><br>
		Status Updates (tblStatus)<br>
</td>
</tr>
</table>
<br><br>
</body>
</html>

<CFELSE>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Admin</title>
</head>
<body>
<br><br><p align="center"><b>Sorry, you do not have access to this part of the site.</b></p>
</body>
</CFIF>