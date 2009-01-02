<!--- This page displays the form for adding and editing disposal methods --->

<!--- only users with Administrative access can edit disposal methods --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Disposal Method</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing a disposal method, retrieve the disposal method's information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryDisposalMethod" DATASOURCE="#request.ds#">
		SELECT * FROM tblDisposalMethod WHERE intDisposalMethodID = #URL.edit#
	</CFQUERY>
</CFIF>
</head>

<!--- If the user is editing a disposal method, display the following form --->
<CFIF IsDefined("URL.edit")>

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Edit Disposal Method</b></p><br>
<FORM NAME="form1" ACTION="disposalMethodAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="disposalMethod_required" VALUE="You must enter a purchaser type">
<CFOUTPUT QUERY="qryDisposalMethod">
<!--- the hidden field, edit, tells disposalMethodAdmin.cfm 
which disposal method the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="#intDisposalMethodID#">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Disposal Method:</td>
		<td><INPUT TYPE="text" NAME="disposalMethod" SIZE="50" MAXLENGTH=50 VALUE="#strDisposalMethod#"></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="##" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="disposalMethodAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</CFOUTPUT>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new disposal method, so display the following form --->
<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Disposal Method</b></p><br>
<FORM NAME="form1" ACTION="disposalMethodAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="disposalMethod_required" VALUE="You must enter a purchaser type.">
<!--- The hidden field, add, tells disposalMethodAdmin.cfm 
that the user is adding a disposal method --->
<INPUT TYPE="hidden" NAME="add" VALUE="yes">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Disposal Method:</td>
		<td><INPUT TYPE="text" NAME="disposalMethod" SIZE="30"></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="disposalMethodAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>

</CFIF>
</html>
<CFELSE>
<!--- The user does not have access to this page so display a message --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Admin</title>
</head>
<body>
<br><br><p align="center"><b>Sorry, you do not have access to this part of the site.</b></p>
</body>
</CFIF>