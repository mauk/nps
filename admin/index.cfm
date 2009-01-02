<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Admin Contents</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

</head>

<body bgcolor="#FFFFFF" text="#000000">
<br><br><p align="center">
<b>Project Admin</b><br><br>
<CFIF Client.Admin EQ 1>
	<a class="link" href="deptAdmin.cfm">Client/Dept</a><br><br>
	<a class="link" href="locationAdmin.cfm">Locations</a><br><br>
	<a class="link" href="clientContactAdmin.cfm">Client Contact</a><br><br>
	<a class="link" href="agentAdmin.cfm">Advisors</a><br><br>
	<a class="link" href="propertyTypeAdmin.cfm">Property Types</a><br><br>
	<a class="link" href="interestSoldAdmin.cfm">Interest Sold Types</a><br><br>
	<a class="link" href="disposalMethodAdmin.cfm">Disposal Methods</a><br><br>
	<a class="link" href="purchaserTypeAdmin.cfm">Purchaser Types</a><br><br>
	<a class="link" href="projectAdmin.cfm">Projects</a><br><br>
	<a class="link" href="passwordAdmin.cfm">Change Password</a><br><br>
	<a class="link" href="asciiDownload.cfm">Download Tables</a><br><br>
<CFELSEIF Client.Admin EQ 2>
	<a class="link" href="deptAdmin.cfm">Client/Dept</a><br><br>
	<a class="link" href="locationAdmin.cfm">Locations</a><br><br>
	<a class="link" href="clientContactAdmin.cfm">Client Contact</a><br><br>
	<a class="link" href="passwordAdmin.cfm">Change Password</a><br><br>
	<a class="link" href="asciiDownload.cfm">Download Tables</a><br><br>
</CFIF>
</body>
</html>
