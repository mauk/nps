<!--- This page displays the form for adding and editing purchaser types --->

<!--- only users with Administrative access can edit purchaser type --->
<CFIF Client.Admin EQ 1>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title><CFIF IsDefined("URL.edit")>Edit<CFELSE>Add</CFIF> Purchaser Type</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

<!--- If user is editing a purchaser type, retrieve the purchaser type's information --->
<CFIF IsDefined("URL.edit")>
	<CFQUERY NAME="qryPurchaserType" DATASOURCE="#request.ds#">
		SELECT * FROM tblPurchaserType WHERE intPurchaserTypeID = #URL.edit#
	</CFQUERY>
</CFIF>
</head>

<!--- If the user is editing a purchaser type, display the following form
populated with data from the above query. --->
<CFIF IsDefined("URL.edit")>

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Edit Purchaser Type</b></p><br>
<FORM NAME="form1" ACTION="purchaserTypeAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="purchaserType_required" VALUE="You must enter a purchaser type">
<CFOUTPUT QUERY="qryPurchaserType">
<!--- the hidden field, edit, tells purchaserTypeAdmin.cfm 
which purchaser type the user is editing --->
<INPUT TYPE="hidden" NAME="edit" VALUE="#intPurchaserTypeID#">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Purchaser Type:</td>
		<td><INPUT TYPE="text" NAME="purchaserType" SIZE="50" MAXLENGTH=50 VALUE="#strPurchaserType#"></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="##" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="purchaserTypeAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</CFOUTPUT>
</FORM>
</body>

<CFELSE>
<!--- the user is adding a new purchaser type, so display the following form --->

<body bgcolor="#FFFFFF" text="#000000">
<p><b>Add Purchaser Type</b></p><br>
<FORM NAME="form1" ACTION="purchaserTypeAdmin.cfm" METHOD="POST">
<INPUT TYPE="hidden" NAME="purchaserType_required" VALUE="You must enter a purchaser type.">
<!--- The hidden field, add, tells purchaserTypeAdmin.cfm 
that the user is adding a purchaser type --->
<INPUT TYPE="hidden" NAME="add" VALUE="yes">
<table border="0" cellpadding="3" cellspacing="0">
	<tr>
		<td valign="right">Purchaser Type:</td>
		<td><INPUT TYPE="text" NAME="purchaserType" SIZE="30"></td> 
	</tr>
	<tr>
		<td colspan="2" align="center"><a href="#" onClick="document.form1.submit(); return false;"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a>&nbsp;<a href="purchaserTypeAdmin.cfm"><img src="../images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
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